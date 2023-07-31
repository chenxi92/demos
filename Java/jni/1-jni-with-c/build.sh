#/bin/bash

set -eu

export JAVA_HOME="$JAVA8_HOME"
echo "JAVA_HOME = $JAVA_HOME"

function compile_java_and_generate_c_header()
{
    javac -h . HelloJNI.java
}

function compile_c_program() {
    gcc -I"$JAVA_HOME/include" \
    -I"$JAVA_HOME/include/darwin" \
    -dynamiclib \
    -o libhello.dylib \
    HelloJNI.c
}

function run_java_program()
{
    unset JAVA_HOME
    # use the default java envrionment from Android Studio
    java HelloJNI
}

[ -f "HelloJNI.h" ] && rm -rf HelloJNI.h
echo "start to compile java and generate: HelloJNI.h"
compile_java_and_generate_c_header

[ -f "libhello.dylib" ] && rm -rf libhello.dylib
echo "start to compile c program and generate: libhello.dylib"
compile_c_program

echo "start to run java code"
run_java_program


