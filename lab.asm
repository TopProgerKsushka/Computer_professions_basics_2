ORG 004

X: WORD ? ; Х

XMAX: WORD 003F ; Максимально допустимое значение Х

XMIN: WORD -0040 ; Минимально допустимое значение Х

TEMPA: WORD ?

TEMPC: WORD ?

TMP: WORD ?

SIGNMASK: WORD 0080 ; Маска для получения знака числа с ВУ-2

ORG 010

BACK: WORD ? NOP MOV TEMPA ROL MOV TEMPC BR FLAG3 ; Ячейка для хранения адреса возврата ; Ячейка для отладочной точки остановки ; Сохранение содержимого аккумулятора ; Сохранение содержимого Carry флага ; Начало обработки прерываний

BEGIN: EI ; Начало основной программы, разрешение прерываний

CYCLE: CLA DI ADD X INC JSR CHECK EI MOV X BR CYCLE ; Цикл для инкремента значения X ; Проверка значения Х на принадлежность ОДЗ ; Запись значения Х

CHECK:

WORD ? SUB XMIN BMI FIX ADD XMIN SUB XMAX BPL FIX ADD XMAX BR (CHECK) ; Подпрограмма проверки принадлежности (А)ОДЗ ; Оставляет значение (А), если оно принадлежит ОДЗ

FIX:

CLA ADD XMIN BR (CHECK) ; Запись XMIN в А, если (А) вне ОДЗ

FLAG3: TSF 3 BR FLAG2 CLA ADD X ROL CLC CMA OUT 3 CLF 3 BR RETURN ; Опрос флага ВУ-3 ; Если он сброшен, то переход к опросу флага ВУ-2 ;X ;2X ;2X ;-2X-1 ; Переход к завершению обработки прерываний

FLAG2: TSF 2 BR OFLAGS CLA IN 2 CLF 2 MOV TMP AND SIGNMASK BEQ POSITIVE CLA CMA AND TMP BR EDITX ; Опрос флага ВУ-2 ; Если флаг ВУ-2 не установлен, то обработка прерывания от других ВУ ; Сохранение полученного значения ; Проверка знака числа ; Если отрицательное – заполняем старшие биты единицами

POSITIVE: ADD TMP

EDITX: AND X JSR CHECK MOV X BR RETURN ; Логическое умножение числа на Х ; Проверка на принадлежность ОДЗ ; Запись результата ; Переход к завершению обработки прерываний

OFLAGS: CLF 0 CLF 1 CLF 4 CLF 5 CLF 6 CLF 7 CLF 8 CLF 9 ; Сбрасывание флагов готовности остальных ВУ

RETURN:

CLA ADD TEMPC ROR CLA ADD TEMPA NOP EI BR (BACK) ; Восстановление значений А и С ; Возвращаемся к исходной программе
