#include <stdio.h>
#include <stdlib.h>
typedef struct ponto{
    int x;
    int y;
}Ponto;

int verifica_sinal(Ponto *p1, Ponto *p2, Ponto *ponto_testar){
    return (p1->x - ponto_testar->x) * (p2->y - ponto_testar->y) - (p2->x - ponto_testar->x) * (p1->y - ponto_testar->y);
}
int ponto_dentro(Ponto *ponto_testar, Ponto *p_triangulo1, Ponto *p_triangulo2, Ponto *p_triangulo3){
    int b1 = verifica_sinal(ponto_testar, p_triangulo1, p_triangulo2) < 0;
    int b2 = verifica_sinal(ponto_testar, p_triangulo2, p_triangulo3) < 0;
    int b3 = verifica_sinal(ponto_testar, p_triangulo3, p_triangulo1) < 0;

    if (b1 == b2 && b2 == b3)
        return 1;
    else
        return 0;
}
int main()
{
    FILE *read;
    FILE *write;
    read = fopen("entradas.txt", "r");
    write = fopen("saidas_c.txt", "w");
    if (read == NULL){
        printf("\nErro1\n");
        exit(1);
    }
    if (write == NULL){
        printf("\nErro2\n");
        exit(1);
    }
    int retorno;
    Ponto p_triangulo1, p_triangulo2, p_triangulo3, ponto_testar;

    while (fscanf(read, "%d %d %d %d %d %d %d %d", &ponto_testar.x, &ponto_testar.y ,&p_triangulo1.x, &p_triangulo1.y, &p_triangulo2.x, &p_triangulo2.y, &p_triangulo3.x, &p_triangulo3.y) != EOF){
       retorno = ponto_dentro(&ponto_testar, &p_triangulo1, &p_triangulo2, &p_triangulo3);
       fprintf(write, "%d %d %d %d %d %d %d %d = %d\n", ponto_testar.x, ponto_testar.y ,p_triangulo1.x, p_triangulo1.y, p_triangulo2.x, p_triangulo2.y, p_triangulo3.x, p_triangulo3.y, retorno);

    }
    free(write);
    free(read);

    return 0;
}
