%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"

extern int yylex();
extern int yylineno;
void yyerror(const char *s);

char *last_type = NULL;
Type last_expr_type = TYPE_UNKNOWN;
%}

%union {
    char *str;
    int intval;
}

%token <str> INT FLOAT CHAR
%token <str> IDENT
%token <intval> INT_CONST
%token <intval> FLOAT_CONST
%token ASSIGN SEMI LPAREN RPAREN PLUS MINUS MUL DIV
%token <str> UNKNOWN
%token <str> DOUBLE

%type <str> type
%type <str> varlist
%type <str> expr
%type <str> factor
%type <str> declaration
%type <str> var_decl


%%

program:
    /* empty */
    | program stmt
    ;

stmt:
    declaration
    | expr_stmt
    ;

declaration:
    type varlist SEMI {
        /* varlist already inserted by varlist rule */
    }
    ;

type:
    INT    { $$ = strdup("int"); last_type = $$; }
    | FLOAT { $$ = strdup("float"); last_type = $$; }
    | CHAR  { $$ = strdup("char"); last_type = $$; }
    | DOUBLE { $$ = strdup("double"); last_type = $$; }
    ;

varlist:
    var_decl
    | varlist ',' var_decl
    ;

var_decl:
    IDENT {
        Type t = TYPE_UNKNOWN;
        if (strcmp(last_type, "int")==0) t = TYPE_INT;
        else if (strcmp(last_type, "float")==0) t = TYPE_FLOAT;
        else if (strcmp(last_type, "char")==0) t = TYPE_CHAR;
        else if (strcmp(last_type, "double")==0) t = TYPE_DOUBLE;
        symtab_insert($1, t);
        free($1);
    }
    | IDENT ASSIGN expr {
        Type t = TYPE_UNKNOWN;
        if (strcmp(last_type, "int")==0) t = TYPE_INT;
        else if (strcmp(last_type, "float")==0) t = TYPE_FLOAT;
        else if (strcmp(last_type, "char")==0) t = TYPE_CHAR;
        else if (strcmp(last_type, "double")==0) t = TYPE_DOUBLE;
        symtab_insert($1, t);
        if (t != last_expr_type && last_expr_type != TYPE_UNKNOWN) {
            printf("Error semántico (línea %d): inicialización incompatible para '%s' (esperado %s, encontrado %s)\n",
                   yylineno, $1, type_to_string(t), type_to_string(last_expr_type));
        }
        free($1);
    }
    ;

expr_stmt:
    expr SEMI { }
    ;

expr:
    IDENT ASSIGN expr {
        Symbol *s = symtab_lookup($1);
        if (!s) {
            printf("Error semántico (línea %d): variable '%s' no declarada\n", yylineno, $1);
        } else {
            if (s->type != last_expr_type && last_expr_type != TYPE_UNKNOWN) {
                printf("Error semántico (línea %d): asignación de tipo incompatible a '%s' (esperado %s, encontrado %s)\n",
                       yylineno, $1, type_to_string(s->type), type_to_string(last_expr_type));
            }
        }
        free($1);
    }
    | expr PLUS expr { }
    | expr MINUS expr { }
    | expr MUL expr { }
    | expr DIV expr { }
    | factor { }
    ;

factor:
    IDENT {
        Symbol *s = symtab_lookup($1);
        if (!s) {
            printf("Error semántico (línea %d): variable '%s' no declarada\n", yylineno, $1);
            last_expr_type = TYPE_UNKNOWN;
        } else {
            last_expr_type = s->type;
        }
        free($1);
    }
    | INT_CONST {
        last_expr_type = TYPE_INT;
    }
    | FLOAT_CONST {
        last_expr_type = TYPE_FLOAT;
    }
    | LPAREN expr RPAREN { }
    | UNKNOWN {
        last_expr_type = TYPE_UNKNOWN;
        free($1);
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error sintáctico: %s (línea %d)\n", s, yylineno);
}

int main(int argc, char **argv) {
    symtab_init();
    yylineno = 1;
    yyparse();
    return 0;
}