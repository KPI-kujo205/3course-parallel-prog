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
            // Input B, E
            Arrays.fill(Data.B, 1);
            Arrays.fill(Data.E, 1);
            
            // Signal T2, T3, T4 about input of B, E (S2.1, S3.1, S4.1)
            Data.B1.await();

            // Computation1 e1 = (BH * CH)
            int e1 = Data.computePartialDotProduct(Data.B, Data.C, startIdx, size);
            
            // Computation2 e = e + e1 (КД1)
            Data.eSem.acquire();
            Data.e.addAndGet(e1);
            Data.eSem.release();
            
            // Computation3 SH = sort(D * (ME * MMH))
            int[][] ME_MM = Data.multiplyMatricesBlock(Data.ME, Data.MM, startIdx, size);
            Data.multiplyVectorByMatrixPartial(Data.D, ME_MM, startIdx, size, Data.S);
            Arrays.sort(Data.S, startIdx, startIdx + size);
            
            // Wait for computation of SH in T2 (W2.2)
            Data.Sem2_2.acquire();
            
            // Computation4 S2H = msort(SH, SH)
            Data.mergeSortedParts(Data.S, 0, Lab2.N/4, Lab2.N/2);
            
            // Wait for computation of S2H in T3 (W3.2)
            Data.Sem3_2.acquire();
            
            // Computation5 S = msort(S2H, S2H)
            Data.mergeSortedParts(Data.S, 0, Lab2.N/2, Lab2.N);
            
            // Signal T2, T3, T4 about computation of S (S2.2, S3.2, S4.2)
            Data.Sem1_2.release(3);
            
            // Copy e1 = e (КД2)
            Data.eSem.acquire();
            int e_val = Data.e.get();
            Data.eSem.release();
            
            int x_val;
            synchronized (Data.CS2) {
                x_val = Data.x;
            }
            
            // Compute final result Z = S + e*E*x
            int[] eEx = new int[Lab2.N];
            Data.computePartialScalarVectorProduct(e_val * x_val, Data.E, startIdx, size, eEx);
            Data.addVectorsPartial(Data.S, eEx, startIdx, size, Data.Z);
            
            System.out.println("T1 finished execution");
            Data.t4Last.release(); // Signal that T1 is done
            
        } catch (InterruptedException | BrokenBarrierException e) {
            throw new RuntimeException(e);
        }
        
    }
} 