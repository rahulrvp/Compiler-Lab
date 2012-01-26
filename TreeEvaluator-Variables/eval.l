%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "expTree.tab.h"
	struct node {
		int val;
		int binding;
		char op;
		int flag; // 0 if value, 1 if operator
		struct node *left,*right;
	};
%}

%%

[0-9]+	{
			yylval.nod = malloc (sizeof(struct node));
			yylval.nod -> val = atoi(yytext);
			yylval.nod -> flag = 1;
			yylval.nod -> left = NULL;
			yylval.nod -> right = NULL;
			return NUM;
		}

[+]	{
			yylval.nod = malloc (sizeof(struct node));
			yylval.nod -> op = '+';
			yylval.nod -> flag = 0;
			yylval.nod -> left = NULL;
			yylval.nod -> right = NULL;
			return ADD;
		}

[-]	{
			yylval.nod = malloc (sizeof(struct node));
			yylval.nod -> op = '-';
			yylval.nod -> flag = 0;
			yylval.nod -> left = NULL;
			yylval.nod -> right = NULL;
			return MIN;
		}

[*]	{
			yylval.nod = malloc (sizeof(struct node));
			yylval.nod -> op = '*';
			yylval.nod -> flag = 0;
			yylval.nod -> left = NULL;
			yylval.nod -> right = NULL;
			return MUL;
		}

[/]	{
			yylval.nod = malloc (sizeof(struct node));
			yylval.nod -> op = '/';
			yylval.nod -> flag = 0;
			yylval.nod -> left = NULL;
			yylval.nod -> right = NULL;
			return DIV;
		}
[a-z] {
			yylval.nod = malloc (sizeof(struct node));
			yylval.nod -> binding = (toascii(*yytext)-toascii('a'));
			yylval.nod -> flag = VAR;
			yylval.nod -> left = NULL;
			yylval.nod -> right = NULL;
			return VAR;
		}
read {
			yylval.nod = malloc (sizeof(struct node));
			yylval.nod -> flag = READ;
			return READ;
		}
write {
			yylval.nod = malloc (sizeof(struct node));
			yylval.nod -> flag = WRITE;
			return WRITE;
		}
[\n()] { return *yytext; }

%%
