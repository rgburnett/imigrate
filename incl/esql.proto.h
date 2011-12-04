#ifndef _ESQLPROTOINCLUDED
#define _ESQLPROTOINCLUDED

/*
 * File		: esql.proto.h - function prototypes for esql files
 * 
 * Sccs		: @(#)esql.proto.h	1.3 
 *
 * Dated	: 96/10/30 15:38:39 
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

PUBLIC status	Error(status type, char *module, char *lineno);
PUBLIC status   IUDBConnect(char *database, char *conname);
PUBLIC status   IUCheck(char *statement);
PUBLIC status   IUCheckSQLCode(char *statement);
PUBLIC status   IUColumnInfo(columninfo *colobj, int index);
PUBLIC status	IUCompress(FILE *instream, char *fileseries);
PUBLIC status 	IUConstraints(char *tablename, int type, ConstraintOperation operation);
PUBLIC status	IUDatabase(int op, char *dbname, char *which_space);
PUBLIC status 	IUDBDisconnect(char *conname);
PUBLIC int	IUDBObjectExists(char *database, dbobjclass objtype, char *objname);
PUBLIC status	IUDecompress(char *fileseries, FILE *outstream);
PUBLIC status	IUDirectory(list *alist, char *path);
PUBLIC void	IUDisplayError(char *statement);
PUBLIC void	IUDisplayException(char *statement, int sqlerr_code, int warn_flag);
PUBLIC void	IUDisplaySQLStateError();
PUBLIC void	IUDisplayShortError();
PUBLIC void	IUDisplayWarning(char *statement);
PUBLIC status	IUExpressionCheck(char *statement, int warn_flag);
PUBLIC status	IUListTables(list *alist, char *dbname);
PUBLIC status	IUMasterTableList(char *tablename, list *alist);
PUBLIC status	IURenameTable(char *database, char *from, char *to);
PUBLIC status	IURunSQL(char *dmlstatement, FILE *output, sqlerrors report);
PUBLIC status	IUSQLStateError();
PUBLIC status	IUUnloadTable(char *table, FILE *outstream);
PUBLIC status	IULoadTable(char *tableseries, int commit_threshold, int compress);
PUBLIC status	IUTransactin(int op);
PUBLIC status	IUTime();

#endif
