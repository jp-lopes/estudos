#include <stdio.h>
#include <stdlib.h>

int main()
{
   int hi, mini, segi, segd, hf, minf, segf;
   scanf("%d", &hi);
   scanf("%d", &mini);
   scanf("%d", &segi);
   scanf("%d", &segd);

   segf = segi + segd;
   minf = mini;
   hf = hi;

    while (segf >= 60)
   {
        segf = segf - 60;
        minf = minf + 1;
   }

    while (minf >= 60)
    {
        minf = minf - 60;
        hf = hf + 1;
    }

    printf("%d %d %d", hf, minf, segf);
    return 0;
}
