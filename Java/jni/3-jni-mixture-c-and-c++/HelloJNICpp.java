public class HelloJNICpp {
    static {
        System.loadLibrary("hello");
    }

    private native void sayHello();

    public static void main(String[] args) {
        new HelloJNICpp().sayHello();
    }
}