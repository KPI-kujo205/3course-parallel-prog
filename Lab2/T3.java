package Lab2;

import java.util.Arrays;
import java.util.concurrent.BrokenBarrierException;

public class T3 extends Thread {
    @Override
    public void run() {
        System.out.println("T3 started execution");
        
        int startIdx = Lab2.N/2;
        int size = Lab2.N/4;
        
        try {
            // Initialize data (ME)
            for (int i = 0; i < Lab2.N; i++) {
                Arrays.fill(Data.ME[i], 1);
            }
            
            // Signal other threads about data initialization (S1.1, S2.1, S4.1)
            Data.B1.await();
            
            // Compute partial dot product e3 = (B * C)
            int e3 = Data.computePartialDotProduct(Data.B, Data.C, startIdx, size);
            
            // Add to shared e value (КД1)
            Data.eSem.acquire();
            Data.e.addAndGet(e3);
            Data.eSem.release();
            
            // Compute D*(ME*MM) for this part
            int[][] ME_MM = Data.multiplyMatricesBlock(Data.ME, Data.MM, startIdx, size);
            Data.multiplyVectorByMatrixPartial(Data.D, ME_MM, startIdx, size, Data.S);
            
            // Sort this part of S
            Arrays.sort(Data.S, startIdx, startIdx + size);
            
            // Wait for T4 to complete its part (W4.2)
            Data.Sem4_2.acquire();
            
            // Merge third and fourth parts
            Data.mergeSortedParts(Data.S, startIdx, startIdx + size, 3 * Lab2.N/4);
            
            // Signal T1 about completion of this part (S1.2)
            Data.Sem3_2.release();
            
            // Wait for T1 to complete sorting (W1.2)
            Data.Sem1_2.acquire();
            
            // Get shared values
            Data.eSem.acquire();  // КД2
            int e_val = Data.e.get();
            Data.eSem.release();
            
            int x_val;
            synchronized (Data.CS2) {  // КД4
                x_val = Data.x;
            }
            
            // Compute final result Z = S + e*E*x
            int[] eEx = new int[Lab2.N];
            Data.computePartialScalarVectorProduct(e_val * x_val, Data.E, startIdx, size, eEx);
            Data.addVectorsPartial(Data.S, eEx, startIdx, size, Data.Z);
            
            // Final synchronization - wait for all threads to complete their computations (S4.2)
            Data.B2.await();
            
            System.out.println("T3 finished execution");

        } catch (InterruptedException | BrokenBarrierException e) {
            throw new RuntimeException(e);
        }
        
    }
} 