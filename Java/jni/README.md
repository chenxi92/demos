# JNI

Learn Java JNI with [Java Native Interface](https://www3.ntu.edu.sg/home/ehchua/programming/java/JavaNativeInterface.html) tutorial.



## Environment

- macOS 12.6.3
- Java 8
- Android Studio Electric Eel | 2022.1.1 Patch 2



## Commands

### Compile a Java file

> javac -h . <java-file-name>.java

`-h` options generates C/C++ header and places it in the directory specified. (In the above, '.' represent the current directory)



### Run a class file

> java <java-class-file-name>

OR (if you need explicity sepcify a Java library path)

> java -Djava.library.path=<file-path> <java-class-file-name>



### List the method signatur

> javap -s -p <java-class-file-name>

`-s` : print signatur

`-p`: show private members



