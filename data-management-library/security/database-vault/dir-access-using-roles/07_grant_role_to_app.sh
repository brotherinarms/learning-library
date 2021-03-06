#!/bin/bash

# keep track of script usage with a simple curl query
# the remote host runs nginx and uses a javascript function to mask your public ip address
# see here for details: https://www.nginx.com/blog/data-masking-user-privacy-nginscript/
#
file_path=`realpath "$0"`
curl -Is --connect-timeout 3 http://150.136.21.99:6868${file_path} > /dev/null

# generate an output based on the script name
outfile=$(basename -s .sh $0)".out"
#echo $outfile
rm -f $outfile 2>&1
exec > >(tee -a $outfile) 2>&1


echo
echo "Grant the role to the application user..."
echo
echo

sqlplus -s -l sys/${DBUSR_PWD}@${PDB_NAME} as sysdba <<EOF

set serveroutput on;
set echo on;
column grantee format a25
column granted_role format a25

grant EMPSEARCH_APP to EMPLOYEESEARCH_PROD;

select * from dba_role_privs where grantee = 'EMPLOYEESEARCH_PROD' order by 1;

EOF

