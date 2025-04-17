package Lab2;

import java.util.Arrays;
import java.util.concurrent.BrokenBarrierException;

public class T1 extends Thread {
    @Override
    public void run() {
        System.out.println("T1 started execution");
        
        int startIdx = 0;
        int size = Lab2.N/4;
        
        try {
            // Initialize data (B, E)
            Arrays.fill(Data.B, 1);
            Arrays.fill(Data.E, 1);
            
            // Signal 
            // Wait
            Data.B1.await();

            // Compute partial dot product e1 = (B * C)
            int e1 = Data.computePartialDotProduct(Data.B, Data.C, startIdx, size);
            
            // Add to shared e value
            Data.eSem.acquire();
            Data.e.addAndGet(e1);
            Data.eSem.release();
            
            // Compute D*(ME*MM) for this part
            int[][] ME_MM = Data.multiplyMatricesBlock(Data.ME, Data.MM, startIdx, size);
            Data.multiplyVectorByMatrixPartial(Data.D, ME_MM, startIdx, size, Data.S);
            
            // Sort this part of S
            Arrays.sort(Data.S, startIdx, startIdx + size);
            
            // Wait for T2 to complete its part
            Data.Sem2_2.acquire();
            
            // Merge first two parts
            Data.mergeSortedParts(Data.S, 0, Lab2.N/4, Lab2.N/2);
            
            // Wait for T3 to complete its part
            Data.Sem3_2.acquire();
            
            // Merge all parts
            Data.mergeSortedParts(Data.S, 0, Lab2.N/2, Lab2.N);
            
            // Signal other threads about completion of sorting
            Data.Sem1_2.release(3);
            
            // Get shared values
            Data.eSem.acquire();
            int e_val = Data.e.get();
            Data.eSem.release();
            
            int x_val;       // КД3
            synchronized (Data.CS2) {
                x_val = Data.x;
            }
            
            // Compute final result Z = S + e*E*x
            int[] eEx = new int[Lab2.N];
            Data.computePartialScalarVectorProduct(e_val * x_val, Data.E, startIdx, size, eEx);
            Data.addVectorsPartial(Data.S, eEx, startIdx, size, Data.Z);
            
            // Final synchronization
            Data.B1.await();
            
        } catch (InterruptedException | BrokenBarrierException e) {
            throw new RuntimeException(e);
        }
        
        System.out.println("T1 finished execution");
    }
} 