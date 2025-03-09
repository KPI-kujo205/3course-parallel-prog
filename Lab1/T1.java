package Lab1;

import java.util.Arrays;
import java.util.Scanner;
import Lab1.Data;

/** 
 * Calculates
 * d = (A * ((B + C)*(MA*ME)))
*/
class T1 extends Thread {

    /**
    * Constructor to set thread name and priority
    * @param priority Thread priority (1-10)
    */
    public T1(int priority) {
        super("Thread-F1"); // Set thread name
        setPriority(priority); // Set thread priority
    }

    public void run() {
        long startTime = System.currentTimeMillis();
        Scanner scanner = new Scanner(System.in);
        
        int[][] A;
        int[] B;
        int[] C;
        int[][] MA;
        int[][] ME;
        
        // Initialize based on N value
        if (Data.isRandomInput) {
            // Random initialization for larger matrices
            System.out.println("Initializing T1 matrices with random values...");
            A = Data.randomMatrix("Tread 1, A");
            B = Data.randomVector("Tread 1, B");
            C = Data.randomVector("Tread 1, C");
            MA = Data.randomMatrix("Tread 1, MA");
            ME = Data.randomMatrix("Tread 1, ME");
        } else {
            // Manual input for small matrices
            A = Data.inputMatrix("Tread 1, A", scanner);
            B = Data.inputVector("Tread 1, B", scanner);
            C = Data.inputVector("Tread 1, C", scanner);
            MA = Data.inputMatrix("Tread 1, MA", scanner);
            ME = Data.inputMatrix("Tread 1, ME", scanner);
        }
        
        // Calculate F1: 1.11 d = (A * ((B + C)*(MA*ME)))
        
        int[] sum = new int[Data.N];
        for(int i = 0; i < Data.N; i++)
            sum[i] = B[i] + C[i];
            
        int[][] temp = Data.multiplyMatrices(MA, ME);
        int[] temp2 = Data.multiplyMatrixVector(temp, sum);
        int[] d = Data.multiplyMatrixVector(A, temp2);
        
        Data.printVector("T1 Result", d);
    }
}