// Implementation from Guillaume Androz

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#define MIN3(a, b, c) ((a) < (b) ? ((a) < (c) ? (a) : (c)) : ((b) < (c) ? (b) : (c)))

// To compile:
// - cc -fPIC -shared -o levenshtein.so levenshtein.c

int levenshtein(char *source, char *target, int ins_cost, int del_cost, int rep_cost)
{
    /*
    Input: 
        source: a string corresponding to the string you are starting with
        target: a string corresponding to the string you want to end with
        ins_cost: an integer setting the insert cost
        del_cost: an integer setting the delete cost
        rep_cost: an integer setting the replace cost
    Output:
        the minimum edit distance (med) required to convert the source string to the target
    */

    // use deletion and insert cost as  1
    int nb_row = strlen(source);
    int nb_col = strlen(target);
    int row, col, diag, temp;
        
    // initialization
    unsigned int line[nb_col + 1];
    for (col=1; col<nb_col + 1; col++) {
        line[col] = col;
    }
    
    // iterate over rows
    for (row=1; row<nb_row + 1; row++) {
        line[0] = row;
        for (col=1, diag=row - 1; col<nb_col + 1; col++) {
            temp = line[col];
            line[col] = MIN3(line[col-1]+ins_cost, line[col]+del_cost, diag + (source[row-1] == target[col-1] ? 0 : rep_cost));
            diag = temp;
        }
    }
      
    return line[nb_col];
}

// int main(int argc, char *argv[])
// {
//     if(argc == 6) {
//         char *source = argv[1];
//         char *target = argv[2];
//         int ins_cost = atoi(argv[3]);
//         int del_cost = atoi(argv[4]);
//         int rep_cost = atoi(argv[5]);
//         levenshtein(source, target, ins_cost, del_cost, rep_cost);
//     }
//     else 
//     {
//         return -1;
//     } 
// }
