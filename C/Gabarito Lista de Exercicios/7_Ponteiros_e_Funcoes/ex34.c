#include <stdio.h>
#include <stdlib.h>

int main()
{
    float *notas, media, soma=0;
    int qtd, i;

    printf("Quantidade de notas: ");
    scanf("%d", &qtd);
    notas = (float *)calloc(qtd, sizeof(float));

    for(i=0;i<qtd;i++){
        printf("Nota %d: ", i+1);
        scanf("%f", &notas[i]);
        soma += notas[i];
    }

    media = soma/qtd;
    printf("\nMedia das notas: %.2f", media);
    free(notas);
    return 0;
}
