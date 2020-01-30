<style type="text/css">
    .nav-link {
	color: #0000F0 !important; 
	font-weight: bold;
	font-size: 16px;
    }
    /*log message*/
	iframe{
	  width:92%;
	  position: absolute;
	  bottom: 0px;
	  height: 300px;
	}
</style>
<div class="side-nav col-2">
  <div class="nav flex-column nav-pills" id="v-pills-tab" role="tablist" aria-orientation="vertical">
    <a class="nav-link" id="v-pills-dashboard-tab" href="dashboard.php" role="tab" aria-controls="v-pills-dashboard" aria-selected="true"><div class="nav-link-icon"></div>Dashboard</a>
    <a class="nav-link" id="v-pills-config-tab" href="config.php" role="tab" aria-controls="v-pills-config" aria-selected="true"><div class="nav-link-icon"></div>Config</a>
    <!-- log message -->
    <iframe>
    	<p  id="msg"></p>
    </iframe>
  </div>
</div>
