include("heading_C.jl")
@C raw""" 
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <gmp.h>
void mod(mpz_t result, mpz_t base, mpz_t exponent, mpz_t mod) {
    mpz_set_ui(result, 1);
    mpz_t temp_base; mpz_t temp_exponent; mpz_t temp_mod;
    mpz_init(temp_base); mpz_init(temp_exponent); mpz_init(temp_mod);
	mpz_set(temp_base, base);
    mpz_set(temp_exponent, exponent);
    mpz_set(temp_mod, mod);
    mpz_mod(temp_base, temp_base, temp_mod);
    while (mpz_cmp_ui(temp_exponent, 0) > 0) {
        if (mpz_odd_p(temp_exponent)) {
            mpz_mul(result, result, temp_base);
            mpz_mod(result, result, temp_mod);
        }
        mpz_fdiv_q_2exp(temp_exponent, temp_exponent, 1);
        mpz_mul(temp_base, temp_base, temp_base);
        mpz_mod(temp_base, temp_base, temp_mod);
    }
    mpz_clear(temp_base);
    mpz_clear(temp_exponent);
    mpz_clear(temp_mod);
}
int is_prime(mpz_t n) {
    int iterations = 25;
    if (mpz_cmp_ui(n, 2) < 0) return 0;
    if (mpz_cmp_ui(n, 2) == 0) return 1;
    if (mpz_even_p(n)) return 0;
    mpz_t d, r, a, x, n_minus_1;
    gmp_randstate_t state;
    gmp_randinit_default(state);
    gmp_randseed_ui(state, time(0));
    mpz_init(d);
    mpz_init(r);
    mpz_init(a);
    mpz_init(x);
    mpz_init(n_minus_1);
    mpz_sub_ui(n_minus_1, n, 1);
    mpz_set(d, n_minus_1);
    mpz_set_ui(r, 0);
    while (mpz_even_p(d)) {
        mpz_fdiv_q_2exp(d, d, 1);
        mpz_add_ui(r, r, 1);
    }
    for (int i = 0; i < iterations; i++) {
        mpz_urandomm(a, state, n_minus_1);
        mod(x, a, d, n);
        if (mpz_cmp_ui(x, 1) != 0 && mpz_cmp(x, n_minus_1) != 0) {
            int composite = 1;
            mpz_t temp_r;
            mpz_init_set(temp_r, r);

            while (mpz_cmp_ui(temp_r, 0) > 0) {
                mod(x, x, temp_r, n);
                if (mpz_cmp(x, n_minus_1) == 0) {
                    composite = 0;
                    break;
                }
                mpz_sub_ui(temp_r, temp_r, 1);
            }
            mpz_clear(temp_r);
            if (composite) {
                mpz_clear(d);
                mpz_clear(r);
                mpz_clear(a);
                mpz_clear(x);
                mpz_clear(n_minus_1);
                gmp_randclear(state);
                return 0;
            }
        }
    }
    mpz_clear(d);
    mpz_clear(r);
    mpz_clear(a);
    mpz_clear(x);
    mpz_clear(n_minus_1);
    gmp_randclear(state);

    return 1;
}
int main() {
    mpz_t number;
    mpz_init(number);
    mpz_set_str(number, "316266921844009482046654269131", 10);
    if (is_prime(number)) {
        printf("Число ");
        mpz_out_str(stdout, 10, number);
        printf(" является простым\n");
    } else {
        printf("Число ");
        mpz_out_str(stdout, 10, number);
        printf(" является составным\n");
    }
    mpz_clear(number);
    return 0;
}
"""
