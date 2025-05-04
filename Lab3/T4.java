/**
 * Thread T4 - Responsible for:
 * 1. Input MR and d
 * 2. Calculate local min/max and update global values
 * 3. Calculate portion of the result matrix MA
 */
public class T4 extends Thread {
    private final SynchronizedMonitor syncMonitor;
    private final SharedMonitor sharedMonitor;

    public T4(SynchronizedMonitor syncMonitor, SharedMonitor sharedMonitor) {
        super("T4");
        setName("T4");
        this.syncMonitor = syncMonitor;
        this.sharedMonitor = sharedMonitor;
        System.out.println("Created thread " + getName());
    }

    @Override
    public void run() {
        try {
            System.out.println("T4: Starting execution");

            // Step 1: Input MR and d
            System.out.println("T4: Inputting MR and d");
            Data.MR = Data.fillMatrix(Data.N, Data.N, 1);
            int d = 2; // Example value for scalar d
            sharedMonitor.set_d(d);

            // Step 2: Signal to T1, T2, T3 about input of MR and d
            System.out.println("T4: Signaling completion of data input");
            syncMonitor.signal_In();//                             – S1-1,S2-1,S3-1

            // Step 3: Wait for data input in T1, T2
            System.out.println("T4: Waiting for other threads to complete data input");
            syncMonitor.wait_In();//                               – W1-1,W2-1

            // Step 4: Calculate a4 = min(ZH)
            System.out.println("T4: Calculating local minimum");
            int localMin = Data.findMin(Data.Z, 3 * Data.H, 4 * Data.H);

            // Step 5: Update global minimum
            System.out.println("T4: Updating global minimum (critical section)");
            sharedMonitor.update_min(localMin);  //                 - KD1

            // Step 6: Signal to T1, T2, T3 about completion of calculating min
            System.out.println("T4: Signaling completion of minimum calculation");
            syncMonitor.signal_Min();//                              – S1-2,S2-2,S3-2

            // Step 7: Wait for completion of min calculation in other threads
            System.out.println("T4: Waiting for other threads to complete minimum calculation");
            syncMonitor.wait_Min();//                                – W1-2,W2-2,W3-2

            // Step 8: Calculate b4 = max(ZH)
            System.out.println("T4: Calculating local maximum");
            int localMax = Data.findMax(Data.Z, 3 * Data.H, 4 * Data.H);

            // Step 9: Update global maximum
            System.out.println("T4: Updating global maximum (critical section)");
            sharedMonitor.update_max(localMax);  //                  - KD2

            // Step 10: Signal to T1, T2, T3 about completion of calculating max
            System.out.println("T4: Signaling completion of maximum calculation");
            syncMonitor.signal_Max();//                             – S1-3,S2-3,S3-3

            // Step 11: Wait for completion of max calculation in other threads
            System.out.println("T4: Waiting for other threads to complete maximum calculation");
            syncMonitor.wait_Max();//                               – W1-3,W2-3,W3-3

            // Step 12: Copy shared value
            int minValue = sharedMonitor.get_min();  //             - KD3
            
            // Step 13: Copy shared value
            int maxValue = sharedMonitor.get_max();  //             - KD4
            
            // Step 14: Copy shared value
            int dValue = sharedMonitor.get_d();      //             - KD5

            // Step 15: Calculate portion of MA
            System.out.println("T4: Calculating portion of result matrix");
            int[][] MRMC = Data.multiplyMatrices(Data.MR, Data.MC, 3 * Data.H, 4 * Data.H);
            Data.calculatePartialMA(minValue, maxValue, dValue, MRMC, 3 * Data.H, 4 * Data.H);

            // Step 16: Signal to T3 about completion of calculating MA portion
            System.out.println("T4: Signaling completion of final calculation");
            syncMonitor.signal_Out();//                              – S3-4

            System.out.println("T4: Execution completed");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
