interface primeModule{
  command int64_t power(int64_t a, uint64_t n, int64_t p);
  command int64_t gcd(int64_t a, int64_t b);
  command bool isPrime(uint64_t n, int64_t k);
  command uint32_t genLargeNum();//could take input of seed later for now will use rand()
  command uint32_t genLargePrime();
}
