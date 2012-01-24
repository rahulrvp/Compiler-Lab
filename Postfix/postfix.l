%{
	#include <stdlib.h>
	#include <math.h>
	#include "postfix.tab.h"
%}

%%

[0-9]+	{
			yylval = atoi(yytext);
			return NUM;
		}

[-+*/\n]	{
			return (*yytext);
		}

%%
