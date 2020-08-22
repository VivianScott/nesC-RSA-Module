#include "RSA.h"
interface RSAinterface{

    //char *PRIME_SOURCE_FILE = "primes.txt";
    command bool RSAtest();
    //command void rsa_gen_keys(struct public_key_class *pub, struct private_key_class *priv, const char *PRIME_SOURCE_FILE);
    //command void rsa_gen_keys(struct public_key_class *pub, struct private_key_class *priv);
    //command void rsa_gen_keys(uint64_t *pubMod, uint64_t *pubExp, uint64_t *privMod, uint64_t *privExp);
    command void rsa_test_key();
    //command int64_t *rsa_encrypt(const char *message, const uint32_t message_size, const struct public_key_class *pub);
    command uint64_t *rsa_encrypt(const char *message, const uint32_t message_size);
    //command char *rsa_decrypt(const int64_t *message, const uint32_t message_size, const struct private_key_class *pub);
    command char *rsa_decrypt(const uint64_t *message, const uint32_t message_size);

    command void rsa_test_prime(uint64_t a);

    command uint32_t rsa_gen_prime();

    command void gen_key();

    command void test_key_gen();

    command int64_t get_modulus();

    command int64_t get_exponent();
}
