%{
/***************************************************************************
         SudokuSolver  - A Tool to solve sudoku by the fastest way
                             -------------------
    begin                : 2013-07-23
    copyright            : (C) 2013 by Walter Tsui
    email                : waltertech426@gmail.com
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

%}

clc
clear

%Normal Sudoku
%%{
Sudo_0 = [
        7, 5, 0, 0, 9, 0, 0, 0, 2;
        0, 0, 0, 4, 0, 7, 0, 0, 0;
        0, 0, 3, 0, 2, 0, 0, 0, 6;
        0, 3, 0, 0, 0, 0, 9, 0, 0;
        0, 0, 0, 6, 0, 1, 0, 0, 0;
        0, 0, 8, 0, 0, 0, 0, 7, 0;
        5, 0, 0, 0, 6, 0, 1, 0, 0;
        0, 0, 0, 9, 0, 5, 0, 0, 0;
        1, 0, 0, 0, 8, 0, 0, 2, 4;
        ];
%%}

%Hardest Sudoku 
%%{
Sudo_0 = [
        8, 0, 0, 0, 0, 0, 0, 0, 0;
        0, 0, 3, 6, 0, 0, 0, 0, 0;
        0, 7, 0, 0, 9, 0, 2, 0, 0;
        0, 5, 0, 0, 0, 7, 0, 0, 0;
        0, 0, 0, 0, 4, 5, 7, 0, 0;
        0, 0, 0, 1, 0, 0, 0, 3, 0;
        0, 0, 1, 0, 0, 0, 0, 6, 8;
        0, 0, 8, 5, 0, 0, 0, 1, 0;
        0, 9, 0, 0, 0, 0, 4, 0, 0;
        ];
%%}

%Start solving
[Sudo_End, Sudo_Cand, IsSudoComplete, IsResultCorrect, NumOfGuess] = SudokuSolver_Initial(Sudo_0);

if isempty(Sudo_End) == 1
    return
end

%Display the result
Sudo_CandCnt = sum(Sudo_Cand, ndims(Sudo_Cand));

display(Sudo_End)
display(Sudo_CandCnt)