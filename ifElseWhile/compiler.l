%{
	#include "source.h"
	#include "compiler.tab.h"

%}

%%

[0-9]+	{
			yylval.nod = malloc (sizeof(struct node));
			yylval.nod -> val = atoi(yytext);
			yylval.nod -> flag = Operand;
			yylval.nod -> left = NULL;
			yylval.nod -> right = NULL;
			return NUM;
		}

[a-z] {
			yylval.nod = malloc (sizeof(struct node));
			yylval.nod -> binding = (toascii(*yytext)-toascii('a'));
			yylval.nod -> name = *yytext;
			yylval.nod -> flag = Variable;
			yylval.nod -> left = NULL;
			yylval.nod -> right = NULL;
			return VARIABLE;
		}

[+]	{ return '+'; }
[-]	{ return '-'; }
[*]	{ return '*'; }
[/]	{ return '/'; }
[=]	{ return '='; }

[<] { return LT; }
[>] { return GT; }
"<=" { return LE; }
">=" { return GE; }
"!=" { return NE; }
"==" { return EQ; }

"read" { return READ; }
"write" { return WRITE; }
"begin" { return BEG; }
"end" { return ENND; }

"if" { return IF; }
"then" { return THEN; }
"else" { return ELSE; }
"endif" { return ENDIF; }

"while" { return WHILE; }
"do" { return DO; }
"endwhile" { return ENDWHILE; }

[\n();] { return *yytext; }

%%
