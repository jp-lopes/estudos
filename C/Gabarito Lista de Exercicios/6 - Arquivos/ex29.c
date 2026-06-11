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
    float somatorio=0, media;
    st_aluno ALUNO[5];
    arq = fopen("reg_al.bin", "rb");
    if (arq == NULL) {
        printf("Erro na abertura do arquivo para leitura!");
        return 1;
    }
    fread(ALUNO, sizeof(st_aluno), 5, arq);
    fclose(arq);

    for(i=0;i<5;i++) {
        if (ALUNO[i].nota>=5) printf("\nAluno %s Aprovado!\n", ALUNO[i].nome);
        somatorio += ALUNO[i].nota;
    }
    media = somatorio/5;
    printf("\nMedia da turma: %.2f\n", media);

    return 0;
}
