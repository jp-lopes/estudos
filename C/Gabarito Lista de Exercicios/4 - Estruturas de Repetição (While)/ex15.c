#include <stdio.h>
#include <stdlib.h>

int main()
{
    float nota[20], soma, porcent, qtdalta, qtdbaixa, media, qtd;
    int i;
    soma = 0.0;
    porcent = 0.0;
    qtdalta = 0.0;
    qtdbaixa = 0.0;
    media = 0.0;
    qtd = 0.0;

    for (i=0; ;i++){
        scanf("%f", &nota[i]);
        if (nota[i]<0) break;
        else if (nota[i]<5) qtdbaixa++;
        if (nota[i]>=5) qtdalta++;
        soma = soma + nota[i];
        qtd++;
    }

    media = soma/qtd;
    porcent = (qtdalta/qtd)*100.0;

    printf("%.0f %.0f %.2f %.1f", qtdalta, qtdbaixa, media, porcent);
    return 0;
}
