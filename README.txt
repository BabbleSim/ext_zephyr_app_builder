This component just contains a script (Makefile) to automate building a zephyr
app and copying the resulting exe to the bin directory with a proper name

You should always define ZEPHYR_BASE (either as an enviroment variable or in the call to make)
You can also provide 
  BOARD (by default nrf52_bsim)
  APP (by default samples/hello_world)
  and CONF_FILE (by default prj.conf)

e.g.:
make ZEPHYR_BASE=$HOME/zephyr APP=samples/bluetooth/central 
