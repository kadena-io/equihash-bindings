#include <cstdlib>
#include <utility>

#include "cbits.h"
#include "pow.cc"
#include "blake/blake2b.cpp"

using namespace _POW;

extern "C" {

void*
equihash_create_proof(const uint32_t n, const uint32_t k, const uint32_t seed,
                      const uint32_t nonce, int n_inputs, uint32_t* ins) {
  std::vector<Input> inputs(ins, ins + n_inputs);
  return new Proof(n, k, Seed{seed}, nonce, std::move(inputs));
}

void equihash_destroy_proof(void* proof) {
  Proof* p = (Proof*) proof;
  delete p;
}

void*
equihash_find_proof(
  const uint32_t n, const uint32_t k, const uint32_t seed) {
  Equihash obj(n, k, Seed{seed});
  return new Proof(obj.FindProof());
}

int equihash_check_proof(void* proof) {
  Proof* p = (Proof*) proof;
  return p->Test();
}

uint32_t* equihash_explode_proof(void* proof0, uint32_t* n_out, uint32_t* k_out,
                                 uint32_t* seed_out, uint32_t* nonce_out,
                                 int* n_inputs_out) {
  Proof* proof = (Proof*) proof0;
  *n_out = proof->n;
  *k_out = proof->k;
  *seed_out = proof->seed[0];
  *nonce_out = proof->nonce;
  size_t inputs_n = proof->inputs.size();
  *n_inputs_out = static_cast<int>(inputs_n);
  uint32_t* inputs_out = (uint32_t*) malloc(sizeof(uint32_t) * inputs_n);
  const uint32_t* p = proof->inputs.data();
  uint32_t* q = inputs_out;
  for (size_t i = 0; i < inputs_n; ++i) {
    *q++ = *p++;
  }
  return inputs_out;
}

}
