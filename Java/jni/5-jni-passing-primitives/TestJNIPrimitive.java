
public class TestJNIPrimitive {
    static {
        System.loadLibrary("hello");
    }

    private native double average(int n1, int n2, int n3);

    private native String sayHello(String msg);

    private native double[] sumAverage(int[] numbers);

    private int number = 88;
    private String message = "Hello from Java";
    private native void modifyInstanceVariable();

    private static double staticNumber = 55.66;
    private native void modifyStaticVariable();


    // Declare a native method that calls back the Java methods below
    private native void nativeMethod();
    private void callback() {
        System.out.println("Callback in Java");
    }
    private void callback(String message) {
        System.out.println("Callback in Java with: " + message);
    }
    private double callbackAverage(int n1, int n2) {
        return ((double)n1 + n2) / 2.0;
    }
    private static String callbackStatic() {
        return "From Static Java callback";
    }

    public static void main(String[] args) {
        System.out.println("\n--- test double");
        System.out.println("In Java, the average is: " + new TestJNIPrimitive().average(3, 2, 1));
        
        System.out.println("\n--- test string");

        String result = new TestJNIPrimitive().sayHello("Hello from Java");
        System.out.println("In Java, the result string is: " + result);

        System.out.println("\n--- test array");

        int[] numbers = { 22, 33, 44 };
        double[] sumAverage = new TestJNIPrimitive().sumAverage(numbers);
        System.out.println("In Java, the sum is: " + sumAverage[0]);
        System.out.println("In Java, the average is: " + sumAverage[1]);

        System.out.println("\n--- test modify variable");
        TestJNIPrimitive test = new TestJNIPrimitive();
        test.modifyInstanceVariable();
        System.out.println("In Java, int is: " + test.number);
        System.out.println("In Java, String is: " + test.message);

        System.out.println("\n--- test modify static variable");
        test.modifyStaticVariable();
        System.out.println("In Java, the double is " + staticNumber);

        System.out.println("\n--- test callback");
        test.nativeMethod();
    }
}