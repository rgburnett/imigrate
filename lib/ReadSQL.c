/*
 * File		: ReadSQL.c
 * 
 * Sccs		: @(#)ReadSQL.c	1.2
 *
 * Dated	: 96/10/30 15:24:27 
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
#include <string.h>

PRIVATE
char *sccsid = "SCCS: @(#)ReadSQL.c	1.2 Continuus: %subsystem: % %filespec: %";

/*{{ FUNCDOC 3
 *
 * Name 	: ReadSQL - read an SQL statement from a file
 *
 * Synopsis	: PUBLIC
 *		  char *
 *		  ReadSQL(into, from)
 *		  char *into;
 *		  FILE *from;
 *
 * Arguments	: into - a buffer to read the statement into
 *
 * Description	: from - the FILE stream we are reading from 
 *
 * Returns	: a pointer to the buffer or NULL on error/EOF 
 *
 * See Also	: match() 
 *
 */

typedef enum 
{
    INSTATEMENT,
    INPROC, 
    ENDPROC,
    INCOMMENT, 
    ENDCOMMENT, 
    SEMICOLON,
    SKIPSPACE
} state;

PUBLIC
char *
ReadSQL(into, from)
char *into;
FILE *from;
{
    char *ptr;
    char token[ 100 ];
    char last[ 100 ];
    char sqlbuf[ MAX_SQL_BUF ];
    int braces = 0;
    int c;
    int retval;
    state previous, tokenstate = SKIPSPACE;

    if ( from == (FILE *)NULL)
	return (char *)NULL;

    bzero(into, strlen(into));

    while((retval = GetSQLToken(token, from)) != EOF)
    {
	previous = tokenstate;

	if(*token == '{')
	    tokenstate = INCOMMENT;

	else if (*token == '}')
	    tokenstate = ENDCOMMENT;
	else if (*token == ';')
	{
	    if(tokenstate != INPROC)
		tokenstate = SEMICOLON;
	}
	else if(!strcmp(token, "procedure"))
	{
	    if(!strcmp(last, "create"))
		tokenstate = INPROC;
	    else if(!strcmp(last, "end"))
		tokenstate = ENDPROC;
	}
	else if(!isspace(*token))
	{
	    if(tokenstate != INCOMMENT && tokenstate != INPROC)
		tokenstate = INSTATEMENT;
	}
	else
	{
	    if(tokenstate == SEMICOLON) 
		tokenstate = SKIPSPACE;
	}

	switch(tokenstate)
	{
	    case SKIPSPACE:
		continue;

	    case INCOMMENT:
		if(*token == '{')
		    braces++;
		continue;

	    case ENDCOMMENT:
		if(--braces == 0)
		    tokenstate = SKIPSPACE;
		continue;

	    case ENDPROC:
		tokenstate = SKIPSPACE;
		strcat(into, token);
		break;

	    case SEMICOLON:
		strcat(into, ";");
		return into;
		
	    case INPROC:
	    case INSTATEMENT:
		strcat(into, token);
		break;
	}

	if(!isspace(*token))
	    strcpy(last, token);
    }

    return (retval == EOF) ? (char *)NULL : into;
}

PRIVATE
GetSQLToken(to, from)
char *to;
FILE *from;
{
    char *ptr;
    int c;
    int inspace = 0;
    int inword = 0;

    if(from == (FILE *)NULL && to != (char *)NULL)
    {
	Error(IU_EINVALIDARG, "ReadSQL.GetSQLToken: NULL pointer", "168");
	return EOF;
    }

    ptr = to;

    while((c = fgetc(from)) != EOF)
    {
	if(ferror(from))
	{
	    Error(errno, "ReadSQL.GetSQLToken: I/O error", "178");
	    return EOF;
	}

	if(c == '\n')
	    ++linecount;
	    
	if(isspace(c))
	{
	    if(inspace == 0 && inword)
	    {
		ungetc(c, from);
		if( c == '\n')
		    --linecount;
		*ptr = '\0';
		break;
	    }

	    *ptr++ = c;
	    inspace = 1;
	}
	else
	{
	    inword = 1;

	    if(inspace == 1)
	    {
		ungetc(c, from);
		if( c == '\n')
		    --linecount;
		*ptr = '\0';
		break;
	    }
		
	    if(ispunct(c) && c != '"' && c != '_' && c != '.')
	    {
		if(ptr == to)
		{
		    *ptr++ = c;
		    *ptr = '\0';
		    break;
		}

		ungetc(c, from);
		if( c == '\n')
		    --linecount;
		*ptr = '\0';
		break;
	    }

	    *ptr++ = c;
	    *ptr = '\0';
	}

    }

    return (c == EOF) ? EOF : 1;
}

#ifdef TEST

char *strings[]= {
    "create database stores7;",
    "grant connect to \"burnetg\" -- this is a comment",
    "",
    "{ THIS MALARKY shoudl not be read }",
    "grant dba to \"burnetg\";",
    "grant resource to \"public\";",
    "create table \"burnetg\".customer ",
    "  (",
    "	customer_num serial not null constraint \"burnetg\".n100_2,",
    " 	fname char(15),",
    "	lname char(15),",
    "	company char(20),",
    "	address1 char(20),",
    "	address2 char(20),",
    "	city char(15),",
    "	state char(2),",
    "	zipcode char(5),",
    "	phone char(18),",
    "	primary key (customer_num) constraint \"burnetg\".u100_1",
    "     );",
    "",
    "revoke all on \"burnetg\".customer from \"public\";",
    "",
    "create procedure \"burnetg\".absaddr_U  ( uversion_used smallint)",
    "",
    "	    if (uversion_used = 1) ",
    "	    then",
    "		update cust_calls",
    "		set call_code = \"B\"",
    "		where", 
    "		    call_code = \"A\";",
    "	    end if;",
    "end procedure;",
    "",
    "grant execute on absaddr_U to public as burnetg;",
    "grant - thsi is the last statement;",
    "{ THE END }",
    NULL
};

main()
{
    FILE *fp;
    char buf[ 4096 ];
    int i;

    setbuf(stdout, (char *)NULL);

    if((fp = fopen(".t", "w")) == (FILE *)NULL)
    {
	perror("Cannot open temp file [ .t ]\n");
	exit(1);
    }

    for( i = 0; strings[ i ]; i++)
	fprintf(fp, "%s\n", strings[ i ]);

    fflush(fp);
    fclose(fp);

    if((fp = fopen(".t", "r")) == (FILE *)NULL)
    {
	perror("Cannot open temp file [ .t ]\n");
	exit(1);
    }

    while(ReadSQL(buf, fp) != (char *)NULL)
    {
	printf(" Read [ %s ] %d\n", buf, linecount);
	sleep(1);
    }

    fclose(fp);

    unlink(".t");
}
    
#endif
