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

function IsResultCorrect = SudokuVerifier(Sudo, Sudo_0_size, SubSudo_0_size)
    
	IsResultCorrect = 1;

	for i = 1:Sudo_0_size(1)
		for j = 1:Sudo_0_size(2)
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
			
            
            if (rem(i, SubSudo_0_size(1)) ~= 1) || (rem(j, SubSudo_0_size(2)) ~= 1)
                continue
            end
            
            [row, col] = find(Sudo(i:i + 2, j:j + 2) == Sudo(i, j));
            
			if length(col) > 1
				IsResultCorrect = 0;
				break;
			end
		end
		
		if IsResultCorrect == 0
			break
		end
		
	end