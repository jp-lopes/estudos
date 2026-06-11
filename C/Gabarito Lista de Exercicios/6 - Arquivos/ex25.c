#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
    FILE *arq;
    char palavra[20], palavraarq[20];
    int qtd=0;

    scanf("%s", palavra);

    arq = fopen("palavras.txt", "rt+");
    if (arq == NULL) {
        printf("ERRO");
        exit(0);
    }
    while(feof(arq)==0) {
        fscanf(arq, "%s", palavraarq);
        if (strcmp(palavra,palavraarq)==0) qtd++;
    }
    fclose(arq);
    printf("%d", qtd);
    return 0;
}
