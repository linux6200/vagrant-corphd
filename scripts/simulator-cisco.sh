all_simulators=true


# Grab All Simulators and Install (SMIS already done above)
if [ "$all_simulators" = true ]; then


  # ---------------------------------
  # First Cisco Simulator
  # ---------------------------------
  if [ ! -e /vagrant/simulators/cisco_sim.zip ]; then
     wget 'https://build.coprhd.org/jenkins/userContent/simulators/cisco-sim/1.0.0.0.1453093200/cisco-simulators-1.0.0.0.1453093200.zip' -O /vagrant/simulators/cisco_sim.zip
  fi

  unzip /vagrant/simulators/cisco_sim.zip -d /simulator
  cd /simulator/cisco-sim
  # Update Config files for correct directory
  cp bashrc ~/.bashrc 
  sed -i 's/CISCO_SIM_HOME=\/cisco-sim/CISCO_SIM_HOME=\/simulator\/cisco-sim/' ~/.bashrc
  sed -i 's/chmod -R 777 \/cisco-sim/chmod -R 777 \/simulator\/cisco-sim/' ~/.bashrc
  source ~/.bashrc
  sed -i "s#args=('\/cisco-sim\/#args=('\/simulator\/cisco-sim\/#" /simulator/cisco-sim/config/logging.conf 
  # Update sshd_config to allow root login - that's how Cisco Sim works
  sed -i "s/PermitRootLogin no/PermitRootLogin yes/" /etc/ssh/sshd_config
  service sshd restart


fi

