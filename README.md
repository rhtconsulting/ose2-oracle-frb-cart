ose2-oracle-frb-cart
====================

A. Synopsis
===========

This cartridge provides the ability to call on a remote script that accepts basic Oracle Tenant information, creates a tenant with said information, and than returns to the cartridge some further basic information. The cartridge then sets a series of application level environment variables that will allow a data-source to be configured that can connect to the new Oracle tenant.

B. Installation
===============

1. Setup OSE Environment
------------------------

Before the cartridge can be installed, a OSE2 environment must be provisioned; for details on this please consult the official Red Hat documentation. (https://access.redhat.com/documentation/en-US/OpenShift_Enterprise/2/html-single/Deployment_Guide/)

2. Oracle Requirements/Remote Script
------------------------------------

TODO

3. Cartridge Installation
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
