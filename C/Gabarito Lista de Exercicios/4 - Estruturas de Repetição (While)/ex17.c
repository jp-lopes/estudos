#include <stdio.h>
#include <stdlib.h>

int main()
{
    int anoin, anofin, anobis, i;
    scanf("%d %d", &anoin, &anofin);
    anobis = anoin;
    for (i=0;anobis<=anofin;i++){
        if ((anobis%400==0) || (anobis%4==0 && anobis%100!=0)) printf("%d\n", anobis);
        anobis++;
    }
    return 0;
}
