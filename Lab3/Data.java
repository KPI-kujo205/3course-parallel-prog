import java.util.Arrays;

/**
 * Data class containing matrices, vectors, and computation methods
 */
public class Data {
    // Constants
    static final int N = 16; // Size of the matrices and vectors
    static final int P = 4;    // Number of processors
    static final int H = N / P; // Block size for each processor

    // Matrices and vectors (shared data)
    static int[][] MA = new int[N][N]; // Result matrix
    static int[][] MX = new int[N][N]; // Input matrix
    static int[][] MR = new int[N][N]; // Input matrix
    static int[][] MC = new int[N][N]; // Input matrix
    static int[] Z = new int[N];       // Input vector

    /**
     * Fill a vector with a specific value
     */
    public static int[] fillVector(int m, int value) {
        int[] data = new int[m];
        Arrays.fill(data, value);
        return data;
    }

    /**
     * Fill a matrix with a specific value
     */
    public static int[][] fillMatrix(int m, int n, int value) {
        int[][] data = new int[m][n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                data[i][j] = value;
            }
        }
        return data;
    }

    /**
     * Find the minimum value in a portion of an array
     */
    public static int findMin(int[] array, int start, int end) {
        int min = Integer.MAX_VALUE;
        for (int i = start; i < end; i++) {
            if (array[i] < min) {
                min = array[i];
            }
        }
        return min;
    }

    /**
     * Find the maximum value in a portion of an array
     */
    public static int findMax(int[] array, int start, int end) {
        int max = Integer.MIN_VALUE;
        for (int i = start; i < end; i++) {
            if (array[i] > max) {
                max = array[i];
            }
        }
        return max;
    }

    /**
     * Multiply matrix MR and a portion of matrix MC
     * Returns the result for the portion of the matrix
     */
    public static int[][] multiplyMatrices(int[][] MR, int[][] MC, int startRow, int endRow) {
        int[][] result = new int[endRow - startRow][N];
        
        for (int i = 0; i < endRow - startRow; i++) {
            for (int j = 0; j < N; j++) {
                result[i][j] = 0;
                for (int k = 0; k < N; k++) {
                    result[i][j] += MR[i + startRow][k] * MC[k][j];
                }
            }
        }
        
        return result;
    }

    /**
     * Calculate partial MA for a block: a*MX + b*(MR*MC)*d
     */
    public static void calculatePartialMA(int minValue, int maxValue, int d, int[][] MRMC, int start, int end) {
        for (int i = start; i < end; i++) {
            for (int j = 0; j < N; j++) {
                // First part: min(Z) * MX
                int firstPart = minValue * MX[i][j];
                
                // Second part: max(Z) * (MR*MC) * d
                int secondPart = maxValue * MRMC[i - start][j] * d;
                
                // Combine parts
                MA[i][j] = firstPart + secondPart;
            }
        }
    }
}
