#include <stdio.h>
#include <stdlib.h>

int main()
{
    int pes, cabecas, patos, coelhos;
    scanf("%d", &cabecas);
    scanf("%d", &pes);

    coelhos = ((pes - (2*cabecas)))/2;
    patos = cabecas - coelhos;

    printf("%d %d", patos, coelhos);
    return 0;
}

