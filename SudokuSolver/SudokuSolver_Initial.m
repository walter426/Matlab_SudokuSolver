%{
/***************************************************************************
         SudokuSolver_Initial  - A Tool to solve sudoku by the fastest way
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

function [Sudo_End, Sudo_Cand, IsSudoComplete, IsResultCorrect, NumOfGuess] = SudokuSolver_Initial(Sudo_0)
    Sudo_End = [];
    Sudo_Cand = [];
    IsSudoComplete= 0;
    IsResultCorrect = 1;
    NumOfGuess = 0;
    
    Sudo_0_size = size(Sudo_0);

    %Check whether each dimension of the sudo is equal or not
    if isempty(find(Sudo_0_size/Sudo_0_size(1) ~= 1)) == 0
        display('The size of the sudo is not valid')
        return
    end
    
    SubSudo_0_size = sqrt(Sudo_0_size);
    
    %Check whether each dimension of the Sudo fullfill n^2, where n is integer
    %Since the length of any dimension of a Sudo is equal to the square of the length of the dimension of the sub-sudo.  
    %if isempty(find(rem(SubSudo_0_size, 1) ~= 0)) == 0
    if rem(SubSudo_0_size(1), 1) > 0
        display('The size of the sudo is not valid1')
        return
    end


    %Count start time
    display(strcat('Start Time: ', datestr(now, 'HH:MM:SS')))

    [Sudo_End, Sudo_Cand, IsSudoComplete, IsResultCorrect, NumOfGuess] = SudokuSolver(Sudo_0, Sudo_0_size, SubSudo_0_size);

    %Count End time
    display(strcat('End Time: ', datestr(now, 'HH:MM:SS')))

	
	
	
	
	