/*
 * File		: RmConstraintName.ec
 * 
 * Sccs		: @(#)RmConstraintName.ec	1.4
 *
 * Dated	: 96/10/24 14:43:50 
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

/*
 *
 * Name 	: RmConstraintName - remove constraint statement from create table 
 *
 * Synopsis	: PUBLIC
 *		  void
 *		  RmConstraintName(sqlbuf)
 *		  char *sqlbuf;
 *
 * Arguments	: sqlbuf	- buffer containing the sql statement 
 *
 * Description	: In order to create a temporary table we need to change the name 
 *		  and remove the constraint statements from the sql source.
 *
 * Returns	: void
 *
 * See Also	:
 *
 */

EXEC SQL include "iimport.h";

PRIVATE
char *sccsid = "SCCS: @(#)RmConstraintName.ec	1.4 Continuus: %subsystem: % %filespec: %";

#include <memory.h>
#include <string.h>

PUBLIC
void
RmConstraintName(sqlbuf)
char *sqlbuf;
{
    char *ptr;
    char *token;
    char buf[ MAX_SQL_BUF ];
    int len;

    ptr = sqlbuf;

    len = strlen(sqlbuf);

    bzero(buf, MAX_SQL_BUF);

    while((token = strtok(ptr, " 	\n")) != (char *)NULL)
    {
	ptr = (char *)NULL;

	if(!memcmp(token, "constraint", 10))
	{
	    if((token = strtok(ptr, " 	\n")) != (char *)NULL)
		if(match(token, "[\"a-z][a-z\"]*.[a-z0-9_][a-z0-9_]*,"))
		    strcat(buf, ",\n");
	}
	else
	{
	    strcat(buf, token);

	    if(match(token, ".*,$"))
		strcat(buf, "\n");
	    else
		strcat(buf, " ");
	}
    }

    (void) memcpy(sqlbuf, buf, len);
}

#ifdef TEST

char *sqlbuf1 = "create table \"burnetg\".buffer1 \
  (\
    customer_num serial not null constraint \"burnetg\".n100_2,\
    fname char(15),\
    lname char(15),\
    company char(20),\
    address1 char(20),\
    address2 char(20),\
    city char(15),\
    state char(2),\
    zipcode char(5),\
    phone char(18),\
    primary key (customer_num) constraint \"burnetg\".u100_1\
  );";
char *sqlbuf2 = "create table \"burnetg\".buffer2 \
  (\
    customer_num serial not null constraint \"burnetg\".n100_2,\
    fname char(15),\
    lname char(15),\
    company char(20),\
    address1 char(20),\
    address2 char(20),\
    city char(15),\
    state char(2),\
    zipcode char(5),\
    phone char(18),\
    primary key (customer_num) constraint \"burnetg\".u100_1\
  );";

char *sqlbuf3 = "create table \"burnetg\".buffer3 \
  (\
    customer_num serial not null constraint \"burnetg\".n100_2,\
    fname char(15),\
    lname char(15),\
    company char(20),\
    address1 char(20),\
    address2 char(20),\
    city char(15),\
    state char(2),\
    zipcode char(5),\
    phone char(18),\
    primary key (customer_num) constraint \"burnetg\".u100_1\
  );";

main()
{

    RmConstraintName(sqlbuf1);
    printf("SQLBUF1 [ %s ]\n", sqlbuf1);
    RmConstraintName(sqlbuf2);
    printf("SQLBUF2 [ %s ]\n", sqlbuf2);
    RmConstraintName(sqlbuf3);
    printf("SQLBUF3 [ %s ]\n", sqlbuf3);
}

#endif
