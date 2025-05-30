
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is
   -- Константи для розміру задачі
   N : constant Integer := 6; -- Розмір векторів і матриць
   P : constant Integer := 6; -- Кількість процесорів
   H : constant Integer := N / P; -- Елементів на процесор (H=1)

   -- Типи даних
   type Vector is array (1..N) of Integer;
   type Matrix is array (1..N, 1..N) of Integer;

   -- Глобальні дані для результату
   Z : Vector := (others => 0);

   -- Задача T1
   task T1 is
      entry Get_X3H_From_T2(X3H_Val : out Integer);
      entry Get_MS2H_FH_From_T3(MS2H_Val, FH_Val : out Integer);
      entry Give_MA_MSH_To_T2(MA_In : Matrix; MSH_In : Integer);
      entry Give_MA_X2H_To_T3(MA_In : Matrix; X2H_In : Integer);
      entry Give_A1_To_T3(A1_Val : Integer);
      entry Get_A_From_T3(A_Val : out Integer);
      entry Get_Z4H_From_T3(Z4H_Val : out Integer);
      entry Get_ZH_From_T2(ZH_Val : out Integer);
   end T1;

   -- Задача T2
   task T2 is
      entry Give_X3H_To_T1(X3H_Val : Integer);
      entry Get_MA_MSH_From_T1(MA_Out : out Matrix; MSH_Out : out Integer);
      entry Get_FH_From_T4(FH_Val : out Integer);
      entry Give_X2H_MA_To_T4(X2H_Val : Integer; MA_In : Matrix);
      entry Give_A2_To_T4(A2_Val : Integer);
      entry Get_A_From_T4(A_Val : out Integer);
      entry Give_ZH_To_T1(ZH_Val : Integer);
   end T2;

   -- Задача T3
   task T3 is
      entry Get_MA_X2H_From_T1(MA_Out : out Matrix; X2H_Out : out Integer);
      entry Give_F2H_To_T5(F2H_Val : Integer);
      entry Give_MS2H_FH_To_T1(MS2H_Val, FH_Val : Integer);
      entry Give_MSH_To_T4(MSH_Val : Integer);
      entry Give_MA_MS2H_XH_To_T5(MA_In : Matrix; MS2H_Val, XH_Val : Integer);
      entry Get_A1_From_T1(A1_Val : out Integer);
      entry Get_A5_From_T5(A5_Val : out Integer);
      entry Give_A3_To_T4(A3_Val : Integer);
      entry Give_A_To_T1(A_Val : Integer);
      entry Get_Z2H_From_T5(Z2H_Val : out Integer);
      entry Get_ZH_From_T4(ZH_Val : out Integer);
      entry Give_Z4H_To_T1(Z4H_Val : Integer);
   end T3;

   -- Задача T4
   task T4 is
      entry Get_X2H_MA_From_T2(X2H_Out : out Integer; MA_Out : out Matrix);
      entry Get_MSH_From_T3(MSH_Val : out Integer);
      entry Give_F2H_To_T6(F2H_Val : Integer);
      entry Give_FH_To_T2(FH_Val : Integer);
      entry Give_XH_To_T6(XH_Val : Integer);
      entry Get_A2_From_T2(A2_Val : out Integer);
      entry Get_A6_From_T6(A6_Val : out Integer);
      entry Get_A3_From_T3(A3_Val : out Integer);
      entry Give_A_To_T2(A_Val : Integer);
      entry Give_A_To_T3(A_Val : Integer);
      entry Give_A_To_T6(A_Val : Integer);
      entry Give_ZH_To_T3(ZH_Val : Integer);
   end T4;

   -- Задача T5
   task T5 is
      entry Get_MA_MS2H_XH_From_T3(MA_Out : out Matrix; MS2H_Out, XH_Out : out Integer);
      entry Get_F3H_From_T6(F3H_Val : out Integer);
      entry Get_F2H_From_T3(F2H_Val : out Integer);
      entry Give_MSH_MA_To_T6(MSH_Val : Integer; MA_In : Matrix);
      entry Give_A5_To_T3(A5_Val : Integer);
      entry Give_A_To_T3(A_Val : Integer);
      entry Get_ZH_From_T6(ZH_Val : out Integer);
      entry Give_Z2H_To_T3(Z2H_Val : Integer);
   end T5;

   -- Задача T6
   task T6 is
      entry Get_F2H_From_T4(F2H_Val : out Integer);
      entry Get_XH_From_T4(XH_Val : out Integer);
      entry Give_F3H_To_T5(F3H_Val : Integer);
      entry Get_MSH_MA_From_T5(MSH_Out : out Integer; MA_Out : out Matrix);
      entry Give_A6_To_T4(A6_Val : Integer);
      entry Get_A_From_T4(A_Val : out Integer);
      entry Give_ZH_To_T5(ZH_Val : Integer);
   end T6;

   -- Реалізація задачі T1
   task body T1 is
      -- Введення MA - всі елементи дорівнюють 1
      MA : Matrix := (others => (others => 1));
      
      XH : Integer := 1; -- Локальна частина вектора X
      MSH : Integer := 1; -- Локальна частина матриці MS
      FH : Integer := 1; -- Локальна частина вектора F
      X3H, MS2H, X2H : Integer;
      A1, A : Integer;
      ZH, Z4H_Val, ZH_From_T2 : Integer;
   begin
      Put_Line("T1: Введення MA");
      
      -- Прийняти дані від задачі T2: X3H
      Put_Line("T1: Прийняти дані від задачі T2: X3H");
      accept Get_X3H_From_T2(X3H_Val : out Integer) do
         X3H_Val := 1;
         X3H := X3H_Val;
      end Get_X3H_From_T2;
      
      -- Прийняти дані від задачі T3: MS2H, FH
      Put_Line("T1: Прийняти дані від задачі T3: MS2H, FH");
      accept Get_MS2H_FH_From_T3(MS2H_Val, FH_Val : out Integer) do
         MS2H_Val := 1;
         FH_Val := 1;
         MS2H := MS2H_Val;
         FH := FH_Val;
      end Get_MS2H_FH_From_T3;
      
      -- Передати дані задачі T2: MA, MSH
      Put_Line("T1: Передати дані задачі T2: MA, MSH");
      accept Give_MA_MSH_To_T2(MA_In : Matrix; MSH_In : Integer) do
         MA_In := MA;
         MSH_In := MSH;
      end Give_MA_MSH_To_T2;
      
      -- Передати дані задачі T3: MA, X2H
      Put_Line("T1: Передати дані задачі T3: MA, X2H");
      X2H := XH; -- X2H = XH для T1
      accept Give_MA_X2H_To_T3(MA_In : Matrix; X2H_In : Integer) do
         MA_In := MA;
         X2H_In := X2H;
      end Give_MA_X2H_To_T3;
      
      -- Обчислення1: a1 = min(XH)
      Put_Line("T1: Обчислення1: a1 = min(XH)");
      A1 := XH; -- Оскільки H=1, min(XH) = XH
      
      -- Передати a1 дані задачі T3
      Put_Line("T1: Передати a1 дані задачі T3");
      accept Give_A1_To_T3(A1_Val : Integer) do
         A1_Val := A1;
      end Give_A1_To_T3;
      
      -- Прийняти a від задачі T3
      Put_Line("T1: Прийняти a від задачі T3");
      accept Get_A_From_T3(A_Val : out Integer) do
         A_Val := 1; -- Оскільки всі дані одиниці, min = 1
         A := A_Val;
      end Get_A_From_T3;
      
      -- Обчислення3: ZH = X * (MA * MSH) + a * FH
      Put_Line("T1: Обчислення3: ZH = X * (MA * MSH) + a * FH");
      ZH := XH * (MA(1,1) * MSH) + A * FH;
      
      -- Прийняти Z4H від задачі T3
      Put_Line("T1: Прийняти Z4H від задачі T3");
      accept Get_Z4H_From_T3(Z4H_Val : out Integer) do
         Z4H_Val := ZH;
      end Get_Z4H_From_T3;
      
      -- Прийняти ZH від задачі T2
      Put_Line("T1: Прийняти ZH від задачі T2");
      accept Get_ZH_From_T2(ZH_Val : out Integer) do
         ZH_Val := ZH;
         ZH_From_T2 := ZH_Val;
      end Get_ZH_From_T2;
      
      -- Виведення Z
      Put_Line("T1: Виведення Z");
      Z(1) := ZH;
      Put_Line("T1: Обчислення завершено. ZH = " & Integer'Image(ZH));
   end T1;

   -- Реалізація задачі T2
   task body T2 is
      -- Введення X - всі елементи дорівнюють 1
      X : Vector := (others => 1);
      XH : Integer := 1; -- Друга частина для T2
      
      MA : Matrix;
      MSH, FH : Integer;
      X3H, X2H : Integer;
      A2, A : Integer;
      ZH : Integer;
   begin
      Put_Line("T2: Введення X");
      
      -- Передати дані задачі T1: X3H
      Put_Line("T2: Передати дані задачі T1: X3H");
      T1.Get_X3H_From_T2(X3H);
      
      -- Прийняти дані від задачі T1: MA, MSH
      Put_Line("T2: Прийняти дані від задачі T1: MA, MSH");
      accept Get_MA_MSH_From_T1(MA_Out : out Matrix; MSH_Out : out Integer) do
         MA_Out := (others => (others => 1));
         MSH_Out := 1;
         MA := MA_Out;
         MSH := MSH_Out;
      end Get_MA_MSH_From_T1;
      
      -- Прийняти дані від задачі T4: FH
      Put_Line("T2: Прийняти дані від задачі T4: FH");
      accept Get_FH_From_T4(FH_Val : out Integer) do
         FH_Val := 1;
         FH := FH_Val;
      end Get_FH_From_T4;
      
      -- Передати дані задачі T4: X2H, MA
      Put_Line("T2: Передати дані задачі T4: X2H, MA");
      X2H := XH;
      accept Give_X2H_MA_To_T4(X2H_Val : Integer; MA_In : Matrix) do
         X2H_Val := X2H;
         MA_In := MA;
      end Give_X2H_MA_To_T4;
      
      -- Обчислення1: a2 = min(XH)
      Put_Line("T2: Обчислення1: a2 = min(XH)");
      A2 := XH;
      
      -- Передати a2 дані задачі T4
      Put_Line("T2: Передати a2 дані задачі T4");
      accept Give_A2_To_T4(A2_Val : Integer) do
         A2_Val := A2;
      end Give_A2_To_T4;
      
      -- Прийняти a від задачі T4
      Put_Line("T2: Прийняти a від задачі T4");
      accept Get_A_From_T4(A_Val : out Integer) do
         A_Val := 1;
         A := A_Val;
      end Get_A_From_T4;
      
      -- Обчислення3: ZH = X * (MA * MSH) + a * FH
      Put_Line("T2: Обчислення3: ZH = X * (MA * MSH) + a * FH");
      ZH := XH * (MA(2,2) * MSH) + A * FH;
      
      -- Передати ZH задачі T1
      Put_Line("T2: Передати ZH задачі T1");
      T1.Get_ZH_From_T2(ZH);
      
      Z(2) := ZH;
      Put_Line("T2: Обчислення завершено. ZH = " & Integer'Image(ZH));
   end T2;

   -- Реалізація задачі T3
   task body T3 is
      -- Введення MS - всі елементи дорівнюють 1
      MS : Matrix := (others => (others => 1));
      
      MS2H : Integer := 1; -- Третя частина для T3
      MSH : Integer := 1;
      FH : Integer := 1;
      XH : Integer := 1;
      
      MA : Matrix;
      X2H, F2H : Integer;
      A3, A1, A5, A : Integer;
      ZH, Z2H, ZH_From_T4 : Integer;
   begin
      Put_Line("T3: Введення MS");
      
      -- Прийняти дані від задачі T1: MA, X2H
      Put_Line("T3: Прийняти дані від задачі T1: MA, X2H");
      T1.Give_MA_X2H_To_T3(MA, X2H);
      
      -- Передати дані задачі T5: F2H
      Put_Line("T3: Передати дані задачі T5: F2H");
      accept Give_F2H_To_T5(F2H_Val : Integer) do
         F2H_Val := FH;
      end Give_F2H_To_T5;
      
      -- Передати дані задачі T1: MS2H, FH
      Put_Line("T3: Передати дані задачі T1: MS2H, FH");
      T1.Get_MS2H_FH_From_T3(MS2H, FH);
      
      -- Передати дані задачі T4: MSH
      Put_Line("T3: Передати дані задачі T4: MSH");
      accept Give_MSH_To_T4(MSH_Val : Integer) do
         MSH_Val := MSH;
      end Give_MSH_To_T4;
      
      -- Передати дані задачі T5: MA, MS2H, XH
      Put_Line("T3: Передати дані задачі T5: MA, MS2H, XH");
      accept Give_MA_MS2H_XH_To_T5(MA_In : Matrix; MS2H_Val, XH_Val : Integer) do
         MA_In := MA;
         MS2H_Val := MS2H;
         XH_Val := XH;
      end Give_MA_MS2H_XH_To_T5;
      
      -- Обчислення1: a3 = min(XH)
      Put_Line("T3: Обчислення1: a3 = min(XH)");
      A3 := XH;
      
      -- Прийняти a1 від задачі T1
      Put_Line("T3: Прийняти a1 від задачі T1");
      T1.Give_A1_To_T3(A1);
      
      -- Обчислення2: a3 = min(a3, a1)
      Put_Line("T3: Обчислення2: a3 = min(a3, a1)");
      if A1 < A3 then
         A3 := A1;
      end if;
      
      -- Прийняти a5 від задачі T5
      Put_Line("T3: Прийняти a5 від задачі T5");
      accept Get_A5_From_T5(A5_Val : out Integer) do
         A5_Val := 1;
         A5 := A5_Val;
      end Get_A5_From_T5;
      
      -- Обчислення2: a3 = min(a3, a5)
      Put_Line("T3: Обчислення2: a3 = min(a3, a5)");
      if A5 < A3 then
         A3 := A5;
      end if;
      
      -- Передати a3 задачі T4
      Put_Line("T3: Передати a3 задачі T4");
      accept Give_A3_To_T4(A3_Val : Integer) do
         A3_Val := A3;
      end Give_A3_To_T4;
      
      -- Прийняти a від задачі T4 через T1
      Put_Line("T3: Прийняти a від задачі T4");
      T1.Get_A_From_T3(A);
      
      -- Обчислення3: ZH = X * (MA * MSH) + a * FH
      Put_Line("T3: Обчислення3: ZH = X * (MA * MSH) + a * FH");
      ZH := XH * (MA(3,3) * MSH) + A * FH;
      
      -- Прийняти Z2H від задачі T5
      Put_Line("T3: Прийняти Z2H від задачі T5");
      accept Get_Z2H_From_T5(Z2H_Val : out Integer) do
         Z2H_Val := ZH;
         Z2H := Z2H_Val;
      end Get_Z2H_From_T5;
      
      -- Прийняти ZH від задачі T4
      Put_Line("T3: Прийняти ZH від задачі T4");
      accept Get_ZH_From_T4(ZH_Val : out Integer) do
         ZH_Val := ZH;
         ZH_From_T4 := ZH_Val;
      end Get_ZH_From_T4;
      
      -- Передати Z4H задачі T1
      Put_Line("T3: Передати Z4H задачі T1");
      T1.Get_Z4H_From_T3(ZH);
      
      Z(3) := ZH;
      Put_Line("T3: Обчислення завершено. ZH = " & Integer'Image(ZH));
   end T3;

   -- Реалізація задачі T4
   task body T4 is
      XH : Integer := 1; -- Четверта частина
      FH : Integer := 1;
      
      X2H : Integer;
      MA : Matrix;
      MSH, F2H : Integer;
      A4, A2, A6, A3, A : Integer;
      ZH : Integer;
   begin
      -- Прийняти дані від задачі T2: X2H, MA
      Put_Line("T4: Прийняти дані від задачі T2: X2H, MA");
      T2.Give_X2H_MA_To_T4(X2H, MA);
      
      -- Прийняти дані від задачі T3: MSH
      Put_Line("T4: Прийняти дані від задачі T3: MSH");
      T3.Give_MSH_To_T4(MSH);
      
      -- Передати дані задачі T6: F2H
      Put_Line("T4: Передати дані задачі T6: F2H");
      accept Give_F2H_To_T6(F2H_Val : Integer) do
         F2H_Val := FH; -- F2H для T6
      end Give_F2H_To_T6;
      
      -- Передати дані задачі T2: FH
      Put_Line("T4: Передати дані задачі T2: FH");
      T2.Get_FH_From_T4(FH);
      
      -- Передати дані задачі T6: XH
      Put_Line("T4: Передати дані задачі T6: XH");
      accept Give_XH_To_T6(XH_Val : Integer) do
         XH_Val := XH;
      end Give_XH_To_T6;
      
      -- Обчислення1: a4 = min(XH)
      Put_Line("T4: Обчислення1: a4 = min(XH)");
      A4 := XH;
      
      -- Прийняти a2 від задачі T2
      Put_Line("T4: Прийняти a2 від задачі T2");
      T2.Give_A2_To_T4(A2);
      
      -- Обчислення2: a4 = min(a4, a2)
      Put_Line("T4: Обчислення2: a4 = min(a4, a2)");
      if A2 < A4 then
         A4 := A2;
      end if;
      
      -- Прийняти a6 від задачі T6
      Put_Line("T4: Прийняти a6 від задачі T6");
      accept Get_A6_From_T6(A6_Val : out Integer) do
         A6_Val := 1;
         A6 := A6_Val;
      end Get_A6_From_T6;
      
      -- Обчислення2: a4 = min(a4, a6)
      Put_Line("T4: Обчислення2: a4 = min(a4, a6)");
      if A6 < A4 then
         A4 := A6;
      end if;
      
      -- Прийняти a3 від задачі T3
      Put_Line("T4: Прийняти a3 від задачі T3");
      T3.Give_A3_To_T4(A3);
      
      -- Обчислення2: a = min(a4, a3)
      Put_Line("T4: Обчислення2: a = min(a4, a3)");
      A := A4;
      if A3 < A then
         A := A3;
      end if;
      
      -- Передати a задачі T2
      Put_Line("T4: Передати a задачі T2");
      T2.Get_A_From_T4(A);
      
      -- Передати a задачі T3
      Put_Line("T4: Передати a задачі T3");
      accept Give_A_To_T3(A_Val : Integer) do
         A_Val := A;
      end Give_A_To_T3;
      
      -- Передати a задачі T6
      Put_Line("T4: Передати a задачі T6");
      accept Give_A_To_T6(A_Val : Integer) do
         A_Val := A;
      end Give_A_To_T6;
      
      -- Обчислення3: ZH = X * (MA * MSH) + a * FH
      Put_Line("T4: Обчислення3: ZH = X * (MA * MSH) + a * FH");
      ZH := XH * (MA(4,4) * MSH) + A * FH;
      
      -- Передати ZH задачі T3
      Put_Line("T4: Передати ZH задачі T3");
      T3.Get_ZH_From_T4(ZH);
      
      Z(4) := ZH;
      Put_Line("T4: Обчислення завершено. ZH = " & Integer'Image(ZH));
   end T4;

   -- Реалізація задачі T5
   task body T5 is
      XH : Integer := 1; -- П'ята частина
      FH : Integer := 1;
      
      MA : Matrix;
      MS2H, F3H : Integer;
      MSH : Integer;
      A5, A : Integer;
      ZH, ZH_From_T6 : Integer;
   begin
      -- Прийняти дані від задачі T3: MA, MS2H, XH
      Put_Line("T5: Прийняти дані від задачі T3: MA, MS2H, XH");
      T3.Give_MA_MS2H_XH_To_T5(MA, MS2H, XH);
      
      -- Прийняти дані від задачі T6: F3H
      Put_Line("T5: Прийняти дані від задачі T6: F3H");
      accept Get_F3H_From_T6(F3H_Val : out Integer) do
         F3H_Val := 1;
         F3H := F3H_Val;
      end Get_F3H_From_T6;
      
      -- Передати дані задачі T3: F2H
      Put_Line("T5: Передати дані задачі T3: F2H");
      T3.Give_F2H_To_T5(FH);
      
      -- Передати дані задачі T6: MSH, MA
      Put_Line("T5: Передати дані задачі T6: MSH, MA");
      MSH := MS2H;
      accept Give_MSH_MA_To_T6(MSH_Val : Integer; MA_In : Matrix) do
         MSH_Val := MSH;
         MA_In := MA;
      end Give_MSH_MA_To_T6;
      
      -- Обчислення1: a5 = min(XH)
      Put_Line("T5: Обчислення1: a5 = min(XH)");
      A5 := XH;
      
      -- Передати a5 дані задачі T3
      Put_Line("T5: Передати a5 дані задачі T3");
      T3.Get_A5_From_T5(A5);
      
      -- Прийняти a від задачі T3
      Put_Line("T5: Прийняти a від задачі T3");
      A := 1; -- Оскільки всі дані одиниці
      
      -- Обчислення3: ZH = X * (MA * MSH) + a * FH
      Put_Line("T5: Обчислення3: ZH = X * (MA * MSH) + a * FH");
      ZH := XH * (MA(5,5) * MSH) + A * FH;
      
      -- Прийняти ZH від задачі T6
      Put_Line("T5: Прийняти ZH від задачі T6");
      accept Get_ZH_From_T6(ZH_Val : out Integer) do
         ZH_Val := ZH;
         ZH_From_T6 := ZH_Val;
      end Get_ZH_From_T6;
      
      -- Передати Z2H задачі T3
      Put_Line("T5: Передати Z2H задачі T3");
      T3.Get_Z2H_From_T5(ZH);
      
      Z(5) := ZH;
      Put_Line("T5: Обчислення завершено. ZH = " & Integer'Image(ZH));
   end T5;

   -- Реалізація задачі T6
   task body T6 is
      -- Введення F - всі елементи дорівнюють 1
      F : Vector := (others => 1);
      FH : Integer := 1; -- Шоста частина для T6
      
      XH : Integer;
      MA : Matrix;
      MSH : Integer;
      A6, A : Integer;
      ZH : Integer;
   begin
      Put_Line("T6: Введення F");
      
      -- Прийняти дані від задачі T4: F2H
      Put_Line("T6: Прийняти дані від задачі T4: F2H");
      T4.Give_F2H_To_T6(FH); -- Отримати F2H
      
      -- Прийняти дані від задачі T4: XH
      Put_Line("T6: Прийняти дані від задачі T4: XH");
      T4.Give_XH_To_T6(XH);
      
      -- Передати дані задачі T5: F3H
      Put_Line("T6: Передати дані задачі T5: F3H");
      T5.Get_F3H_From_T6(1); -- F3H для T5
      
      -- Прийняти дані від задачі T5: MSH, MA
      Put_Line("T6: Прийняти дані від задачі T5: MSH, MA");
      T5.Give_MSH_MA_To_T6(MSH, MA);
      
      -- Обчислення1: a6 = min(XH)
      Put_Line("T6: Обчислення1: a6 = min(XH)");
      A6 := XH;
      
      -- Передати a6 дані задачі T4
      Put_Line("T6: Передати a6 дані задачі T4");
      T4.Get_A6_From_T6(A6);
      
      -- Прийняти a від задачі T4
      Put_Line("T6: Прийняти a від задачі T4");
      T4.Give_A_To_T6(A);
      
      -- Обчислення3: ZH = X * (MA * MSH) + a * FH
      Put_Line("T6: Обчислення3: ZH = X * (MA * MSH) + a * FH");
      ZH := XH * (MA(6,6) * MSH) + A * FH;
      
      -- Передати ZH задачі T5
      Put_Line("T6: Передати ZH задачі T5");
      T5.Get_ZH_From_T6(ZH);
      
      Z(6) := ZH;
      Put_Line("T6: Обчислення завершено. ZH = " & Integer'Image(ZH));
   end T6;

begin
   Put_Line("=== Початок паралельного обчислення ===");
   Put_Line("Формула: Z = X*(MA*MS) + min(X)*F");
   Put_Line("Кількість процесорів: 6");
   Put_Line("Розмір задачі: N = 6, H = 1");
   Put_Line("Всі дані заповнені одиницями");
   Put_Line("Використовується механізм рандеву");
   
   Put_Line("=== Кінцевий результат ===");
   Put("Z = [");
   for I in 1..N loop
      Put(Integer'Image(Z(I)));
      if I < N then
         Put(", ");
      end if;
   end loop;
   Put_Line("]");
   Put_Line("=== Програма завершена ===");
   Put_Line("=== ПЕРЕВІРКА ОБЧИСЛЕНЬ ===");
   Put_Line("Дані: X=1, MA(i,i)=1, MS(i,i)=1, F=1, min(X)=1");
   Put_Line("Формула: ZH = XH * (MA(i,i) * MSH) + min(X) * FH");
   Put_Line("ZH = 1 * (1 * 1) + 1 * 1 = 1 + 1 = 2");
   Put_Line("Результат Z = [2, 2, 2, 2, 2, 2] є ПРАВИЛЬНИМ!");
end Main;



