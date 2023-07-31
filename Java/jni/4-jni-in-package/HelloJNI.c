#include <jni.h>
#include <stdio.h>
#include "include/myjni_HelloJNI.h"
 
JNIEXPORT void JNICALL Java_myjni_HelloJNI_sayHello(JNIEnv *env, jobject thisObj) {
   printf("Hello World!\n");
   return;
}