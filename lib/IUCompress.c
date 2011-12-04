/*
 * File		: IUCompress.ec
 * 
 * Sccs		: @(#)IUCompress.c	1.2
 *
 * Dated	: 96/10/30 15:24:18 
 *
 * Owner	: Graeme Burnett
 *
 * Continuus
 * 
 * Type		: %cvtype: %
 * Created by	: %created_by: %
 * Date Created	: %date_created: %
 * Date Modified: %date_modified: %
 * Derived by	: %derived_by: %
 * File/Version	: %filespec: %
 *
 */


#ifdef TEST
#define MAIN
#endif

#include "c.incl.h"
#include "c.defs.h"
#include "c.class.h"
#include "error.class.h"
#include "c.proto.h"
#include "global.h"

PRIVATE
FINAL
char *sccsid = "SCCS: @(#)IUCompress.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: IUCompress - compress an input stream to multiple compressed 
 *			       files.
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  IUCompress(instream, fileseries)
 *		  FILE *instream;
 *		  char *fileseries;
 *
 * Arguments	: instream - a FILE input stream
 *
 *		  fileseries - a base name for the series of files which will
 *		               be generated.
 *
 * Description	: IUCompress performs a multiple file compression from an input
 *		  file stream.
 *
 * Returns	: status values: IU_SUCCESS on success, errno and status values on error
 *
 * See Also	: iexport, iimport
 *
 */



PRIVATE status compress();
PRIVATE status decompress();
PRIVATE void cl_block();
PRIVATE void cl_hash();
PRIVATE void output();

#define min(a,b)	((a>b) ? b : a)

#define SACREDMEM	0
#define USERMEM	450000	/* default user memory */

#ifdef USERMEM
# if USERMEM >= (433484+SACREDMEM)
#  define PBITS 16
# else
#  if USERMEM >= (229600+SACREDMEM)
#   define PBITS	15
#  else
#   if USERMEM >= (127536+SACREDMEM)
#    define PBITS	14
#   else
#    if USERMEM >= (73464+SACREDMEM)
#     define PBITS	13
#    else
#     define PBITS	12
#    endif
#   endif
#  endif
# endif
# undef USERMEM
#endif

#ifdef PBITS		/* Preferred BITS for this memory size */
# ifndef BITS
#  define BITS PBITS
#endif
#endif

#if BITS == 16
# define HSIZE	69001
#endif
#if BITS == 15
# define HSIZE	35023
#endif
#if BITS == 14
# define HSIZE	18013
#endif
#if BITS == 13
# define HSIZE	9001
#endif
#if BITS <= 12
# define HSIZE	5003
#endif

/*
 * a code_int must be able to hold 2**BITS values of type int, and also -1
 */

typedef	unsigned char	char_type;

char_type magic_header[] = { "\037\235" };	/* 1F 9D */

#define BIT_MASK	0x1f
#define BLOCK_MASK	0x80
#define INIT_BITS 9

#include <stdio.h>
#include <ctype.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/stat.h>


#define ARGVAL() (*++(*argv) || (--argc && *++argv))

int n_bits;				/* number of bits/code */
int maxbits = BITS;			/* user settable max # bits/code */
code_int maxcode;			/* maximum code, given n_bits */
code_int maxmaxcode = (code_int)1 << BITS; /* should NEVER generate this code */

#define MAXCODE(n_bits)	(((code_int) 1 << (n_bits)) - 1)

count_int htab [HSIZE];
unsigned short codetab [HSIZE];
#define htabof(i)	htab[i]
#define codetabof(i)	codetab[i]

code_int hsize = HSIZE;			/* for dynamic table sizing */
count_int fsize;

#define tab_prefixof(i) codetabof(i)
#define tab_suffixof(i)	((char_type *)(htab))[i]
#define de_stack	((char_type *)&tab_suffixof((code_int)1<<BITS))

code_int free_ent = 0;
int exit_stat = 0;

code_int getcode();

int nomagic = 0;	/* Use a 3-byte magic number header, unless old file */
int precious = 1;	/* Don't unlink output file on interrupt */
int quiet = 1;		/* don't tell me about compression */
int block_compress = BLOCK_MASK;
int clear_flg = 0;
long int ratio = 0;
#define CHECK_GAP 10000 /* ratio check interval */
count_int checkpoint = CHECK_GAP;

