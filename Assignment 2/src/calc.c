#include <stdio.h>
#include "../include/cheader.h"
//#include "y.tab.c"
#include <string.h>

extern ListNode * list;

ListNode* checkPresence(char *str)
{
    ListNode *temp = list;
    while(temp)
    {
        if(strcmp(str,(temp)->var)==0)
            return temp;
        temp = (temp)->next;
    }
    return NULL;
}


int evaluateexpr(nodeType *p) {
    if (!p) return 0;
    //printf("%d",p->type);
    switch(p->type) {
    case constants:  /*printf("%lf",p->con.value);*/     return p->con.value;
    case operators:
        switch(p->opr.oper) {
        case '+':       return evaluateexpr(p->opr.op1) + evaluateexpr(p->opr.op2);
        case '-':       return evaluateexpr(p->opr.op1) - evaluateexpr(p->opr.op2);
        case '*':       return evaluateexpr(p->opr.op1) * evaluateexpr(p->opr.op2);
        case '/':       return evaluateexpr(p->opr.op1) / evaluateexpr(p->opr.op2);
        }
    case variable: 
        ListNode * p1;
        p1 = checkPresence(p->var.value);
        if(p1)
        {
            return p1->val;
        } 
        perror("Not declared");
    /*case bracket:return evaluate(p->brac.inner);*/
    }
    return 0;
}


void printlist(nodeTypelist *list1)
{
    while (list1)
    {
        printf("%d ",evaluateexpr(list1->curr));
        list1 = list1->next;
    }
    printf("\n");
}

void evaluate(StatNode * statements)
{
    while(statements!=NULL)
    {
        switch (statements->type)
        {
        case assignment:
            ListNode * p1;
            p1 = checkPresence(statements->asn.iden);
            if(p1)
            {
                p1->val = evaluateexpr(statements->asn.exprs);
            }
            else{ 
                //printf("%s ",statements->asn.iden); 
                perror("Not declared");}
            break;
        case printer:
            printlist(statements->prin.vars);
        default:
            break;
        }
        statements = statements->next;
    }
}


