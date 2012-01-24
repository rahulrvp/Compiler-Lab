%{
	#include <stdlib.h>
	#include <math.h>
	#include "calculator.tab.h"
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
