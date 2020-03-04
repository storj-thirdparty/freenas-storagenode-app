<?php

# ===========================================================================
#
# Problems Faced and Fixed (and to be handled)
# 1) r-x permissions for folder in path /root/.local/.... /identity.key were missing
# 2) for simulator execution, Base directory for Identity file should exists (/root/.local/share/storj/identity/storagenode/ )
# ===========================================================================

function get_web_page( $url ) {
    $res = array();
    $options = array( 
        CURLOPT_RETURNTRANSFER => true,     // return web page 
        CURLOPT_HEADER         => false,    // do not return headers 
        CURLOPT_FOLLOWLOCATION => true,     // follow redirects 
        CURLOPT_USERAGENT      => "spider", // who am i 
        CURLOPT_AUTOREFERER    => true,     // set referer on redirect 
        CURLOPT_CONNECTTIMEOUT => 120,      // timeout on connect 
        CURLOPT_TIMEOUT        => 120,      // timeout on response 
        CURLOPT_MAXREDIRS      => 10,       // stop after 10 redirects 
    ); 
    $ch      = curl_init( $url ); 
    curl_setopt_array( $ch, $options ); 
    $content = curl_exec( $ch ); 
    $err     = curl_errno( $ch ); 
    $errmsg  = curl_error( $ch ); 
    $header  = curl_getinfo( $ch ); 
    curl_close( $ch ); 

    $res['content'] = $content;     
    $res['url'] = $header['url'];
    return $res; 
} 


$identityFilePath = "/root/.local/share/storj/identity/storagenode/identity.key" ;

