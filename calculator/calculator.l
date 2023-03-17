
%{
  #include<stdio.h>
  #define	YYSTYPE	double 	/* data type of yacc stack */
  #include "y.tab.h"
  extern YYSTYPE yylval;
%}
  
/* Rule Section */
%%

[0-9]*"."[0-9]* {
          yylval=atof(yytext);
          return NUMBER;
       };
[0-9]+ {
          yylval=atoi(yytext);
          return NUMBER;
  
       }   ; 


[ \t] ;
  
[\n] return '\n';
  
. return yytext[0];
%%
  
int yywrap()
{
 return 1;
}
