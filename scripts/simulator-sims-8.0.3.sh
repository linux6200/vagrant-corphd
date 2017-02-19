simulator=true
all_simulators=false

# Grab the SMIS Simulator if enabled
SIMULATOR_VERSION="smis-simulators-1.0.0.0.1455598800.zip"
if [ "$simulator" = true ] || [ "$all_simulators" = true ]; then
  # Download to /vagrant/simulators directory if needed
  if [ ! -e /vagrant/simulators/$SIMULATOR_VERSION ]; then
     wget "https://build.coprhd.org/jenkins/userContent/simulators/smis-sim/1.0.0.0.1455598800/smis-simulators-1.0.0.0.1455598800.zip" -O "/vagrant/simulators/$SIMULATOR_VERSION"
  fi
  # Install SMIS
  unzip /vagrant/simulators/$SIMULATOR_VERSION -d /opt/storageos/

  mv /opt/storageos/ecom /opt/storageos/ecom809

  # Setup the listening port
  sed -i 's/<port>598/<port>700/' /opt/storageos/ecom809/conf/Port_settings.xml
 
  cd /opt/storageos/ecom809/bin
  chmod +x  ECOM
  chmod +x  system/ECOM
  ./ECOM &
  INTERVAL=5
  COUNT=0
  echo "Checking for ECOM Service Starting...."
  while [ $COUNT -lt 4 ];
  do
    COUNT="$(netstat -anp  | grep -c ECOM)"
    printf "."
    sleep $INTERVAL
  done
fi  # SMIS_Simulator

