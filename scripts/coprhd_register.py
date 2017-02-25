#!/usr/bin/env python

import StringIO
import pycurl
import json

#########################
def registerStoragePortInVArray(portid,vaid):
	buf = StringIO.StringIO()
	data = '{ "varray_assignment_changes": { "add": { "varrays": [ "'+vaid+'" ] } } } )'

	print data
	url=baseurl+"vdc/storage-ports/"+portid
	c.setopt(pycurl.URL, url) 
	c.setopt(pycurl.CUSTOMREQUEST,"PUT") 
        c.setopt(pycurl.HTTPHEADER, ['Content-Type: application/json', 'Accept: application/json'])
        c.setopt(pycurl.POSTFIELDS,data)
	c.setopt(pycurl.WRITEFUNCTION, buf.write)
	c.perform()
	print buf.getvalue();

def login():
	buf = StringIO.StringIO()
	header_str = StringIO.StringIO()
	url=baseurl+"login?using-cookies=true"
	c.setopt(pycurl.URL, url) 
	c.setopt(pycurl.USERPWD, "root:ChangeMe")
	c.setopt(pycurl.CUSTOMREQUEST,"GET") 
	c.setopt(pycurl.WRITEFUNCTION, buf.write)
	c.setopt(pycurl.HEADERFUNCTION,header_str.write)
	c.setopt(pycurl.COOKIEJAR, "~/cookfile")
	c.setopt(pycurl.COOKIEFILE, "/tmp/cookfile")
	c.setopt(c.SSL_VERIFYPEER, 0)
	c.perform() 
	status = c.getinfo(c.HTTP_CODE) 
	print(status)

	print(buf.getvalue())
	print(header_str.getvalue());



def registerLDAPProvider():
        buf = StringIO.StringIO()

        data = ' { \"server_urls\": [ \"ldap://192.168.33.10\" ], \"domains\": [ \"viprsanity.com\" ], \"mode\": \"ldap\", \"name\": \"LDAP Simulator\", \"description\": \"LDAP Simulator desc\", \"disable\": \"false\", \"autoreg_coprhd_import_osprojects\": \"false\", \"manager_dn\": \"cn=manager,dc=viprsanity,dc=com\", \"manager_password\": \"secret\", \"search_base\": \"dc=viprsanity,dc=com\", \"search_filter\": \"uid=%U\", \"search_scope\": \"SUBTREE\", \"group_attribute\": \"CN\", \"max_page_size\": \"\", \"validate_certificates\": \"\" }'
        print data
        url=baseurl+"vdc/admin/authnproviders"
        c.setopt(pycurl.URL, url)
        c.setopt(pycurl.CUSTOMREQUEST,"POST")
        c.setopt(pycurl.HTTPHEADER, ['Content-Type: application/json', 'Accept: application/json'])
        c.setopt(pycurl.POSTFIELDS,data)
        c.setopt(pycurl.WRITEFUNCTION, buf.write)
        c.perform()
        ret = json.loads(buf.getvalue())
        ldapid = ret['id']

        data = " { \"group_objclass_changes\": { \"add\": [ \"groupOfNames\", \"posixGroup\", \"groupOfUniqueNames\", \"organizationalRole\" ] }, \"group_memberattr_changes\": { \"add\": [ \"memberUid\", \"member\", \"roleOccupant\", \"uniqueMember\" ] } } "
        print ldapid
        url=baseurl+"vdc/admin/authnproviders/" + ldapid
        c.setopt(pycurl.URL, url)
        c.setopt(pycurl.CUSTOMREQUEST,"PUT")
        c.setopt(pycurl.HTTPHEADER, ['Content-Type: application/json', 'Accept: application/json'])
        c.setopt(pycurl.POSTFIELDS,data)
        c.setopt(pycurl.WRITEFUNCTION, buf.write)
        c.perform()




