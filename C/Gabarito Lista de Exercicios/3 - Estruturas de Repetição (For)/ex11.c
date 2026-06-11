#include <stdio.h>
#include <stdlib.h>

//Fa�a um programa para calcular o valor da seguinte s�rie: 1/1 + 3/2 + 5/3 + 7/4 + ... 99/50
int main()
{
    int i;
    float a, b, soma;
    a=1;
    b=1;
    soma = 0;

    for (i=1; i<=50; i++)
    {
        soma = soma+(a/b);
        a=a+2;
        b=b+1;
    }
    printf("%.3f", soma);
    return 0;
}
