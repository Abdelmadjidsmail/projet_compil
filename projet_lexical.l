%{
#include<stdio.h>
#include<string.h>
#include "projet_syntaxique.tab.h"
extern YYSTYPE yylval;
int line = 0; 
int colonne = 0;
%}
DEFINE "define"
Uint 0|[1-9][0-9]*
Ufloat [0-9]+"."[0-9]+
idf [a-z][a-z0-9]*(_*[a-z0-9]+)*
arithmetic_expression "+"|"-"|"*"|"/"
comparison_expression >|<|==|>=|<=|!=
logical_expression &|"|"|"!"
separator " "|\t
%%
{Uint} {
	colonne = colonne+yyleng;
	if((atoi(yytext)<30000)){
		yylval.entier = atoi(yytext);
		return Int;
	}
	else printf("ERROR\n");
	}
{Ufloat} {
	colonne ++;
	yylval.reel = atoi(yytext);
	return reel;}
{DEFINE} {
	colonne ++;
	yylval.chaine = strdup(yytext);
	return Define;
}
{idf} {
	colonne = colonne + yyleng;
	if(yyleng>7)
		printf("ERROR, %s is a long idf\n",yytext);
	else{
		yylval.chaine = strdup(yytext);
		return idf;
	}
}
"<<" {colonne = colonne + yyleng; return COM_LEFT;}
">>" {colonne = colonne + yyleng; return COM_RIGHT;}
{separator} {colonne ++;}
{logical_expression} {
	colonne ++;
	if(strcmp(yytext,"&")==0)
		return '&';
	else if(strcmp(yytext,"|")==0)
			return '|';
			else return '!';
}
{comparison_expression} {
	colonne = colonne + yyleng;
	if(strcmp(yytext,">")==0)
		return '>';
	else if(strcmp(yytext,"<")==0)
			return '<';
		else if(strcmp(yytext,"<=")==0)
				return subEgal;
			else if(strcmp(yytext,">=")==0)
					return infEgal;
				else if(strcmp(yytext,"==")==0)
						return doubleEgal;
					else if(strcmp(yytext,"!=")==0)
							return notEgal;
}
{arithmetic_expression} {
	colonne ++;
	if(strcmp(yytext,"+")==0)
		return '+';
	else if(strcmp(yytext,"*")==0)
			return '*';
		else if(strcmp(yytext,"-")==0)
				return '-';
			else if(strcmp(yytext,"/")==0)
					return '/';				
}
"=" {colonne ++; return '=';}
")" {colonne ++; return ')';}
"(" {colonne ++; return '(';}
";" {colonne ++; return ';';}
"," {colonne ++; return ',';}
[\n] { line ++; colonne = 0;}
IF { printf("IF\n");colonne = colonne + yyleng; return IF;}
ELSE {printf("ELSE\n");colonne = colonne + yyleng; return ELSE;}
ENDIF {printf("ENDIF\n");colonne = colonne + yyleng; return ENDIF;}
FOR {printf("FOR\n");colonne = colonne + yyleng; return FOR;}
ENDFOR {printf("ENDFOR\n");colonne = colonne + yyleng; return ENDFOR;}
Uint {printf("Int\n");colonne = colonne + yyleng; return Uint;}
Ufloat {printf("Float\n");colonne = colonne + yyleng; return Ufloat;}
DEC {printf("DEC\n");colonne = colonne + yyleng; return DEC;}
INST {printf("INST\n");colonne = colonne + yyleng; return INST;}
FIN {printf("FIN\n");colonne = colonne + yyleng; return FIN;} 
.	{printf("ERROR, line= %d colonne= %d\n",line,colonne);}
%%
int yywrap(void)
{
return 0;
}
