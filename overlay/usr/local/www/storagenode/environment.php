<?php
	# ------------------------------------------------------------------------
	#  Set environment variables
	# ------------------------------------------------------------------------
	$cfgfilename = "config.json";
    $logfilename = "log.json";

	$platformBase   = filter_input(INPUT_SERVER, 'DOCUMENT_ROOT');
	$moduleBase     = $platformBase . dirname($_SERVER['PHP_SELF']) ;
	$scriptsBase    = $moduleBase . '/scripts' ;


	$file           = $moduleBase  . DIRECTORY_SEPARATOR . $cfgfilename  ;
    $logfile        = $moduleBase  . DIRECTORY_SEPARATOR . $logfilename  ;
	$startScript    = $scriptsBase . DIRECTORY_SEPARATOR . 'storagenodestart.sh' ;
	$stopScript     = $scriptsBase . DIRECTORY_SEPARATOR . 'storagenodestop.sh' ;
	$updateScript	= $scriptsBase . DIRECTORY_SEPARATOR . 'storagenodeupdate.sh' ;
	$checkScript    = $scriptsBase . DIRECTORY_SEPARATOR . 'checkStorj.sh' ;
	$isRunning      = $scriptsBase . DIRECTORY_SEPARATOR . 'isRunning.sh' ;
	$storageBinary  = $scriptsBase . DIRECTORY_SEPARATOR . 'storagenode' ;
	$identityFile   = $moduleBase  . DIRECTORY_SEPARATOR . 'identity.pid' ;

?>