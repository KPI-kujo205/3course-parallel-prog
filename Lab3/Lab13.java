/**
 * Software of High-Performance Computer Systems
 * Laboratory Work LR3.2
 * Java Language. Monitors
 * Variant 13
 * Task:
 *   MA = min(Z) * MX + max(Z) * (MR * MC) * d
 *   where:
 *     ‘*’ denotes scalar (dot) product,
 *     MA, MX, MR, MC – matrices,
 *     Z – vector,
 *     d – scalar.
 *
 * Data initialization is distributed across processors as follows:
 *   Processor 1: Inputs matrix MC and vector Z
 *   Processor 2: Inputs matrix MX
 *   Processor 3: Outputs the resulting matrix MA
 *   Processor 4: Inputs matrix MR and scalar d
 *
 * Kuts Ivan Vasylovych
 * Group IM-22
 */

/**
 * Main class for parallel computation
 * Formula: MA = min(Z)*MX + max(Z)*(MR*MC)*d
 */
public class Lab13 {
    public static void main(String[] args) {
        System.out.println("Starting parallel computation for MA = min(Z)*MX + max(Z)*(MR*MC)*d");

        // Create monitor objects for synchronization and shared resources
        SynchronizedMonitor syncMonitor = new SynchronizedMonitor();
        SharedMonitor sharedMonitor = new SharedMonitor();

        // Create threads
        T1 t1 = new T1(syncMonitor, sharedMonitor);
        T2 t2 = new T2(syncMonitor, sharedMonitor);
        T3 t3 = new T3(syncMonitor, sharedMonitor);
        T4 t4 = new T4(syncMonitor, sharedMonitor);

        // Record start time
        long startTime = System.currentTimeMillis();

        // Start threads
        t1.start();
        t2.start();
        t3.start();
        t4.start();

        try {
            // Wait for all threads to complete
            t1.join();
            t2.join();
            t3.join();
            t4.join();
            System.out.println("\nAll threads completed");
        } catch (InterruptedException e) {
            System.out.println("Thread interrupted: " + e.getMessage());
        }

        // Display execution time
        System.out.println("Main thread execution took " + (System.currentTimeMillis() - startTime) + " ms");
    }
}
