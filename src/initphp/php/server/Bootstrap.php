<?php

declare(strict_types=1);

namespace initphp\server;

use Twig\Environment;
use Twig\Loader\FilesystemLoader;

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
        echo $this->twig->render('index.html', ['bootstrap_out' => 'hello world!']);
    }
}
