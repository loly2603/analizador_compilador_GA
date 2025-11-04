all: analizador

parser.tab.c parser.tab.h: parser.y
	bison -d -v parser.y

lex.yy.c: scanner.l parser.tab.h
	flex scanner.l

analizador: parser.tab.c lex.yy.c symtab.c
	gcc -o analizador parser.tab.c lex.yy.c symtab.c -lfl

clean:
	rm -f parser.tab.c parser.tab.h lex.yy.c parser.output analizador