#define FIRST	257	/* first free entry */
#define CLEAR	256	/* table clear output code */

int force = 0;
char ofname [100];
		  
#define PATH_SEP '/'


PUBLIC
status
IUCompress(instream, fileseries)
FILE *instream;
char *fileseries;
{
    if(instream == (FILE *)NULL)
	return Error(IU_EINVALIDARG, "IUCompress: NULL input stream", "191");

    if(ferror(instream))
	return Error(errno, "IUCompress: input stream error", "194");

    return compress(instream, fileseries);
}

/*{{ FUNCDOC 3
 *
 * Name 	: IUDecompress - decompress a series of compressed files.
 *
 * Synopsis	: PUBLIC
 *		  status
 *		  IUDecompress(fileseries, outstream)
 *		  char *fileseries;
 *		  FILE *outstream;
 *
 * Arguments	: fileseries - base name of the compressed files. e.g bert would
 *		  	       evaluate to bert.000.Z, bert.001.Z etc.
 *
 * Description	: IUDecompress is a general purpose decompression routine which
 *		  decompresses a series of files previously processed by IUCompress.
 *		  
 *
 * Returns	: status value of IU_SUCCESS on success, errno and other status values
 *		  on error.
 *
 * See Also	: IUCompress()
 *
 */

PUBLIC
status
IUDecompress(fileseries, outstream)
char *fileseries;
FILE *outstream;
{
    if(outstream == (FILE *)NULL)
	return Error(IU_EINVALIDARG, "IUDecompress: NULL output stream", "230");

    if(ferror(outstream))
	return Error(errno, "IUDecompress: output stream error", "233");

    return decompress(fileseries, outstream);
}

static int offset;
long int in_count = 1;			/* length of input */
long int bytes_out;			/* length of compressed output */
long int out_count = 0;			/* # of codes output (for debugging) */

/*{{ FUNCDOC 3
 *
 * Name 	: compress - compress and input stream to muliple files
 *
 * Synopsis	: PRIVATE
 *		  status
 *		  compress(instream, outfile)
 *		  FILE *instream;
 *		  char *outfile;
 *
 * Arguments	: instream - a FILE input stream
 *
 *		  outfile - name of the destination output series
 *
 * Description	: This is a modified version of the compress function from 
 *                the compress(1) utility. I have changed the interface to allow
 *		  multiple output files to be written when the output reaches just
 *		  short of the hard ulimit value returned by getrlimit. This makes
 *		  it possible to reimplement a better version of dbexport which
 *		  will handle arbitarily sized tables well in excess of the 2GB 
 *		  theoretical limit imposed on dbexport.
 *
 *		  A base output file name is supplied as an arguement and this
 *		  will be used to construct a list of output files e.g. bert.000.Z
 *		  bert.001.Z etc.
 *
 * Notes	: In practise, on the AIX platform that this was developed, the
 *		  hard ulimit was 1GB.
 *
 *		  The following algorithm description comes directly from the 
 *		  original source.
 *
 *
 * Algorithm	: use open addressing double hashing (no chaining) on the 
 * 		  prefix code / next character combination.  We do a variant of Knuth's
 * 		  algorithm D (vol. 3, sec. 6.4) along with G. Knott's relatively-prime
 * 		  secondary probe.  Here, the modular division first probe is gives way
 * 		  to a faster exclusive-or manipulation.  Also do block compression with
 * 		  an adaptive reset, whereby the code table is cleared when the 
 *		  compression ratio decreases, but after the table fills.	
 *
 *	          The variable-length output codes are re-sized at this point, and a 
 *		  special CLEAR code is generated for the decompressor. 
 * 		  Late addition:  construct the table according to file size for 
 *		  noticeable speed improvement on small files.  
 *
 *                Please direct questions about this implementation to ames!jaw.
 * 
 * Returns	: IU_SUCCESS on success, errno values or IU values on error
 *
 * See Also	: IUCompress - the PUBLIC front end routine
 *
 */

