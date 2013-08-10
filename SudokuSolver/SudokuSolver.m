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

function [Sudo_End, Sudo_Cand, IsSudoComplete, IsResultCorrect, NumOfGuess] = SudokuSolver(Sudo_0, Sudo_0_size, SubSudo_0_size)
	NumOfGuess = 0;
	
	%Solve Sudo logically
	[Sudo_End, Sudo_Cand, IsSudoComplete, IsResultCorrect] = SudokuLogicSolver(Sudo_0, Sudo_0_size, SubSudo_0_size);

	if IsSudoComplete == 1 || IsResultCorrect == 0
		return
	end

	%Get Candidates Count 
	Sudo_CandCnt = sum(Sudo_Cand, ndims(Sudo_Cand));
	
	%Find unfilled blocks with the minimum candidate count
	for MinCandCnt = 2:Sudo_0_size(1)
		[row, col] = find(Sudo_CandCnt == MinCandCnt);
		
		NumOfBlks_MinCand = length(row);
		
		if NumOfBlks_MinCand > 0
			break;
		end
	end


	%Fill in the blocks with its candidate, and Solve Sudo logically again one by one. 
	%Do Above process recursively untill the result is wrong or complete
	i_l = row(1);
	j_l = col(1);
	
	for k = 1:Sudo_0_size(1)
		if Sudo_Cand(i_l, j_l, k) == 0
			continue;
		end
		
		Sudo_G = Sudo_End;
		Sudo_G(i_l, j_l) = k;

		NumOfGuess = NumOfGuess + 1;
		[Sudo_G_End, Sudo_G_Cand, IsSudoComplete_G, IsResultCorrect_G, NumOfGuess_G] = SudokuSolver(Sudo_G, Sudo_0_size, SubSudo_0_size);
		NumOfGuess = NumOfGuess + NumOfGuess_G;

		if (IsSudoComplete_G == 1 && IsResultCorrect_G == 1)
			Sudo_End = Sudo_G_End;
			Sudo_Cand = Sudo_G_Cand;
			IsSudoComplete = IsSudoComplete_G;
			IsResultCorrect = IsResultCorrect_G;
			break;
		end
	end
	
	
	
	