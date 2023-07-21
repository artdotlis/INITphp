<?php

declare(strict_types=1);

namespace initphp\server;

use Twig\Environment;
use Twig\Loader\FilesystemLoader;

use function initphp\server\configs\is_production_build;
use function initphp\server\path\get_twig_html;
use function Safe\ob_end_flush;
use function Safe\ob_start;

final class Bootstrap
{
    private readonly Environment $twig;

    // singleton
    private static ?Bootstrap $instance = null;

    private function __construct()
    {
        $loader = new FilesystemLoader(get_twig_html());
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
            header(
                'Content-Security-Policy:' . implode(';', [
                    "img-src 'self' data:",
                    "font-src 'self' data:",
                    "default-src 'self';",
                ])
            );
        }
        header('Cache-Control: max-age=86400;');
        header('Content-Encoding: gzip;');
        ob_start(ob_gzhandler(...));
        echo $this->twig->render('index.html', ['bootstrap_out' => 'hello world!']);
        ob_end_flush();
    }
}
