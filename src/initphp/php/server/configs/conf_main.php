<?php

declare(strict_types=1);

namespace initphp\server\configs;

use function initphp\server\path\get_build_config;
use function Safe\file_get_contents;
use function Safe\preg_match;

function is_production_build(): bool
{
    $file = file_get_contents(get_build_config());
    if (!$file) {
        return false;
    }
    return preg_match('/(production\s*:)\s*false\s*,/', $file) === 0;
}