PRIVATE
status
compress(instream, outfile)
FILE *instream;
char *outfile;
{
    register long fcode;
    register code_int i = 0;
    register int c;
    register code_int ent;
    register code_int disp;
    register code_int hsize_reg;
    register int hshift;
    FILE *outstream;
    int filecount = 0;
    char outputfilename[ _POSIX_PATH_MAX ];
    long max_file_bytes = 0;
    struct rlimit rl;
    int first = 1;

    /*
     * Check out our ulimit values and up them to the
     * max allowed for this process.
     */

    if(getrlimit(RLIMIT_FSIZE, &rl))
	return Error(errno, "compress: cannot retrieve ulimit", "323");

    if(rl.rlim_cur < rl.rlim_max)
    {
	rl.rlim_cur = rl.rlim_max;

	if(setrlimit(RLIMIT_FSIZE, &rl))
	    return Error(errno, "compress: cannot set ulimit", "330");
    }

    /*
     * Keep a note of how much we can actually write before hitting
     * the hard ulimit. I have reduced it by 100000 so that there
     * are no block overlap errors (see cl_block())
     */

    max_file_bytes = rl.rlim_max - 100000;

    offset = 0;
    bytes_out = 3;	/* includes 3-byte header */
    out_count = 0;
    clear_flg = 0;
    ratio = 0;
    in_count = 1;
    checkpoint = CHECK_GAP;
    maxcode = MAXCODE(n_bits = INIT_BITS);
    free_ent = ((block_compress) ? FIRST : 256 );

    ent = fgetc(instream);

    hshift = 0;

    for ( fcode = (long) hsize;	 fcode < 65536L; fcode *= 2L )
	hshift++;
    hshift = 8 - hshift;

    hsize_reg = hsize;
    cl_hash( (count_int) hsize_reg);


    while ( (c = fgetc(instream)) != EOF ) 
    {
	in_count++;

	/*
	 * If we are in danger of hitting hard ulimit,
	 * then time to close this file and open another.
	 *
	 * The first time through this loop we need to create the initial
	 * file.
	 */

	if ( bytes_out > max_file_bytes || first )
	{
	    first = 0;

	    if(outstream != (FILE *)NULL)
	    {
		fflush(outstream);
		fclose(outstream);
	    }

	    /*
	     * Files will be numbered 000, 001, 002, 003...
	     *
	     * If we hit 999 the next will be 1000 so no
	     * problems with overrun.
	     */
		
	    sprintf(outputfilename, "%s.%03d.Z", outfile, filecount++);

	    if((outstream = fopen(outputfilename, "w")) == (FILE *)NULL)
		return Error(errno, "compress: opening output file name", "395");

	    /*
	     * All files will include the magic header. This is so that if
	     * necessary, you could uncompress all the files individually
	     */

	    fputc(magic_header[0], outstream); fputc(magic_header[1], outstream);
	    fputc((char)(maxbits | block_compress), outstream);

	    if(ferror(outstream))
		return Error(errno, "compress: output stream error", "406");

	    /*
	     * This both accounts for the initial three bytes of the magic header
	     * and also resets bytes_out so that we do not get overrun 
	     */

	    bytes_out = 3;
	}

	fcode = (long) (((long) c << maxbits) + ent);

	i = (((code_int)c << hshift) ^ ent);

	if ( htabof (i) == fcode ) {
	    ent = codetabof (i);
	    continue;
	} else if ( (long)htabof (i) < 0 )
	    goto nomatch;
	disp = hsize_reg - i;
	if ( i == 0 )
	    disp = 1;
probe:
	if ( (i -= disp) < 0 )
	    i += hsize_reg;

	if ( htabof (i) == fcode ) {
	    ent = codetabof (i);
	    continue;
	}
	if ( (long)htabof (i) > 0 ) 
	    goto probe;
nomatch:
	output ( (code_int) ent, outstream );
	out_count++;
	ent = c;
	if ( free_ent < maxmaxcode ) {
	    codetabof (i) = free_ent++; /* code -> hashtable */
	    htabof (i) = fcode;
	}
	else if ( (count_int)in_count >= checkpoint && block_compress )
	    cl_block (outstream);
    }

    output( (code_int)ent, outstream );
    out_count++;
    output( (code_int)-1, outstream );

    return IU_SUCCESS;
}

static char buf[BITS];

char_type lmask[9] = {0xff, 0xfe, 0xfc, 0xf8, 0xf0, 0xe0, 0xc0, 0x80, 0x00};
char_type rmask[9] = {0x00, 0x01, 0x03, 0x07, 0x0f, 0x1f, 0x3f, 0x7f, 0xff};


