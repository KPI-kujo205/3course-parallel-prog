package Lab1;

import java.util.Arrays;
import java.util.Scanner;
import java.util.Random;

public class Data {
    public static int N = 1000; // Default size, can be changed
    public static boolean isRandomInput = true;

    static int[][] addMatrices(int[][] a, int[][] b) {
        int[][] result = new int[N][N];
        for(int i = 0; i < N; i++)
            for(int j = 0; j < N; j++)
                result[i][j] = a[i][j] + b[i][j];
        return result;
    }
    
    static int[] multiplyMatrixVector(int[][] m, int[] v) {
        int[] result = new int[N];
        for(int i = 0; i < N; i++)
            for(int j = 0; j < N; j++)
                result[i] += m[i][j] * v[j];
        return result;
    }
    
    static int[][] transposeMatrix(int[][] m) {
        int[][] result = new int[N][N];
        for(int i = 0; i < N; i++)
            for(int j = 0; j < N; j++)
                result[i][j] = m[j][i];
        return result;
    }
    
    static int[] sortVector(int[] v) {
        int[] sorted = v.clone();
        Arrays.sort(sorted);
        return sorted;
    }
    
    static int findMax(int[][] matrix) {
        int max = matrix[0][0];
        for(int i = 0; i < N; i++)
            for(int j = 0; j < N; j++)
                if(matrix[i][j] > max)
                    max = matrix[i][j];
        return max;
    }
    
    static int findMin(int[] vector) {
        int min = vector[0];
        for(int i = 1; i < vector.length; i++)
            if(vector[i] < min)
                min = vector[i];
        return min;
    }
    
    /**
     * Multiply two matrices
     */
    public static int[][] multiplyMatrices(int[][] A, int[][] B) {
        int[][] C = new int[N][N];
        for(int i = 0; i < N; i++) {
            for(int j = 0; j < N; j++) {
                C[i][j] = 0;
                for(int k = 0; k < N; k++) {
                    C[i][j] += A[i][k] * B[k][j];
                }
            }
        }
        return C;
    }
    
    /**
     * Fill a matrix with user input - all at once
     * @param name The name of the matrix (for prompts)
     * @return The filled matrix
     */
    public static int[][] inputMatrix(String name, Scanner scanner) {
        int[][] matrix = new int[N][N];
        System.out.println("Enter values for " + name + " matrix (" + N + "x" + N + "):");
        System.out.println("Enter all " + (N*N) + " values in a single line, separated by spaces:");
        
        for(int i = 0; i < N; i++) {
            for(int j = 0; j < N; j++) {
                matrix[i][j] = scanner.nextInt();
            }
        }
        
        return matrix;
    }
    
    /**
     * Fill a vector with user input - all at once
     * @param name The name of the vector (for prompts)
     * @return The filled vector
     */
    public static int[] inputVector(String name, Scanner scanner) {
        int[] vector = new int[N];
        System.out.println("Enter values for " + name + " vector (size " + N + "):");
        System.out.println("Enter all " + N + " values in a single line, separated by spaces:");
        
        for(int i = 0; i < N; i++) {
            vector[i] = scanner.nextInt();
        }
        
        return vector;
    }
    
    /**
     * Fill a matrix with random values
     * @param name The name of the matrix (for logging)
     * @return The filled matrix
     */
    public static int[][] randomMatrix(String name) {
        int maxValue = 100;
        int[][] matrix = new int[N][N];
        Random random = new Random();
        
        for(int i = 0; i < N; i++) {
            for(int j = 0; j < N; j++) {
                matrix[i][j] = random.nextInt(maxValue);
            }
        }
        
        System.out.println("Matrix " + name + " initialized with random values");
        return matrix;
    }
    
    /**
     * Fill a vector with random values
     * @param name The name of the vector (for logging)
     * @return The filled vector
     */
    public static int[] randomVector(String name) {
        int maxValue = 100;
        int[] vector = new int[N];
        Random random = new Random();
        
        for(int i = 0; i < N; i++) {
            vector[i] = random.nextInt(maxValue);
        }
        
        System.out.println("Vector " + name + " initialized with random values");
        return vector;
    }
    
    /**
     * Print a matrix to console
     */
    public static void printMatrix(String name, int[][] matrix) {
        System.out.println("Matrix " + name + ":");
        System.out.println("_________________________________________");
        for(int i = 0; i < N; i++) {
            for(int j = 0; j < N; j++) {
                System.out.print(matrix[i][j] + " ");
            }
            System.out.println();
        }
        System.out.println("_________________________________________");
    }
    
    /**
     * Print a vector to console
     */
    public static void printVector(String name, int[] vector) {
        System.out.println("Vector " + name + ": ");
        System.out.println("_________________________________________");
        for(int i = 0; i < N; i++) {
            System.out.print(vector[i] + " ");
        }
        System.out.println("_________________________________________");
        System.out.println();
    }
}