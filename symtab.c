#include <stdio.h>
#include <string.h>
#include "symtab.h"

static Symbol table[MAX_SYMS];
static int table_size = 0;

void symtab_init() {
    table_size = 0;
    for (int i = 0; i < MAX_SYMS; ++i) {
        table[i].name[0] = '\0';
        table[i].type = TYPE_UNKNOWN;
        table[i].defined = 0;
    }
}

int symtab_insert(const char *name, Type type) {
    for (int i = 0; i < table_size; ++i) {
        if (strcmp(table[i].name, name) == 0) {
            table[i].type = type;
            table[i].defined = 1;
            return 0; // updated existing
        }
    }
    if (table_size >= MAX_SYMS) return -1;
    strncpy(table[table_size].name, name, MAX_NAME-1);
    table[table_size].name[MAX_NAME-1] = '\0';
    table[table_size].type = type;
    table[table_size].defined = 1;
    table_size++;
    return 1; // inserted new
}

Symbol* symtab_lookup(const char *name) {
    for (int i = 0; i < table_size; ++i) {
        if (strcmp(table[i].name, name) == 0) return &table[i];
    }
    return NULL;
}

const char* type_to_string(Type t) {
    switch(t) {
        case TYPE_INT: return "int";
        case TYPE_FLOAT: return "float";
        case TYPE_CHAR: return "char";
        default: return "unknown";
    }
}