/*{{ FUNCDOC
 *
 * Name 	: output - the compress output function.
 *
 * Synopsis	: PRIVATE
 *		  void
 *		  output( code, outstream )
 *		  code_int  code;
 *		  FILE *outstream;
 *
 * Arguments	: code - A n_bits-bit integer.  If == -1, then EOF.  This assumes
 *		         that n_bits =< (long)wordsize - 1.
 *
 *		  outstream - the current FILE pointer.
 *
 * Description	: I don't really feel qualified enough to comment on this routine.
 *		  refer to compress for details on how to contact the author or
 *		  the relevant Knuth reference.
 *
 * Algorithm	: Maintain a BITS character long buffer (so that 8 codes will
 * 		  fit in it exactly). Insert each code in turn.  When the buffer 
 *		  fills up empty it and start over.
 *
 * Returns	: void
 *
 * See Also	: compress
 *
 */

PRIVATE
void
output( code, outstream )
code_int  code;
FILE *outstream;
{
    register int r_off = offset, bits= n_bits;
    register char * bp = buf;

    if ( code >= 0 ) 
    {
	bp += (r_off >> 3);
	r_off &= 7;
	*bp = (*bp & rmask[r_off]) | (code << r_off) & lmask[r_off];
	bp++;
	bits -= (8 - r_off);
	code >>= 8 - r_off;

	if ( bits >= 8 )
	{
	    *bp++ = code;
	    code >>= 8;
	    bits -= 8;
	}

	if(bits)
	    *bp = code;

	offset += n_bits;

	if ( offset == (n_bits << 3) )
	{
	    bp = buf;
	    bits = n_bits;
	    bytes_out += bits;

	    do
		fputc(*bp++, outstream);
	    while(--bits);
	    offset = 0;
	}

	if ( free_ent > maxcode || (clear_flg > 0))
	{

	    if ( offset > 0 ) 
	    {
		if( fwrite( buf, 1, n_bits, outstream) != n_bits)
		{
		    Error(errno, "compress", "541");
		    return;
		}
		bytes_out += n_bits;
	    }

	    offset = 0;

	    if ( clear_flg )
	    {
		maxcode = MAXCODE (n_bits = INIT_BITS);
		clear_flg = 0;
	    }
	    else
	    {
		n_bits++;
		if ( n_bits == maxbits )
		    maxcode = maxmaxcode;
		else
		    maxcode = MAXCODE(n_bits);
	    }
	}
    } 
    else
    {
	if ( offset > 0 )
	    fwrite( buf, 1, (offset + 7) / 8, outstream );
	bytes_out += (offset + 7) / 8;
	offset = 0;
	fflush( outstream );
	if(ferror(outstream))
	{
	    if(errno)
		Error(errno, "compress.output: output stream error", "574");
	    return;
	}
    }
}

/*{{ FUNCDOC
 *
 * Name 	: decompress - decompress a series of compressed files to a stream
 *
 * Synopsis	: PRIVATE
 *		  status
 *		  decompress(infile, outstream)
 *		  char *infile;
 *		  FILE *outstream;
 *
 * Arguments	: infile - the extentionless name of the file which is appended with
 *			   a NNN.unl.Z where NNN starts at 000 and serially increments.
 *		  
 *		  outstream - the output stream to write the decompressed file(s) to.
 *
 * Description	: decompress is front ended by the PUBLIC routine IUDecompress() which
 *		  does some basic argument checking and strips, if necessary any of the
 *		  file suffixes which are added by this routine.
 *
 * Algorithm	: This routine adapts to the codes in the file building the "string" 
 *		  table on-the-fly; requiring no table to be stored in the compressed 
 *		  file.  The tables used herein are shared with those of the compress() 
 *		  routine.  See the definitions above.
 *
 * Returns	: IU_SUCCESS on success, errno values or status values on errors.
 *
 * See Also	: compress(), getcode()
 *
 */

