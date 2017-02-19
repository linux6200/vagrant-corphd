all_simulators=true


# Grab All Simulators and Install (SMIS already done above)
if [ "$all_simulators" = true ]; then

  # Fourth, VPLEX Simulator
  if [ ! -e /vagrant/simulators/vplex.zip ]; then
     wget 'https://build.coprhd.org/jenkins/userContent/simulators/vplex-sim/1.0.0.0.56/vplex-simulators-1.0.0.0.56-bin.zip' -O /vagrant/simulators/vplex.zip
  fi

  unzip /vagrant/simulators/vplex.zip -d /simulator
  cd /simulator/vplex-simulators-1.0.0.0.56/
  # Edit IP Address for the SMIS provider and Vplex Simulator address (both CoprHD IP in this setup)
  sed -i "s/SMIProviderIP=10.247.98.128:5989,10.247.98.128:7009/SMIProviderIP=${coprhd_ip}:5989/" vplex_config.properties
  sed -i "s/#VplexSimulatorIP=10.247.98.128/VplexSimulatorIP=${coprhd_ip}/" vplex_config.properties
  chmod +x ./run.sh
  ./run.sh &
  # Need to wait for service to be running
  sleep 2
  PID=`ps -ef | grep [v]plex_config | awk '{print $2}'`
  if [[ -z ${PID} ]]; then
     echo "Vplex_Config Simulator Not running - Fail"
     exit 1
  fi
  TIMER=1
  INTERVAL=3
  echo "Waiting for VPlex Simulator to Start..."
  while [[ "`netstat -anp | grep 4430 | grep -c ${PID}`" == 0 ]];
    do
      if [ $TIMER -gt 10 ]; then
      echo ""
      echo "VPlex Sim did not start!" >&2
      exit 1
    fi
      printf "."
      sleep $INTERVAL
      let TIMER=TIMER+$INTERVAL
    done



fi # All_Simulators

