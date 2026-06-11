#include <stdio.h>
#include <stdlib.h>

int main()
{
    int mat[5][5], i, j;

    for (i=0;i<5;i++) {
        for (j=0;j<5;j++) {
            scanf("%d", &mat[i][j]);
        }
    }

    for (i=0;i<5;i++) {
        for (j=0;j<5;j++) {
            if (j==2) {
            int swap = mat[i][j];
            mat[i][j] = mat[j][i];
            mat[j][i] = swap;
            }
        }

    }

    for (i=0;i<5;i++) {
        for (j=0;j<5;j++) {
            printf("%d ", mat[i][j]);
        }
        printf("\n");
    }

    return 0;
}
