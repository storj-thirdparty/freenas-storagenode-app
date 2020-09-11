# FreeNAS Storj storagenode plugin
FreeNAS Storagenode plugin to support STORJ storagenode binary in FreeNAS Jailed environment

1. This is an iocage plugin. That means that this plugin uses the iocage commands to automatically configure and install the required packages and start the plugin in the jail 
2. This plugin is developed for FreeNAS 11.x. 
3. This includes the identity creation feature.


* User won't be able to run multiple instance of this plugin as there will be issues with the port forwarding.



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
	* **overlay/usr/local/www/storagenode** : Contains all the resources and the shell scripts required to the server the UI, and control the storagenode
	* **Install Path** : /root//usr/local/www/storagenode
 



Usage Instructions of Plugin
=============================
1. The default user of the the plugin is 'storj' with usergorup 'storj'. uid=3000, gid= 3000. This user and user goup will require to be created on your NAS using GUI.
2. The plugin ui can be access at "http://{IPADDRESS}:8443". At the first instance Wizard will appear to assist in passing necessary parameters. 
3. Once the plugin in installed the user need to mount the folder which they want to share and use to create the identity. This wll require you to stop the jail. Please ensure that the folder has required read and write permissions for 'storj' user. It is not advisable to use a path inside the jail to  create identity as it will get destroyed if the plugin is removed.
3. Please provide the absolute path with respect to the jail mount points to the fiels and this will require stopping the jail..
4. You may copy the identity to the shared folder or create one if you have the authorization code from Storj. 
5. Identity can created on other machine as NAS may take time. Folllow the instruction on the link https://documentation.storj.io/dependencies/identity
6. Copy the whole identity folder in the folde mentioned in the step 1.
7. Set parameters by clicking the each of the Setup items.
8. Similarly please put the path of the folder being shared.
9. **Email** Provide your emai id. This parameter is optional
10. **Storage** : The value be more than 500 GB  (Dont fill the unit)
11. **Ethereum Wallet Address**: Please put the correct address and verify as the error will only be known after you press the start storagenode button.
12. Press " **Start My Storagenode** " Button to start the storagenode.
13. The area below the buttons will show the messages and error logs. If they dont appear just press the **"Config"** link on the menu side bar.




Troubleshooting
=================

	*	You can use console of the iocage jail to troubleshoot the installation.
	*	Type " iocage console <Name of the Jail>". The default name is Storjstoragenode
	*	Type " cat /var/log/STORJ" to see the log.
	*	The path of the storagenode binary at the path /usr/loca/www/storagenode/scripts
	*	The identity binary is at /tmp.
	



Reference: https//www.ixsystems.com/documentation/freenas/11.2/plugins.html 
