<?php

include '../server/init.php';

?>

<html>
<head>
	<title>Test the Loader</title>
</head>
<body>
	<script type="application/dart" src="/test_loader.dart.js"></script>
	<script src="/packages/browser/dart.js"></script>
  	<div id="config"><?=$config->asJsonString();?></div>

</body>
</html>