#include <stdio.h>
#include <stdlib.h>

int main()
{
    int mat[4][5], i, j, A, B, qtd;
    qtd = 0;

    for (i=0;i<4;i++) {
        for (j=0;j<5;j++){
            scanf("%d", &mat[i][j]);
        }
    }

    scanf("%d %d", &A, &B);

    for (i=0;i<4;i++) {
        for (j=0;j<5;j++){
            if ((mat[i][j]>=A)&&(mat[i][j]<=B)) qtd++;
        }
    }
    printf("%d", qtd);
    return 0;
}
