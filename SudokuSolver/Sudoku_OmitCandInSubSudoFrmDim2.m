%{
/***************************************************************************
         Sudoku_OmitCandInSubSudo  - A Tool to solve sudoku by the fastest way
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

function SubSudo_Cand = Sudoku_OmitCandInSubSudoFrmDim1(SubSudo_0, SubSudo_Cand, Sudo_0_size, SubSudo_0_size)
	%If n empty blocks has n identical cnadiates in the row or col of a local
    %matrix, those candidates can be omitted from the other row or
    %col

    for i = 1:SubSudo_0_size(2)
        ArrAtDimN = SubSudo_0(:, i);

        [dim_1, dim_2] = find(ArrAtDimN == 0);
        NumOfBlocksEmpty = length(dim_1);
        
        if NumOfBlocksEmpty <= 1
            continue
        end
        
        
        %Check whether the number of candiates in the empty blocks equal to the number of empty blocks equal or
        %not
        dim_set = [dim_1(:), dim_2(:)];
        dim_set(:, 2) = dim_set(:, 2) + i - 1;
        
        dim_1 = dim_set(:, 1);
        dim_2 = dim_set(:, 2);
        %dim_2 = dim_2 + i - 1;
        
        if sum(SubSudo_Cand(dim_1(1), dim_2(1), :)) ~= NumOfBlocksEmpty
            continue
        end

        DoSearch = 1;
        
        for blk_idx = 2:NumOfBlocksEmpty
            if sum(SubSudo_Cand(dim_1(blk_idx), dim_2(blk_idx), :)) ~= NumOfBlocksEmpty
                DoSearch = 0;
                break;
            end
        end
        
        if DoSearch == 0
            continue
        end

        
        %Check whether the candidates in the empty blocks are equal or not
        for blk_idx = 2:NumOfBlocksEmpty
            for k = 1:Sudo_0_size(1)
                if SubSudo_Cand(dim_1(1), dim_2(1), k) ~= SubSudo_Cand(dim_1(blk_idx), dim_2(blk_idx), k)
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
        for d = 1:2
            CoorToBeOmitted.(strcat('dim_', num2str(d))) = [1:SubSudo_0_size(d)];

            if d == 2
                CoorToBeOmitted.(strcat('dim_', num2str(d)))(i) = [];
            end
        end
        
        for m = CoorToBeOmitted.('dim_1')
            for n = CoorToBeOmitted.('dim_2')
                if SubSudo_0(m, n) ~= 0
                    continue;
                end

                %{
                if sum(SubSudo_Cand(m, n, :)) <= 1
                    continue;
                end
                %}

                for k = 1:Sudo_0_size(1)
                    if SubSudo_Cand(dim_1(1), dim_2(1), k) > 0
                        SubSudo_Cand(m, n, k) = 0;
                    end
                end
            end
        end
    end