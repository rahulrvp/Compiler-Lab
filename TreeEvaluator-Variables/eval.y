%{
	#include <stdio.h>
	#define OPR 0
	#define OPN 1
	#define VOID 2
	#define VAR 3
	
	int arr[26];
	
	struct node {
		int val;
		int binding;
		char op;
		int flag; // 0 if operator, 1 if value
		struct node *left,*right;
	};
	
	struct Gsymbol {
		char *NAME; // Name of the Identifier
		int TYPE; // TYPE can be INTEGER or BOOLEAN
		/***The TYPE field must be a TypeStruct if user defined types are allowed***/
		int SIZE; // Size field for arrays
		int BINDING; // Address of the Identifier in Memory
		ArgStruct *ARGLIST; // Argument List for functions
		/***Argstruct must store the name and type of each argument ***/
		struct Gsymbol *NEXT; // Pointer to next Symbol Table Entry */
	};

	void preOrder(struct node*);
	void inOrder(struct node*);
	void postOrder(struct node*);
%}

%union {
	struct node *nod;
}

%token NUM ADD MIN MUL DIV VAR READ WRITE = BEGIN END ;

%type <nod> T E NUM ADD MIN MUL DIV Slist Stmt VAR READ WRITE = BEGIN END ;

%left ADD MIN
%left MUL DIV
%left '('

%%
	Program : BEGIN Slist END {evaluate($2)};
	Slist : Stmt { $$=$1; }
			| Slist Stmt { $$ = malloc (struct node) ;
						   $$->flag = VOID;
						   $$->left = $1;
						   $$->right= $2; }
			;
	Stmt : VAR=E { $$ = $2;
					 $$->left = $1;
					 $$->right= $2;
					 }
			| READ(VAR) | WRITE(E)
			;
	T: E'\n'{}
				;
	E: NUM { $$ = $1; }
	 | E ADD E { $$ = $2;
	 			$2->left = $1;
	 			$2->right = $3; }
	 | E MIN E { $$ = $2;
	 			$2->left = $1;
	 			$2->right = $3; }
	 | E MUL E { $$ = $2;
	 			$2->left = $1;
	 			$2->right = $3; }
	 | E DIV E { $$ = $2;
	 			$2->left = $1;
	 			$2->right = $3; }
	 | '('E')' { $$ = $2; }
	 ;
%%

int main() {
	printf ("Enter a valid expression: ");
	return yyparse();
}

yyerror(char *err) {}


void preOrder(struct node* root)
{
	if(root==NULL) {
		return;
	}
	else {
		switch(root->flag) {
			case 0 : printf(" %c",root->op);
						break;
			case 1 : printf(" %d",root->val);
						break;
		}
	preOrder(root->left);
	preOrder(root->right);
	}
}

void inOrder(struct node* root)
{
	if(root==NULL) {
		return;
	}
	else {
		inOrder(root->left);
		switch(root->flag) {
			case 0 : printf(" %c",root->op);
						break;
			case 1 : printf(" %d",root->val);
						break;
		}
	inOrder(root->right);
	}
}

void postOrder(struct node* root)
{
	if(root==NULL) {
		return;
	}
	else {
		postOrder(root->left);
		postOrder(root->right);
		switch(root->flag) {
			case 0 : printf(" %c",root->op);
						break;
			case 1 : printf(" %d",root->val);
						break;
		}
	}
}

void evaluate(struct node* root)
{
	printf ("Not done..!!");
}
