#include <stdio.h>
#include <math.h>

#include "methods.h"

typedef double afunc(double);

double f4(double x) {
    return 2 * x - 3;
}

double f5(double x) {
    return -2 * x + 3;
}

double f6(double x) {
    return 3;
}

int main(int argc, char **argv) {
    double ans, res;

    printf("N       ANS      ABS      REL\n");
    ans = 1.5;
    res = root(f4, f5, 1, 2, 1e-6).res;
    printf("test 1: %lf %lf %lf%%\n", ans, fabs(ans - res), (fabs(ans/res - 1)) * 100);

    ans = 0;
    res = root(f6, f5, -1, 1, 1e-6).res;
    printf("test 2: %lf %lf %lf%%\n", ans, fabs(ans - res), (fabs(ans - res / (res + 1e-6))) * 100);

    ans = 3;
    res = root(f6, f4, 2, 4, 1e-6).res;
    printf("test 3: %lf %lf %lf%%\n", ans, fabs(ans - res), (fabs(ans / res - 1)) * 100);

    ans = 3;
    res = integral(f6, 1, 2, 1e-6).res;
    printf("test 4: %lf %lf %lf%%\n", ans, fabs(ans - res), (fabs(ans / res - 1)) * 100);

    ans = 2;
    res = integral(f4, 1, 3, 1e-6).res;
    printf("test 5: %lf %lf %lf%%\n", ans, fabs(ans - res), (fabs(ans/res - 1)) * 100);

    ans = -2;
    res = integral(f5, 1, 3, 1e-6).res;
    printf("test 6: %lf %lf %lf%%\n", ans, fabs(ans - res), (fabs(ans / res - 1)) * 100);
}
