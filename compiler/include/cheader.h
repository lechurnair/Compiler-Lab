
typedef enum { constants, operators/*, bracket*/ ,variable} nodeEnum;
typedef enum { assignment, printer } stateEnum;
/* constants */
typedef struct {
    int value;                  /* value of constant */
} conNodeType;

typedef struct {
    char *value;                  /* value of constant */
} varNodeType;


typedef struct list
{
    char * var;
    int val;
    int assigned;
    struct list * next;
} ListNode;


/* operators */
typedef struct {
    char oper;                   /* operator */
    struct nodeTypeTag *op1; 
    struct nodeTypeTag *op2;  
 
} oprNodeType;


typedef struct nodeTypeTag {
    nodeEnum type;              /* type of node */

    union {
        conNodeType con;        /* constants */
        oprNodeType opr;        /* operators */
        varNodeType var;
    };
} nodeType;

typedef struct nodeTypelist
{
    nodeType *curr;
    struct nodeTypelist* next;
} nodeTypelist;

typedef struct 
{
    char* iden;
    nodeType * exprs;
}assignNode;

typedef struct 
{
    nodeTypelist* vars;
}printNode;


typedef struct statem
{
    stateEnum type;
    union{
        assignNode asn;
        printNode prin;
    };
    struct statem * next;
    
} StatNode;

extern ListNode * list;
