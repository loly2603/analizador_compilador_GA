%{
#include "parser.tab.h"
#include <string.h>
%}

DIGIT   [0-9]
ID      [a-zA-Z_][a-zA-Z0-9_]*
WS      [ \t\r\n]+

%%

"int"           { return INT; }
"float"         { return FLOAT; }
"char"          { return CHAR; }
"double"        { yylval.str = strdup("double"); return DOUBLE; }

{ID}            { yylval.str = strdup(yytext); return IDENT; }

{DIGIT}+        { yylval.str = strdup(yytext); return INT_CONST; }

{DIGIT}+"."{DIGIT}+ { yylval.str = strdup(yytext); return FLOAT_CONST; }

"="             { return ASSIGN; }
";"             { return SEMI; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MUL; }
"/"             { return DIV; }

"//".*          { /* ignorar comentario */ }

\"[^"]*\"       { yylval.str = strdup(yytext); return UNKNOWN; }
\'[^\']\'       { yylval.str = strdup(yytext); return UNKNOWN; }

{WS}            { /* ignorar espacios */ }

.               { yylval.str = strdup(yytext); return UNKNOWN; }

%%

int yywrap() { return 1; }