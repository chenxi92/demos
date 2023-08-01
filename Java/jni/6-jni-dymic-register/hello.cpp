#include <stdio.h>
#include <string>
#include <iostream>
#include <jni.h>
#include "CryptoService.h"

static const char *classPathName = "Hello";

static jint add(JNIEnv *env, jobject thisObj, jint a, jint b)
{
    int result = a + b;
    printf("In cpp: %d + %d = %d\n", a, b, result);
    return result;
}

// https://stackoverflow.com/a/41820336
std::string jstring2string(JNIEnv *env, jstring jStr) {
    if (!jStr)
        return "";

    const jclass stringClass = env->GetObjectClass(jStr);
    const jmethodID getBytes = env->GetMethodID(stringClass, "getBytes", "(Ljava/lang/String;)[B");
    const jbyteArray stringJbytes = (jbyteArray) env->CallObjectMethod(jStr, getBytes, env->NewStringUTF("UTF-8"));

    size_t length = (size_t) env->GetArrayLength(stringJbytes);
    jbyte* pBytes = env->GetByteArrayElements(stringJbytes, NULL);

    std::string ret = std::string((char *)pBytes, length);
    env->ReleaseByteArrayElements(stringJbytes, pBytes, JNI_ABORT);

    env->DeleteLocalRef(stringJbytes);
    env->DeleteLocalRef(stringClass);
    return ret;
}

static jstring rc4Encrypt(JNIEnv *env, jobject thisObj, jstring message, jstring key)
{
    std::string m_message = jstring2string(env, message);
    std::string m_key = jstring2string(env, key);
    std::cout << "In cpp rc4Encrypt() received message: " + m_message << std::endl;
    std::cout << "In cpp rc4Encrypt() received key: " + m_key << std::endl;
    std::string result = CryptoService::RC4::encrypt(m_message, m_key);
    return env -> NewStringUTF(result.c_str());
}

static jstring rc4Decrypt(JNIEnv *env, jobject thisObj, jstring message, jstring key)
{
    std::string m_message = jstring2string(env, message);
    std::string m_key = jstring2string(env, key);
    std::cout << "In cpp rc4Decrypt() received message: " + m_message << std::endl;
    std::cout << "In cpp rc4Decrypt() received key: " + m_key << std::endl;
    std::string result = CryptoService::RC4::decrypt(m_message, m_key);
    return env -> NewStringUTF(result.c_str());
}

static jstring xorEncrypt(JNIEnv *env, jobject thisObj, jstring message, jstring key)
{
    std::string m_message = jstring2string(env, message);
    std::string m_key = jstring2string(env, key);
    std::cout << "In cpp xorEncrypt() received message: " + m_message << std::endl;
    std::cout << "In cpp xorEncrypt() received key: " + m_key << std::endl;
    std::string result = CryptoService::XOR::encrypt(m_message, m_key);
    return env -> NewStringUTF(result.c_str());
}

static jstring xorDecrypt(JNIEnv *env, jobject thisObj, jstring message, jstring key)
{
    std::string m_message = jstring2string(env, message);
    std::string m_key = jstring2string(env, key);
    std::cout << "In cpp xorDecrypt() received message: " + m_message << std::endl;
    std::cout << "In cpp xorDecrypt() received key: " + m_key << std::endl;
    std::string result = CryptoService::XOR::decrypt(m_message, m_key);
    return env -> NewStringUTF(result.c_str());
}

static JNINativeMethod methods[] = {
    { "add", "(II)I", (void*)add },
    { "rc4Encrypt", "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;", (void *)rc4Encrypt },
    { "rc4Decrypt", "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;", (void *)rc4Decrypt },
    { "xorEncrypt", "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;", (void *)xorEncrypt },
    { "xorDecrypt", "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;", (void *)xorDecrypt },
};

/*
* Register serval native methods for one class.
*/
static int registerNativeMethods(JNIEnv *env, const char *className, JNINativeMethod *gMethods, int numMethods)
{
    jclass cls;

    cls = env -> FindClass(className);
    if (cls == NULL) {
        printf("Native registration unable to find class '%s'\n", className);
        return JNI_FALSE;
    }
    if (env -> RegisterNatives(cls, gMethods, numMethods) < 0) {
        printf("RegisterNatives failed for '%s'\n", className);
        return JNI_FALSE;
    }
    return JNI_TRUE;
}

static int registerNatives(JNIEnv *env)
{
    if (!registerNativeMethods(env, classPathName, methods, sizeof(methods) / sizeof(methods[0]))) {
        return JNI_FALSE;
    }
    return JNI_TRUE;
}

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void* reserved) 
{
    printf("In cpp, jni on load\n");

    JNIEnv *env = NULL;
    
    jint ret = vm->GetEnv((void**) &env, JNI_VERSION_1_6);
    if (ret != JNI_OK) {
        printf("ERROR: GetEnv failed\n");
        return -1;
    }
    
    if (registerNatives(env) != JNI_TRUE) {
        printf("ERROR: registerNatives failed\n");
        return -1;
    }    
    
    return JNI_VERSION_1_6;
}