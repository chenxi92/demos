#/bin/bash

set -eu

export JAVA_HOME="$JAVA8_HOME"
echo "JAVA_HOME = $JAVA_HOME"

function compile_c_program() {
    g++ -I"$JAVA_HOME/include" \
    -I"$JAVA_HOME/include/darwin" \
    -dynamiclib \
    -o libhello.dylib \
    hello.cpp \
    CryptoService.cpp
}

function run_java_program()
{
    javac Hello.java

    java -Djava.library.path=. Hello
}


[ -f "libhello.dylib" ] && rm -rf libhello.dylib
echo "start to compile c program and generate: libhello.dylib"
compile_c_program

echo "start to run java code"
run_java_program



