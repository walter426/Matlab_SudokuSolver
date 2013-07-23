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

function IsResultCorrect = SudokuVerifier(Sudo)

	IsResultCorrect = 1;

	for i = 1:9
		for j = 1:9
			[row, col] = find(Sudo(i, :) == Sudo(i, j));
			
			if length(row) > 1
				IsResultCorrect = 0;
				break;
			end
			
			
			[row, col] = find(Sudo(:, j) == Sudo(i, j));
			
			if length(col) > 1
				IsResultCorrect = 0;
				break;
			end
			
			row_start_l = 3*fix((i - 1)/3) + 1;
			col_start_l = 3*fix((j - 1)/3) + 1;
					
			[row, col] = find(Sudo(row_start_l : row_start_l + 2, col_start_l : col_start_l + 2) == Sudo(i, j));
			
			if length(col) > 1
				IsResultCorrect = 0;
				break;
			end
		end
		
		if IsResultCorrect == 0
			break
		end
		
	end