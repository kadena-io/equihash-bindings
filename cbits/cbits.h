// -*- c++ -*-
#pragma once

#include <inttypes.h>

extern "C" {

void*
equihash_create_proof(const uint32_t n, const uint32_t k, const uint32_t seed,
                      const uint32_t nonce, int n_inputs, uint32_t* ins);
void equihash_destroy_proof(void* proof);
void* equihash_find_proof(
  const uint32_t n, const uint32_t k, const uint32_t seed);
int equihash_check_proof(void* p);

uint32_t* equihash_explode_proof(void* p, uint32_t* n_out, uint32_t* k_out,
                                 uint32_t* seed_out, uint32_t* nonce_out,
                                 int* n_inputs_out);
}
