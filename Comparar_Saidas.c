#include <stdio.h>
#include <stdlib.h>

int main()
{
    FILE *read1 = fopen("saidas_c.txt", "r");
    FILE *read2 = fopen("saidas_verilog.txt", "r");
    FILE *write = fopen("comparacao_saidas.txt", "w");

    int valores_c[8], resultado_c;
    int valores_verilog[8], resultado_verilog;
    int i, contador_linhas = 0, contador_correto = 0, errado = 0;
    if (read1 == NULL || read2 == NULL || write == NULL){
        printf("Erro abertura arquivos\n");
        exit(1);
    }
    while((fscanf(read1, "%d %d %d %d %d %d %d %d %*c %d", &valores_c[0], &valores_c[1], &valores_c[2], &valores_c[3],
        &valores_c[4], &valores_c[5], &valores_c[6], &valores_c[7], &resultado_c))!= EOF){

        fscanf(read2, "%d %d %d %d %d %d %d %d %*c %d", &valores_verilog[0], &valores_verilog[1], &valores_verilog[2], &valores_verilog[3],
        &valores_verilog[4], &valores_verilog[5], &valores_verilog[6], &valores_verilog[7], &resultado_verilog);

        contador_linhas++;
        errado = 0;
        for (i = 0; i < 8; i++){
            fprintf(write, "C = %d - V = %d\n", valores_c[i], valores_verilog[i]);
            if (valores_c[i] != valores_verilog[i]){
                errado++;
            }

        }
        if (errado != 0){
            fprintf(write, "Linha %d - Pontos Lidos Sao Diferetes\n", contador_linhas);
        }else{
            if(resultado_c == resultado_verilog){
                fprintf(write, "Linha %d - Resultado OK\n", contador_linhas);
                contador_correto++;
            }else{
                fprintf(write, "Linha %d - Resultados Diferentes\n", contador_linhas);
            }
        }

    }
    fprintf(write,"\n\n%d Resultados Fecham Iguais\n%d Total lidos", contador_correto, contador_linhas);
    fclose(write);
    fclose(read1);
    fclose(read2);
    return 0;
}
