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

  mv /opt/storageos/ecom /opt/storageos/ecom462
  # Enable version 4.6.2 SMI-S for Sanity Testing
  sed -i 's/^VERSION=80/#VERSION=80/' /opt/storageos/ecom462/providers/OSLSProvider.conf
  sed -i 's/^#VERSION=462/VERSION=462/' /opt/storageos/ecom462/providers/OSLSProvider.conf 
  sed -i 's/ADD_V2_SYMM=yes/ADD_V2_SYMM=no/' /opt/storageos/ecom462/providers/OSLSProvider.conf 
  cd /opt/storageos/ecom462/bin
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

