# FreeNAS Storj storagenode plugin
FreeNAS Storagenode plugin to support STORJ storagenode binary in FreeNAS Jailed environment

1. This is an iocage plugin. That means that this plugin uses the iocage commands to automatically configure and install the required packages and start the plugin in the jail 
2. This plugin is developed for FreeNAS 11.x. 
3. This Feature Branch Integrate RClone


* You wont be able to run multiple instance of this plugin as there may be issues with the port forwarding



Installation Steps
=================================================
*	 An official or community Iocage plugin appears in the plugin list and cant be searched from there catalog and installed.  
  	
	*  This plugin uses VNET interface
	 	*  This also uses NATS
	 	*  Use of IPv6 is optional
		*  NATS is enabled and port forwarding is configured for two ports of the Jail Port: 80 & 14002 
		*  Port 80 of JAIL has been forwarded to 8443 of NAS. If this is used by any other plugin then this port number can be changed in the JSON file to make is compatible.
		*  Port 14002 of jail has been forwarded to port 14002 of the NAS. This is for the storagenode dashboard.
		

*  Manual Install
	* Open the console on you FreeNAS system using a suitable roor authority
	  	* Run  "curl -o /tmp/Storjstoragenode.json https://raw.githubusercontent.com/utropicmedia/storj-freenas/master/Storjstoragenode.json"
	    * Run "iocage fetch -P /tmp/Storjstoragenode.json"
		* The above command will pull suitable version of FreeBSD as specified in Storjstoragenode.json
		* This will also install the required packages after creating the Jail
		* After that it will pull the artifacts for the plugin from https://github.com/utropicmedia/storj-freenas
	
*	Package  installed in the Jail (This is also a part of the Storjstoragenode.json

	* shells/bash
    * devel/git
    * www/nginx
    * lang/php72
    * ftp/php72-curl
    * security/php72-filter
    * devel/php72-json
    * www/php72-session
    * archivers/php72-zip
	* Fetch Package list json file
	

* Structure of the code base
	* **Storjstoragenode.json** :  This contains the plugin description and this shall be submitted to FreeNAS team which will host at their repo then it will appear in the official plugin list as well as in the NAS itself.
	* **ui.json** : This contains the path of the UI for a particcular plugin
	* **post_install.sh** :  This defines all the actions after the installation like download of the storagenode binary, managing file permissions
	* **overlay/usr/local/etc**: Contains files for the configuraion of the ngnix webserver and php
	* **overlay/usr/local/www/storagenode** : Contains all resources and the shell scripts required to the server the UI, and control the storagenode
	* **Install Path** : /root//usr/local/www/storagenode
 



Usage Instructions of Plugin
=============================
1. Please copy the identity file in the **/mnt/pool1/iocage/jails/{NAME OF STORAGENODE JAIL}/root/root/storj_base** your NAS.
2. Identity should be created on other machine as it make take time on NAS. Folllow the instruction on the link https://documentation.storj.io/dependencies/identity
3. Copy the whole identity folder in the folde mentioned in the step 1.
4. Set parameters by clicking the each of the Setup items
5. Put the path of the identity as copied in step 1 as **"/root/storj_base/identity/storagenode/ "**. Please remember that this is the absolute path with reference to the jail of the plugin. Optionally you can create the identity at a given path by providing authorization token
6. Similarly please put the path of the folder being shared 
7. **Email** Provide your emai id. This parameter is options
8. **Storage** : The vlaue be more than 500 GB  (Dont fill the unit)
9. **Ethereum Wallet Address**: Please put the correct address and verify as the error will only be known after you press the start storagenode button.
10. Press " **Start My Storagenode** " Button
11. The area below the buttons will show the messages and error logs. If they dont apear just press the **"Config"** link on the menu side bar.




Troubleshooting
=================

	*	You can use console of the iocage jail to torubleshoot the installation.
	*	Type " iocage console <Name of the Jail>"
	*	Type " cat /var/log/Storj" to see the log
	



Reference: https//www.ixsystems.com/documentation/freenas/11.2/plugins.html 
