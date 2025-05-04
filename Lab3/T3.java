/**
 * Thread T3 - Responsible for:
 * 1. Calculate local min/max and update global values
 * 2. Calculate portion of the result matrix MA
 * 3. Output the final result MA
 */
public class T3 extends Thread {
    private final SynchronizedMonitor syncMonitor;
    private final SharedMonitor sharedMonitor;

    public T3(SynchronizedMonitor syncMonitor, SharedMonitor sharedMonitor) {
        super("T3");
        setName("T3");
        this.syncMonitor = syncMonitor;
        this.sharedMonitor = sharedMonitor;
        System.out.println("Created thread " + getName());
    }

    @Override
    public void run() {
        try {
            System.out.println("T3: Starting execution");

            // Step 1: Wait for data input in T1, T2, T4
            System.out.println("T3: Waiting for other threads to complete data input");
            syncMonitor.wait_In();//                                – W1-1,W2-1,W4-1

            // Step 2: Calculate a3 = min(ZH)
            System.out.println("T3: Calculating local minimum");
            int localMin = Data.findMin(Data.Z, 2 * Data.H, 3 * Data.H);

            // Step 3: Update global minimum
            System.out.println("T3: Updating global minimum (critical section)");
            sharedMonitor.update_min(localMin);  //                 - KD1

            // Step 4: Signal to T1, T2, T4 about completion of calculating min
            System.out.println("T3: Signaling completion of minimum calculation");
            syncMonitor.signal_Min();//                             – S1-2,S2-2,S4-2

            // Step 5: Wait for completion of min calculation in other threads
            System.out.println("T3: Waiting for other threads to complete minimum calculation");
            syncMonitor.wait_Min();//                               – W1-2, W2-2,W4-2

            // Step 6: Calculate b3 = max(ZH)
            System.out.println("T3: Calculating local maximum");
            int localMax = Data.findMax(Data.Z, 2 * Data.H, 3 * Data.H);

            // Step 7: Update global maximum
            System.out.println("T3: Updating global maximum (critical section)");
            sharedMonitor.update_max(localMax);  //                 - KD2

            // Step 8: Signal to T1, T2, T4 about completion of calculating max
            System.out.println("T3: Signaling completion of maximum calculation");
            syncMonitor.signal_Max();//                             – S1-3,S2-3,S4-3

            // Step 9: Wait for completion of max calculation in other threads
            System.out.println("T3: Waiting for other threads to complete maximum calculation");
            syncMonitor.wait_Max();//                               – W1-3,W2-3,W4-3

            // Step 10: Copy shared value
            int minValue = sharedMonitor.get_min();  //             - KD3
                                                     
            // Step 11: Copy shared value
            int maxValue = sharedMonitor.get_max();  //             - KD4
                                                     
            // Step 12: Copy shared value
            int dValue = sharedMonitor.get_d();      //             - KD5

            // Step 13: Calculate portion of MA
            System.out.println("T3: Calculating portion of result matrix");
            int[][] MRMC = Data.multiplyMatrices(Data.MR, Data.MC, 2 * Data.H, 3 * Data.H);
            Data.calculatePartialMA(minValue, maxValue, dValue, MRMC, 2 * Data.H, 3 * Data.H);

            // Step 14: Wait for completion of calculating MA in T1, T2, T4
            System.out.println("T3: Waiting for other threads to complete final calculations");
            syncMonitor.wait_Out();                 //               – W1-4, W2-4,W4-4

            // Step 15: Output the result MA
            System.out.println("T3: Outputting final result matrix MA");
            System.out.println("Matrix MA is calculated. Sample values:");
            for (int i = 0; i < Math.min(5, Data.N); i++) {
                for (int j = 0; j < Math.min(5, Data.N); j++) {
                    System.out.print(Data.MA[i][j] + " ");
                }
                System.out.println();
            }
            System.out.println("...");

            System.out.println("T3: Execution completed");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
