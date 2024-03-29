%{
#define	YYSTYPE	double 	/* data type of yacc stack */
%}
%token NUMBER
%left	'+' '-'	  /* left associative, same precedence */
%left	'*' '/'	  /* left assoc., higher precedence */
%left '(' ')'
%%
list:	  /* Parser: Productions */
	| list '\n'
	| list expr '\n'    { printf("\t%.8g\n", $2); }
	;
expr:	  NUMBER	{ $$ = $1;}
	| expr '+' expr	{ $$ = $1 + $3; }
	| expr '-' expr	{ $$ = $1 - $3; }
	| expr '*' expr	{ $$ = $1 * $3; }
	| expr '/' expr	{ $$ = $1 / $3; }
	| '(' expr ')'	{ $$ = $2; }
	;
%%
	/* end of grammar */

#include <stdio.h>
#include <ctype.h>

char	*progname;	/* for error messages */
int	lineno = 1;

main(argc, argv)	
	char *argv[];
{
	progname = argv[0];
	yyparse();
}


yyerror(s)	/* called for yacc syntax error */
	char *s;
{
	warning(s, (char *) 0);
}

warning(s, t)	/* print warning message */
	char *s, *t;
{
	fprintf(stderr, "%s: %s", progname, s);
	if (t)
		fprintf(stderr, " %s", t);
	fprintf(stderr, " near line %d\n", lineno);
}
