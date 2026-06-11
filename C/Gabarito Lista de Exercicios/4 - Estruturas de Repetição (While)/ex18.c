#include <stdio.h>
#include <stdlib.h>

int main()
{
    int i, lim, fib[50];
    scanf("%d", &lim);

    fib[0]=0;
    fib[1]=1;
    fib[2]=1;
    printf("0\n1\n");

    for (i=2;fib[i-1]<lim;i++) {
        fib[i] = fib[i-2] + fib[i-1];
        printf("%d\n", fib[i]);
    }
    return 0;
}
