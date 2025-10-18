#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <getopt.h>

#include "methods.h"

extern double f1(double x);
extern double f2(double x);
extern double f3(double x);

afunc* get_func_by_index(int idx) {
    switch (idx) {
        case 1:
            return *f1;
        case 2:
            return *f2;
        case 3:
            return *f3;
        default:
            fprintf(stderr, "Invalid function index: %d.\n", idx);
            exit(1);
    }
}

struct arguments {
    int help_flag;            // -h/--help flag
    int root_flag;            // -r/--root flag
    int iterations_flag;      // -i/--iterations flag
    char* test_root_arg;      // -R/--test-root argument
    char* test_integral_arg;  // -I/--test-integral argument
};

void print_help() {
    printf("Usage: program [OPTIONS]\n");
    printf("Options:\n");
    printf("  -h, --help               Show this help message\n");
    printf("  -r, --root               Print x-coordinates of intersection points\n");
    printf("  -i, --iterations         Print iteration count for approximation\n");
    printf("  -R, --test-root F1:F2:A:B:E:R\n");
    printf("                           Test root function with parameters:\n");
    printf("                           F1,F2 - function numbers (1-3)\n");
    printf("                           A,B - interval bounds\n");
    printf("                           E - epsilon precision\n");
    printf("                           R - expected result\n");
    printf("  -I, --test-integral F:A:B:E:R\n");
    printf("                           Test integral function with parameters:\n");
    printf("                           F - function number (1-3)\n");
    printf("                           A,B - integration bounds\n");
    printf("                           E - epsilon precision\n");
    printf("                           R - expected result\n");
}


void print_roots() {
    double eps = 1e-6;
    double root12 = root(f1, f2, 1.5, 2.5, eps).res;
    double root13 = root(f1, f3, -0.5, 0, eps).res;
    double root23 = root(f2, f3, 0, 0.5, eps).res;

    printf("Intersection points (x-coordinates):\n");
    printf("f1 x f2: %lf\n", root12);
    printf("f1 x f3: %lf\n", root13);
    printf("f2 x f3: %lf\n", root23);
}


void print_iterations() {
    double eps = 1e-12;
    unsigned root12 = root(f1, f2, 1.5, 2.5, eps).iter;
    unsigned root13 = root(f1, f3, -0.5, 0, eps).iter;
    unsigned root23 = root(f2, f3, 0, 0.5, eps).iter;
    printf("Iterations needed:\n");
    printf("f1 x f2: %d\n", root12);
    printf("f1 x f3: %d\n", root13);
    printf("f2 x f3: %d\n", root23);
}

void calculate_area() {
    double eps = 1e-6;
    double root12 = root(f1, f2, 1.5, 2.5, eps).res;
    double root13 = root(f1, f3, -0.5, 0, eps).res;
    double root23 = root(f2, f3, 0, 0.5, eps).res;

    double s1 = integral(f1, root13, root12, eps).res;
    double s2 = integral(f2, root23, root12, eps).res;
    double s3 = integral(f3, root13, root23, eps).res;
    printf("Total area: %.6f\n", s1 - s2 - s3);
}

void test_root(const char *arg) {
    int f1_idx, f2_idx;
    double a, b, eps, expected;

    if (sscanf(arg, "%d:%d:%lf:%lf:%lf:%lf", &f1_idx, &f2_idx, &a, &b, &eps, &expected) != 6) {
        fprintf(stderr, "Invalid format for test-root argument\n");
        fprintf(stderr, "Expected format: F1:F2:A:B:E:R\n");
        return;
    }

    double result = root(get_func_by_index(f1_idx), get_func_by_index(f2_idx), a, b, eps).res;

    double abs_error = fabs(result - expected);
    double rel_error = abs_error / fabs(expected);
    printf("Result: %.6f\n", result);
    printf("Absolute error: %.6f\n", abs_error);
    printf("Relative error: %.6f\n", rel_error);
}


void test_integral(const char *arg) {
    int f_idx;
    double a, b, eps, expected;

    if (sscanf(arg, "%d:%lf:%lf:%lf:%lf", &f_idx, &a, &b, &eps, &expected) != 5) {
        fprintf(stderr, "Invalid format for test-integral argument\n");
        fprintf(stderr, "Expected format: F:A:B:E:R\n");
        return;
    }

    double result = integral(get_func_by_index(f_idx), a, b, eps).res;

    double abs_error = fabs(result - expected);
    double rel_error = abs_error / fabs(expected);
    printf("Result: %.6f\n", result);
    printf("Absolute error: %.6f\n", abs_error);
    printf("Relative error: %.6f\n", rel_error);
}

int main(int argc, char *argv[]) {
    struct arguments args = {0};

    static struct option long_options[] = {
            {"help",        no_argument,       NULL, 'h'},
            {"root",        no_argument,       NULL, 'r'},
            {"iterations",  no_argument,       NULL, 'i'},
            {"test-root",   required_argument, NULL, 'R'},
            {"test-integral", required_argument, NULL, 'I'},
            {NULL, 0, NULL, 0}  // Terminator
    };

    int opt;
    int option_index = 0;
    while ((opt = getopt_long(argc, argv, "hriR:I:", long_options, &option_index)) != -1) {
        switch (opt) {
            case 'h':
                args.help_flag = 1;
                break;
            case 'r':
                args.root_flag = 1;
                break;
            case 'i':
                args.iterations_flag = 1;
                break;
            case 'R':
                args.test_root_arg = optarg;
                break;
            case 'I':
                args.test_integral_arg = optarg;
                break;
            case '?':
                print_help();
                return EXIT_FAILURE;
            default:
                fprintf(stderr, "Unexpected error during option parsing\n");
                return EXIT_FAILURE;
        }
    }

    // Handle non-option arguments (if any)
    if (optind < argc) {
        fprintf(stderr, "Non-option arguments: ");
        while (optind < argc) {
            fprintf(stderr, "%s ", argv[optind++]);
        }
        fprintf(stderr, "\n");
        print_help();
        return 1;
    }

    // Execute requested actions
    if (args.help_flag) {
        print_help();
    }
    if (args.root_flag) {
        print_roots();
    }
    if (args.iterations_flag) {
        print_iterations();
    }
    if (args.test_root_arg) {
        test_root(args.test_root_arg);
    }
    if (args.test_integral_arg) {
        test_integral(args.test_integral_arg);
    }

    if (!(args.help_flag || args.root_flag || args.iterations_flag ||
          args.test_root_arg || args.test_integral_arg)) {
        calculate_area();
    }

    return 0;
}
