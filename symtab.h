#ifndef SYMTAB_H
#define SYMTAB_H

#define MAX_SYMS 1024
#define MAX_NAME 64

typedef enum { TYPE_INT, TYPE_FLOAT, TYPE_CHAR, TYPE_UNKNOWN, TYPE_DOUBLE} Type;

typedef struct {
    char name[MAX_NAME];
    Type type;
    int defined;
} Symbol;

void symtab_init();
int symtab_insert(const char *name, Type type);
Symbol* symtab_lookup(const char *name);
const char* type_to_string(Type t);

#endif