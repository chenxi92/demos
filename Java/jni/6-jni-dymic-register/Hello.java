
public class Hello {
    
    static {
        System.loadLibrary("hello");
    }

    private native int add(int a, int b);
    private native String rc4Encrypt(String message, String key);
    private native String rc4Decrypt(String message, String key);
    private native String xorEncrypt(String message, String key);
    private native String xorDecrypt(String message, String key);

    private static void testRC4() {
        System.out.println("\n\n -- test rc4");
        String message = "hello world";
        String key = "";
        String encrypted = new Hello().rc4Encrypt(message, key);
        System.out.println("In Java, received message: [" + encrypted + "]\n");
        String decrypted = new Hello().rc4Decrypt(encrypted, key);
        if (message.equals(decrypted) == true) {
            System.out.println("rc4 encrypt and decrypt success");
        }
    }

    private static void testXOR() {
        System.out.println("\n\n -- test xor");
        String message = "hello world";
        String key = "";
        String encrypted = new Hello().xorEncrypt(message, key);
        System.out.println("In Java, received message: [" + encrypted + "]\n");
        String decrypted = new Hello().xorDecrypt(encrypted, key);
        if (message.equals(decrypted) == true) {
            System.out.println("xor encrypt and decrypt success");
        }
    }

    public static void main(String[] args) {
        int result = new Hello().add(1, 2);
        System.out.println("In Java, received result = " + result);

        testRC4();

        testXOR();
    }
}