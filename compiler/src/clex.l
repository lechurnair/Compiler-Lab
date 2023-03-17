%{
	#include <stdlib.h>
	#include "../include/cheader.h"
	#include "y.tab.h"
	void yyerror(char *);
%}

alpha [A-Za-z]
digit [0-9]
und [_]

%%
([0-9]*[.])?[0-9]* {
	yylval.iValue = atof(yytext);
	return NUMBER;
}
"begindecl" {return BEGINS;}
"enddecl" {return ENDS;}
"print" {return PRINT;}
"integer" {return INT;}

{alpha}({alpha}|{digit}|{und})* {yylval.str=strdup(yytext);
	return IDENTIFIER;
}
"=" {return '=';}
"+" {return '+';}
"-" {return '-';}
"*" {return '*';}
"/" {return '/';}
";" {return ';';}
"," {return COMMA;}
"(" {return '(';}
")" {return ')';}
[ \t\n]+ {;} 
. yyerror("Not a Valid Input");
%%

int yywrap(void) {
	return 1;
}
