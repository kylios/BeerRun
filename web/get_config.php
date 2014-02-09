<?php

include '../server/init.php';

header('Response-Type: application/json');
header('Access-Control-Allow-Origin: *');
print(json_encode(Config::get()));
