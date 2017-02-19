all_simulators=true


# Grab All Simulators and Install (SMIS already done above)
if [ "$all_simulators" = true ]; then

  # ---------------------------------
  # Third, Windows Host Simulator
  # ---------------------------------
  if [ ! -e /vagrant/simulators/win_host.zip ]; then
     wget 'https://build.coprhd.org/jenkins/userContent/simulators/win-sim/1.0.0.0.1442808000/win-simulators-1.0.0.0.1442808000.zip' -O /vagrant/simulators/win_host.zip
  fi

  unzip /vagrant/simulators/win_host.zip -d /simulator
  cd /simulator/win-sim

  echo ${coprhd_ip}

  # Update Provider IP for SMIS Simulator address (running on CoprHD in this setup)
  sed -i "s/<provider ip=\"10.247.66.220\" username=\"admin\" password=\"#1Password\" port=\"5989\" type=\"VMAX\"><\/provider>/<provider ip=\"${coprhd_ip}\" username=\"admin\" password=\"#1Password\" port=\"5989\" type=\"VMAX\"><\/provider>/" /simulator/win-sim/config/simulator.xml
   echo "${coprhd_ip} winhost1 winhost2 winhost3 winhost4 winhost5 winhost6 winhost7 winhost8 winhost9 winhost10" >> /etc/hosts
  ./runWS.sh &
  sleep 5


fi # All_Simulators

