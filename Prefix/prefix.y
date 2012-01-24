%{
	#include <stdio.h>
	#include <string.h>
%}

%union {
	char *str;
}

%token NUM ADD MIN MUL DIV

%type <str> T E NUM ADD MIN MUL DIV

%left ADD MIN
%left MUL DIV
%left '('

%%
	T: E'\n' { printf ( "\nPrefix Expression : %s",$1 ); }
	 ;
	E: NUM { $$ = $1;}
	 | E ADD E { $$ = malloc(20); strcat($$,"+"); strcat($$," "); strcat($$,$1); strcat($$," "); strcat($$,$3);}
	 | E MIN E { $$ = malloc(20); strcat($$,"-"); strcat($$," "); strcat($$,$1); strcat($$," "); strcat($$,$3);}
	 | E MUL E { $$ = malloc(20); strcat($$,"*"); strcat($$," "); strcat($$,$1); strcat($$," "); strcat($$,$3);}
	 | E DIV E { $$ = malloc(20); strcat($$,"/"); strcat($$," "); strcat($$,$1); strcat($$," "); strcat($$,$3);}
	 | '('E')' { $$ = $2;}
	 ;
%%

int main() {
	printf ("Enter a valid expression : ");
	yyparse();
	return 0;
}

yyerror(char *err) {}
