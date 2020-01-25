<?php include 'header.php';?>
  <div>
    <nav class="navbar">
      <a class="navbar-brand" href="index.php"><img src="./resources/img/logo.svg" /></a>
    </nav>
    <div class="row">
      <?php include 'menu.php'; ?>
      <div class="col-10">
        <div class="container-fluid dashboard-view">
	<?php
		$platformBase	= '/usr/local/www/' ;
		$moduleBase	= $platformBase . 'storagenode/';
		$checkRunning	= $moduleBase . 'scripts/checkStorj.sh' ;

              $output = shell_exec("/usr/local/bin/bash $checkRunning");
              $err = shell_exec("/usr/local/bin/bash $checkRunning 2>&1 ");
	      if (!trim($output) == "") { 
		      echo "<H2> Storj Status </H2> " ;
		      echo " $output <br> " ;
			#$port = "" ;
			$port = ":14002" ;
			$httphost = $_SERVER['HTTP_HOST'];
			$httphost = preg_replace('/(\:[0-9]+)/', '', $httphost) ;
			$url =  "http://${httphost}${port}";
			$escaped_url = htmlspecialchars( $url, ENT_QUOTES, 'UTF-8' );
			$_finalUrl = $escaped_url ;
	?>
		      <a href="<?php echo $_finalUrl;?>" target="_blank">Storj Storage Node Stats </a>
       <?php 
	      }  else {
	?>
		<frame width="40%" height="20%">  <H2> STORJ Status is: </H2> <?php echo $err ;?> </frame>
	<?php
	      }
	?>

        <div>
      </div>
    </div>
  </div>

<?php include 'footer.php';?>
