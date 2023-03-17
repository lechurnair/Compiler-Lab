all: makedir build run

makedir:
	@mkdir -p bin
	@echo "Directories made..."
	
run : bin/a.out
	@echo "Calculator is now ACTIVE"
	@./bin/a.out

build:src/calc.c bin/lex.yy.c bin/y.tab.c 
	@ gcc -o bin/a.out src/calc.c bin/lex.yy.c bin/y.tab.c 
	@echo "Build Finished..."

bin/lex.yy.c:
	@lex -o bin/lex.yy.c src/clex.l
bin/y.tab.c:
	@yacc -o bin/y.tab.c -d src/cyacc.y

clean:	
	@rm -rf bin 