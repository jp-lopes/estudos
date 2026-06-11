#include <stdio.h>
#include <stdlib.h>


void mdc(int a, int b, int c, int *mdc, int *mmc){
    int i;
    for(i=a;;i--) {
        if(a%i==0 && b%i==0 && c%i==0){
            *mdc = i;
            break;
        }
    }
    for(i=a;;i++){
        if(i%a==0 && i%b==0 && i%c==0){
            *mmc = i;
            break;
        }
    }
}

int main()
{
    int x, y, z, mdc2, mmc2;
    scanf("%d %d %d", &x, &y, &z);
    mdc(x, y, z, &mdc2, &mmc2);
    printf("%d %d", mdc2, mmc2);
    return 0;
}
