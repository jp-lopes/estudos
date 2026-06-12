#include <stdio.h>
#include <stdlib.h>

int main()
{
    float altura, pesoideal;
    int sexo;
    scanf("%f %d", &altura, &sexo);

    if (sexo==2)
        pesoideal = (72.7*altura)-58.0;
    else if (sexo==1)
        pesoideal = (62.1*altura)-44.7;

    printf("%.2f", pesoideal);
}
