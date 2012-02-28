%{

	#include "source.h"

	extern FILE *yyin;
	FILE *fp;
	int regCount=-1;
	int labelCount = -1;
	struct node *createTree(int,struct node *,struct node *,struct node *);
	int evaluate(struct node *);
	int getReg();
	void freeReg();
	int getLabel();
	void freeLabel();
%}

%union {
	struct node *nod;
}

%token NUM '+' '-' '*' '/' '='
%token READ WRITE
%token BEG ENND
%token VARIABLE
%token IF THEN ELSE ENDIF
%token WHILE DO ENDWHILE
%token LT GT LE GE EQ NE

%type <nod> E NUM '+' '-' '*' '/' '='
%type <nod> READ WRITE
%type <nod> BEG ENND
%type <nod> PGM S SL
%type <nod> VARIABLE 
%type <nod> IF THEN ELSE ENDIF
%type <nod> WHILE DO ENDWHILE
%type <nod> LT GT LE GE EQ NE

%left LT GT LE GE EQ NE
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
	SL	: SL '\n' S ';' { $$ = createTree(Void,$1,NULL,$3);}
		| S ';' { $$ = $1;}
		;
	S	: VARIABLE '=' E { $$ = createTree(Assignment,$1,NULL,$3); }
		| READ '(' VARIABLE ')' { $$ = createTree(Read,$3,NULL,NULL); } 
		| WRITE '(' E ')' { $$ = createTree(Write,$3,NULL,NULL); }
		| IF '('E')' '\n' THEN '\n' SL '\n' ENDIF { $$ = createTree(If,$3,$8,NULL); }
		| IF '('E')' '\n' THEN '\n' SL '\n' ELSE '\n' SL '\n' ENDIF { $$ = createTree(IfElse,$3,$8,$12); }
		| WHILE '('E')''\n' DO'\n' SL '\n' ENDWHILE { $$ = createTree(While,$3,$8,NULL); }
		;
	E	: NUM { $$ = $1;}
		| VARIABLE { $$ = $1;}
	 	| E '+' E { $$ = createTree(Add,$1,NULL,$3); }
	 	| E '-' E { $$ = createTree(Sub,$1,NULL,$3); }
		| E '*' E { $$ = createTree(Mul,$1,NULL,$3); }
	 	| E '/' E { $$ = createTree(Div,$1,NULL,$3); }
	 	| E LT E { $$ = createTree(L_T,$1,NULL,$3); }
	 	| E GT E { $$ = createTree(G_T,$1,NULL,$3); }
	 	| E LE E { $$ = createTree(L_E,$1,NULL,$3); }
	 	| E GE E { $$ = createTree(G_E,$1,NULL,$3); }
	 	| E EQ E { $$ = createTree(E_Q,$1,NULL,$3); }
	 	| E NE E { $$ = createTree(N_E,$1,NULL,$3); }
	 	| '('E')' { $$ = $2; }
	 	;
%%

