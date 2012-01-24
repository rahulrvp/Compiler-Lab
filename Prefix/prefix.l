%{
	#include "calculator.tab.h"
%}

%%
[0-9]+	{
			yylval.str = malloc (20);
			strcpy(yylval.str,yytext);
			return NUM;
		}

[+]	{
			return ADD;
		}

[-]	{
			return MIN;
		}

[*]	{
			return MUL;
		}

[/]	{
			return DIV;
		}
[\n()] {return (*yytext);}

%%