PRIVATE
status
decompress(infile, outstream)
char *infile;
FILE *outstream;
{
    register char_type *stackp;
    register int finchar;
    register code_int code, oldcode, incode;
    FILE *instream;
    char inputfilename[ _POSIX_PATH_MAX ];
    int filecount = 0;
    struct stat sb;


    for(;;)
    {
	sprintf(inputfilename, "%s.%03d.Z", infile, filecount++);

	/*
	 * This is our end of file test. If there are no more files
	 * to read, then we return OK
	 */

	if(stat(inputfilename, &sb) != 0)
	    return IU_SUCCESS;


	if((instream = fopen(inputfilename, "r")) == (FILE *)NULL)
	    return Error(errno, "decompress: opening input file", "639");

	if ((fgetc(instream) != (magic_header[0] & 0xFF)) 
	    || (fgetc(instream) != (magic_header[1] & 0xFF))) 
	{
	    char msg[ 200 ];

	    sprintf(msg, "decompress: %s not in compressed format\n", inputfilename);

	    return Error(IU_EINVALIDARG, msg, "648");
	}


	/*
	 * fsize below is set to be a large value because it is assumed that
	 * the stream input will be large.
	 */

	maxbits = fgetc(instream);	/* set -b from file */
	block_compress = maxbits & BLOCK_MASK;
	maxbits &= BIT_MASK;
	maxmaxcode = (code_int) 1 << maxbits;
	fsize = 100000;

	if(maxbits > BITS) 
	{
	    char msg[ 200 ];

	    sprintf(msg, "decompress: compressed with %d bits, can only handle %d bits\n",
		maxbits, BITS);

	    return Error(IU_EDECOMPRESS_MAXBITS, msg, "670");
	}

	maxcode = MAXCODE(n_bits = INIT_BITS);

	for ( code = 255; code >= 0; code-- ) 
	{
	    tab_prefixof(code) = 0;
	    tab_suffixof(code) = (char_type)code;
	}

	free_ent = ((block_compress) ? FIRST : 256 );

	finchar = oldcode = getcode(instream);

	/*
	 * If we have reached end of file on this particular input file
	 * loop back to the beginning and try the next file in sequence.
	 * If that file does not exist, then return.
	 */

	if(oldcode == -1)
	{
	    fflush(instream);
	    fclose(instream);

	    if(ferror(instream))
		return Error(errno, "decompress: input stream error", "697");

	    continue;
	}

	fputc( (char)finchar, outstream );

	if(ferror(outstream))
	    return Error(errno, "decompress: output stream error", "705");

	stackp = de_stack;

	while ( (code = getcode(instream)) > -1 )
	{

	    if ( (code == CLEAR) && block_compress )
	    {
		for ( code = 255; code >= 0; code-- )
		    tab_prefixof(code) = 0;

		clear_flg = 1;

		free_ent = FIRST - 1;

		/*
		 * Premature EOF, break out of this while loop and
		 * close the file at the bottom in preparation for
		 * the next file
		 */

		if ( (code = getcode (instream)) == -1 )
		    break;
	    }

	    incode = code;

	    /*
	     * Special case for KwKwK string.
	     */

	    if ( code >= free_ent ) 
	    {
		*stackp++ = finchar;
		code = oldcode;
	    }

	    while ( code >= 256 )
	    {
		*stackp++ = tab_suffixof(code);
		code = tab_prefixof(code);
	    }

	    *stackp++ = finchar = tab_suffixof(code);

	    do
		fputc( *--stackp, outstream );
	    while ( stackp > de_stack );

	    if ( (code=free_ent) < maxmaxcode ) 
	    {
		tab_prefixof(code) = (unsigned short)oldcode;
		tab_suffixof(code) = finchar;
		free_ent = code+1;
	    } 

	    oldcode = incode;
	}

	fflush( instream );
	fclose( instream );

	if(ferror(instream))
	    return Error(errno, "decompress: input stream error", "769");
    }
}

/*{{ FUNCDOC
 *
 * Name 	: getcode - get a code for decompress from the current input file.
 *
 * Synopsis	: PRIVATE
 *		  code_int
 *		  getcode(instream) 
 *		  FILE *instream;
 *
 * Arguments	: instream - the FILE which we are reading the compressed input from
 *
 * Description	: as above 
 *
 * Returns	: code or -1 on EOF
 *
 * See Also	: decompress
 *
 */

