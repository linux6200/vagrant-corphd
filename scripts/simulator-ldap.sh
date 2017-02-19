all_simulators=true


# Grab All Simulators and Install (SMIS already done above)
if [ "$all_simulators" = true ]; then

  # ---------------------------------
  # Second, LDAP Simulator
  # ---------------------------------
  if [ ! -e /vagrant/simulators/ldapsvc-1.0.0.zip ]; then
     wget 'https://build.coprhd.org/jenkins/userContent/simulators/ldap-sim/1.0.0.0.7/ldap-simulators-1.0.0.0.7-bin.zip' -O /vagrant/simulators/ldapsvc-1.0.0.zip
  fi

  unzip /vagrant/simulators/ldapsvc-1.0.0.zip -d /simulator
  cd /simulator/ldapsvc-1.0.0/bin/
  echo "Starting LDAP Simulator Service"
  ./ldapsvc &
  sleep 5
  curl -X POST -H "Content-Type: application/json" -d "{\"listener_name\": \"COPRHDLDAPSanity\"}" http://127.0.0.1:8082/ldap-service/start


fi

