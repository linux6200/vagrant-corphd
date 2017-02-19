# Login and check the Version
COPRHD_IP=https://192.168.33.11:4443
CANT_CONNECT="Unable to connect to the service. The service is unavailable"

# Uncomment when Testing - stop services and make sure we fail
# vagrant ssh coprhd -c "echo ChangeMe | sudo /etc/storageos/storageos stop"

printf "Waiting for CoprHD Services to start..."
TIMER=1
echo "Cant connect is: ${CANT_CONNECT}"
while [[ `curl --insecure -G --anyauth $COPRHD_IP/login?using-cookies=true -u 'root:ChangeMe' -c ~/cookiefile -v` =~ ${CANT_CONNECT} ]];
do
    sleep 5
    printf "."
    if [ $TIMER -gt 15 ]; then
        echo ""
        echo "CoprHD Services Did Not Start"
        echo ""
        exit 1
    fi
    let TIMER=${TIMER}+1
done

VERSION=`curl -k $COPRHD_IP/upgrade/target-version -b ~/cookiefile`
echo "VERSION is: ${VERSION}"

# -------------------------------- 
#  Add CISCO Network Provider 
# --------------------------------
curl -X POST -H "Content-Type: application/json" -d "{\"name\": \"cisco-1\", \"ip_address\": \"192.168.33.10\", \"port_number\": \"22\", \"user_name\": \"root\", \"password\": \"vagrant\", \"system_type\": \"mds\",  \"smis_use_ssl\": \"true\"}" $COPRHD_IP/vdc/network-systems -b ~/cookiefile -k

# -------------------------------- 
#  Add VNX/VMAX SMI-S Provider 
# --------------------------------
curl -X POST -H "Content-Type: application/json" -d "{ \"name\": \"VMAX Simulator Provider\", \"ip_address\": \"192.168.33.10\", \"port_number\": \"7009\", \"user_name\": \"root\", \"password\": \"vagrant\", \"use_ssl\": \"true\", \"interface_type\": \"smis\" } "  $COPRHD_IP/vdc/storage-providers -b ~/cookiefile -k
curl -X POST -H "Content-Type: application/json" -d "{ \"name\": \"VNX Simulator Provider\", \"ip_address\": \"192.168.33.10\", \"port_number\": \"5989\", \"user_name\": \"root\", \"password\": \"vagrant\", \"use_ssl\": \"true\", \"interface_type\": \"smis\" } "  $COPRHD_IP/vdc/storage-providers -b ~/cookiefile -k


# -------------------------------- 
#  Add VPLEX SMI-S Provider 
# --------------------------------
curl -X POST -H "Content-Type: application/json" -d "{ \"name\": \"VPLEX Simulator Provider\", \"ip_address\": \"192.168.33.10\", \"port_number\": \"4430\", \"user_name\": \"root\", \"password\": \"vagrant\", \"use_ssl\": \"true\", \"interface_type\": \"vplex\" } "  $COPRHD_IP/vdc/storage-providers -b ~/cookiefile -k



