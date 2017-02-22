all_simulators=true


# Grab All Simulators and Install (SMIS already done above)
if [ "$all_simulators" = true ]; then

  # ---------------------------------
  # Second, LDAP Simulator
  # ---------------------------------
  if [ ! -e /vagrant/simulators/ldapsvc-1.0.0.zip ]; then
     wget 'https://coprhd.atlassian.net/wiki/download/attachments/6652057/ldapsvc-1.0.0.zip?version=2&modificationDate=1453406325338&api=v2' -O /vagrant/simulators/ldapsvc-1.0.0.zip
  fi

  unzip /vagrant/simulators/ldapsvc-1.0.0.zip -d /simulator
  cd /simulator/ldapsvc-1.0.0/bin/
  echo "Starting LDAP Simulator Service"
  ./ldapsvc &
  sleep 30
  curl -X POST -H "Content-Type: application/json" -d "{\"listener_name\": \"COPRHDLDAPSanity\"}" http://127.0.0.1:8082/ldap-service/start


fi

