#!/usr/bin/env bash

set -e

source test/setup

use Test::More

cd tmp

(
    git init subproject
    cd subproject

    echo foo >foo
    git add foo
    git commit -m "foo"
) &> /dev/null || die

(
    git init superproject
    cd superproject

    #echo bar >bar
    #git add bar
    #git commit -m "bar"

    git subrepo clone ../subproject
    echo "foo" >> subproject/foo
    git commit -am "foo"

   # git subrepo push subproject
) &> /dev/null || die

done_testing

#teardown
