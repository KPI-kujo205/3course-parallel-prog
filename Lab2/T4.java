package Lab2;

import java.util.Arrays;
import java.util.concurrent.BrokenBarrierException;

public class T4 extends Thread {
    @Override
    public void run() {
        System.out.println("T4 started execution");
        
        int startIdx = 3 * Lab2.N/4;
        int size = Lab2.N/4;
        
        try {
            // Initialize data (C, x)
            Arrays.fill(Data.C, 1);
            Data.x = 1;
            
            // Signal other threads about data initialization (S1.1, S2.1, S3.1)
            Data.B1.await();
            
            // Compute partial dot product e4 = (B * C)
            int e4 = Data.computePartialDotProduct(Data.B, Data.C, startIdx, size);
            
            // Add to shared e value (КД1)
            Data.eSem.acquire();
            Data.e.addAndGet(e4);
            Data.eSem.release();
            
            // Compute D*(ME*MM) for this part
            int[][] ME_MM = Data.multiplyMatricesBlock(Data.ME, Data.MM, startIdx, size);
            Data.multiplyVectorByMatrixPartial(Data.D, ME_MM, startIdx, size, Data.S);
            
            // Sort this part of S
            Arrays.sort(Data.S, startIdx, startIdx + size);
            
            // Signal T3 about completion of this part (S3.2)
            Data.Sem4_2.release();
            
            // Wait for T1 to complete sorting (W1.2)
            Data.Sem1_2.acquire();
            
            // Get shared values
            Data.eSem.acquire();  // КД2
            int e_val = Data.e.get();
            Data.eSem.release();
            
            int x_val;
            synchronized (Data.CS2) {  // КД3
                x_val = Data.x;
            }
            
            // Compute final result Z = S + e*E*x
            int[] eEx = new int[Lab2.N];
            Data.computePartialScalarVectorProduct(e_val * x_val, Data.E, startIdx, size, eEx);
            Data.addVectorsPartial(Data.S, eEx, startIdx, size, Data.Z);
            
            // Final synchronization - wait for all threads to complete their computations (S4.2)
            Data.B2.await();
            
            // Print the result
            Data.printResVectorZ(Data.Z);


            System.out.println("T4 finished execution");
        } catch (InterruptedException | BrokenBarrierException e) {
            throw new RuntimeException(e);
        }
        
        
    }
} 