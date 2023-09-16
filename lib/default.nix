{lib, ...}:
# personal lib
{
  # get default across the module system
  _module.args = {
    default = import ./theme lib;
  };
}
