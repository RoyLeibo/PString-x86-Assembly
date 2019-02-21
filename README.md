# PString-x86-Assembly
My implementation of PString in Assembly, which is a string that it's first byte represent it's length.
The programm includes 3 files: "Main", "Func_Select" and "pstring".
The "main" receives 5 inputs: length of first string, the first string, length of second string, the second string and a function number to activate on those strings.
The "func_select" file gets the inputs and calling the right function from the "pstring" file.
The function numbers are:
* 50: pstrlen - prints the strings length
* 51: replaceChar - replace a specific char in both string with a different char receives in the user's input.
* 52: pstrijcpy - copies and replaces sub string from string 2 in string 1 in the range receives by user.
* 53: swapCase - switch between big letter and small letters in both strings.
* 54: pstrijcmp - compares the ASCII value of both string in a range reveived from user.
