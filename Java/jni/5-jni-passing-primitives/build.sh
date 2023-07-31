#/bin/bash

set -eu

export JAVA_HOME="$JAVA8_HOME"
echo "JAVA_HOME = $JAVA_HOME"

function compile_java_and_generate_c_header()
{
    javac -h . TestJNIPrimitive.java
}

function compile_c_program() {
    g++ -I"$JAVA_HOME/include" \
    -I"$JAVA_HOME/include/darwin" \
    -dynamiclib \
    -o libhello.dylib \
    TestJNIPrimitive.c
}

function run_java_program()
{
    unset JAVA_HOME
    # use the default java envrionment from Android Studio
    java -Djava.library.path=. TestJNIPrimitive
}


[ -f "TestJNIPrimitive.h" ] && rm -rf TestJNIPrimitive.h
[ -f "TestJNIPrimitive.class" ] && rm -rf TestJNIPrimitive.class
echo "start to compile java and generate: TestJNIPrimitive.h"
compile_java_and_generate_c_header

[ -f "libhello.dylib" ] && rm -rf libhello.dylib
echo "start to compile c program and generate: libhello.dylib"
compile_c_program

echo "start to run java code"
run_java_program



