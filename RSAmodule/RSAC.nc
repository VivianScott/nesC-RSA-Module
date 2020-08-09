configuration RSAC{
    provides interface RSAinterface;
}

implementation{
    components RSAP as RSA;
    RSAinterface = RSA;
    //components new HashmapC(uint32_t, 20) as NeighMap;
    //RSA.Hashmap -> NeighMap;
    components primeC;
    RSA.primeModule -> primeC;
}
