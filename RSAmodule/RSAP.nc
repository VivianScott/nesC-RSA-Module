#include "RSA.h"
#include <math.h>

//provides encryption/decryption
//stores public/private keys
//figure out how to generate prime numbers

module RSAP{
    provides interface RSAinterface;

    uses interface primeModule;
    //uses interface Hashmap<uint32_t>;
}
implementation{
    //MAY REQUIRE CHANGES TO SIGNED INT IN PLACES?
    public_key_class pubKey;
    private_key_class privKey;
    char *PRIME_SOURCE_FILE = "primes.txt";
    char buffer[1024];
    const int32_t MAX_DIGITS = 50;
    int16_t i = 0;
    int16_t j = 0;

    /*
    int64_t gcd(int64_t a, int64_t h){
      int64_t temp;
    */
    uint64_t gcd(uint64_t a, uint64_t h){
      uint64_t temp;
      while(TRUE){
        temp = a%h;
        if(temp==0){
          return h;
        }
        a = h;
        h = temp;
      }
    }

/*
    int64_t ExtEuclid(int64_t a, int64_t b){
      int64_t x = 0;
      int64_t y = 1;
      int64_t u = 1;
      int64_t v = 0;
      int64_t gcdVar = b;
      int64_t m;
      int64_t n;
      int64_t q;
      int64_t r;
*/
    uint64_t ExtEuclid(uint64_t a, uint64_t b){
      uint64_t x = 0;
      uint64_t y = 1;
      uint64_t u = 1;
      uint64_t v = 0;
      uint64_t gcdVar = b;
      uint64_t m;
      uint64_t n;
      uint64_t q;
      uint64_t r;
      while(a != 0){
        q = gcdVar/a;
        r = gcdVar%a;
        m = x-u*q;
        n = y-v*q;
        gcdVar = a;
        a = r;
        x = u;
        y = v;
        u = m;
        v = n;
      }
      return y;
    }

    //int64_t rsa_modExp(int64_t b, int64_t e, int64_t m){
    uint64_t rsa_modExp(uint64_t b, uint64_t e, uint64_t m){
      if(b<0 || e<0 || m<=0){
        exit(1);
      }
      b = b % m;
      if(e==0){
        return 1;
      }
      if(e==1){
        return b;
      }
      if(e%2 == 0){
        return(rsa_modExp(b*b%m, e/2, m) % m);
      }
      if(e%2 == 1){
        return(b*rsa_modExp(b,(e-1), m) % m);
      }
    }

    int64_t inverse(int64_t a, int64_t b){
      int64_t inv;
      int64_t q, r, r1=a, r2 = b, t, t1=0, t2=1;

      while(r2>0){
        q = r1/r2;
        r = r1 - q * r2;
        r1 = r2;
        r2 = r;

        t = t1 - q * r2;
        t1 = t2;
        t2 = t;
      }

      if(r1 == 1){
        inv = t1;
      }
      if(inv < 0){
        inv = inv + a;
      }
      return inv;
    }
    /*
    command void RSAinterface.rsa_gen_keys(struct public_key_class *pub, struct private_key_class *priv, const char *PRIME_SOURCE_FILE){

    }
    */
    command bool RSAinterface.RSAtest(){
      return 1;
    }

    command void RSAinterface.rsa_test_prime(uint64_t a){
      int64_t k = 3;
      uint8_t v;
      call primeModule.isPrime(a, k);
      //call primeModule.is_prime(a, k);
      /*
      for(v=0; v<10; v++){
        call primeModule.genLargeNum();
      }
      */
      //a = call primeModule.genLargePrime();
    }

    command uint32_t RSAinterface.rsa_gen_prime(){
      uint32_t num;

      num = call primeModule.genLargePrime();

      return num;
    }

    command void RSAinterface.rsa_gen_key(){
      uint32_t p;
      uint32_t q;
      uint64_t n;
      uint64_t count;
      uint64_t totient;
      uint64_t e;
      uint64_t d;
      uint64_t k;
      uint64_t x;

      p = call RSAinterface.rsa_gen_prime();
      q = call RSAinterface.rsa_gen_prime();

      dbg(GENERAL_CHANNEL, "p: %llu q: %llu \n", p , q);

      n = p*q;
      pubKey.modulus = n;
      privKey.modulus = n;
      totient = (p-1)*(q-1);

      do{
        e = rand() % (totient - 2) + 2;
      }while(gcd(e, totient) != 1);

      d = inverse(totient, e);

      /*
      for(e = totient-1; e>2; e--){
        if(gcd(e,totient) == 1){
          break;
        }
      }

      for(k = 0; k<10; k++){
        x = 1+i*totient;
        if(x%e == 0){
          d = x/e;
          break;
        }
      }
      */

      /*
      e = powl(2, 4)+1;

      d = ExtEuclid(totient,e);
      while(d<0){
        d = d+totient;
      }
      */

      /*
      e = 2;

      while(e<totient){
        count = gcd(e, totient);
        if(count == 1){
          break;
        }else{
          e++;
        }
      }

      k = 2;

      d = (1+(k*totient))/e;
      */

      pubKey.exponent = e;
      privKey.exponent = d;

      dbg(GENERAL_CHANNEL, "pubKey modulus: %llu pubKey exponent: %llu\n", pubKey.modulus, pubKey.exponent);
      dbg(GENERAL_CHANNEL, "privKey modulus: %llu privKey exponent: %llu\n", privKey.modulus, privKey.exponent);
    }
    //command void RSAinterface.rsa_gen_keys(struct public_key_class *pub, struct private_key_class *priv){
    //command void RSAinterface.rsa_gen_keys(uint64_t *pubMod, uint64_t *pubExp, uint64_t *privMod, uint64_t *privExp){
    command void RSAinterface.rsa_test_key(){

        pubKey.modulus = 3127;
        pubKey.exponent = 3;

        privKey.modulus = 3127;
        privKey.exponent = 2011;

      /*
        pubKey.modulus = 14;
        pubKey.exponent = 5;

        privKey.modulus = 14;
        privKey.exponent = 11;
      */
        dbg(GENERAL_CHANNEL, "VALUES ASSIGNED \n");

        dbg(GENERAL_CHANNEL, "pub modulus: %d, pub exponent: %d \n", pubKey.modulus, pubKey.exponent);
        dbg(GENERAL_CHANNEL, "priv modulus: %d, priv exponent: %d \n", privKey.modulus, privKey.exponent);
    }

    //command int64_t* RSAinterface.rsa_encrypt(const char *message, const uint32_t message_size, const struct public_key_class *pub){
    command int64_t* RSAinterface.rsa_encrypt(const char *message, const uint32_t message_size){
        int64_t *encrypted = malloc(sizeof(int64_t)*message_size);
        int64_t k;

        //dbg(GENERAL_CHANNEL, "Beginning encryption \n");
        if(encrypted == NULL){
          //heap allocation fails
          dbg(GENERAL_CHANNEL, "Heap allocation failed. \n");
          return NULL;
        }
        //dbg(GENERAL_CHANNEL, "start of loop \n");
        for(k=0; k<message_size; k++){
          encrypted[k] = rsa_modExp(message[k], pubKey.exponent, pubKey.modulus);
        }
        //dbg(GENERAL_CHANNEL, "End of loop \n");
        return encrypted;
    }

    command void RSAinterface.gen_key(){
      uint64_t p, q, n, phi_n;
      p = call RSAinterface.rsa_gen_prime();
      q = call RSAinterface.rsa_gen_prime();
      n = p*q;
      phi_n = (p-1)*(q-1);

      pubKey.modulus = n;
      privKey.modulus = n;

      dbg(GENERAL_CHANNEL, "p: %llu, q: %llu, n: %llu, phi_n: %llu \n", p, q, n, phi_n);
    }

    //command char* RSAinterface.rsa_decrypt(const int64_t *message, const uint32_t message_size, const struct private_key_class *priv){
    command char* RSAinterface.rsa_decrypt(const int64_t *message, const uint32_t message_size){

      char *decrypted;
      char *temp;
      int64_t k = 0;

      if(message_size % sizeof(int64_t) != 0){
        //message size not devisable, so decryption fails
        dbg(GENERAL_CHANNEL, "Error: message not devisable.\n");
        return NULL;
      }

      decrypted = malloc(message_size/sizeof(int64_t));
      temp = malloc(message_size);

      if((decrypted == NULL) || (temp==NULL)){
        //heap allocation fails
        dbg(GENERAL_CHANNEL, "Error: heap allocation failed.\n");
        return NULL;
      }

      for(k=0; k<message_size/8; k++){
        temp[k] = rsa_modExp(message[k], privKey.exponent, privKey.modulus);
      }

      for(k=0; k<message_size/8; k++){
        decrypted[k] = temp[k];
      }
      free(temp);
      return decrypted;
  }
}
