#include <stdio.h>
#include <stdlib.h>

int* alocar() {
    int* v;
    int i;
    v = (int *)calloc(10, sizeof(int));
    for(i=0;i<10;i++) {
        printf("Valor %.2d: ", i+1);
        scanf("%d", &v[i]);
    }
    return v;
}

void maiormenor(int *v, int *maior, int *menor) {
    int i;
    *maior=-1;
    *menor=1000000000;
    for(i=0;i<10;i++) {
        if(v[i]>*maior) *maior=v[i];
        if(v[i]<*menor) *menor=v[i];
    }
}

int main() {
    int maior2, menor2, i;
    int *vetor;
    vetor = alocar();

    printf("\n");
    for(i=0; i<10; i++) {
        printf("Valor lido %.2d: %d\n",i+1, vetor[i]);
    }

    maiormenor(vetor, &maior2, &menor2);
    printf("\nMaior: %d\nMenor: %d\n", maior2, menor2);
    free(vetor);
    return 0;
}
