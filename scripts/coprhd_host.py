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
	tenant_str = json.loads(buf.getvalue())
	return tenant_str['id'];


def createHost(name,hosttype):
	buf = StringIO.StringIO()
	data = ' { "type": "'+hosttype+'", "host_name": "'+name+'.lab.com", "os_version": "5.6", "name": "'+name+'", "port_number": "22", "user_name": "root", "password": "root", "use_ssl": "", "cluster": "", "vcenter_data_center": "", "project": "", "discoverable": "false", "tenant": "'+getTenant()+'", "boot_volume": "" }'

	print data
	url=baseurl+"compute/hosts"
	c.setopt(pycurl.URL, url) 
	c.setopt(pycurl.CUSTOMREQUEST,"POST") 
        c.setopt(pycurl.HTTPHEADER, ['Content-Type: application/json', 'Accept: application/json'])
        c.setopt(pycurl.POSTFIELDS,data)
	c.setopt(pycurl.WRITEFUNCTION, buf.write)
	c.perform()
	print buf.getvalue();


##############################
##            Main Begin
##############################

baseurl="https://192.168.33.11:4443/"
buf = StringIO.StringIO()
c = pycurl.Curl() 

login()

createHost('aixhost3','AIX')




buf.close()











