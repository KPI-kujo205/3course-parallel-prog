package Lab2;

import java.util.concurrent.CyclicBarrier;
import java.util.concurrent.Semaphore;
import java.util.concurrent.atomic.AtomicInteger;

public class Data {
    public static int[] B = new int[Lab2.N];
    public static int[] C = new int[Lab2.N];
    public static int[] D = new int[Lab2.N];
    public static int[] E = new int[Lab2.N];
    public static int[] S = new int[Lab2.N];
    public static int[] Z = new int[Lab2.N];
    public static int[][] ME = new int[Lab2.N][Lab2.N];
    public static int[][] MM = new int[Lab2.N][Lab2.N];
    
    // Shared scalar values
    public static int x;
    public static AtomicInteger e = new AtomicInteger(0);
    
    // Synchronization primitives
    public static final Object CS2 = new Object(); // Critical section for x
    
    // Semaphores for synchronization
    public static Semaphore Sem1_2 = new Semaphore(0); // T1 -> T2,T3,T4 (S2.2, S3.2, S4.2)
    public static Semaphore Sem2_2 = new Semaphore(0); // T2 -> T1 (S1.2)
    public static Semaphore Sem3_2 = new Semaphore(0); // T3 -> T1 (S1.2)
    public static Semaphore Sem4_2 = new Semaphore(0); // T4 -> T3 (S3.2)
    
    public static Semaphore eSem = new Semaphore(1); // Semaphore for protecting e access
    
    public static CyclicBarrier B1 = new CyclicBarrier(4);
    public static CyclicBarrier B2 = new CyclicBarrier(4);
    
    // Helper methods for computations
    public static int computePartialDotProduct(int[] vec1, int[] vec2, int startIdx, int chunkSize) {
        int result = 0;
        final int endIdx = startIdx + chunkSize;
        
        for (int i = startIdx; i < endIdx; i++) {
            result += vec1[i] * vec2[i];
        }
        
        return result;
    }
    
    public static int[][] multiplyMatricesBlock(int[][] matrixA, int[][] matrixB, int startCol, int blockSize) {
        int rows = matrixA.length;
        int cols = matrixB[0].length;
        int[][] result = new int[rows][cols];
        
        for (int i = 0; i < rows; i++) {
            for (int k = 0; k < matrixA[0].length; k++) {
                if (matrixA[i][k] == 0) continue;
                for (int j = startCol; j < startCol + blockSize; j++) {
                    result[i][j] += matrixA[i][k] * matrixB[k][j];
                }
            }
        }
        return result;
    }
    
    public static void multiplyVectorByMatrixPartial(int[] vector, int[][] matrix, int startCol, int colCount, int[] result) {
        final int n = vector.length;
        
        for (int j = startCol; j < startCol + colCount; j++) {
            int sum = 0;
            for (int i = 0; i < n; i++) {
                sum += vector[i] * matrix[i][j];
            }
            result[j] = sum;
        }
    }
    
    public static void mergeSortedParts(int[] array, int start1, int end1, int end2) {
        int[] temp = new int[end2 - start1];
        int i = start1, j = end1, k = 0;
        
        while (i < end1 && j < end2) {
            if (array[i] <= array[j]) {
                temp[k++] = array[i++];
            } else {
                temp[k++] = array[j++];
            }
        }
        
        while (i < end1) temp[k++] = array[i++];
        while (j < end2) temp[k++] = array[j++];
        
        System.arraycopy(temp, 0, array, start1, temp.length);
    }
    
    public static void computePartialScalarVectorProduct(int scalar, int[] vector, int startIdx, int size, int[] result) {
        final int endIdx = startIdx + size;
        for (int i = startIdx; i < endIdx; i++) {
            result[i] = vector[i] * scalar;
        }
    }
    
    public static void addVectorsPartial(int[] vec1, int[] vec2, int startIdx, int size, int[] result) {
        final int endIdx = startIdx + size;
        for (int i = startIdx; i < endIdx; i++) {
            result[i] = vec1[i] + vec2[i];
        }
    }
    
    public static void printResVectorZ(int[] vector) {
        System.out.print("Vector Z: ");
        for (int value : vector) {
            System.out.print(value + " ");
        }
        System.out.println();
    }
} 