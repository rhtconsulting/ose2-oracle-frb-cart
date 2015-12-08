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

2. Install sshpass Utility
--------------------------

To provide the needed requirement that the SSH call use username/password rather than public-key exchange; the sshpass command needs to be installed. This is because the ssh command does not support silent username/password authentication as this cartridge would require. The sshpass tool is not avaliable from the official Red Hat repos, but can instead be downloaded from the Fedora EPEL repos. 

Please refer to the official EPEL documentation for instructions on how to enable the repos: https://fedoraproject.org/wiki/EPEL

```
sudo yum install -y wget
wget https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh epel-release-6-8.noarch.rpm
yum install -y sshpass
```

3. Oracle Requirements/Remote Script
------------------------------------

This cartridge is in and of itself not responsible for configuring a remote tenant, instead that responsibility lies to a script that resides on a remote host that will be called by the install script when the gear is instantiated. Script is called via a remote sshpass call. The script accepts username, password, and SID. It will then return success/fail@@host@@port@@Tenant_ID

4. Cartridge Installation
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

You now need to set the environment variables on each Node. Please note that the script does expect the password variable value to be a base64 hash of the plaintext password. Modify as needed:
```
echo "$(echo "Password123" |  base64)" > /etc/openshift/env/OPENSHIFT_ORACLE_DB_SCRIPT_ENC_PASSWORD
echo "/OracleProvisioningScript.sh" > /etc/openshift/env/OPENSHIFT_ORACLE_DB_SCRIPT_LOC
echo "@@" > /etc/openshift/env/OPENSHIFT_ORACLE_DB_SCRIPT_DELIMINATOR
echo "oraclescripthost.example.com" > /etc/openshift/env/OPENSHIFT_ORACLE_DB_SCRIPT_HOST
echo "scriptuser" > /etc/openshift/env/OPENSHIFT_ORACLE_DB_SCRIPT_USER
```

C. GEAR CREATION
================

Creating an instance of this Oracle Configuration Cartridge follows a similar processes as any other Add-On cartridge save the fact that a environment variable, OPENSHIFT_ORACLE_DB_SID, needs to be set for the application. This environment variable will be passed to the remote script that actually provisions the Oracle tenant and will be used to determine the Oracle SID. Below is an example in which a jbossews-2.0 application is created with the Oracle Configuration Add-On.

```
rhc app-create myapplication jbossews-2.0 frb-oracle-12.0 OPENSHIFT_ORACLE_DB_SID=mySid --namespace domain --gear-size small --scaling
```
