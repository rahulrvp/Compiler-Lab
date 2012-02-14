	#include <stdio.h>
	#include <stdlib.h>


	#define VOID -1
	
	#define OPR 0
	#define OPND 1
	#define VAR 2
	#define RD 3 		// Read
	#define WR 4		// Write
	

	
	int bindArray[26]; // Array that stores values of variables.
	
	struct node {
		int val;
		char op;
		char name;
		int flag;
		int binding;
		struct node *left,*right;
	};
	
	
