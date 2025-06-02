---------------------------------------------------------------------
-- Програмне забезпечення високопродуктивних комп'ютерних систем
-- Лабораторна робота ЛР5
-- Повідомлення. Мова Ada. Механізм рандеву
-- Варіант 8
-- Z =  X*(MA*MS) + min(X)*F

-- ПВВ1: MA, Z
-- ПВВ2: X
-- ПВВ3: MS
-- ПВВ6: F 
-- Куц Іван Васильович
-- Група ІМ-22
---------------------------------------------------------------------

with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Real_Time;
use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Real_Time;


procedure Lab5 is
   N: Integer := 600;  -- Розмір векторів і квадратних матриць
   P: Integer := 6;   -- Кількість процесорів
   H: Integer := N/P; -- Розмір підвектора і кількість стовпців підматриці

   Start_Time, End_Time: Time;
   Elapsed_Time: Time_Span;
   Current_Time: Time;

   -- Формування типів
   type Vector_General is array(Integer range <>) of Integer;
   subtype Vector_N is Vector_General(1..N);
   subtype Vector_H is Vector_General(1..H);
   subtype Vector_2H is Vector_General(1..2*H);
   subtype Vector_3H is Vector_General(1..3*H);
   subtype Vector_4H is Vector_General(1..4*H);

   type Matrix_General is array(Integer range <>) of Vector_N;
   type Matrix_N is array(1..N) of Vector_N;
   type Matrix_H is array(1..N) of Vector_H;
   type Matrix_2H is array(1..N) of Vector_2H;
   type Matrix_3H is array(1..N) of Vector_3H;
   type Matrix_4H is array(1..N) of Vector_4H;

   -- Допоміжні функції
   function Fill_Vector return Vector_N is
      Vector: Vector_N;
   begin
      for I in 1..N loop
         Vector(I) := 1;
      end loop;
      return Vector;
   end Fill_Vector;

   function Fill_Matrix return Matrix_N is
      Matrix: Matrix_N;
   begin
      for I in 1..N loop
         for J in 1..N loop
            Matrix(I)(J) := 1;
         end loop;
      end loop;
      return Matrix;
   end Fill_Matrix;

   function Find_Min(Vector: Vector_H) return Integer is
      Min_Value: Integer := Vector(1);
   begin
      for I in 2..H loop
         if Vector(I) < Min_Value then
            Min_Value := Vector(I);
         end if;
      end loop;
      return Min_Value;
   end Find_Min;

   function Multiply_Vector_Matrix(Vector: Vector_N; Matrix: Matrix_H; Task_Num: Integer) return Vector_H is
      Result: Vector_H := (others => 0);
   begin
      for I in 1..H loop
         for J in 1..N loop
            Result(I) := Result(I) + (Vector(J) * Matrix(J)(I));
         end loop;
      end loop;
      return Result;
   end Multiply_Vector_Matrix;

   function Multiply_Matrices(Matrix1: Matrix_N; Matrix2: Matrix_H) return Matrix_H is
      Result: Matrix_H := (others => (others => 0));
   begin
      for I in 1..N loop
         for J in 1..H loop
            for K in 1..N loop
               Result(I)(J) := Result(I)(J) + (Matrix1(I)(K) * Matrix2(K)(J));
            end loop;
         end loop;
      end loop;
      return Result;
   end Multiply_Matrices;

   function Calculate_Zh(X: Vector_N; MA: Matrix_N; MSh: Matrix_H; a: Integer; Fh: Vector_H; Task_Num: Integer) return Vector_H is
      Result: Vector_H;
      MAMSh: Matrix_H;
      XMAMSh: Vector_H;
   begin
      -- MA * MSh
      MAMSh := Multiply_Matrices(MA, MSh);

      -- X * (MA * MSh)
      XMAMSh := Multiply_Vector_Matrix(X, MAMSh, Task_Num);

      -- X * (MA * MSh) + a * Fh
      for I in 1..H loop
         Result(I) := XMAMSh(I) + (a * Fh(I));
      end loop;

      Put_Line("T" & Integer'Image(Task_Num) & ": Final Zh result:");
      for I in 1..H loop
         Put(Integer'Image(Result(I)));
      end loop;
      Put_Line("");

      return Result;
   end Calculate_Zh;

   -- Task specifications
   task T1 is
      pragma Storage_Size(2_147_483_648);
      entry X3h_fromT2(X3h_IN: in Vector_3H; X_IN: in Vector_N);
      entry MS2h_fromT3(MS2h_IN: in Matrix_2H);
      entry Fh_fromT3(F_IN: in Vector_N);
      entry a_fromT3(a_IN: in Integer);
      entry Zh_fromT2(Zh_IN: in Vector_H);
      entry Z4h_fromT3(Z4h_IN: in Vector_4H);
   end T1;

   task T2 is
      pragma Storage_Size(2_147_483_648);
      entry MAMSh_fromT1(MA_IN: in Matrix_N; MSh_IN: in Matrix_H);
      entry Fh_fromT4(F_IN: in Vector_N);
      entry a_fromT4(a_IN: in Integer);
   end T2;

   task T3 is
      pragma Storage_Size(2_147_483_648);
      entry MAX2h_fromT1(MA_IN: in Matrix_N; X2h_IN: in Vector_2H; X_IN: in Vector_N);
      entry F2h_fromT5(F_IN: in Vector_N);
      entry a1_fromT1(a1_IN: in Integer);
      entry a5_fromT5(a5_IN: in Integer);
      entry a_fromT4(a_IN: in Integer);
      entry Z2h_fromT5(Z2h_IN: in Vector_2H);
      entry Zh_fromT4(Zh_IN: in Vector_H);
   end T3;

   task T4 is
      pragma Storage_Size(2_147_483_648);
      entry MAX2h_fromT2(MA_IN: in Matrix_N; X2h_IN: in Vector_2H; X_IN: in Vector_N);
      entry MSh_fromT3(MSh_IN: in Matrix_H);
      entry F2h_fromT6(F_IN: in Vector_N);
      entry a2_fromT2(a2_IN: in Integer);
      entry a6_fromT6(a6_IN: in Integer);
      entry a3_fromT3(a3_IN: in Integer);
      entry a_fromT4(a_IN: in Integer);
   end T4;

   task T5 is
      pragma Storage_Size(2_147_483_648);
      entry MAMS2hXh_fromT3(MA_IN: in Matrix_N; MS2h_IN: in Matrix_2H; Xh_IN: in Vector_H; X_IN: in Vector_N);
      entry F3h_fromT6(F_IN: in Vector_N);
      entry a_fromT3(a_IN: in Integer);
      entry Zh_fromT6(Zh_IN: in Vector_H);
   end T5;

   task T6 is
      pragma Storage_Size(2_147_483_648);
      entry MAXh_fromT4(MA_IN: in Matrix_N; Xh_IN: in Vector_H; X_IN: in Vector_N);
      entry MAMSh_fromT5(MA_IN: in Matrix_N; MSh_IN: in Matrix_H);
      entry a_fromT4(a_IN: in Integer);
   end T6;

   -- Task bodies
   task body T1 is
      MA: Matrix_N;
      X: Vector_N;
      MS2h: Matrix_2H;
      F: Vector_N;
      a1, a: Integer;
      Z: Vector_N;
      X3h: Vector_3H;
      Zh: Vector_H;
      Z4h: Vector_4H;
   begin
      -- Введення MA
      MA := Fill_Matrix;

      -- Прийняти дані від задачі T3: F
      accept Fh_fromT3(F_IN: in Vector_N) do
         F := F_IN;
      end Fh_fromT3;

      -- Прийняти дані від задачі T3: MS2Н
      accept MS2h_fromT3(MS2h_IN: in Matrix_2H) do
         MS2h := MS2h_IN;
      end MS2h_fromT3;

      -- Прийняти дані від задачі T2: X3H, X
      accept X3h_fromT2(X3h_IN: in Vector_3H; X_IN: in Vector_N) do
         X3h := X3h_IN;
         X := X_IN;
      end X3h_fromT2;

      -- Передати дані задачі T2: MA, MSН
      T2.MAMSh_fromT1(MA, (for I in 1..N => MS2h(I)(1..H)));

      -- Передати дані задачі T3: MA, X2H, X
      T3.MAX2h_fromT1(MA, X3h(1..2*H), X);

      -- Обчислення1: a1 = min(XН)
      a1 := Find_Min(X3h(1..H));

      -- Передати a1 дані задачі T3
      T3.a1_fromT1(a1);

      -- Прийняти a від задачі T3
      accept a_fromT3(a_IN: in Integer) do
         a := a_IN;
      end a_fromT3;

      -- Обчислення3: ZН = X * (MA * MSН) + a * F
      Z(1..H) := Calculate_Zh(X, MA, (for I in 1..N => MS2h(I)(1..H)), a, F(1..H), 1);

      -- Прийняти Z4H від задачі T3
      accept Z4h_fromT3(Z4h_IN: in Vector_4H) do
         Z4h := Z4h_IN;
      end Z4h_fromT3;

      -- Прийняти ZH від задачі T2
      accept Zh_fromT2(Zh_IN: in Vector_H) do
         Zh := Zh_IN;
      end Zh_fromT2;

      -- Об'єднання всіх векторів у Z
      Z(1..H) := Z(1..H);           -- Перші H елементів (вже обчислені)
      Z(H+1..2*H) := Z4h(1..H);     -- Наступні H елементів з Z4h
      Z(2*H+1..3*H) := Z4h(H+1..2*H); -- Наступні H елементів з Z4h
      Z(3*H+1..4*H) := Z4h(2*H+1..3*H); -- Наступні H елементів з Z4h
      Z(4*H+1..5*H) := Z4h(3*H+1..4*H); -- Наступні H елементів з Z4h
      Z(5*H+1..6*H) := Zh;          -- Останні H елементів з Zh

      -- Виведення Z
      Put_Line("Final result vector Z:");
      for I in 1..N loop
         Put(Integer'Image(Z(I)));
      end loop;
      Put_Line("");

      -- Record end time and calculate elapsed time
      End_Time := Clock;
      Elapsed_Time := End_Time - Start_Time;
      Put_Line("Calculation finished");
      Put_Line("Total execution time: " & Integer'Image(Integer(To_Duration(Elapsed_Time) * 1000.0)) & " milliseconds");
   end T1;

   task body T2 is
      X: Vector_N;
      MA: Matrix_N;
      MSh: Matrix_H;
      F: Vector_N;
      a2, a: Integer;
      Zh: Vector_H;
   begin
      -- Введення X
      X := Fill_Vector;

      -- Прийняти дані від задачі T4: FH
      accept Fh_fromT4(F_IN: in Vector_N) do
         F := F_IN;
      end Fh_fromT4;

      -- Передати дані задачі T1: X3H, X
      T1.X3h_fromT2(X(1..3*H), X);

      -- Прийняти дані від задачі T1: MA, MSН
      accept MAMSh_fromT1(MA_IN: in Matrix_N; MSh_IN: in Matrix_H) do
         MA := MA_IN;
         MSh := MSh_IN;
      end MAMSh_fromT1;

      -- Передати дані задачі T4: X2H, X, MA
      T4.MAX2h_fromT2(MA, X(1..2*H), X);

      -- Обчислення1: a2 = min(XН)
      a2 := Find_Min(X(1..H));

      -- Передати a2 дані задачі T4
      T4.a2_fromT2(a2);

      -- Прийняти a від задачі T4
      accept a_fromT4(a_IN: in Integer) do
         a := a_IN;
      end a_fromT4;

      -- Обчислення3: ZН = X * (MA * MSН) + a * FH
      Zh := Calculate_Zh(X, MA, MSh, a, F(1..H), 2);

      -- Передати ZH задачі T1
      T1.Zh_fromT2(Zh);
   end T2;

   task body T3 is
      MS: Matrix_N;
      MA: Matrix_N;
      X2h: Vector_2H;
      X: Vector_N;
      F: Vector_N;
      a3, a1, a5, a: Integer;
      Z2h: Vector_2H;
      Zh: Vector_H;
      Zh_T3: Vector_H;
   begin
      -- Введення MS
      MS := Fill_Matrix;
      
      -- Прийняти дані від задачі T5: F2H
      accept F2h_fromT5(F_IN: in Vector_N) do
         F := F_IN;
      end F2h_fromT5;

      -- Передати дані задачі T1: FH
      T1.Fh_fromT3(F);

      -- Передати дані задачі T1: MS2Н
      T1.MS2h_fromT3((for I in 1..N => MS(I)(1..2*H)));

      -- Прийняти дані від задачі T1: MA, X2H, X
      accept MAX2h_fromT1(MA_IN: in Matrix_N; X2h_IN: in Vector_2H; X_IN: in Vector_N) do
         MA := MA_IN;
         X2h := X2h_IN;
         X := X_IN;
      end MAX2h_fromT1;

      -- Передати дані задачі T5: MA, MS2H, XH, X
      T5.MAMS2hXh_fromT3(MA, (for I in 1..N => MS(I)(1..2*H)), X2h(1..H), X);

      -- Передати дані задачі T4: MSH
      T4.MSh_fromT3((for I in 1..N => MS(I)(1..H)));

      -- Обчислення1: a3 = min(XН)
      a3 := Find_Min(X2h(1..H));

      -- Прийняти a1 від задачі T1
      accept a1_fromT1(a1_IN: in Integer) do
         a1 := a1_IN;
      end a1_fromT1;

      -- Обчислення2: a3 = min(a3, a1)
      a3 := Integer'Min(a3, a1);

      -- Прийняти a5 від задачі T5
      accept a5_fromT5(a5_IN: in Integer) do
         a5 := a5_IN;
      end a5_fromT5;

      -- Обчислення2: a3 = min(a3, a5)
      a3 := Integer'Min(a3, a5);

      -- Передати a3 задачі T4
      T4.a3_fromT3(a3);

      -- Прийняти a від задачі T4
      accept a_fromT4(a_IN: in Integer) do
         a := a_IN;
      end a_fromT4;

      -- Передати a задачі T1
      T1.a_fromT3(a);

      -- Передати a задачі T5
      T5.a_fromT3(a);

      -- Обчислення3: ZН = X * (MA * MSН) + a * FH
      Zh_T3 := Calculate_Zh(X, MA, (for I in 1..N => MS(I)(1..H)), a, F(1..H), 3);

      -- Прийняти Z2H від задачі T5
      accept Z2h_fromT5(Z2h_IN: in Vector_2H) do
         Z2h := Z2h_IN;
      end Z2h_fromT5;

      -- Прийняти Zh від задачі T4
      accept Zh_fromT4(Zh_IN: in Vector_H) do
         Zh := Zh_IN;
      end Zh_fromT4;

      -- Передати Z4H задачі T1
      T1.Z4h_fromT3((Z2h & Zh & Zh_T3));
   end T3;

   task body T4 is
      MA: Matrix_N;
      X2h: Vector_2H;
      X: Vector_N;
      MSh: Matrix_H;
      F: Vector_N;
      a4, a2, a6, a3, a: Integer;
      Zh: Vector_H;
   begin
      -- Прийняти дані від задачі T6: F2H
      accept F2h_fromT6(F_IN: in Vector_N) do
         F := F_IN;
      end F2h_fromT6;

      -- Передати дані задачі T2: FH
      T2.Fh_fromT4(F);

      -- Прийняти дані від задачі T2: MA, X2H, X
      accept MAX2h_fromT2(MA_IN: in Matrix_N; X2h_IN: in Vector_2H; X_IN: in Vector_N) do
         MA := MA_IN;
         X2h := X2h_IN;
         X := X_IN;
      end MAX2h_fromT2;

      -- Прийняти дані від задачі T3: MSН
      accept MSh_fromT3(MSh_IN: in Matrix_H) do
         MSh := MSh_IN;
      end MSh_fromT3;

      -- Передати дані задачі T6: XH
      T6.MAXh_fromT4(MA, X2h(1..H), X);

      -- Обчислення1: a4 = min(XН)
      a4 := Find_Min(X2h(1..H));

      -- Прийняти a2 від задачі T2
      accept a2_fromT2(a2_IN: in Integer) do
         a2 := a2_IN;
      end a2_fromT2;

      -- Обчислення2: a4 = min(a4, a2)
      a4 := Integer'Min(a4, a2);

      -- Прийняти a6 від задачі T6
      accept a6_fromT6(a6_IN: in Integer) do
         a6 := a6_IN;
      end a6_fromT6;

      -- Обчислення2: a4 = min(a4, a6)
      a4 := Integer'Min(a4, a6);

      -- Прийняти a3 від задачі T3
      accept a3_fromT3(a3_IN: in Integer) do
         a3 := a3_IN;
      end a3_fromT3;

      -- Обчислення2: a = min(a4, a3)
      a := Integer'Min(a4, a3);

      -- Передати a задачі T2
      T2.a_fromT4(a);

      -- Передати a задачі T3
      T3.a_fromT4(a);

      -- Передати a задачі T6
      T6.a_fromT4(a);

      -- Обчислення3: ZН = X * (MA * MSН) + a * FH
      Zh := Calculate_Zh(X, MA, MSh, a, F(1..H), 4);

      -- Передати ZH задачі T3
      T3.Zh_fromT4(Zh);
   end T4;

   task body T5 is
      MA: Matrix_N;
      MS2h: Matrix_2H;
      Xh: Vector_H;
      X: Vector_N;
      F: Vector_N;
      a5, a: Integer;
      Zh: Vector_H;
   begin
      -- Прийняти дані від задачі T6: F3H
      accept F3h_fromT6(F_IN: in Vector_N) do
         F := F_IN;
      end F3h_fromT6;

      -- Передати дані задачі T3: F2H
      T3.F2h_fromT5(F);

      -- Прийняти дані від задачі T3: MA, MS2H, XH, X
      accept MAMS2hXh_fromT3(MA_IN: in Matrix_N; MS2h_IN: in Matrix_2H; Xh_IN: in Vector_H; X_IN: in Vector_N) do
         MA := MA_IN;
         MS2h := MS2h_IN;
         Xh := Xh_IN;
         X := X_IN;
      end MAMS2hXh_fromT3;

      -- Передати дані задачі T6: MSH, MA
      T6.MAMSh_fromT5(MA, (for I in 1..N => MS2h(I)(1..H)));

      -- Обчислення1: a5 = min(XН)
      a5 := Find_Min(Xh);

      -- Передати a5 дані задачі T3
      T3.a5_fromT5(a5);

      -- Прийняти a від задачі T3
      accept a_fromT3(a_IN: in Integer) do
         a := a_IN;
      end a_fromT3;

      -- Обчислення3: ZН = X * (MA * MSН) + a * FH
      Zh := Calculate_Zh(X, MA, (for I in 1..N => MS2h(I)(1..H)), a, F(1..H), 5);

      -- Прийняти ZН від задачі T6
      accept Zh_fromT6(Zh_IN: in Vector_H) do
         Zh := Zh_IN;
      end Zh_fromT6;

      -- Передати Z2H задачі T3
      T3.Z2h_fromT5((Zh & Zh));
   end T5;

   task body T6 is
      F: Vector_N;
      MA: Matrix_N;
      Xh: Vector_H;
      X: Vector_N;
      MSh: Matrix_H;
      a6, a: Integer;
      Zh: Vector_H;
   begin
      -- Введення F
      F := Fill_Vector;

      -- Передати дані задачі T4: F2H
      T4.F2h_fromT6(F);

      -- Передати дані задачі T5: F3H
      T5.F3h_fromT6(F);

      -- Прийняти дані від задачі T4: MA, XH, X
      accept MAXh_fromT4(MA_IN: in Matrix_N; Xh_IN: in Vector_H; X_IN: in Vector_N) do
         MA := MA_IN;
         Xh := Xh_IN;
         X := X_IN;
      end MAXh_fromT4;

      -- Прийняти дані від задачі T5: MA, MSH
      accept MAMSh_fromT5(MA_IN: in Matrix_N; MSh_IN: in Matrix_H) do
         MA := MA_IN;
         MSh := MSh_IN;
      end MAMSh_fromT5;

      -- Обчислення1: a6 = min(XН)
      a6 := Find_Min(Xh);

      -- Передати a6 дані задачі T4
      T4.a6_fromT6(a6);

      -- Прийняти a від задачі T4
      accept a_fromT4(a_IN: in Integer) do
         a := a_IN;
      end a_fromT4;

      -- Обчислення3: ZН = X * (MA * MSН) + a * FH
      Zh := Calculate_Zh(X, MA, MSh, a, F(1..H), 6);

      -- Передати ZН задачі T5
      T5.Zh_fromT6(Zh);
   end T6;

begin
   Start_Time := Clock;
   Put_Line("Lab5 is started");
   Put_Line("Start time: 0 milliseconds");
end Lab5;