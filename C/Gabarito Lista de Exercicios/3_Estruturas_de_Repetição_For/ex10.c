#include <stdio.h>
#include <stdlib.h>

int main()
{
    int x, y, z, pow, i;
    scanf("%d %d", &x, &y);
    z = x;
    pow = 1;
// teste
    if (y<0)
    {
        printf("invalido");
        return 1;
    }
    if (y==0)
    {
        printf("1");
        return 0;
    }


//calcular x^y sem funções
    for (i=0; i<y; i++)
    {
        x = pow;
        pow = x*z;

    }

    printf("%d", pow);
    return 0;
}
