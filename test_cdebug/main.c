#include <stdio.h>
#define MAX_N 40

void print_int_endline (int i) {
    printf("%d\n", i);
}

// Print integers from 1 to [n], on separate lines.
int main(int argc, char* argv) {
    int n = MAX_N;
    for (int i = 1; i <= n; i++) {
        print_int_endline (i);
    }
    return 0;
}
