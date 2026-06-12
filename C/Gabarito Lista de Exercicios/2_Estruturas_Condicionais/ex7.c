#include <stdio.h>
#include <stdlib.h>

int main()
{
    int a, b, c;
    scanf("%d %d %d", &a, &b, &c);

    if (a<b){
        if (b<c) //b>a e c>b
            printf("%d %d %d", a, b, c);
        else { //b>a e b>c
            if (a>c) //b>a b>c a>c
                printf("%d %d %d", c, a, b);
            else //b>a e b>c e c>a
                printf("%d %d %d", a, c, b);
        }
    }
    else{
        if (b<c){ // a>b e c>b
            if (a>c) //a>b e c>b e a>c
                printf("%d %d %d", b, c, a);
            else //a>b e c>b e c>a
                printf("%d %d %d", b, a, c);
        }
        else //a>b e b>c
            printf("%d %d %d", c, b, a);
    }


    printf(" ");
    return 0;
}
