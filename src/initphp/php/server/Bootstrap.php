<?php

declare(strict_types=1);

namespace initphp\server;

use Twig\Environment;
use Twig\Loader\FilesystemLoader;

use function initphp\server\configs\is_production_build;

final class Bootstrap
{
    private readonly Environment $twig;

    // singleton
    private static ?Bootstrap $instance = null;

    private function __construct()
    {
        $loader = new FilesystemLoader('./html');
        $this->twig = new Environment($loader, ['cache' => '/tmp/twig_cache/']);
    }

    public static function getBootstrap(): self
    {
        if (is_null(self::$instance)) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function init(): void
    {
        if (is_production_build()) {
            header("Content-Security-Policy: default-src 'self'");
        }
        header('Cache-Control: max-age=86400;');
        header('Encoding: UTF-8');
        echo $this->twig->render('index.html', ['bootstrap_out' => 'hello world!']);
    }
}
