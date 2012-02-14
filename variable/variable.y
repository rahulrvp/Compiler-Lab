%{
	
	#include "source.h"

	extern FILE *yyin;
	FILE *fp;
	int regCount=-1;

	struct node *createTree(int,char,struct node *,struct node *);
	int evaluate(struct node *);
	int getReg();
	void freeReg();
%}

%union {
	struct node *nod;
}

%token NUM '+' '-' '*' '/' '='
%token READ WRITE
%token BEG ENND
%token VARIABLE

%type <nod> E NUM '+' '-' '*' '/' '='
%type <nod> READ WRITE
%type <nod> BEG ENND
%type <nod> PGM S SL
%type <nod> VARIABLE 

%left '+' '-'
%left '*' '/'
%left '('

// createTree(f,v,op,bind,l,r)

%%
	PGM	: BEG '\n' SL '\n' ENND {
								 evaluate($3);
								 codeGenerator($3);
								}
		;
	SL	: SL '\n' S ';' { $$ = createTree(VOID,'@',$1,$3);}
		| S ';' { $$ = $1;}
		;
	S	: VARIABLE '=' E { $$ = createTree(OPR,'=',$1,$3); }
		| READ '(' VARIABLE ')' { $$ = createTree(RD,'@',$3,NULL); } 
		| WRITE '(' E ')' { $$ = createTree(WR,'@',$3,NULL); } 
		;
	E	: NUM { $$ = $1;}
		| VARIABLE { $$ = $1;}
	 	| E '+' E { $$ = createTree(OPR,'+',$1,$3); }
	 	| E '-' E { $$ = createTree(OPR,'-',$1,$3); }
		| E '*' E { $$ = createTree(OPR,'*',$1,$3); }
	 	| E '/' E { $$ = createTree(OPR,'/',$1,$3); }
	 	| '('E')' { $$ = $2; }
	 	;
%%

int main(int argc,char *argv[]) {
	if (argc>1){
		
		if((fp=fopen(argv[2], "w")) == NULL) {
   		 	printf("Cannot open file.\n");
    		exit(1);
  		}
  		fprintf(fp,"START\n");							 

		yyin = fopen(argv[1],"r");
		yyparse();
		fclose(yyin);
		
		fprintf(fp,"HALT\n");
		fclose(fp);
		printf("SIM code generated with filename '%s' :)\n",argv[2]);
	}
	else {
		printf("Please input a filename..\n");
	}
	return 0;
}

yyerror(char *err) {}

// createTree(f,op,l,r)

	struct node *createTree(int f,char op,struct node *l,struct node *r) {
		struct node *temp = malloc(sizeof(struct node));
		temp -> flag = f;
		temp -> op = op;
		temp -> left = l;
		temp -> right = r;
		return temp;
	}
	
	int evaluate(struct node *root) {
		int a,b;
		if (root->flag == VAR) {
			return (bindArray[root->binding]);
		}
		else if (root->flag == OPND) {
			return (root->val);
		}
		else if (root->flag == OPR) {
			switch(root->op) {
				case '+': a = evaluate(root->left);
						  b = evaluate(root->right);
						  return (a+b);
				case '-': a = evaluate(root->left);
						  b = evaluate(root->right);
						  return (a-b);
				case '*': a = evaluate(root->left);
						  b = evaluate(root->right);
						  return (a*b);
				case '/': a = evaluate(root->left);
						  b = evaluate(root->right);
						  return (a/b);
				case '=': bindArray[root->left->binding] = evaluate(root->right);
						  break;
				}
		}
		else if (root->flag == RD) {
			printf("READ(%c) :",root->left->name);
			scanf("%d",&a);
			bindArray[root->left->binding] = a;
			return -1;
		}
		else if (root->flag == WR) {
			a = evaluate(root->left);
			printf("WRITE(E) : %d\n",a);
			return -1;
		}
		else if (root->flag == VOID) {
			evaluate(root->left);
			evaluate(root->right);
			return -1;
		}
	}
	
	int getReg() { return ++regCount; }
	void freeReg() { regCount--;}
	
	int codeGenerator(struct node *root) {
		int reg;
		int loc;

		if (root->flag == VAR) {
			reg = getReg();
			fprintf(fp,"MOV R%d [%d]\n",reg,root->binding);
			return reg;
		}
		else if (root->flag == OPND) {
			reg = getReg();
			fprintf(fp,"MOV R%d %d\n",reg,root->val);
			return reg;
		}
		else if (root->flag == OPR) {
			switch(root->op) {
				case '+': reg = codeGenerator(root->left);
						  codeGenerator(root->right);
						  fprintf(fp,"ADD R%d R%d\n",reg,(reg+1));
						  freeReg();
						  return reg;
				case '-': reg = codeGenerator(root->left);
						  codeGenerator(root->right);
						  fprintf(fp,"SUB R%d R%d\n",reg,(reg+1));
						  freeReg();
						  return reg;
				case '*': reg = codeGenerator(root->left);
						  codeGenerator(root->right);
						  fprintf(fp,"MUL R%d R%d\n",reg,(reg+1));
						  freeReg();
						  return reg;
				case '/': reg = codeGenerator(root->left);
						  codeGenerator(root->right);
						  fprintf(fp,"DIV R%d R%d\n",reg,(reg+1));
						  freeReg();
						  return reg;
				case '=': loc = root->left->binding;
						  reg = codeGenerator(root->right);
						  fprintf(fp,"MOV [%d] R%d\n",loc,reg);
						  freeReg();
						  return -1;
				}
		}
		else if (root->flag == RD) {
			loc = root->left->binding;
			reg = getReg();
			fprintf(fp,"IN R%d\n",reg);
			fprintf(fp,"MOV [%d] R%d\n",loc,reg);
			freeReg();
			return -1;
		}
		else if (root->flag == WR) {
			reg = codeGenerator(root->left);
			fprintf(fp,"OUT R%d\n",reg);
			freeReg();
			return -1;
		}
		else if (root->flag == VOID) {
			codeGenerator(root->left);
			codeGenerator(root->right);
			return -1;
		}

	}
