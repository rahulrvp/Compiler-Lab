%{
	#include "source.h"
	#include "expTree.tab.h"

%}

%%

[0-9]+	{
			yylval.nod = malloc (sizeof(struct node));
			yylval.nod -> val = atoi(yytext);
			yylval.nod -> flag = OPND;
			yylval.nod -> left = NULL;
			yylval.nod -> right = NULL;
			return NUM;
		}

[a-z] {
			yylval.nod = malloc (sizeof(struct node));
			yylval.nod -> binding = (toascii(*yytext)-toascii('a'));
			yylval.nod -> name = *yytext;
			yylval.nod -> flag = VAR;
			yylval.nod -> left = NULL;
			yylval.nod -> right = NULL;
			return VARIABLE;
		}

[+]	{ return '+'; }
[-]	{ return '-'; }
[*]	{ return '*'; }
[/]	{ return '/'; }
[=]	{ return '='; }

"read" { return READ; }
"write" { return WRITE; }
"begin" { return BEG; }
"end" { return ENND; }

[\n();] { return *yytext; }

%%
