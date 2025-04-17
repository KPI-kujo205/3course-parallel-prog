package Lab2;
import java.util.Arrays;

public class Lab2 {
    public static int N = 12;

    public static void main(String[] args) {
        // Validate that N is divisible by 4
        if (N % 4 != 0) {
            throw new IllegalArgumentException("N must be divisible by 4");
        }
            
        // Get program start time
        long startTime = System.currentTimeMillis();

        // Initialize threads
        T1 T1 = new T1();
        T2 T2 = new T2();
        T3 T3 = new T3();
        T4 T4 = new T4();

        // Start threads
        T1.start();
        T2.start();
        T3.start();
        T4.start();

        // Wait for threads to complete
        try {
            T1.join();
            T2.join();
            T3.join();
            T4.join();
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

        // Get program end time
        long endTime = System.currentTimeMillis();

        // Print execution time
        System.out.println("Program execution time: " + (endTime - startTime) + " milliseconds");
    }
} 