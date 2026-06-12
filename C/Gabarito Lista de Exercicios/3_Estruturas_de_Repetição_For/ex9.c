#include <stdio.h>
#include <stdlib.h>

int main()
{
    int  a, fat, i;
    scanf("%d", &a);
    fat=1;

    if (a<0){
        printf("Invalido");
        return 1;
    }
    if (a==0){
        printf("1");
        return 0;
    }
    for (i=1; i<=a; i++)
        {
        fat = fat*i;
        }
    printf("%d", fat);
    return 0;
}
