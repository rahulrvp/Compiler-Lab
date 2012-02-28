	#include <stdio.h>
	#include <stdlib.h>

	#define Void 1
	
	#define Variable 2
	#define Read 3
	#define Write 4
	#define Assignment 5
	
	#define Operand 6
	#define Add 7
	#define Sub 8
	#define Mul 9
	#define Div 10
	
	#define L_T 11
	#define G_T 12
	#define L_E 13
	#define G_E 14
	#define E_Q 15
	#define N_E 16
	
	#define If 17
	#define IfElse 18
	#define While 19


	int bindArray[26]; // Array that stores values of variables.

	struct node {
		int val;
		char name;
		int flag;
		int binding;
		struct node *left,*mid,*right;
	};
