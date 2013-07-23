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

function [Sudo_End, Sudo_Cand, IsSudoComplete, IsResultCorrect] = SudokuLogicSolver(Sudo_0)

	Sudo_End = Sudo_0;
	Sudo_Cand = ones(9, 9, 9);

	max_iteration = 1000;
	
	IsSudoComplete = 0;
	IsResultCorrect = 1;
	
	[row, col] = find(Sudo_End == 0);

	if length(row) == 0
		IsSudoComplete = 1;
		IsResultCorrect = SudokuVerifier(Sudo_End);
		return
	end

	Sudo_End_prev = ones(9, 9);
	NumOfNoFilling = 0;
	
	for iter = 1:max_iteration
		[row, col] = find(Sudo_End - Sudo_End_prev);
		
		if length(row) == 0
			NumOfNoFilling = NumOfNoFilling + 1;
			
			if NumOfNoFilling >= 2
				break;
			end
		else
			NumOfNoFilling = 0;
		end
		
		Sudo_End_prev = Sudo_End;
		
		for i = 1:9
			for j = 1:9
				%Omit invalid candidates of the filled position
				if Sudo_End(i, j) ~= 0
					for k = 1:9
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

				[row, col] = find(Sudo_End(row_start_l : row_start_l + 2, col_start_l : col_start_l + 2));
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
				
				%Check row by row
				for i_l = 1:3
					row_l = row_start_l + i_l - 1;
					col_l = col_start_l;
					
					[row, col] = find(Sudo_End(row_l, col_l : col_l + 2) == 0);
					NumOfBlocksEmpty = length(col);
					
					if NumOfBlocksEmpty <= 1
						continue
					end
					
					%Check whether the number of candiates in the empty blocks equal to the number of empty blocksequal or
					%not
					row = row + row_l - 1;
					col = col + col_l - 1;
					
					if sum(Sudo_Cand(row(1), col(1), :)) ~= NumOfBlocksEmpty
						continue
					end
					
					DoSearch = 1;
					
					for blk_idx = 2:NumOfBlocksEmpty
						if sum(Sudo_Cand(row(blk_idx), col(blk_idx), :)) ~= NumOfBlocksEmpty
							DoSearch = 0;
							break;
						end
					end
					
					if DoSearch == 0
						continue
					end
					
					
					%Check whether the candidates in the empty blocks are equal or not
					for blk_idx = 2:NumOfBlocksEmpty
						for k = 1:9
							if Sudo_Cand(row(1), col(1), k) ~= Sudo_Cand(row(blk_idx), col(blk_idx), k)
								DoSearch = 0;
								break;
							end
						end
						
						if DoSearch == 0
							break;
						end
					end
					
					if DoSearch == 0
						continue
					end
					
					
					%Omit the candidates of the empty blocks in the other rows
					%of the local matrix
					for m = 1:3
						if m == i_l
							continue
						end
						
						row_m_idx = row_start_l + m - 1;
						
						for n = 1:3
							col_n_idx = col_start_l + n - 1;
							
							if Sudo_End(row_m_idx, col_n_idx) ~= 0
								continue;
							end

							%{
							if sum(Sudo_Cand(row_m_idx, col_n_idx, :)) <= 1
								continue;
							end
							%}

							for k = 1:9
								if Sudo_Cand(row(1), col(1), k) > 0
									Sudo_Cand(row_m_idx, col_n_idx, k) = 0;
								end
							end
						end
					end
				end
			   
				
				%Check col by col
				for j_l = 1:3
					row_l = row_start_l;
					col_l = col_start_l + j_l - 1;
					
					[row, col] = find(Sudo_End(row_l: row_l + 2, col_l) == 0);
					NumOfBlocksEmpty = length(col);
					
					if NumOfBlocksEmpty <= 1
						continue
					end
					
					%Check whether the number of candiates in the empty blocks equal to the number of empty blocksequal or
					%not
					row = row + row_l - 1;
					col = col + col_l - 1;
					
					if sum(Sudo_Cand(row(1), col(1), :)) ~= NumOfBlocksEmpty
						continue
					end
					
					DoSearch = 1;
					
					for blk_idx = 2:NumOfBlocksEmpty
						if sum(Sudo_Cand(row(blk_idx), col(blk_idx), :)) ~= NumOfBlocksEmpty
							DoSearch = 0;
							break;
						end
					end
					
					if DoSearch == 0
						continue
					end
					
					
					%Check whether the candidates in the empty blocks are equal or not
					for blk_idx = 2:NumOfBlocksEmpty
						for k = 1:9
							if Sudo_Cand(row(1), col(1), k) ~= Sudo_Cand(row(blk_idx), col(blk_idx), k)
								DoSearch = 0;
								break;
							end
						end
						
						if DoSearch == 0
							break;
						end
					end
					
					if DoSearch == 0
						continue
					end
					
					
					%Omit the candidates of the empty blocks in the other cols
					%of the local matrix
					for m = 1:3
						row_m_idx = row_start_l + m - 1;
						
						for n = 1:3
							if n == j_l
								continue
							end
						
							col_n_idx = col_start_l + n - 1;
							
							if Sudo_End(row_m_idx, col_n_idx) ~= 0
								continue;
							end

							%{
							if sum(Sudo_Cand(row_m_idx, col_n_idx, :)) <= 1
								continue;
							end
							%}
							
							for k = 1:9
								if Sudo_Cand(row(1), col(1), k) > 0
									Sudo_Cand(row_m_idx, col_n_idx, k) = 0;
								end
							end
						end
					end
				end
				
				
				%Fill in the block(i, j) if only one candidate is left in the
				%block
				if sum(Sudo_Cand(i, j, :)) == 1
					for k = 1:9
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
				for k = 1:9
					if Sudo_Cand(i, j, k) == 0
						continue;
					end

					if (sum(Sudo_Cand(i, :, k)) == 1) || ... %one by one in row
						(sum(Sudo_Cand(:, j, k)) == 1) || ...%one by one in col
						(sum(sum(Sudo_Cand(row_start_l : row_start_l + 2, col_start_l : col_start_l + 2, k))) == 1) %one by one in local 3 x 3 matrix
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
		IsResultCorrect = SudokuVerifier(Sudo_End);
	end