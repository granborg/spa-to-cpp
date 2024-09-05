#!/bin/bash

web_dir=../RTCompactVue/Web
build_dir=$(pwd)
if test -d $web_dir; then
    cd $web_dir
    npm install
    npm run build
    cd $build_dir
else
    echo "COULD NOT FIND $web_dir - skipping npm build steps!"
fi

code_generator=../RTCompactVue/webserver_code_generator/binary/webserver_code_generator

if test -f $code_generator; then
    echo "Output Directory: $build_dir/main/"
    $code_generator $web_dir/dist/ $build_dir/main/ 
else
    echo "COULD NOT FIND $code_generator - SKIPPING ESP WEBSERVER GEN STEP!!!"
fi

