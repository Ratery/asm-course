#pragma once

#define START_FRAGMENTS_NUMBER 8
#define MAX_RUNGE_ITERATIONS 30
#define MAX_SECANT_ITERATIONS 1e4

struct res_pair {
    double res;
    unsigned iter;
};

typedef double afunc(double);

struct res_pair root(afunc* f, afunc* g, double a, double b, double eps);
struct res_pair integral(afunc* f, double a, double b, double eps);
