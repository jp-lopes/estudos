#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
    int i, j, flag_contido=0;
    char palavra[20], textoarq[150];
    FILE *arq;

    arq = fopen("palavras.txt", "rt+");

    if (arq==NULL) {
        printf("ERRO\n");
        return 1;
    }

    scanf("%s", palavra);



    while (feof(arq)==0) {
        fscanf(arq, "%s", textoarq);
        if (strcmp(palavra, textoarq) == 0) {
            flag_contido =1;
        }
    }

    fclose(arq);
    if (flag_contido==0) printf("\nPalavra %s nao esta contida no texto", palavra);
    else printf("\nPalavra %s esta contida no texto", palavra);

    return 0;
}