int main(int argc,char *argv[]) {
	if (argc>1){

		if((fp=fopen(argv[2], "w")) == NULL) {
   		 	printf("Cannot open file.!\n");
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

	struct node *createTree(int f,struct node *l,struct node *m,struct node *r) {
		struct node *temp = malloc(sizeof(struct node));
		temp -> flag = f;
		temp -> left = l;
		temp -> mid = m;
		temp -> right = r;
		return temp;
	}

	int evaluate(struct node *root) {
		int a,b;
		if (root->flag == Variable) {
			return (bindArray[root->binding]);
		}
		else if (root->flag == Operand) {
			return (root->val);
		}
		else if (root->flag == Add) {
			a = evaluate(root->left);
			b = evaluate(root->right);
			return (a+b);
		}
		else if (root->flag == Sub) {
			a = evaluate(root->left);
			b = evaluate(root->right);
			return (a-b);
		}
		else if (root->flag == Mul) {
			a = evaluate(root->left);
			b = evaluate(root->right);
			return (a*b);
		}
		else if (root->flag == Div) {
			a = evaluate(root->left);
			b = evaluate(root->right);
			return (a/b);
		}
		else if (root->flag == Assignment) {
			bindArray[root->left->binding] = evaluate(root->right);
		}
		else if (root->flag == Read) {
			printf("READ(%c) :",root->left->name);
			scanf("%d",&a);
			bindArray[root->left->binding] = a;
			return -1;
		}
		else if (root->flag == Write) {
			a = evaluate(root->left);
			printf("WRITE(E) : %d\n",a);
			return -1;
		}
		else if (root->flag == Void) {
			evaluate(root->left);
			evaluate(root->right);
			return -1;
		}
		else if (root->flag == L_T) {
			if (evaluate(root->left) < evaluate(root->right))
				return 1;
			else
				return 0;
		}
		else if (root->flag == G_T) {
			if (evaluate(root->left) > evaluate(root->right))
				return 1;
			else
				return 0;
		}
		else if (root->flag == L_E) {
			if (evaluate(root->left) <= evaluate(root->right))
				return 1;
			else
				return 0;
		}
		else if (root->flag == G_E) {
			if (evaluate(root->left) >= evaluate(root->right))
				return 1;
			else
				return 0;
		}
		else if (root->flag == E_Q) {
			if (evaluate(root->left) == evaluate(root->right))
				return 1;
			else
				return 0;
		}
		else if (root->flag == N_E) {
			if (evaluate(root->left) != evaluate(root->right))
				return 1;
			else
				return 0;
		}
		else if (root -> flag == If) {
			if (evaluate(root->left)==1)
				evaluate(root->mid);
		}
		else if (root -> flag == IfElse) {
			if (evaluate(root->left)==1)
				evaluate(root->mid);
			else
				evaluate(root->right);
		}
		else if (root -> flag == While) {
			while (evaluate(root->left)==1) {
				evaluate(root->mid);
			}
		}
	}

	int getReg() { return ++regCount; }
	void freeReg() { regCount--;}
	int getLabel() { return ++labelCount; }
	void freeLabel() { labelCount--;}

	int codeGenerator(struct node *root) {
		int reg;
		int loc;
		int lbl1,lbl2;

		if (root->flag == Variable) {
			reg = getReg();
			fprintf(fp,"MOV R%d [%d]\n",reg,root->binding);
			return reg;
		}
		else if (root->flag == Operand) {
			reg = getReg();
			fprintf(fp,"MOV R%d %d\n",reg,root->val);
			return reg;
		}
		else if (root->flag == Add) {
			reg = codeGenerator(root->left);
			codeGenerator(root->right);
			fprintf(fp,"ADD R%d R%d\n",reg,(reg+1));
			freeReg();
			return reg;
		}
		else if (root->flag == Sub) {
			reg = codeGenerator(root->left);
			codeGenerator(root->right);
			fprintf(fp,"SUB R%d R%d\n",reg,(reg+1));
			freeReg();
			return reg;
		}
		else if (root->flag == Mul) {
			reg = codeGenerator(root->left);
			codeGenerator(root->right);
			fprintf(fp,"MUL R%d R%d\n",reg,(reg+1));
			freeReg();
			return reg;
		}
		else if (root->flag == Div) {
			reg = codeGenerator(root->left);
			codeGenerator(root->right);
			fprintf(fp,"DIV R%d R%d\n",reg,(reg+1));
			freeReg();
			return reg;
		}
		else if (root->flag == Assignment) {
			loc = root->left->binding;
			reg = codeGenerator(root->right);
			fprintf(fp,"MOV [%d] R%d\n",loc,reg);
			freeReg();
			return -1;
		}
		else if (root->flag == Read) {
			loc = root->left->binding;
			reg = getReg();
			fprintf(fp,"IN R%d\n",reg);
			fprintf(fp,"MOV [%d] R%d\n",loc,reg);
			freeReg();
			return -1;
		}
		else if (root->flag == Write) {
			reg = codeGenerator(root->left);
			fprintf(fp,"OUT R%d\n",reg);
			freeReg();
			return -1;
		}
		else if (root->flag == Void) {
			codeGenerator(root->left);
			codeGenerator(root->right);
			return -1;
		}
		else if (root->flag == L_T) {
			reg = codeGenerator(root->left);
			codeGenerator(root->right);
			fprintf(fp,"LT R%d R%d\n",reg,reg+1);
			freeReg();
			return reg;
		}
		else if (root->flag == G_T) {
			reg = codeGenerator(root->left);
			codeGenerator(root->right);
			fprintf(fp,"GT R%d R%d\n",reg,reg+1);
			freeReg();
			return reg;
		}
		else if (root->flag == L_E) {
			reg = codeGenerator(root->left);
			codeGenerator(root->right);
			fprintf(fp,"LE R%d R%d\n",reg,reg+1);
			freeReg();
			return reg;
		}
		else if (root->flag == G_E) {
			reg = codeGenerator(root->left);
			codeGenerator(root->right);
			fprintf(fp,"GE R%d R%d\n",reg,reg+1);
			freeReg();
			return reg;
		}
		else if (root->flag == E_Q) {
			reg = codeGenerator(root->left);
			codeGenerator(root->right);
			fprintf(fp,"EQ R%d R%d\n",reg,reg+1);
			freeReg();
			return reg;
		}
		else if (root->flag == N_E) {
			reg = codeGenerator(root->left);
			codeGenerator(root->right);
			fprintf(fp,"NE R%d R%d\n",reg,reg+1);
			freeReg();
			return reg;
		}
		else if (root -> flag == If) {
			reg = codeGenerator(root->left);
			lbl1 = getLabel();
			fprintf(fp,"JZ R%d Label%d\n",reg,lbl1);
			freeReg();
			codeGenerator(root->mid);
			fprintf(fp,"Label%d:\n",lbl1);
		}
		else if (root -> flag == IfElse) {
			reg = codeGenerator(root->left);
			lbl1 = getLabel();
			lbl2 = getLabel();
			fprintf(fp,"JZ R%d Label%d\n",reg,lbl1);
			freeReg();
			codeGenerator(root->mid);
			fprintf(fp,"JMP Label%d\n",lbl2);
			fprintf(fp,"Label%d:\n",lbl1);
			codeGenerator(root->right);
			fprintf(fp,"Label%d:\n",lbl2);
		}
		else if (root -> flag == While) {
			lbl1 = getLabel();
			lbl2 = getLabel();
			fprintf(fp,"Label%d:\n",lbl1);
			reg = codeGenerator(root -> left);
			fprintf(fp,"JZ R%d Label%d\n",reg,lbl2);
			freeReg();
			codeGenerator(root -> mid);
			fprintf(fp,"JMP Label%d\n",lbl1);
			fprintf(fp,"Label%d:\n",lbl2);
		}
	}
