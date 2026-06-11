#include <stdio.h>
#include <stdlib.h>

int main()
{
    int mat[4][5], soma[5], i, j;

    for (j=0;j<5;j++) {
        soma[j] = 0;
    }



    for (i=0;i<4;i++) {
        for (j=0;j<5;j++) {
            scanf("%d", &mat[i][j]);
        }
    }

    for (i=0;i<4;i++) {
        for (j=0;j<5;j++) {
            soma[j] = soma [j] + mat[i][j];
        }
    }


    for (j=0;j<5;j++) {
        printf("%d\n", soma[j]);
       }

    return 0;
}
