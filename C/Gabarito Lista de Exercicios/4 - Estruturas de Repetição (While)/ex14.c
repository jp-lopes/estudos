#include <stdio.h>
#include <stdlib.h>

int main()
{
	int i, notas[20], maior, menor;
	maior = 0;
	menor = 20;

		for (i=0;;i++) {
		scanf("%d", &notas[i]);
		if (notas[i]>maior) maior = notas[i];
		if (notas[i] < 0) break;	
		if (notas[i]<menor) menor = notas[i];
	}
	printf("%d %d", maior, menor);
	return 0;
}