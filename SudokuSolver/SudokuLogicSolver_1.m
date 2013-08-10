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

function [Sudo_End, Sudo_Cand, IsSudoComplete, IsResultCorrect] = SudokuLogicSolver(Sudo_0, Sudo_0_size, SubSudo_0_size)

	Sudo_End = Sudo_0;
	Sudo_Cand = ones([Sudo_0_size, Sudo_0_size(1)]);

	max_iteration = 1000;
	
	IsSudoComplete = 0;
	IsResultCorrect = 1;
	

    if isempty(find(Sudo_End == 0)) == 1
		IsSudoComplete = 1;
		IsResultCorrect = SudokuVerifier(Sudo_End, Sudo_0_size, SubSudo_0_size);
		return
	end

	Sudo_End_prev = ones(Sudo_0_size(1));
	NumOfNoFilling = 0;
	
	for iter = 1:max_iteration
        if isempty(find(Sudo_End - Sudo_End_prev)) == 1 
			NumOfNoFilling = NumOfNoFilling + 1;
			
			if NumOfNoFilling >= 2
				break;
			end
		else
			NumOfNoFilling = 0;
		end
		
		Sudo_End_prev = Sudo_End;
		
		for i = 1:Sudo_0_size(1)
			for j = 1:Sudo_0_size(2)
				%Omit invalid candidates of the filled position
				if Sudo_End(i, j) ~= 0
					for k = 1:Sudo_0_size(1)
						if k ~= Sudo_End(i, j)
							Sudo_Cand(i, j, k) = 0;
						end
					end

					continue;
					
				%if number of candidates is zero, it implies the solution is wrong
				elseif sum(Sudo_Cand(i, j, :)) == 0
					IsResultCorrect = 0;
					return
				end


				%Omit candidates in row
				[row, col] = find(Sudo_End(i, :));
				NumOfBlocksFilled = length(row);

				if NumOfBlocksFilled > 0
					row = row + i - 1;

					for k = 1:NumOfBlocksFilled
						Sudo_Cand(i, j, Sudo_End(row(k), col(k))) = 0;
					end
				end
				
				
				%Omit candidates in column
				[row, col] = find(Sudo_End(:, j));
				NumOfBlocksFilled = length(col);

				if NumOfBlocksFilled > 0
					col = col + j - 1;

					for k = 1:NumOfBlocksFilled
						Sudo_Cand(i, j, Sudo_End(row(k), col(k))) = 0;
					end
				end

				
				%Omit candidates in local 3 x 3 matrix
				row_start_l = 3*fix((i - 1)/3) + 1;
				col_start_l = 3*fix((j - 1)/3) + 1;
                
                SubSudo_rng_row = [row_start_l : row_start_l + SubSudo_0_size(1) - 1];
                SubSudo_rng_col = [col_start_l : col_start_l + SubSudo_0_size(2) - 1];

                if (rem(i, SubSudo_0_size(1)) == 0) && (rem(j, SubSudo_0_size(2)) == 0)
                    [row, col] = find(Sudo_End(SubSudo_rng_row, SubSudo_rng_col));
                    NumOfBlocksFilled = length(col);

                    if NumOfBlocksFilled > 0
                        row = row + row_start_l - 1;
                        col = col + col_start_l - 1;

                        for k = 1:NumOfBlocksFilled
                            Sudo_Cand(i, j, Sudo_End(row(k), col(k))) = 0;
                        end
                    end

                    %If n empty blocks has n identical cnadiates in the row or col of a local
                    %matrix, those candidates can be omitted from the other row or
                    %col
                    
                    %%{
                    SubSudo_0 = Sudo_End(SubSudo_rng_row, SubSudo_rng_col);
                    SubSudo_Cand = Sudo_Cand(SubSudo_rng_row, SubSudo_rng_col, :);

                    %Check row by row
                    %SubSudo_Cand = Sudoku_OmitCandInSubSudoFrmDimN(SubSudo_0, SubSudo_Cand, Sudo_0_size, SubSudo_0_size, 1);
                    %Check col by col
                    %SubSudo_Cand = Sudoku_OmitCandInSubSudoFrmDimN(SubSudo_0, SubSudo_Cand, Sudo_0_size, SubSudo_0_size, 2);

                    SubSudo_Cand = Sudoku_OmitCandInSubSudoFrmDim1(SubSudo_0, SubSudo_Cand, Sudo_0_size, SubSudo_0_size);
                    SubSudo_Cand = Sudoku_OmitCandInSubSudoFrmDim2(SubSudo_0, SubSudo_Cand, Sudo_0_size, SubSudo_0_size);
                    
                    Sudo_Cand(SubSudo_rng_row, SubSudo_rng_col, :) = SubSudo_Cand;
                    %%}
                end

				%Fill in the block(i, j) if only one candidate is left in the
				%block
				if sum(Sudo_Cand(i, j, :)) == 1
					for k = 1:Sudo_0_size(1)
						if Sudo_Cand(i, j, k) == 1
							Sudo_End(i, j) = k;
							break;
						end
					end
				end
				
				if Sudo_End(i, j) ~= 0
					continue;
				end
				
				
				%Fill in the block(i, j) if only one candidate is left in the
				%below blocks pattarns
				for k = 1:Sudo_0_size(1)
					if Sudo_Cand(i, j, k) == 0
						continue;
					end

					if (sum(Sudo_Cand(i, :, k)) == 1) || ... %one by one in row
						(sum(Sudo_Cand(:, j, k)) == 1) || ...%one by one in col
						(sum(sum(Sudo_Cand(SubSudo_rng_row, SubSudo_rng_col, k))) == 1) %one by one in local 3 x 3 matrix
						Sudo_End(i, j) = k;
						break;
					end
				end
			end
		end
	end
	
	
	[row, col] = find(Sudo_End == 0);

	if length(row) == 0
		IsSudoComplete = 1;
		IsResultCorrect = SudokuVerifier(Sudo_End, Sudo_0_size, SubSudo_0_size);
	end