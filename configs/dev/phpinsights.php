<?php

declare(strict_types=1);

use SlevomatCodingStandard\Sniffs\Namespaces\UseSpacingSniff;
use SlevomatCodingStandard\Sniffs\ControlStructures\DisallowShortTernaryOperatorSniff;
use SlevomatCodingStandard\Sniffs\ControlStructures\AssignmentInConditionSniff;
use PHP_CodeSniffer\Standards\Generic\Sniffs\Formatting\SpaceAfterNotSniff;
use PHP_CodeSniffer\Standards\Generic\Sniffs\Files\LineLengthSniff;
use NunoMaduro\PhpInsights\Domain\Sniffs\ForbiddenSetterSniff;
use NunoMaduro\PhpInsights\Domain\Insights\ForbiddenDefineFunctions;

echo 'definition';
return [
    'preset' => 'default',
    'exclude' => [
        "vendor"
    ],
    'remove' => [
        SpaceAfterNotSniff::class,
        ForbiddenSetterSniff::class,
        AssignmentInConditionSniff::class,
        DisallowShortTernaryOperatorSniff::class,
        ForbiddenDefineFunctions::class,
    ],
    'config' => [
        LineLengthSniff::class => [
            'lineLimit' => 90,
            'absoluteLineLimit' => 100,
        ],
        UseSpacingSniff::class => [
            'linesCountBeforeFirstUse' => 1,
            'linesCountBetweenUseTypes' => 1,
            'linesCountAfterLastUse' => 1,
        ],
    ],
];
