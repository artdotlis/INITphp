<?php

declare(strict_types=1);

namespace initphp;

require_once 'vendor/autoload.php';

use initphp\server\Bootstrap;

$boot = Bootstrap::getBootstrap();
$boot->init();
exit(0);
