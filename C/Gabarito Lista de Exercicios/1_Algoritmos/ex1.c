#include <stdio.h>
#include <stdlib.h>

int main()
{
    int dias, semanas, diferenca;
    semanas = 0;
    dias = 0;
    diferenca = 0;

    scanf("%d",&dias);

    semanas = dias/7;
    diferenca = dias - (semanas*7);
    printf("%d %d", semanas, diferenca);
    return 0;
}
