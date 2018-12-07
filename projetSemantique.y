%{
	#include<stdio.h>
	#include<string.h>
	#include"Routine.h"
	#include "quad.h"
	extern FILE *yyin;
	extern int line;
	extern int colonne;
	int yylex();
	int yyerror(char* msg);
	
	int type; //sauvegarder le type des variables
	int valeur; //sauvegarder la valeur lu
	int bool; //designe si l'expression contient qu'une valeur ou pas
	float valeurf;
	char *tmp[2];
	int itmp = 0;
	int indice = 1;/*indice de temporaire*/	
	char *s;
%}
%union{
	char *chaine;
	int entier;
	float reel;
	struct {
	   int type;
	   char val[60];
	}idf;
}
%token '&' '|' '!' '>' '<' subEgal infEgal doubleEgal notEgal '+' '-' '*' '/' '=' ')' '(' ';' ',' IF ELSE ENDIF FOR ENDFOR Uint Ufloat DEC INST FIN 
%token <chaine> idf Define Commentaire
%token <entier> Int 
%token <reel> reel

%left '>' subEgal doubleEgal notEgal infEgal '<' 
%left '|' '&' 
%right '!'
%right ENDFOR ENDIF ELSE
%left '+' '-'
%left '*' '/'
%right '(' 

%type <entier> Value 
%type <idf> ExpArithmetique

%%
S: entite DEC Dec INST Inst FIN {printf("programme correcte\n");YYACCEPT;}
;
entite : idf {printf("le nom du programme %s\n",$1);}
;
Dec : DecVar Dec 
	| DecCste Dec 
	| DecVar 
	| DecCste 
;
DecVar : Type listP ';' { }
;
DecCste : Define Type listC ';' { }
;
Type: Uint {type = 0; }
	| Ufloat {type = 1; }
;
listP: idf ',' listP {  insert($1,type,0); }
	| idf { insert($1,type,0);}
;
listC : idf '=' Value ',' listC  {  insert($1,type,1);compatible_type( idf_type($1) ,$3);}
	| idf '=' Value {  insert($1,type,1); compatible_type( idf_type($1) ,$3);}
;
Value : Int { valeur = $1; $$ = 0; }
	| reel { if( $1 == 0) valeur = 0; else valeur = -1; valeurf =$1;  $$ = 1; }
;
Inst : Affectation  ';' Inst  | Affectation  ';'
	 | Condition Inst | Condition
	 | Boucle Inst | Boucle
	 | Commentaire Inst | Commentaire
;
Affectation : idf '=' ExpArithmetique { non_dec($1); modif_cste($1); compatible_type( idf_type($1) ,$3.type);   }
;
ExpArithmetique: ExpArithmetique '+' ExpArithmetique { bool = 1; compatible_type( $1.type ,$3.type); $$.type = $1.type; } 
					  | ExpArithmetique '-' ExpArithmetique { bool = 1; compatible_type( $1.type ,$3.type); $$.type = $1.type; } 
					  | ExpArithmetique '*' ExpArithmetique { bool = 1; compatible_type( $1.type ,$3.type); $$.type = $1.type;} 
					  | ExpArithmetique '/' ExpArithmetique { if(bool == 0) div_par_zero(valeur); compatible_type( $1.type ,$3.type); $$.type = $1.type;} 
					  | idf  { bool = 1; non_dec($1); $$.type = idf_type($1); }
					  | Value { bool = 0; $$.type = $1; }
					  | '(' ExpArithmetique ')' {  $$.type = $2.type; }
;
Condition: IF '(' Expression ')' Inst ENDIF
		 | IF '(' Expression ')' Inst  ELSE Inst ENDIF
;
Expression: EXPComparaison | ExpressionLogique
;
EXPComparaison: ExpArithmetique OPComparaison ExpArithmetique {compatible_type( $1.type ,$3.type); }
;
OPComparaison: '>' | '<' | subEgal | infEgal  | doubleEgal  | notEgal  
; 
ExpressionLogique: '(' Expression ')' OperateurLogique '(' Expression ')'  
					| '!' '(' Expression ')'
;
OperateurLogique : '&' | '|' 
;
Boucle : FOR '(' Affectation ';' '(' Expression ')' ';' Affectation ')' Inst ENDFOR 
;

%%
int yyerror(char* msg)
{printf("%s: ligne %d,colonne %d.\n",msg,line,colonne);
return 1;
}
int main()
{

yyin=fopen("code.txt","r");
yyparse();
display();

return 0;
}




