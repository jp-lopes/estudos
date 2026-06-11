#include <stdio.h>
#include <stdlib.h>

int main()
{
    FILE *arq;
    char origem[10], destino[10], texto[150];
    int f_erro = 0;
    printf("COPIAR UM ARQUIVO E COLAR EM OUTRO\n");
    printf("Nome do arquivo de origem: ");
    scanf("%s", origem);
    printf("Nome do arquivo de destino: ");
    scanf("%s", destino);

    // Ler e copiar arquivo de origem
    arq = fopen(origem, "rt");
    if (arq == NULL) {
        printf("Erro na leitura do arquivo de origem!\n");
        f_erro = 1;
    }

    else {
        fgets(texto, 150, arq);
    }
    fclose(arq);

    arq = fopen(destino, "w+t");
    if (arq == NULL) {
        printf("Erro na abertura do arquivo de destino!\n");
        f_erro = 1;
    }

    else {
        fprintf(arq, "%s", texto);
    }
    fclose(arq);

    if (f_erro == 0) printf("Sucesso!");
    else printf("ERRO");
    return 0;
}
