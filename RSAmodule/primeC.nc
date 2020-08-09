configuration primeC{
  provides interface primeModule;
  //uses interface GIntmodule;
}
implementation{

  components primeP as primegen;
  primeModule = primegen;

}
