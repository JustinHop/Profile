#!/usr/bin/env php
<?
/*
 * Give a php file as the first arg. Then pass vars like foo=bar like.
 * get.php phpfile.php FOO=bar
 *
 * will get you running phpfile.php with $_GET['foo'] = bar
 *
 */

$file = $argv[1];

if (file_exists($file){

    for($i=2;$i<$argc;$i++) {
        $things = split("=",$argv[$i]);
        $_GET[$things[0]] = $things[1];
        echo "$things[0] = $things[1]\n";
    }

    include($file);
}else{
    echo "$file does not exist\n";
    exit 1;
}
?>
