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
   N: Integer := 24;  -- Розмір векторів і квадратних матриць
   P: Integer := 6;   -- Кількість процесорів
   H: Integer := N/P; -- Розмір підвектора і кількість стовпців підматриці

   Start_Time, End_Time: Time;
   Elapsed_Time: Time_Span;

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

   function Multiply_Vector_Matrix(Vector: Vector_N; Matrix: Matrix_H) return Vector_H is
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

   function Calculate_Zh(X: Vector_N; MA: Matrix_N; MSh: Matrix_H; a: Integer; Fh: Vector_H) return Vector_H is
      Result: Vector_H;
      MAMSh: Matrix_H;
      XMAMSh: Vector_H;
   begin
      -- MA * MSh
      MAMSh := Multiply_Matrices(MA, MSh);
      -- X * (MA * MSh)
      XMAMSh := Multiply_Vector_Matrix(X, MAMSh);
      -- X * (MA * MSh) + a * Fh
      for I in 1..H loop
         Result(I) := XMAMSh(I) + (a * Fh(I));
      end loop;
      return Result;
   end Calculate_Zh;

   -- Task specifications
   task T1 is
      pragma Storage_Size(2_147_483_648);
      entry X3h_fromT2(X3h_IN: in Vector_3H);
      entry MS2hFh_fromT3(MS2h_IN: in Matrix_2H; Fh_IN: in Vector_H);
      entry a_fromT3(a_IN: in Integer);
      entry Zh_fromT2(Zh_IN: in Vector_H);
      entry Z4h_fromT3(Z4h_IN: in Vector_4H);
   end T1;

   task T2 is
      pragma Storage_Size(2_147_483_648);
      entry MAMSh_fromT1(MA_IN: in Matrix_N; MSh_IN: in Matrix_H);
      entry Fh_fromT4(Fh_IN: in Vector_H);
      entry a_fromT4(a_IN: in Integer);
   end T2;

   task T3 is
      pragma Storage_Size(2_147_483_648);
      entry MAX2h_fromT1(MA_IN: in Matrix_N; X2h_IN: in Vector_2H);
      entry F2h_fromT5(F2h_IN: in Vector_2H);
      entry a1_fromT1(a1_IN: in Integer);
      entry a5_fromT5(a5_IN: in Integer);
      entry a_fromT4(a_IN: in Integer);
      entry Z2h_fromT5(Z2h_IN: in Vector_2H);
      entry Zh_fromT4(Zh_IN: in Vector_H);
   end T3;

   task T4 is
      pragma Storage_Size(2_147_483_648);
      entry MAX2h_fromT2(MA_IN: in Matrix_N; X2h_IN: in Vector_2H);
      entry MSh_fromT3(MSh_IN: in Matrix_H);
      entry F2h_fromT6(F2h_IN: in Vector_2H);
      entry a2_fromT2(a2_IN: in Integer);
      entry a6_fromT6(a6_IN: in Integer);
      entry a3_fromT3(a3_IN: in Integer);
   end T4;

   task T5 is
      pragma Storage_Size(2_147_483_648);
      entry MAMS2hXh_fromT3(MA_IN: in Matrix_N; MS2h_IN: in Matrix_2H; Xh_IN: in Vector_H);
      entry F3h_fromT6(F3h_IN: in Vector_3H);
      entry a_fromT3(a_IN: in Integer);
      entry Zh_fromT6(Zh_IN: in Vector_H);
   end T5;

   task T6 is
      pragma Storage_Size(2_147_483_648);
      entry MAXh_fromT4(MA_IN: in Matrix_N; Xh_IN: in Vector_H);
      entry MAMSh_fromT5(MA_IN: in Matrix_N; MSh_IN: in Matrix_H);
      entry a_fromT4(a_IN: in Integer);
   end T6;

   -- Task bodies
   task body T1 is
      MA: Matrix_N;
      X: Vector_N;
      MS2h: Matrix_2H;
      Fh: Vector_H;
      a1, a: Integer;
      Z: Vector_N;
      X3h: Vector_3H;
      Zh: Vector_H;
      Z4h: Vector_4H;
   begin
      Put_Line("Task T1 is started");

      -- Введення MA
      Put_Line("T1: Initializing MA");
      MA := Fill_Matrix;
      Put_Line("T1: MA initialized");

      -- Прийняти дані від задачі T2: X3H
      Put_Line("T1: Waiting for X3h_fromT2");
      accept X3h_fromT2(X3h_IN: in Vector_3H) do
         X3h := X3h_IN;
      end X3h_fromT2;
      Put_Line("T1: Received X3h_fromT2");

      -- Передати дані задачі T2: MA, MSН
      Put_Line("T1: Sending MAMSh_fromT1 to T2");
      T2.MAMSh_fromT1(MA, (for I in 1..N => MS2h(I)(1..H)));
      Put_Line("T1: Sent MAMSh_fromT1 to T2");

      -- Прийняти дані від задачі T3: MS2Н, FН
      Put_Line("T1: Waiting for MS2hFh_fromT3");
      accept MS2hFh_fromT3(MS2h_IN: in Matrix_2H; Fh_IN: in Vector_H) do
         MS2h := MS2h_IN;
         Fh := Fh_IN;
      end MS2hFh_fromT3;
      Put_Line("T1: Received MS2hFh_fromT3");

      -- Передати дані задачі T3: MA, X2H
      Put_Line("T1: Sending MAX2h_fromT1 to T3");
      T3.MAX2h_fromT1(MA, X3h(1..2*H));
      Put_Line("T1: Sent MAX2h_fromT1 to T3");

      -- Обчислення1: a1 = min(XН)
      Put_Line("T1: Calculating a1 = min(XH)");
      a1 := Find_Min(X3h(1..H));
      Put_Line("T1: a1 calculated: " & Integer'Image(a1));

      -- Передати a1 дані задачі T3
      Put_Line("T1: Sending a1 to T3");
      T3.a1_fromT1(a1);
      Put_Line("T1: Sent a1 to T3");

      -- Прийняти a від задачі T3
      Put_Line("T1: Waiting for a_fromT3");
      accept a_fromT3(a_IN: in Integer) do
         a := a_IN;
      end a_fromT3;
      Put_Line("T1: Received a_fromT3: " & Integer'Image(a));

      Put_Line("X3h'First = " & Integer'Image(X3h'First) & ", X3h'Last = " & Integer'Image(X3h'Last));
      Put_Line("MA'First = " & Integer'Image(MA'First) & ", MA'Last = " & Integer'Image(MA'Last));
      Put_Line("MS2h'First = " & Integer'Image(MS2h'First) & ", MS2h'Last = " & Integer'Image(MS2h'Last));
      Put_Line("a = " & Integer'Image(a));
      Put_Line("Fh'First = " & Integer'Image(Fh'First) & ", Fh'Last = " & Integer'Image(Fh'Last));
      
      Put_Line("T1: Calculating Z(1..H)");
      declare
         X_temp: Vector_N := (others => 0);
      begin
         for I in 1..H loop
            X_temp(I) := X3h(I);
         end loop;
         Z(1..H) := Calculate_Zh(X_temp, MA, (for I in 1..N => MS2h(I)(1..H)), a, Fh);
      end;
      Put_Line("T1: Finish calculating Z(1..H)");

      -- Прийняти Z4H від задачі T3
      Put_Line("T1: Waiting for Z4h_fromT3");
      accept Z4h_fromT3(Z4h_IN: in Vector_4H) do
         Z4h := Z4h_IN;
      end Z4h_fromT3;
      Put_Line("T1: Received Z4h_fromT3");

      -- Прийняти ZH від задачі T2
      Put_Line("T1: Waiting for Zh_fromT2");
      accept Zh_fromT2(Zh_IN: in Vector_H) do
         Zh := Zh_IN;
      end Zh_fromT2;
      Put_Line("T1: Received Zh_fromT2");

      -- Debug prints
      Put_Line("Debug: Z(1..H) values:");
      for I in 1..H loop
         Put(Integer'Image(Z(I)));
      end loop;
      Put_Line("");

      Put_Line("Debug: Z4h values:");
      for I in 1..4*H loop
         Put(Integer'Image(Z4h(I)));
      end loop;
      Put_Line("");

      Put_Line("Debug: Zh values:");
      for I in 1..H loop
         Put(Integer'Image(Zh(I)));
      end loop;
      Put_Line("");

      -- Об'єднання всіх векторів у Z
      Z(1..H) := Z(1..H);           -- Перші H елементів (вже обчислені)
      Z(H+1..2*H) := Z4h(1..H);     -- Наступні H елементів з Z4h
      Z(2*H+1..3*H) := Z4h(H+1..2*H); -- Наступні H елементів з Z4h
      Z(3*H+1..4*H) := Z4h(2*H+1..3*H); -- Наступні H елементів з Z4h
      Z(4*H+1..5*H) := Z4h(3*H+1..4*H); -- Наступні H елементів з Z4h
      Z(5*H+1..6*H) := Zh;          -- Останні H елементів з Zh

      -- Виведення Z
      Put_Line("Result vector Z:");
      for I in 1..N loop
         Put(Integer'Image(Z(I)));
      end loop;
      Put_Line("");
      Put_Line("Task T1 is finished");
   end T1;

   task body T2 is
      X: Vector_N;
      MA: Matrix_N;
      MSh: Matrix_H;
      Fh: Vector_H;
      a2, a: Integer;
      Zh: Vector_H;
   begin
      Put_Line("Task T2 is started");

      -- Введення X
      Put_Line("T2: Initializing X");
      X := Fill_Vector;
      Put_Line("T2: X initialized");

      -- Передати дані задачі T1: X3H
      Put_Line("T2: Sending X3h_fromT2 to T1");
      T1.X3h_fromT2(X(1..3*H));
      Put_Line("T2: Sent X3h_fromT2 to T1");

      -- Прийняти дані від задачі T1: MA, MSН
      Put_Line("T2: Waiting for MAMSh_fromT1");
      accept MAMSh_fromT1(MA_IN: in Matrix_N; MSh_IN: in Matrix_H) do
         MA := MA_IN;
         MSh := MSh_IN;
      end MAMSh_fromT1;
      Put_Line("T2: Received MAMSh_fromT1");

      -- Прийняти дані від задачі T4: FН
      Put_Line("T2: Waiting for Fh_fromT4");
      accept Fh_fromT4(Fh_IN: in Vector_H) do
         Fh := Fh_IN;
      end Fh_fromT4;
      Put_Line("T2: Received Fh_fromT4");

      -- Передати дані задачі T4: X2H, MA
      Put_Line("T2: Sending MAX2h_fromT2 to T4");
      T4.MAX2h_fromT2(MA, X(1..2*H));
      Put_Line("T2: Sent MAX2h_fromT2 to T4");

      -- Обчислення1: a2 = min(XН)
      Put_Line("T2: Calculating a2 = min(XH)");
      a2 := Find_Min(X(1..H));
      Put_Line("T2: a2 calculated: " & Integer'Image(a2));

      -- Передати a2 дані задачі T4
      Put_Line("T2: Sending a2 to T4");
      T4.a2_fromT2(a2);
      Put_Line("T2: Sent a2 to T4");

      -- Прийняти a від задачі T4
      Put_Line("T2: Waiting for a_fromT4");
      accept a_fromT4(a_IN: in Integer) do
         a := a_IN;
      end a_fromT4;
      Put_Line("T2: Received a_fromT4: " & Integer'Image(a));

      -- Обчислення3: Zh = X * (MA * MSh) + a * Fh
      Put_Line("T2: Calculating Zh");
      Zh := Calculate_Zh(X, MA, MSh, a, Fh);
      Put_Line("T2: Zh calculated");

      -- Передати Zh задачі T1
      Put_Line("T2: Sending Zh to T1");
      T1.Zh_fromT2(Zh);
      Put_Line("T2: Sent Zh to T1");

      Put_Line("Task T2 is finished");
   end T2;

   task body T3 is
      MS: Matrix_N;
      MA: Matrix_N;
      X2h: Vector_2H;
      F2h: Vector_2H;
      a3, a1, a5, a: Integer;
      Z2h: Vector_2H;
      Zh: Vector_H;
      Zh_T3: Vector_H;
   begin
      Put_Line("Task T3 is started");

      -- Введення MS
      Put_Line("T3: Initializing MS");
      MS := Fill_Matrix;
      Put_Line("T3: MS initialized");

      -- Передати дані задачі T1: MS2Н, FН
      Put_Line("T3: Sending MS2hFh_fromT3 to T1");
      T1.MS2hFh_fromT3((for I in 1..N => MS(I)(1..2*H)), F2h(1..H));
      Put_Line("T3: Sent MS2hFh_fromT3 to T1");

      -- Прийняти дані від задачі T1: MA, X2H
      Put_Line("T3: Waiting for MAX2h_fromT1");
      accept MAX2h_fromT1(MA_IN: in Matrix_N; X2h_IN: in Vector_2H) do
         MA := MA_IN;
         X2h := X2h_IN;
      end MAX2h_fromT1;
      Put_Line("T3: Received MAX2h_fromT1");

      -- Прийняти дані від задачі T5: F2Н
      Put_Line("T3: Waiting for F2h_fromT5");
      accept F2h_fromT5(F2h_IN: in Vector_2H) do
         F2h := F2h_IN;
      end F2h_fromT5;
      Put_Line("T3: Received F2h_fromT5");

      -- Передати дані задачі T5: MA, MS2H, XH
      Put_Line("T3: Sending MAMS2hXh_fromT3 to T5");
      T5.MAMS2hXh_fromT3(MA, (for I in 1..N => MS(I)(1..2*H)), X2h(1..H));
      Put_Line("T3: Sent MAMS2hXh_fromT3 to T5");

      -- Передати дані задачі T4: MSH
      Put_Line("T3: Sending MSh_fromT3 to T4");
      T4.MSh_fromT3((for I in 1..N => MS(I)(1..H)));
      Put_Line("T3: Sent MSh_fromT3 to T4");

      -- Обчислення1: a3 = min(XН)
      Put_Line("T3: Calculating a3 = min(XH)");
      a3 := Find_Min(X2h(1..H));
      Put_Line("T3: a3 calculated: " & Integer'Image(a3));

      -- Прийняти a1 від задачі T1
      Put_Line("T3: Waiting for a1_fromT1");
      accept a1_fromT1(a1_IN: in Integer) do
         a1 := a1_IN;
      end a1_fromT1;
      Put_Line("T3: Received a1_fromT1: " & Integer'Image(a1));

      -- Обчислення2: a3 = min(a3, a1)
      a3 := Integer'Min(a3, a1);
      Put_Line("T3: a3 updated after min with a1: " & Integer'Image(a3));

      -- Прийняти a5 від задачі T5
      Put_Line("T3: Waiting for a5_fromT5");
      accept a5_fromT5(a5_IN: in Integer) do
         a5 := a5_IN;
      end a5_fromT5;
      Put_Line("T3: Received a5_fromT5: " & Integer'Image(a5));

      -- Обчислення2: a3 = min(a3, a5)
      a3 := Integer'Min(a3, a5);
      Put_Line("T3: a3 updated after min with a5: " & Integer'Image(a3));

      -- Передати a3 задачі T4
      Put_Line("T3: Sending a3 to T4");
      T4.a3_fromT3(a3);
      Put_Line("T3: Sent a3 to T4");

      -- Прийняти a від задачі T4
      Put_Line("T3: Waiting for a_fromT4");
      accept a_fromT4(a_IN: in Integer) do
         a := a_IN;
      end a_fromT4;
      Put_Line("T3: Received a_fromT4: " & Integer'Image(a));

      -- Передати a задачі T1
      Put_Line("T3: Sending a to T1");
      T1.a_fromT3(a);
      Put_Line("T3: Sent a to T1");

      -- Передати a задачі T5
      Put_Line("T3: Sending a to T5");
      T5.a_fromT3(a);
      Put_Line("T3: Sent a to T5");

      -- Обчислення3: Zh = X * (MA * MSh) + a * Fh
      Put_Line("T3: Calculating Zh");
      declare
         X_temp: Vector_N := (others => 0);
      begin
         for I in X2h'Range loop
            X_temp(I) := X2h(I);
         end loop;
         Zh_T3 := Calculate_Zh(X_temp, MA, (for I in 1..N => MS(I)(1..H)), a, F2h(1..H));
      end;
      Put_Line("T3: Zh calculated");

      -- Прийняти Z2H від задачі T5
      Put_Line("T3: Waiting for Z2h_fromT5");
      accept Z2h_fromT5(Z2h_IN: in Vector_2H) do
         Z2h := Z2h_IN;
      end Z2h_fromT5;
      Put_Line("T3: Received Z2h_fromT5");

      -- Прийняти Zh від задачі T4
      Put_Line("T3: Waiting for Zh_fromT4");
      accept Zh_fromT4(Zh_IN: in Vector_H) do
         Zh := Zh_IN;
      end Zh_fromT4;
      Put_Line("T3: Received Zh_fromT4");

      -- Передати Z4H задачі T1
      Put_Line("T3: Sending Z4h_fromT3 to T1");
      T1.Z4h_fromT3((Z2h & Zh & Zh_T3));
      Put_Line("T3: Sent Z4h_fromT3 to T1");

      Put_Line("Task T3 is finished");
   end T3;

   task body T4 is
      MA: Matrix_N;
      X2h: Vector_2H;
      MSh: Matrix_H;
      F2h: Vector_2H;
      a4, a2, a6, a3, a: Integer;
      Zh: Vector_H;
   begin
      Put_Line("Task T4 is started");

      -- Передати дані задачі T2: FН
      Put_Line("T4: Sending Fh_fromT4 to T2");
      T2.Fh_fromT4(F2h(1..H));
      Put_Line("T4: Sent Fh_fromT4 to T2");

      -- Прийняти дані від задачі T2: MA, X2H
      Put_Line("T4: Waiting for MAX2h_fromT2");
      accept MAX2h_fromT2(MA_IN: in Matrix_N; X2h_IN: in Vector_2H) do
         MA := MA_IN;
         X2h := X2h_IN;
      end MAX2h_fromT2;
      Put_Line("T4: Received MAX2h_fromT2");

      -- Прийняти дані від задачі T3: MSН
      Put_Line("T4: Waiting for MSh_fromT3");
      accept MSh_fromT3(MSh_IN: in Matrix_H) do
         MSh := MSh_IN;
      end MSh_fromT3;
      Put_Line("T4: Received MSh_fromT3");

      -- Прийняти дані від задачі T6: F2H
      Put_Line("T4: Waiting for F2h_fromT6");
      accept F2h_fromT6(F2h_IN: in Vector_2H) do
         F2h := F2h_IN;
      end F2h_fromT6;
      Put_Line("T4: Received F2h_fromT6");

      -- Передати дані задачі T6: XH
      Put_Line("T4: Sending MAXh_fromT4 to T6");
      T6.MAXh_fromT4(MA, X2h(1..H));
      Put_Line("T4: Sent MAXh_fromT4 to T6");

      -- Обчислення1: a4 = min(XН)
      Put_Line("T4: Calculating a4 = min(XH)");
      a4 := Find_Min(X2h(1..H));
      Put_Line("T4: a4 calculated: " & Integer'Image(a4));

      -- Прийняти a2 від задачі T2
      Put_Line("T4: Waiting for a2_fromT2");
      accept a2_fromT2(a2_IN: in Integer) do
         a2 := a2_IN;
      end a2_fromT2;
      Put_Line("T4: Received a2_fromT2: " & Integer'Image(a2));

      -- Обчислення2: a4 = min(a4, a2)
      a4 := Integer'Min(a4, a2);
      Put_Line("T4: a4 updated after min with a2: " & Integer'Image(a4));

      -- Прийняти a6 від задачі T6
      Put_Line("T4: Waiting for a6_fromT6");
      accept a6_fromT6(a6_IN: in Integer) do
         a6 := a6_IN;
      end a6_fromT6;
      Put_Line("T4: Received a6_fromT6: " & Integer'Image(a6));

      -- Обчислення2: a4 = min(a4, a6)
      a4 := Integer'Min(a4, a6);
      Put_Line("T4: a4 updated after min with a6: " & Integer'Image(a4));

      -- Прийняти a3 від задачі T3
      Put_Line("T4: Waiting for a3_fromT3");
      accept a3_fromT3(a3_IN: in Integer) do
         a3 := a3_IN;
      end a3_fromT3;
      Put_Line("T4: Received a3_fromT3: " & Integer'Image(a3));

      -- Обчислення2: a = min(a4, a3)
      a := Integer'Min(a4, a3);
      Put_Line("T4: a calculated: " & Integer'Image(a));

      -- Передати a задачі T2
      Put_Line("T4: Sending a to T2");
      T2.a_fromT4(a);
      Put_Line("T4: Sent a to T2");

      -- Передати a задачі T3
      Put_Line("T4: Sending a to T3");
      T3.a_fromT4(a);
      Put_Line("T4: Sent a to T3");

      -- Передати a задачі T6
      Put_Line("T4: Sending a to T6");
      T6.a_fromT4(a);
      Put_Line("T4: Sent a to T6");

      -- Обчислення3: Zh = X * (MA * MSh) + a * Fh
      Put_Line("T4: Calculating Zh");
      declare
         X_temp: Vector_N := (others => 0);
      begin
         for I in X2h'Range loop
            X_temp(I) := X2h(I);
         end loop;
         Zh := Calculate_Zh(X_temp, MA, MSh, a, F2h(1..H));
      end;
      Put_Line("T4: Zh calculated");

      -- Передати Zh задачі T3
      Put_Line("T4: Sending Zh to T3");
      T3.Zh_fromT4(Zh);
      Put_Line("T4: Sent Zh to T3");

      Put_Line("Task T4 is finished");
   end T4;

   task body T5 is
      MA: Matrix_N;
      MS2h: Matrix_2H;
      Xh: Vector_H;
      F3h: Vector_3H;
      a5, a: Integer;
      Zh: Vector_H;
   begin
      Put_Line("Task T5 is started");

      -- Передати дані задачі T3: F2H
      Put_Line("T5: Sending F2h_fromT5 to T3");
      T3.F2h_fromT5(F3h(1..2*H));
      Put_Line("T5: Sent F2h_fromT5 to T3");

      -- Прийняти дані від задачі T3: MA, MS2H, XH
      Put_Line("T5: Waiting for MAMS2hXh_fromT3");
      accept MAMS2hXh_fromT3(MA_IN: in Matrix_N; MS2h_IN: in Matrix_2H; Xh_IN: in Vector_H) do
         MA := MA_IN;
         MS2h := MS2h_IN;
         Xh := Xh_IN;
      end MAMS2hXh_fromT3;
      Put_Line("T5: Received MAMS2hXh_fromT3");

      -- Прийняти дані від задачі T6: F3H
      Put_Line("T5: Waiting for F3h_fromT6");
      accept F3h_fromT6(F3h_IN: in Vector_3H) do
         F3h := F3h_IN;
      end F3h_fromT6;
      Put_Line("T5: Received F3h_fromT6");

      -- Передати дані задачі T6: MSH, MA
      Put_Line("T5: Sending MAMSh_fromT5 to T6");
      T6.MAMSh_fromT5(MA, (for I in 1..N => MS2h(I)(1..H)));
      Put_Line("T5: Sent MAMSh_fromT5 to T6");

      -- Обчислення1: a5 = min(XН)
      Put_Line("T5: Calculating a5 = min(XH)");
      a5 := Find_Min(Xh);
      Put_Line("T5: a5 calculated: " & Integer'Image(a5));

      -- Передати a5 дані задачі T3
      Put_Line("T5: Sending a5 to T3");
      T3.a5_fromT5(a5);
      Put_Line("T5: Sent a5 to T3");

      -- Прийняти a від задачі T3
      Put_Line("T5: Waiting for a_fromT3");
      accept a_fromT3(a_IN: in Integer) do
         a := a_IN;
      end a_fromT3;
      Put_Line("T5: Received a_fromT3: " & Integer'Image(a));

      -- Обчислення3: Zh = X * (MA * MSh) + a * Fh
      Put_Line("T5: Calculating Zh");
      declare
         X_temp: Vector_N := (others => 0);
      begin
         for I in Xh'Range loop
            X_temp(I) := Xh(I);
         end loop;
         Zh := Calculate_Zh(X_temp, MA, (for I in 1..N => MS2h(I)(1..H)), a, F3h(1..H));
      end;
      Put_Line("T5: Zh calculated");

      -- Прийняти Zh від задачі T6
      Put_Line("T5: Waiting for Zh_fromT6");
      accept Zh_fromT6(Zh_IN: in Vector_H) do
         Zh := Zh_IN;
      end Zh_fromT6;
      Put_Line("T5: Received Zh_fromT6");

      -- Передати Z2H задачі T3
      Put_Line("T5: Sending Z2h_fromT5 to T3");
      T3.Z2h_fromT5((Zh & Zh));
      Put_Line("T5: Sent Z2h_fromT5 to T3");

      Put_Line("Task T5 is finished");
   end T5;

   task body T6 is
      F: Vector_N;
      MA: Matrix_N;
      Xh: Vector_H;
      MSh: Matrix_H;
      a6, a: Integer;
      Zh: Vector_H;
   begin
      Put_Line("Task T6 is started");

      -- Введення F
      Put_Line("T6: Initializing F");
      F := Fill_Vector;
      Put_Line("T6: F initialized");

      -- Передати дані задачі T4: F2H
      Put_Line("T6: Sending F2h_fromT6 to T4");
      T4.F2h_fromT6(F(1..2*H));
      Put_Line("T6: Sent F2h_fromT6 to T4");

      -- Прийняти дані від задачі T4: MA, XH
      Put_Line("T6: Waiting for MAXh_fromT4");
      accept MAXh_fromT4(MA_IN: in Matrix_N; Xh_IN: in Vector_H) do
         MA := MA_IN;
         Xh := Xh_IN;
      end MAXh_fromT4;
      Put_Line("T6: Received MAXh_fromT4");

      -- Передати дані задачі T5: F3H
      Put_Line("T6: Sending F3h_fromT6 to T5");
      T5.F3h_fromT6(F(1..3*H));
      Put_Line("T6: Sent F3h_fromT6 to T5");

      -- Прийняти дані від задачі T5: MA, MSH
      Put_Line("T6: Waiting for MAMSh_fromT5");
      accept MAMSh_fromT5(MA_IN: in Matrix_N; MSh_IN: in Matrix_H) do
         MA := MA_IN;
         MSh := MSh_IN;
      end MAMSh_fromT5;
      Put_Line("T6: Received MAMSh_fromT5");

      -- Обчислення1: a6 = min(XН)
      Put_Line("T6: Calculating a6 = min(XH)");
      a6 := Find_Min(Xh);
      Put_Line("T6: a6 calculated: " & Integer'Image(a6));

      -- Передати a6 дані задачі T4
      Put_Line("T6: Sending a6 to T4");
      T4.a6_fromT6(a6);
      Put_Line("T6: Sent a6 to T4");

      -- Прийняти a від задачі T4
      Put_Line("T6: Waiting for a_fromT4");
      accept a_fromT4(a_IN: in Integer) do
         a := a_IN;
      end a_fromT4;
      Put_Line("T6: Received a_fromT4: " & Integer'Image(a));

      -- Обчислення3: Zh = X * (MA * MSh) + a * Fh
      Put_Line("T6: Calculating Zh");
      declare
         X_temp: Vector_N := (others => 0);
      begin
         for I in Xh'Range loop
            X_temp(I) := Xh(I);
         end loop;
         Zh := Calculate_Zh(X_temp, MA, MSh, a, F(1..H));
      end;
      Put_Line("T6: Zh calculated");

      -- Передати Zh задачі T5
      Put_Line("T6: Sending Zh to T5");
      T5.Zh_fromT6(Zh);
      Put_Line("T6: Sent Zh to T5");

      Put_Line("Task T6 is finished");
   end T6;

begin
   Start_Time := Clock;
   Put_Line("Lab5 is started");

end Lab5;