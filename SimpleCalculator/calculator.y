%{
	#include <stdio.h>
	#include <string.h>
%}

%token NUM
%left '+' '-'
%left '*' '/'

%%
	T: E'\n' {printf ( "Result of the exprn is : %d",$$); }
	 ;
	E: NUM { $$ = $1; }
	 | E'+'E { $$ = $1 + $3; }
	 | E'-'E { $$ = $1 - $3; }
	 | E'*'E { $$ = $1 * $3; }
	 | E'/'E { $$ = $1 / $3; }
	 | '('E')' { $$ = $2; }
	 ;
%%

int main() {
	printf ("Enter a valid expression : ");
	yyparse();
	printf ("\n");
	return 0;
}

yyerror(char *err) {}
