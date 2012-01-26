%{
	#include <stdio.h>
	struct node {
		int val;
		char op;
		int flag; // 0 if operator, 1 if value
		struct node *left,*right;
	};

	void preOrder(struct node*);
	void inOrder(struct node*);
	void postOrder(struct node*);
%}

%union {
	struct node *nod;
}

%token NUM ADD MIN MUL DIV

%type <nod> T E NUM ADD MIN MUL DIV

%left ADD MIN
%left MUL DIV
%left '('

%%
	T: E'\n'{printf ("\nPre-order : "); preOrder($1);
			 printf ("\nIn-order : "); inOrder($1);
			 printf ("\nPost-order : "); postOrder($1);}
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
