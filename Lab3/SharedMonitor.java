/**
 * SharedMonitor - for mutual exclusion with shared resources
 * Used to safely read and update shared variables between threads
 */
public class SharedMonitor {
    // Shared resources
    private int minZ = Integer.MAX_VALUE; // Global minimum of Z
    private int maxZ = Integer.MIN_VALUE; // Global maximum of Z
    private int d; // Scalar value

    /**
     * Update the global minimum value of Z
     * Critical section 1 (KD1)
     */
    public synchronized void update_min(int localMin) {
        if (localMin < minZ) {
            minZ = localMin;
        }
    }

    /**
     * Update the global maximum value of Z
     * Critical section 2 (KD2)
     */
    public synchronized void update_max(int localMax) {
        if (localMax > maxZ) {
            maxZ = localMax;
        }
    }

    /**
     * Set the scalar value d
     */
    public synchronized void set_d(int value) {
        this.d = value;
    }

    /**
     * Get the global minimum value (used by all threads)
     * Critical section 3 (KD3)
     */
    public synchronized int get_min() {
        return minZ;
    }

    /**
     * Get the global maximum value (used by all threads)
     * Critical section 4 (KD4)
     */
    public synchronized int get_max() {
        return maxZ;
    }

    /**
     * Get the scalar value d (used by all threads)
     * Critical section 5 (KD5)
     */
    public synchronized int get_d() {
        return d;
    }
}