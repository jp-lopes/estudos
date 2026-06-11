#include <stdio.h>
#include <stdlib.h>

int main()
{
    float lado1, lado2, lado3;
    scanf("%f %f %f", &lado1, &lado2, &lado3);
    if ((lado1+lado2>lado3) && (lado2+lado3>lado1) && (lado1+lado3>lado2)){
        if ((lado1==lado2) && (lado2==lado3) && (lado1==lado3))
            printf("Equilatero");
        else if ((lado1==lado2) || (lado2==lado3) || (lado1==lado3))
            printf("Isosceles");
        else
            printf("Escaleno");
    }
    else
    printf("Invalido");

    return 0;
}
