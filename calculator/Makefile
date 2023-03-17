all: run

run: calculator
	@echo "calculator is now active"
	@./a.out 

calculator : lex.yy.c y.tab.c
			@gcc lex.yy.c y.tab.c 2> output.txt

lex.yy.c: 
	@lex calculator.l

y.tab.c: 
	@yacc -d calculator.y 

clean: 
	@rm -rf a.out lex.yy.c y.tab.c output.txt y.tab.h
	@echo "Deleted temporary files"