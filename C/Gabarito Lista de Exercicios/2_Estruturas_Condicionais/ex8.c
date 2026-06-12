#include <stdio.h>
#include <stdlib.h>

int main()
{
    int ano;
    scanf("%d", &ano);

    if ((ano%400==0) || (ano%4==0 && ano%100!=0))
        printf("Sim");
    else
        printf("Nao");
    return 0;
}
