#include <stdio.h>
#include <stdlib.h>

int main()
{
    int A[5], B[5], soma[5], i;

    for (i=0;i<5;i++) {
        scanf("%d", &A[i]);
    }
    for (i=0;i<5;i++) {
        scanf("%d", &B[i]);
    }
    for (i=0;i<5;i++) {
        soma[i] = A[i] + B[i];
    }

    for (i=0;i<5;i++) {
        printf("%d\n", soma[i]);
    }
    return 0;
}
