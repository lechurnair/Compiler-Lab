%{
#include <stdio.h>
#include <stdlib.h>
#include "../include/cheader.h"
nodeType *opr(char oper, nodeType *val1, nodeType * val2);
nodeType *con(int val);
nodeType *var(char* val);
void evaluate(StatNode * statements);
void freeNode(nodeType *p);
ListNode* makeList(char* s);
StatNode* asn(char *s,nodeType *p);
StatNode* prin(nodeTypelist* list);
ListNode * list;
nodeTypelist *makemixList(nodeType *p);
//void printlist(ListNode* list);
//void printstatements(StatNode *stats);
int yylex();
void yyerror(const char *s);
%}

%union {
	int iValue;
	//char* opValue;
    char* str;
    ListNode* varlist;
    StatNode * statlist;
	nodeType *nPtr;
    nodeTypelist *nPtrl;
}

%token <iValue> NUMBER
%token <str> IDENTIFIER
%token PRINT BEGINS ENDS INT COMMA
%left '+' '-'
%left '*' '/'
/*%left '(' ')'*/
%type <nPtr> expr
%type <varlist> decl  ident_list
%type <statlist> statements state_list
%type <nPtrl> mixlist
%% 

prog: BEGINS decl ENDS state_list  {list = $2; evaluate($4);}
    ;

decl: INT ident_list ';' { /*printlist($2);*/ $$ = $2;}
    | INT ident_list ';' decl {
                        ListNode* val = $2;
                        while(val->next!=NULL)
                        {
                            val = val->next;
                        }
                        val->next = $4;
                        $$ = $2;
                        }
    ;

ident_list: IDENTIFIER {ListNode *val = makeList($1);
                        $$ = val;
                        }
    |  IDENTIFIER COMMA ident_list{ ListNode* val = makeList($1);
                                 val->next = $3;
                                 $$ = val;}
    ;

mixlist : expr  {$$ = makemixList($1);}
        | expr COMMA mixlist {nodeTypelist * val = makemixList($1);
                                 val->next = $3;
                                 $$ = val;}

state_list:  state_list statements ';' { /*printstatements($1); printf("HI\n%d\n",$2->type);*/
                    StatNode* val = $1;
                        while(val->next!=NULL)
                        {
                            val = val->next;
                        }
                        val->next = $2;
                        $$ = $1;
                        }
          | statements ';' { $$ = $1;}

statements: IDENTIFIER '=' expr  { $$ = asn($1,$3);}
            | PRINT '(' mixlist ')'  {$$ = prin($3);}
        ;




expr:	  NUMBER	{ $$ = con($1);}
    |   IDENTIFIER  { $$ = var($1);}
	| expr '+' expr	{ $$ = opr('+', $1, $3); }
	| expr '-' expr	{ $$ = opr('-', $1, $3); }
	| expr '*' expr	{ $$ = opr('*', $1, $3); }
	| expr '/' expr	{ $$ = opr('/', $1, $3); }
	| '(' expr ')'	{ $$ = $2;} 
	;
%%

nodeTypelist *makemixList(nodeType *p)
{
    nodeTypelist * ans;
    if ((ans = malloc(sizeof(nodeTypelist))) == NULL)
        yyerror("out of memory");
    ans->curr = p;
    ans->next = NULL;
}

// void printlist(ListNode* list)
// {
//     while(list!=NULL)
//     {
//         printf("%s\n",list->var);
//         list = list->next;
//     }
// }

// void printstatements(StatNode * stat)
// {
//     while(stat!=NULL)
//     {
//         printf("%d\n",stat->type);
//         stat = stat->next;
//     }
// }

ListNode * makeList(char* value)
{
    ListNode* p;
    if ((p = malloc(sizeof(ListNode))) == NULL)
        yyerror("out of memory");
    p->var = value;
    //printf("when list is made %s\n",p->var);
    p->assigned = 0;
    p->next = NULL;
    return p;
}

StatNode *asn(char * variab, nodeType *p)
{
    StatNode *ans;
    if ((ans = malloc(sizeof(StatNode))) == NULL)
        yyerror("out of memory");
    ans->type = assignment;
    ans->asn.iden = variab;
    ans->asn.exprs = p;
    ans->next = NULL;
    return ans;
}

StatNode *prin(nodeTypelist *p)
{
    StatNode *ans;
    if ((ans = malloc(sizeof(StatNode))) == NULL)
        yyerror("out of memory");
    ans->type = printer;
    ans->prin.vars = p;
    ans->next = NULL;
    return ans;
} 

nodeType *var(char * value) {
    nodeType *p;
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");
	p->type = variable;
    p->var.value = value;
    return p;
}

nodeType *con(int value) {
    nodeType *p;
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");
	p->type = constants;
    p->con.value = value;
    return p;
}


nodeType *opr(char oper, nodeType *val1, nodeType *val2) {
    nodeType *p;

    /* allocate node, extending op array */
    if ((p = malloc(sizeof(nodeType) )) == NULL)
        yyerror("out of memory");
    p->opr.oper = oper;
	p->type = operators;
    p->opr.op1 = val1;
    p->opr.op2 = val2;
    return p;
}

void freeNode(nodeType *p) {
	    if (!p) return;
    if (p->type == operators) {
        freeNode(p->opr.op1);
		freeNode(p->opr.op2);
    }
    free (p);
}

void yyerror(const char *s) {
    fprintf(stdout, "%s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}