function identityExists() {
    	global $identityFilePath ;
	return file_exists($identityFilePath);
}

    date_default_timezone_set('Asia/Kolkata');
    $date = Date('Y-m-d H:i:s');
    $output = "" ;
    $configFile = "config.json";
    #$logFile = "/tmp/storjlog.json";
    $logFile = "/tmp/storj_identity.log" ;

    if (isset($_POST["createidval"])){
		logMessage("Identity php called for creation purpose!");
		logEnvironment();
		
		if(identityExists()) {
			logMessage("Identity Key File already available");
			echo "Identity Key File already available";
			return ;
		} else {
			logMessage("Identity Key doesn't exists. Going to start identity generation ");
		}


		$simulation = 1 ;

		if($simulation ) {
		    $binaryFilePath =  "/tmp/iSimulator.php" ;
		} else {
		$urlToFetch = "https://github.com/storj/storj/releases/latest/download/identity_freebsd_amd64.zip" ;
		$binaryFilePath = "/tmp/identity" ;

		# 1) Fetch the zip file
		$destination_path = "/tmp/identity_freebsd_amd64.zip";
		$result = get_web_page($urlToFetch ) ;
		$content = $result['content'];
		if( $content == NULL ) {
		    echo "Error during URL fetch ($urlToFetch)" ;
		    logMessage("Error during URL fetch ($urlToFetch)");
		    return ;
		}
		file_put_contents($destination_path, $content);
		if( file_exists($destination_path)) {
		    chmod($destination_path, 0777);
		}

		# 2) Uncompress it in /tmp/ folder
		# 3) Provide it executable permissions 

		$zip = new ZipArchive;
		$identityZipFile = '/tmp/identity_freebsd_amd64.zip';
		$identityFile = '/tmp/identity';
		$res = $zip->open($identityZipFile);
		if ($res === TRUE) {
		  $zip->extractTo('/tmp/');
		  if( ! file_exists($identityFile)) {
			logMessage("File $identityFile not in zip $identityZipFile!");
			echo "File $identityFile not in zip ! check contents!";
			return ;
		  }
		  chmod($identityFile, 0777);
		  $zip->close();
		} else {
		  echo 'error while unzip!';
		  logMessage("Error during unzip of file $identityZipFile ");
		  return ;
		}
		logMessage("Zip file $identityZipFile has been extracted -> $identityFile");

		} # Extraction of Identity generation program binary

		# 4) Get a temporary file name for LOG FILE
		#$logFile = tempnam("/tmp","storj") . ".log" ;
		$logFile = "/tmp/storj_identity.log" ;
	
		# 5) Run the binary with following arguments, and
		# 	redirect STDOUT & STDERR output to the temporary LOG FILE
		#  <BinaryFileName> create storagenode > $logFile 2>&1 
		$cmd = "$binaryFilePath create storagenode ";
		$programStartTime = Date('Y-m-d H:i:s');
		logMessage("Launching command $cmd and capturing log in $logFile ");
		#$output = shell_exec(" $cmd > $logFile 2>&1 & " );
		#$pid = exec("$cmd > $logFile 2>&1 & ", $output );
		$pid = 0 ; $refPid = &$pid ;
		exec("$cmd > $logFile 2>&1 & ", $output, $refPid );
		logMessage("Launched command (@ $programStartTime) process id = #$pid# ");

		# 6) Store in JSON format in (config.json)
		# 	-> Path of LOG FILE with id "LogFilePath"
		# 	-> Value 0  for "LastLineRead"

		$jsonString = file_get_contents($configFile);
		$data = json_decode($jsonString, true);
		$data['LogFilePath'] = $logFile;
		$data['idGenPid'] = $pid ;
		$data['idGenStartTime'] = $programStartTime ;
		$newJsonString = json_encode($data);
		file_put_contents($configFile, $newJsonString);

	        logMessage("Invoked identity generation program ($binaryFilePath) ");

    } else if (isset($_POST["status"])) {
		logMessage("Identity php called for fetching STATUS!");
		logEnvironment();

		# 7) Get Status from LOG FILE  
		#	Find Name of LOG FILE from config.json (LogFilePath)
		#	Read Last Line of LOG FILE into output variable
		#	Print / Return output variable string

	    $jsonString = file_get_contents($configFile);
	    $data = json_decode($jsonString, true);
	    $file = $data['LogFilePath'];
	    $pid =  $data['idGenPid']  ;
	    $prgStartTime = $data['idGenStartTime'] ;
	    $file = escapeshellarg($file);
	    $lastline = `tail -r -c 59 $file `;

	    if( identityExists()) {
		    logMessage("STATUS: Identity exists !");
		    echo $date . " : " . "Identity has been generated" ;
	    } else if(!file_exists("/proc/$pid")){	# Check PID completion
		    logMessage("STATUS: Identity generation program execution over" . 
				" (Possibly with ERROR/UNKNOWN)!\n$lastline");
		    echo "Identity generation STATUS($date):<BR> " .
		    		"Started at:  $prgStartTime <BR>" . $lastline ;
	    } else if($lastline == "Done"){	# EXACT Check to be figured out 
		    logMessage("STATUS: Identity generation completed ");
		    echo $date . " : " . "Identity generation completed ";
	    }else{
		    logMessage("STATUS: Identity generation in progress ");
		    echo $date . ": Identity generation in progress" . "<BR> " . $lastline ;
	    }

    } else if (isset($_POST["validateIdentity"])) {
		logMessage("Identity php called for validating IDENTITY!");
		logEnvironment();

	# POST RUN CHECK. In case IDENTITY Creation is done (status should be 100%) 
	#
	# Ensure that identity string has been set by JS for this call.
	#  Return failure in case not set
	#
	#
	# 8) Check whether following files are created in path given
	# 	(A) Path : /root/.local/share/storj/identity/storagenode
	# 	(B) Files to check
	# 		- ca.key
	# 		- ca.cert
	# 		- identity.cert
	# 		- identity.key
	# 9) Run the authorization
	# 	<IdentityBinary> authorize storagenode <email:characterstring>
	# 10) Final Checks to be done
	# 		- Check whether ca.cert and identity.cert have BEGIN pattern
	#		- count the number of BEGIN in both files
	# 11) RETURN SUCCESS if both files have >0 # of BEGIN patterns
	#
	if(!isset($_POST["identityString"]))  {
	    echo "Identity String is not set !" ;
	    exit(1);
	}
	$identityString = $_POST["identityString"] ;

    	$Path = "/root/.local/share/storj/identity/storagenode/";
	$fileList = [ 
	    "ca.key",
	    "identity.key",
	    "ca.cert",
	    "identity.cert"
	];
	$allReqdFilesAvailable = 1 ;
	foreach( $fileList as $file ) {
	    if(!file_exists($Path.$file)) {
		$allReqdFilesAvailable = 0 ;
	    }
	    # Check BEGIN pattern << Is it required here or after identitiy validation?
	    $content = file_get_contents($Path.$file);
	    if( strpos($content, "BEGIN") === false ) {
		$allReqdFilesAvailable = 0 ;
	    }
	}
	if( $allReqdFilesAvailable == 0 ) {
	    echo "One or all of required files not available!" ;
	    exit(2);
	}
	$cmd = "/tmp/identity authorize storagenode $identityString ";
	$output = shell_exec(" $cmd 2>&1 " );
	echo $output;
    }else if (isset($_POST["file_exist"])) {
    	// Checking file if exist or not.
    	if(file_exists($identityFilePath))
    	#if(file_exists("/tmp/identity_freebsd_amd64.zip"))
	{
		logMessage("File $identityFilePath already exists !");
    		echo "0";
    	}else{
		logMessage("File $identityFilePath doesn't exists !");
    		echo "1";
    	}
    } else {
	logMessage("Identity php called (PURPOSE NOT CLEAR)!");
    }
    return (0);

function logEnvironment() {
	logMessage(
	    	"" 
		#"\n----------------------------------------------\n"
		#. "ENV is : " . print_r($_ENV, true)
		. "POST is : " . print_r($_POST, true)
		#. "SERVER is : " . print_r($_SERVER, true)
		#. "----------------------------------------------\n"
	);
}

function logMessage($message) {
    $file = "/var/log/StorJ" ;
    $message = preg_replace('/\n$/', '', $message);
    $date = `date` ; $timestamp = str_replace("\n", " ", $date);
    file_put_contents($file, $timestamp . $message . "\n", FILE_APPEND);
}

?>
