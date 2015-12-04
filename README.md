ose2-oracle-frb-cart
====================

A. Synopsis
===========

TODO

B. Installation
===============

1. Setup OSE Environment
------------------------

TODO

2. Cartridge Installation
-------------------------
The cartridge can be installed as any other  OSE cartridge.

On each OpenShift Node execute the following commands:
```
cd /usr/libexec/openshift/cartridges
git clone https://github.com/rhtconsulting/ose2-oracle-frb-cart.git
oo-admin-cartridge --action install --recursive --source /usr/libexec/openshift/cartridges
oo-admin-ctl-cartridge --activate -c import-node --obsolete
oo-admin-broker-cache --clear && oo-admin-console-cache --clear
```

You now need to set the environment variables on each Node. Modify as needed:
```
echo "$(echo "Password123" |  base64)" > /etc/openshift/env/OPENSHIFT_ORACLE_DB_SCRIPT_ENC_PASSWORD
echo "/OracleProvisioningScript.sh" > /etc/openshift/env/OPENSHIFT_ORACLE_DB_SCRIPT_LOC
echo "@@" > /etc/openshift/env/OPENSHIFT_ORACLE_DB_SCRIPT_DELIMINATOR
echo "oraclescripthost.example.com" > /etc/openshift/env/OPENSHIFT_ORACLE_DB_SCRIPT_HOST
echo "scriptuser" > /etc/openshift/env/OPENSHIFT_ORACLE_DB_SCRIPT_USER
```