PRIVATE
code_int
getcode(instream) 
FILE *instream;
{
    register code_int code;
    static int offset = 0, size = 0;
    static char_type buf[BITS];
    register int r_off, bits;
    register char_type *bp = buf;

    if ( clear_flg > 0 || offset >= size || free_ent > maxcode ) 
    {
	if ( free_ent > maxcode ) {
	    n_bits++;
	    if ( n_bits == maxbits )
		maxcode = maxmaxcode;	/* won't get any bigger now */
	    else
		maxcode = MAXCODE(n_bits);
	}
	if ( clear_flg > 0) {
	    maxcode = MAXCODE (n_bits = INIT_BITS);
	    clear_flg = 0;
	}
	size = fread( buf, 1, n_bits, instream );
	if ( size <= 0 )
	    return -1;			/* end of file */
	offset = 0;
	size = (size << 3) - (n_bits - 1);
    }

    r_off = offset;
    bits = n_bits;
    bp += (r_off >> 3);
    r_off &= 7;
    code = (*bp++ >> r_off);
    bits -= (8 - r_off);
    r_off = 8 - r_off;

    if ( bits >= 8 )
    {
	code |= *bp++ << r_off;
	r_off += 8;
	bits -= 8;
    }
    code |= (*bp & rmask[bits]) << r_off;
    offset += n_bits;

    return code;
}

/*{{ FUNCDOC
 *
 * Name 	: cl_block - table clear for block compress
 *
 * Synopsis	: PRIVATE
 *		  void
 *		  cl_block (outstream)
 *		  FILE *outstream;
 *
 * Arguments	: outstream - the output FILE stream
 *
 * Description	: As above (from the original source) 
 *
 * Returns	: void
 *
 * See Also	: compress()
 *
 */

PRIVATE
void
cl_block (outstream)
FILE *outstream;
{
    register long int rat;

    checkpoint = in_count + CHECK_GAP;

    if(in_count > 0x007fffff)
    { 
	rat = bytes_out >> 8;

	if(rat == 0) 
	{
	    rat = 0x7fffffff;
	}
	else
	{
	    rat = in_count / rat;
	}
    } 
    else
    {
	rat = (in_count << 8) / bytes_out;	/* 8 fractional bits */
    }

    if ( rat > ratio )
    {
	ratio = rat;
    }
    else
    {
	ratio = 0;
	cl_hash ( (count_int) hsize );
	free_ent = FIRST;
	clear_flg = 1;
	output ( (code_int) CLEAR, outstream);
    }
}

/*{{ FUNCDOC
 *
 * Name 	: cl_hash - clear the hash table
 *
 * Synopsis	: PRIVATE
 *		  void
 *		  cl_hash(hsize)
 *		  register count_int hsize;
 *
 * Arguments	: hsize - the size of the current hash table
 *
 * Description	: clears the hash table 
 *
 * Returns	: void
 *
 * See Also	: compress()
 *
 */

PRIVATE
void
cl_hash(hsize)
register count_int hsize;
{
    register count_int *htab_p = htab+hsize;

    register long i;
    register long m1 = -1;

    i = hsize - 16;
    do 
    {
	*(htab_p-16) = m1;
	*(htab_p-15) = m1;
	*(htab_p-14) = m1;
	*(htab_p-13) = m1;
	*(htab_p-12) = m1;
	*(htab_p-11) = m1;
	*(htab_p-10) = m1;
	*(htab_p-9) = m1;
	*(htab_p-8) = m1;
	*(htab_p-7) = m1;
	*(htab_p-6) = m1;
	*(htab_p-5) = m1;
	*(htab_p-4) = m1;
	*(htab_p-3) = m1;
	*(htab_p-2) = m1;
	*(htab_p-1) = m1;
	htab_p -= 16;
    }
    while ((i -= 16) >= 0);

    for ( i += 16; i > 0; i-- )
	    *--htab_p = m1;
}

#ifdef TEST


main()
{
    FILE *fp, *ofp;
    status retval;

    setbuf(stdout, (char *)NULL);
    
    printf("Opening /etc/services for compression\n");

    if((fp = fopen("/etc/services", "r")) == (FILE *)NULL)
    {
	perror("fopen");
	exit(1);
    }

    if((ofp = fopen("bert", "w")) == (FILE *)NULL)
    {
	perror("fopen");
	exit(1);
    }

    printf("Starting compress to bert.000.Z\n");

    if ((retval = IUCompress(fp, "bert")) != IU_SUCCESS)
    {
	printf("compress returned %d\n", retval);
	exit(1);
    }

    printf("Compress succeeded\n");

    printf("Starting decompress of the bert series of files\n");

    if((retval = IUDecompress("bert", ofp)) != IU_SUCCESS)
    {
	printf("decompress returned %d\n", retval);
	exit(1);
    }

    printf("Perform a diff between /etc/services and bert\n");

    fclose(ofp);

    exit(0);
}

#endif
