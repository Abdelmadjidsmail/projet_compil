%{
	#include<stdio.h>
	extern FILE *yyin;
	int yylex();
	int yyerror(char* msg);
	
%}
%union{
	char *chaine;
	int entier;
	float reel;
}
%token COM_LEFT COM_RIGHT '&' '|' '!' '>' '<' subEgal infEgal doubleEgal notEgal '+' '-' '*' '/' '=' ')' '(' ';' ',' IF ELSE ENDIF FOR ENDFOR Uint Ufloat DEC INST FIN 
%token <chaine> idf Define 
%token <entier> Int
%token <reel> reel

%left '+' '-'
%left '*' '/'
%left '|' '&' 
%left COM_RIGHT
%right '(' ELSE ENDFOR ENDIF '!'
%left '=' '>' '<' subEgal infEgal doubleEgal notEgal  


%%
S: entite DEC Dec INST Inst FIN {printf("programme correcte\n");}
;
entite : idf {printf("le nom du programme %s\n",$1);}
;
Dec : DecVar Dec 
	| DecCste Dec 
	| DecVar 
	| DecCste 
;
DecVar : Type listP ';' 
;
DecCste : Define Type listC ';' 
;
Type: Uint 
	| Ufloat 
;
listP: idf ',' listP | idf 
;
listC : idf '=' Value ',' listC | idf '=' Value
;
Value : Int {printf("val %d ",$1);} | reel {printf("val %f ",$1);}
;
Inst : Affectation  ';' Inst  | Affectation  ';'
	 | Condition Inst | Condition
	 | Boucle Inst | Boucle
	 | Commentaire Inst | Commentaire
;
Affectation : idf '=' ExpArithmetique {printf("idf %s =  ",$1);}
;
ExpArithmetique: idf OpArithmetique ExpArithmetique  {printf("idf %s",$1);}
					  | Value OpArithmetique ExpArithmetique 
					  | '(' ExpArithmetique ')' OpArithmetique ExpArithmetique
					  | idf  {printf("idf %s",$1);}
					  | Value 
					  | '(' ExpArithmetique ')'
;
OpArithmetique: '+' {printf(" + ");}| '-' {printf(" - ");}| '*' {printf(" * ");}| '/' {printf(" / ");}
;
Condition: IF '(' Expression ')' Inst ENDIF
		 | IF '(' Expression ')' Inst  ELSE Inst ENDIF
;
Expression: EXPComparaison | ExpressionLogique
;
EXPComparaison: ExpArithmetique OPComparaison ExpArithmetique 
;
OPComparaison: '>' 
					| '<' 
					| subEgal 
					| infEgal 
					| doubleEgal 
					| notEgal 
; 
ExpressionLogique: '(' Expression ')' OperateurLogique '(' Expression ')'  
					| '!' '(' Expression ')'
					| '(' Expression ')' OperateurLogique ExpressionLogique
;
OperateurLogique : '&' | '|' 
;
Boucle : FOR '(' Affectation ';' '(' Expression ')' ';' Affectation ')' Inst ENDFOR 
;
Commentaire: COM_LEFT text COM_RIGHT
;
text: idf text | idf | Inst | '&' | '|' | '!' | '>' | '<' | subEgal | infEgal | doubleEgal | notEgal | '+' | '-' | '*' | '/' | '=' | ')' | '(' | ';' | ',' | IF | ELSE | ENDIF | FOR | ENDFOR | Uint | Ufloat | DEC | INST | FIN 
;
%%
int yyerror(char* msg)
{printf("%s",msg);
return 1;
}
int main()
{
yyin=fopen("code.txt","r");
yyparse();
return 0;
}





