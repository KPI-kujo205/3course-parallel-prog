/**
 * SynchronizedMonitor - for thread synchronization
 * Used to synchronize data input and computation stages between threads
 */
public class SynchronizedMonitor {
    // Counters for synchronization
    private int dataInputCounter = 0;
    private int minCalculatedCounter = 0;
    private int maxCalculatedCounter = 0;
    private int finalCalculationCounter = 0;

    // Constants defining synchronization thresholds
    private static final int TOTAL_DATA_INPUT_THREADS = 3; // T1, T2, T4 need to input data
    private static final int TOTAL_MIN_CALCULATION_THREADS = 4;
    private static final int TOTAL_MAX_CALCULATION_THREADS = 4;
    private static final int TOTAL_FINAL_CALCULATION_SIGNALS = 3; // T1, T2, T4 signal to T3

    /**
     * Signal that a thread has completed its data input
     */
    public synchronized void signal_In() {
        dataInputCounter++;
        if (dataInputCounter == TOTAL_DATA_INPUT_THREADS) {
            notifyAll(); // Wake up all waiting threads once data input is complete
        }
    }

    /**
     * Wait until all threads have completed their input
     */
    public synchronized void wait_In() {
        if (dataInputCounter < TOTAL_DATA_INPUT_THREADS) {
            try {
                wait(); // Thread sleeps until notified
            } catch (InterruptedException ignored) {}
        }
    }

    /**
     * Signal that a thread has completed its minimum calculation
     */
    public synchronized void signal_Min() {
        minCalculatedCounter++;
        if (minCalculatedCounter == TOTAL_MIN_CALCULATION_THREADS) {
            notifyAll(); // Wake up all waiting threads once all minimums are calculated
        }
    }

    /**
     * Wait until all threads have completed their minimum calculation
     */
    public synchronized void wait_Min() {
        if (minCalculatedCounter < TOTAL_MIN_CALCULATION_THREADS) {
            try {
                wait(); // Thread sleeps until notified
            } catch (InterruptedException ignored) {}
        }
    }

    /**
     * Signal that a thread has completed its maximum calculation
     */
    public synchronized void signal_Max() {
        maxCalculatedCounter++;
        if (maxCalculatedCounter == TOTAL_MAX_CALCULATION_THREADS) {
            notifyAll(); // Wake up all waiting threads once all maximums are calculated
        }
    }

    /**
     * Wait until all threads have completed their maximum calculation
     */
    public synchronized void wait_Max() {
        if (maxCalculatedCounter < TOTAL_MAX_CALCULATION_THREADS) {
            try {
                wait(); // Thread sleeps until notified
            } catch (InterruptedException ignored) {}
        }
    }

    /**
     * Signal that a thread has completed its final calculation
     */
    public synchronized void signal_Out() {
        finalCalculationCounter++;
        if (finalCalculationCounter == TOTAL_FINAL_CALCULATION_SIGNALS) {
            notifyAll(); // Wake up T3 which is waiting for final results
        }
    }

    /**
     * Wait until other threads have completed their calculations (used by T3)
     */
    public synchronized void wait_Out() {
        if (finalCalculationCounter < TOTAL_FINAL_CALCULATION_SIGNALS) {
            try {
                wait(); // Thread sleeps until notified
            } catch (InterruptedException ignored) {}
        }
    }
} 