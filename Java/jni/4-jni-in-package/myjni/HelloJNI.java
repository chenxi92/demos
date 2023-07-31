package myjni;

public class HelloJNI {
    static {
        System.loadLibrary("hello"); // libhello.so
    }

    private native void sayHello();

    public static void main(String[] args) {
        new myjni.HelloJNI().sayHello();
    }
}