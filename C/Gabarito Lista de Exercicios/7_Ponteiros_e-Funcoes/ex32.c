#include <stdio.h>
#include <stdlib.h>

void divisores(int *a, int *b, int *tam){
    int i, j=0;

    for(i=1;i<=a[0];i++){
        if(a[0]%i==0) {
            b[j] = i;
            j++;
        }
    }
    for(i=1;i<=a[1];i++){
        if(a[1]%i==0) {
            b[j] = i;
            j++;
        }
    }
    for(i=1;i<=a[2];i++){
        if(a[2]%i==0) {
            b[j] = i;
            j++;
        }
    }
    *tam = j;
}


int main(){
    int i, qtd, x[3];
    int *y;

    y = (int *)calloc(1000,sizeof(int));

    for(i=0;i<3;i++) {
        scanf("%d", &x[i]);
    }
    divisores(x, y, &qtd);

    for(i=0;i<qtd;i++) {
        printf("%d\n", y[i]);
    }
    return 0;
}
