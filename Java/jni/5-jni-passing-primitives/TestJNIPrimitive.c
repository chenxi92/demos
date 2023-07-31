#include "TestJNIPrimitive.h"
#include <stdio.h>
 
JNIEXPORT jdouble JNICALL Java_TestJNIPrimitive_average(JNIEnv *env, jobject thisObj, jint n1, jint n2, jint n3) {
   jdouble result;
   printf("In C, the numbers are: %d, %d, %d\n", n1, n2, n3);
   result = ((jdouble)n1 + n2 + n3) / 3.0;
   // jint is mapped to int, jdouble is mapped to double
   return result;
}

JNIEXPORT jstring JNICALL Java_TestJNIPrimitive_sayHello(JNIEnv *env, jobject thisObj, jstring inJNIStr) 
{
   // Step 1: Convert the JNI String (jstring) into C-String (char*)
   const char *inCStr = env->GetStringUTFChars(inJNIStr, NULL);
   if (NULL == inCStr) return NULL;
 
   // Step 2: Perform its intended operations
   printf("In C, the received string is: %s\n", inCStr);
   env->ReleaseStringUTFChars(inJNIStr, inCStr);  // release resources
 
   // Prompt user for a C-string
   // char outCStr[128];
   // printf("Enter a String: ");
   // scanf("%s", outCStr);    // not more than 127 characters
 
   // Step 3: Convert the C-string (char*) into JNI String (jstring) and return
   return env->NewStringUTF("A Test String From C");
}

JNIEXPORT jdoubleArray JNICALL Java_TestJNIPrimitive_sumAverage(JNIEnv *env, jobject thisObj, jintArray inJNIArray) 
{
   // Setp 1: Convert the incoming JNI jintarray to C's jint[]
   jint *inCArray = env -> GetIntArrayElements(inJNIArray, NULL);
   if (NULL == inCArray) return NULL;
   jsize length = env -> GetArrayLength(inJNIArray);

   // Setp 2: perform it's intended operation
   jint sum = 0;
   int i;
   for (i = 0; i < length; i++) {
      sum += inCArray[i];
   }
   jdouble average = (jdouble)sum / length;
   env -> ReleaseIntArrayElements(inJNIArray, inCArray, 0);

   jdouble outCArray[] = { sum, average };

   // Setp 3: Convert the C's Native jdouble[] to JNI jdoublearray, and return
   jdoubleArray outJNIArray = env -> NewDoubleArray(2);
   if (NULL == outJNIArray) return NULL;
   env -> SetDoubleArrayRegion(outJNIArray, 0, 2, outCArray);
   return outJNIArray;
}

JNIEXPORT void JNICALL Java_TestJNIPrimitive_modifyInstanceVariable(JNIEnv *env, jobject thisObj)
{
   // Get a reference to this object's class
   jclass thisClass = env -> GetObjectClass(thisObj);

   // int
   // Get the Field ID of the instance variables "number"
   jfieldID fidNumber = env -> GetFieldID(thisClass, "number", "I");
   if (NULL == fidNumber) return;

   // Get the int given the Field ID
   jint number = env -> GetIntField(thisObj, fidNumber);
   printf("In C, the int is: %d\n", number);

   // Change the variable
   number = 99;
   env -> SetIntField(thisObj, fidNumber, number);

   // Get the Field ID of the instance variable "message"
   jfieldID fidMessage = env -> GetFieldID(thisClass, "message", "Ljava/lang/String;");
   if (NULL == fidMessage) return;

   // String 
   // Get the object given the Field ID
   jstring message = (jstring)env -> GetObjectField(thisObj, fidMessage);

   // Create a C-string with the JNI String
   const char *cStr = env -> GetStringUTFChars(message, NULL);
   if (NULL == cStr) return;

   printf("In C, the string is: %s\n", cStr);
   env -> ReleaseStringUTFChars(message, cStr);

   // Create a new C-String and assign to the JNI string
   message = env -> NewStringUTF("Hell from C");
   if (NULL == message) return;

   // modify the instance variables
   env -> SetObjectField(thisObj, fidMessage, message);
}

JNIEXPORT void JNICALL Java_TestJNIPrimitive_modifyStaticVariable(JNIEnv *env, jobject thisObj)
{
   // Get a reference to this object's class
   jclass thisClass = env -> GetObjectClass(thisObj);

   // int
   // Get the Field ID of the instance variables "number"
   jfieldID fidNumber = env -> GetStaticFieldID(thisClass, "staticNumber", "D");
   if (NULL == fidNumber) return;

   jdouble number = env -> GetStaticDoubleField(thisClass, fidNumber);
   printf("In C, the double is: %f\n", number);

   number = 77.88;
   env -> SetStaticDoubleField(thisClass, fidNumber, number);
}

JNIEXPORT void JNICALL Java_TestJNIPrimitive_nativeMethod(JNIEnv *env, jobject thisObj)
{
   // Get a reference to this object's class
   jclass thisClass = env -> GetObjectClass(thisObj);

   // Get the Method ID for method "callback", which takes no arg and return void
   jmethodID midCallback = env -> GetMethodID(thisClass, "callback", "()V");
   if (NULL == midCallback) return;
   printf("In C, will call back Java's callback()\n");
   env -> CallVoidMethod(thisObj, midCallback);

   jmethodID midCallbackStr = env -> GetMethodID(thisClass, "callback", "(Ljava/lang/String;)V");
   if (NULL == midCallbackStr) return;
   printf("In C, will call back Java's callback(String)\n");
   jstring message = env -> NewStringUTF("Hello from C");
   env -> CallVoidMethod(thisObj, midCallbackStr, message);

   jmethodID midCallBackAverage = env -> GetMethodID(thisClass, "callbackAverage", "(II)D");
   if (NULL == midCallBackAverage) return;
   jdouble average = env -> CallDoubleMethod(thisObj, midCallBackAverage, 2, 3);
   printf("In C, the average is: %.2f\n", average);

   jmethodID midCallbackStatic = env -> GetStaticMethodID(thisClass, "callbackStatic", "()Ljava/lang/String;");
   if (NULL == midCallbackStatic) return;
   jstring resultJNIStr = (jstring)env -> CallStaticObjectMethod(thisClass, midCallbackStatic);
   const char *resultCStr = env -> GetStringUTFChars(resultJNIStr, NULL);
   if (NULL == resultCStr) return;
   printf("In C, the returned string is: %s\n", resultCStr);
   env -> ReleaseStringUTFChars(resultJNIStr, resultCStr);
}