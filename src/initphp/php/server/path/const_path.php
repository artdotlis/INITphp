<?php

declare(strict_types=1);

namespace initphp\server\path;

/** @return array<string> */
function get_prefix(): array
{
    return ['..', '..'];
}

function get_config_root(): string
{
    return merge_path(__DIR__, [...get_prefix(), 'configs']);
}

function get_build_config(): string
{
    return merge_path(__DIR__, [...get_prefix(), 'configs', 'project.js']);
}

function get_twig_html(): string
{
    return merge_path(__DIR__, [...get_prefix(), 'twig']);
}

/** @param array<string> $path_el */
function merge_path(string $root, array $path_el): string
{
    return $root . DIRECTORY_SEPARATOR . implode(DIRECTORY_SEPARATOR, $path_el);
}