def createBlockVirtualPool(name,numofpath,prov_type,varrays):
	buf = StringIO.StringIO()
	data = '{ "name": "'+name+'", "description": "'+name+' desc", "num_paths":'+numofpath+', "protocols": [ "FC" ], "provisioning_type":"'+prov_type+'", "use_matched_pools": "true", "varrays": [ '+varrays+' ] }'

	print data
	url=baseurl+"block/vpools"
	c.setopt(pycurl.URL, url) 
	c.setopt(pycurl.CUSTOMREQUEST,"POST") 
        c.setopt(pycurl.HTTPHEADER, ['Content-Type: application/json', 'Accept: application/json'])
        c.setopt(pycurl.POSTFIELDS,data)
	c.setopt(pycurl.WRITEFUNCTION, buf.write)
	c.perform()
	print buf.getvalue();
	
def getTenant():
	buf = StringIO.StringIO()
	url=baseurl+"tenant"
	c.setopt(pycurl.URL, url) 
	c.setopt(pycurl.CUSTOMREQUEST,"GET") 
        c.setopt(pycurl.HTTPHEADER, ['Content-Type: application/json', 'Accept: application/json'])
	c.setopt(pycurl.WRITEFUNCTION, buf.write)
	c.perform()
	return buf.getvalue();



##############################
##            Main Begin
##############################

baseurl="https://192.168.33.11:4443/"
buf = StringIO.StringIO()
c = pycurl.Curl() 

login()

##--------------------------------------------------------------
##------------------------- VArrays ----------------------------
##--------------------------------------------------------------
buf.truncate(0)
url=baseurl+"vdc/varrays.json"
c.setopt(pycurl.URL, url) 
c.setopt(pycurl.CUSTOMREQUEST,"GET") 
c.setopt(pycurl.WRITEFUNCTION, buf.write)
c.perform() 

varrays=buf.getvalue();
varrays_json=json.loads(buf.getvalue())

##--------------------------------------------------------------
##------------------------- Storage Ports-----------------------
##--------------------------------------------------------------
buf.truncate(0)
url=baseurl+"vdc/storage-ports.json"
c.setopt(pycurl.URL, url) 
c.setopt(pycurl.CUSTOMREQUEST,"GET") 
c.setopt(pycurl.WRITEFUNCTION, buf.write)
c.perform() 
storage_ports_json=json.loads(buf.getvalue())



varray_names=""

for va in varrays_json['varray']:
    print va['id'],va['name']
    vaid = va['id']

    if varray_names == "": 
    	varray_names='"'+vaid+'"';
    else:
 	varray_names=varray_names+',"'+vaid+'"'


    ## Register storage in VArray
    if va['name'] == 'L1A_VA_VMAX_1111' :
	print "----------- 1111 -------------"
        for port in storage_ports_json['storage_port']:
	    if port['name'].find('SYMMETRIX+999595867618') != -1: 
	         print port['id'],port['name']
		 registerStoragePortInVArray(port['id'],vaid)


    elif va['name'] == 'L1B_VA_VMAX_2222' :
	print "------------ 2222 --------------"
        for port in storage_ports_json['storage_port']:
	    if port['name'].find('SYMMETRIX+999334388821') != -1: 
	         print port['id'],port['name']
		 registerStoragePortInVArray(port['id'],vaid)
    else :
	print "------------ other ---------------";


print "\n\nCreate Virtual Pools ....\n\n"
createBlockVirtualPool('VP_VMAX_TL1_2HBA','2','Thick',varray_names);
createBlockVirtualPool('VP_VMAX_TL1_4HBA','4','Thin',varray_names);

createBlockVirtualPool('VP_VMAX_TL2_2HBA','2','Thick',varray_names);
createBlockVirtualPool('VP_VMAX_TL2_4HBA','4','Thin',varray_names);
    
createBlockVirtualPool('VP_VMAX_TL3_2HBA','2','Thick',varray_names);
createBlockVirtualPool('VP_VMAX_TL3_4HBA','4','Thin',varray_names);
    
    

## Register LDAP Provider
registerLDAPProvider();






buf.close()











