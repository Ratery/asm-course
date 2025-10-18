#include <stdio.h>
#include <math.h>

#include "methods.h"

int get_sign(double x) {
    return x < 0 ? -1 : 1;
}

double func_sub(afunc* f, afunc* g, double x) {
    return f(x) - g(x);
}

struct res_pair root(afunc* f, afunc* g, double a, double b, double eps) {
    double c;
    for (unsigned i = 0; i < MAX_SECANT_ITERATIONS; i++) {
        double f_left = func_sub(f, g, a);
        double f_right = func_sub(f, g, b);
        c = (a * f_right - b * f_left) / (f_right - f_left);

        double mid = (a + b) / 2;
        double f_mid = func_sub(f, g, mid);
        if (get_sign(f_left) * get_sign(f_mid - (f_left + f_right) / 2) == 1) {
            b = c;
            if (get_sign(func_sub(f, g, c)) * get_sign(func_sub(f, g, c + eps)) == -1) {
                struct res_pair res = {c, i + 1};
                return res;
            }
        } else {
            a = c;
            if (get_sign(func_sub(f, g, c)) * get_sign(func_sub(f, g, c - eps)) == -1) {
                struct res_pair res = {c, i + 1};
                return res;
            }
        }
    }
    struct res_pair res = {c, MAX_SECANT_ITERATIONS};
    return res;
}

struct res_pair integral(afunc* f, double a, double b, double eps) {
    unsigned n = START_FRAGMENTS_NUMBER;
    double start_point = 0.5 * (f(a) + f(b));

    double integral = start_point;
    double h = (b - a) / n;

    for (unsigned i = 1; i < n; i++) {
        integral += f(a + i * h);
    }
    integral *= h;

    unsigned i = 0;
    double prev_integral;
    do {
        n *= 2;
        h /= 2;
        prev_integral = integral;
        integral = start_point;

        for (unsigned i = 1; i < n; i++) {
            integral += f(a + i * h);
        }
        integral *= h;
        i++;
    } while (i < MAX_RUNGE_ITERATIONS && fabs(prev_integral - integral) / 3 >= eps);
    double final_precision = fabs(prev_integral - integral) / 3;
    if (final_precision >= eps) {
        fprintf(
            stderr,
            "[WARNING]: Failed to reach desired precision, consider increasing iterations limit\n"
        );
    }
    struct res_pair res = {integral, i + 1};
    return res;
}
