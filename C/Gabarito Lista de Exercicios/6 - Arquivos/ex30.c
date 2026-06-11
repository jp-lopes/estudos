#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct  reg_f {
		char titulo[60];
		char genero[60];
		int ano;
		} filmes;

int main()
{
    FILE *arq;
    int(i);
    char gen[60];
    filmes f[5];

    scanf("%s", gen);

    arq = fopen("filmes.bin", "rb");
    if(arq==NULL) exit(0);
    fread(f, sizeof(filmes), 5, arq);
    fclose(arq);

    for(i=0;i<5;i++){
        if (strcmp(f[i].genero,gen)==0) printf("%s\n", f[i].titulo);
    }

    return 0;
}
