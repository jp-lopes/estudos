#include <stdio.h>
#include <stdlib.h>

FILE *arq;
typedef struct {
    char nome[20];
    float nota;
} st_aluno;


int main()
{
    int i;
    st_aluno ALUNO[5];
    for(i=0;i<5;i++) {
        printf("*ALUNO %d*\n", i+1);

        printf("Nome do aluno %d: ", i+1);
        scanf("%s", ALUNO[i].nome, 20, stdin);

        printf("Nota do aluno %d: ", i+1);
        scanf("%f", &ALUNO[i].nota);
    }

    arq = fopen("reg_al.bin", "wb+");
    if (arq == NULL) {
        printf("Erro na abertura do arquivo!");
        return 1;
    }
    fwrite(ALUNO, sizeof(st_aluno), 5, arq);
    fclose(arq);
    printf("\nRegistrado!");
    return 0;
}
