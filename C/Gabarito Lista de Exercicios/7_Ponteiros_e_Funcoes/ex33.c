#include <stdio.h>
#include <stdlib.h>

void troca(int *a,int *b) {
    int c;
    c = *a;
    *a = *b;
    *b = c;
}

int main()
{
    int num1, num2;

    printf("Digite dois valores: ");
    scanf("%d %d", &num1, &num2);

    troca(&num1, &num2);

    printf("Numero 1: %d\n", num1);
    printf("Numero 2: %d\n", num2);
    return 0;
}
