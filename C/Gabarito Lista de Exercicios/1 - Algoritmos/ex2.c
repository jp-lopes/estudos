#include <stdio.h>
#include <stdlib.h>

int main()
{
    float invest1, invest2, invest3, investtotal, premiototal, premio1, premio2, premio3;
    scanf("%f", &premiototal);
    scanf("%f", &invest1);
    scanf("%f", &invest2);
    scanf("%f", &invest3);

    investtotal = (invest1+invest2+invest3);
    premio1 = (invest1/investtotal)*premiototal;
    premio2 = (invest2/investtotal)*premiototal;
    premio3 = (invest3/investtotal)*premiototal;

    printf("%.2f ", premio1);
    printf("%.2f ", premio2);
    printf("%.2f ", premio3);
    return 0;
}
