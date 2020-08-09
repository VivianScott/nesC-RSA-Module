#include <stdlib.h>
module primeP{
  provides interface primeModule;
}

implementation{

  command int64_t primeModule.power(int64_t a, uint64_t n, int64_t p){
      int res = 1;
      a = a % p; //random number mod potential prime - 1
      while(n>0){ //potential prime > 0
        if(n&1){ //if n is odd
          res = (res*a)%p; //res = (res*random number) mod potential prime - 1
        }
        n = n>>1; //potential prime =
        a = (a*a)%p;
      }
      //dbg(GENERAL_CHANNEL, "res: %d\n", res);
      return res;
  }

  command int64_t primeModule.gcd(int64_t a, int64_t b){
      if(a<b){
        return call primeModule.gcd(b, a);
      }else if(a%b == 0){
        return b;
      }else{
        return call primeModule.gcd(b, a%b);
      }
  }

  command bool primeModule.isPrime(uint64_t n, int64_t k){
      if(n<=1 || n==4){
        dbg(GENERAL_CHANNEL, "Input is not prime. (check 1)\n");
        return FALSE;
      }
      if(n<=3){
        dbg(GENERAL_CHANNEL, "Input is prime.\n");
        return TRUE;
      }
      while(k>0){
        int64_t a = 2+rand()%(n-4);

        if(call primeModule.gcd(n, a) != 1){
          dbg(GENERAL_CHANNEL, "Input is not prime. (check 2)\n");
          return FALSE;
        }

        if(call primeModule.power(a, n-1, n) != 1){
          dbg(GENERAL_CHANNEL, "Input is not prime. (check 3)\n");
          return FALSE;
        }
        k--;
      }
      dbg(GENERAL_CHANNEL, "Input is prime.\n");
      return TRUE;
  }

  command uint32_t primeModule.genLargeNum(){
      uint32_t r = 0;
      int8_t l;
      for(l = 3; l>0; l--){//l=5
        r = r*(107374 + (uint32_t)1) + rand(); //1073741823
      }
      if(r >= 2150000000){
        r = r/2;
      }
      r = r/1000000;
      dbg(GENERAL_CHANNEL, "Generated number: %lu \n", r);
      return r;
  }

  command uint32_t primeModule.genLargePrime(){
    uint32_t num;
    uint16_t safety;
    bool foundPrime = FALSE;

    num = call primeModule.genLargeNum();
    if(num%2 == 0){//make sure num is odd
      num = num+1;
    }
    safety = 0;
    while(foundPrime == FALSE){
      dbg(GENERAL_CHANNEL, "Checking if %llu is prime...\n", num);
      foundPrime = call primeModule.isPrime(num, 3);
      if(foundPrime == FALSE){
        num = num+2; //only checks odd numbers
        safety++;
      }
      if(safety >= 300){
        dbg(GENERAL_CHANNEL, "safety triggered.\n");
        break;
      }
    }
    return num;
  }
}
