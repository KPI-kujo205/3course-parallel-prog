package Lab1;

import java.util.Arrays;
import java.util.Random;
import java.util.Scanner;


public class Lab1 {
    public static void main(String[] args) {
        System.out.println("Starting parallel computation...");
        
        long startTime = System.currentTimeMillis();
        
        T1 t1 = new T1(1);
        T2 t2 = new T2(6);
        T3 t3 = new T3(10);
        
        t1.start();
        t2.start();
        t3.start();
        
        try {
            t1.join();
            t2.join();
            t3.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        
        long endTime = System.currentTimeMillis();
        long totalExecutionTime = endTime - startTime;
        
        System.out.println("\n--- Performance Results ---");
        System.out.println("Total execution time: " + totalExecutionTime + " ms");
        System.out.println("All computations completed successfully.");
    }
}
