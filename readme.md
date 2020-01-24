Storj's storagenode plugin for FreeNAS
=======================================
Contains description of steps to setup storagenode plugin in FreeNAS Jailed environment

1) host/setup.sh provides setup steps to establish Jail 
2) It includes launch of post install shell inside Jail 

If required in case of error, steps can be run manually at a time, while checking 
for possible conflicts / errors given here:
(A) in specific configuration files: (in host)
  - /etc/rc.conf  
  - /etc/pf.conf (packet filter)
(B) In network addresses (192.168.0.* range)
(C) iocage launch issues (RELEASE,  Network address etc)


Manual Steps to be followed (refer setup.sh file)
=================================================
1) Setup network environment 
  (example setup.sh shows static IP configuration)
	(A) Update rc.sys file  for
	 -> network settings
	 -> Disabling IPv6 (if required)
	(B) Restart network (if required)
3) Packet Filter
	(A) Define Packet Filter settings in pc.conf file. It includes
	    -> NAT settings
	    -> redirect web requests from appropriate input port (8080 used here)
	(B) Enable PF service (if not already done)
	(c) Restart pf
4) StorjAdmin Jail Setup
	(A) Fetch Package list json file
	(B) Create Jail with appropriate settings
	    -> resolver
	    -> namserver
	    -> raw socket enabling
	    -> FETCHING of Package files
	(C) Fetch Repository to JAIL env
5) Launch post install script
	(A) Setup web configuration and services
	(B) Extract application to be hosted
	(C) Start services
	(D) Show user 
 

DEFAULT SETTINGS
================
1) Port for servicing on host environment : 8080


Reference: https//www.ixsystems.com/documentation/freenas/11.2/plugins.html 
