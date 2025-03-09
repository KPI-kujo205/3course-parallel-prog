package Lab1;

import java.util.Arrays;
import java.util.Scanner;
import Lab1.Data;


/** 
 * Calculates
 * MF = MG + (MH*MK) +ML
*/
class T2 extends Thread {
    
    /**
    * Constructor to set thread name and priority
    * @param priority Thread priority (1-10)
    */
    public T2(int priority) {
        super("Thread-F2"); // Set thread name
        setPriority(priority); // Set thread priority
    }
    
    public void run() {
        long startTime = System.currentTimeMillis();
        Scanner scanner = new Scanner(System.in);
        
        int[][] MG;
        int[][] MH;
        int[][] MK;
        int[][] ML;
        
        if (Data.isRandomInput) {
            // Random initialization for larger matrices
            System.out.println("Initializing T2 matrices with random values...");
            MG = Data.randomMatrix("Tread 2, MG");
            MH = Data.randomMatrix("Tread 2, MH");
            MK = Data.randomMatrix("Tread 2, MK");
            ML = Data.randomMatrix("Tread 2, ML");
        } else {
            // Manual input for small matrices
            MG = Data.inputMatrix("Tread 2, MG", scanner);
            MH = Data.inputMatrix("Tread 2, MH", scanner);
            MK = Data.inputMatrix("Tread 2, MK", scanner);
            ML = Data.inputMatrix("Tread 2, ML", scanner);
        }
        
        
        int[][] temp = Data.multiplyMatrices(MH, MK);
        int[][] MF = new int[Data.N][Data.N];
        
        for(int i = 0; i < Data.N; i++) {
            for(int j = 0; j < Data.N; j++) {
                MF[i][j] = MG[i][j] + temp[i][j] + ML[i][j];
            }
        };


        Data.printMatrix("T2 Result", MF);
    }
}