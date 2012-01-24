%{
	#include <stdio.h>
	#include <string.h>
%}

%token NUM
%left '+' '-'
%left '*' '/'

%%
	E: NUM { printf ("%d ",$1);}
	 | E'+'E { $$ = $1 + $3; printf("+ ");}
	 | E'-'E { $$ = $1 - $3; printf("- ");}
	 | E'*'E { $$ = $1 * $3; printf("* ");}
	 | E'/'E { $$ = $1 / $3; printf("/ ");}
	 | '('E')' { $$ = $2;}
	 ;
%%

int main() {
	printf ("Enter a valid expression : ");
	yyparse();
	printf ("\n");
	return 0;
}

yyerror(char *err) {}
