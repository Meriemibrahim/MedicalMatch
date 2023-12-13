<?php

use App\Kernel;
use Symfony\Component\ErrorHandler\Debug;
use Symfony\Component\HttpFoundation\Request;

require dirname(__DIR__).'/vendor/autoload.php';

// Environment
$env = $_SERVER['APP_ENV'] ?? 'prod';
$debug = ($_SERVER['APP_DEBUG'] ?? ('prod' !== $env)) && !isset($_SERVER['SHELL']);

// Debugging
if ($debug) {
    umask(0000);
    Debug::enable();
}

// Create Symfony Kernel
$kernel = new Kernel($env, $debug);

// Request handling
$request = Request::createFromGlobals();
$response = $kernel->handle($request);
$response->send();
$kernel->terminate($request, $response);
