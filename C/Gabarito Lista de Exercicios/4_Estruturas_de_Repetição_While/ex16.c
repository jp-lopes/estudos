#include <stdio.h>
#include <stdlib.h>

int main()
{
    float x, y, somatorio;
    int i;
    x = 0;
    y = 0;

//Ler x e y (inteiros) y deve ser maior do que x
    while (y<=x) {
            scanf("%f %f", &x, &y);
    }

    somatorio = x;
    for (i=x;i<y;i++) {
        x++;
        somatorio = somatorio+x;
    }



//exibir a soma dos n�meros de x a y.
    printf("%.2f", somatorio);
    return 0;
}
