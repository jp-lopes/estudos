#include <stdio.h>
#include <stdlib.h>

int main()
{
    int num[10], i, soma;
    soma = 0;

    for (i=0;i<10;i++){
        scanf("%d", &num[i]);
    }

    for (i=0;i<10;i++) {
        if (i%2!=0) soma=soma+num[i];
    }

    printf("%d", soma);
    return 0;
}
