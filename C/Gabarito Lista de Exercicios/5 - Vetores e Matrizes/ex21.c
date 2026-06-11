#include <stdio.h>
#include <stdlib.h>

int main()
{
    int num[10], i, dif[10], maior;
    maior = 0;

    for (i=0;i<10;i++) {
        scanf("%d", &num[i]);
    }

    for (i=0;i<9;i++) {
        dif[i] = abs(num[i+1] - num[i]);
    }

    for (i=0;i<9;i++) {
        if (dif[i] > maior) maior = dif[i];
    }
    printf("%d", maior);
    return 0;
}
