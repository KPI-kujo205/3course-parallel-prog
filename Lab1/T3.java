package Lab1;

import java.util.Arrays;
import java.util.Scanner;
import Lab1.Data;

/** 
 * Calculates
 * s = MIN(MO*MP+MS)
*/
class T3 extends Thread {
    
    /**
    * Constructor to set thread name and priority
    * @param priority Thread priority (1-10)
    */
    public T3(int priority) {
        super("Thread-F3"); // Set thread name
        setPriority(priority); // Set thread priority
    }
    
    public void run() {
        long startTime = System.currentTimeMillis();
        Scanner scanner = new Scanner(System.in);
        
        int[][] MO;
        int[][] MP;
        int[][] MS;
        
        if (Data.isRandomInput) {
            // Random initialization for larger matrices
            System.out.println("Initializing T3 matrices with random values...");
            MO = Data.randomMatrix("Tread 3, MO");
            MP = Data.randomMatrix("Tread 3, MP");
            MS = Data.randomMatrix("Tread 3, MS");
        } else {
            // Manual input for small matrices
            MO = Data.inputMatrix("Tread 3, MO", scanner);
            MP = Data.inputMatrix("Tread 3, MP", scanner);
            MS = Data.inputMatrix("Tread 3, MS", scanner);
        }
        
        
        int[][] temp = Data.multiplyMatrices(MO, MP);
        int[][] result = new int[Data.N][Data.N];
        
        for(int i = 0; i < Data.N; i++) {
            for(int j = 0; j < Data.N; j++) {
                result[i][j] = temp[i][j] + MS[i][j];
            }
        }
        
        // Find minimum value in the result matrix
        int s = result[0][0];
        for(int i = 0; i < Data.N; i++) {
            for(int j = 0; j < Data.N; j++) {
                if(result[i][j] < s) {
                    s = result[i][j];
                }
            }
        }
        
        System.out.println("\nT3 Result " + s);
    }
}