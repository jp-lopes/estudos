#include <stdio.h>
#include <stdlib.h>

//Criar um programa que determina os números de 1 a N que são quadrados perfeitos (a raiz é um número inteiro), sendo N um inteiro fornecido pelo usuário.

int main()
{
    int n, i, b;
    scanf("%d",&n);
    for(i=1; i<=n; i++)
    {
        b = i*i;
        if (b<=n)
            printf("%d\n", b);
    }
    return 0;
}
