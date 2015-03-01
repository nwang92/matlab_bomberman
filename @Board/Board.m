classdef Board < handle
%The Board class takes no inputs, and generates a board using various
%BoardPiece objects. It has a constant property Size, which is set as [15
%15], which can be intepreted as a 15x15 matrix. The Board also has
%properties of MyBoardPieces and Bombs. MyBoardPieces is a cell array of
%all the objects on the current board, while Bombs is another cell array
%that has a list of all the bombs that are placed on the board. This gets
%updated when bombs are placed on the board, as well as when bombs explode.
    
    properties
        MyBoardPieces = {};
        Bombs;
    end
        
    properties (Constant)
        Size = [15 15];
    end
    
    methods
        function bd = Board() %Board constructor
            if nargin == 0
                EmptySpace([1 1],bd);
                EmptySpace([1 2],bd);
                EmptySpace([2 1],bd);
                EmptySpace([1 3],bd);
                EmptySpace([3 1],bd);
                EmptySpace([15 15],bd);
                EmptySpace([15 14],bd);
                EmptySpace([15 13],bd);
                EmptySpace([14 15],bd);
                EmptySpace([13 15],bd);
                Brick([4 1],bd,'Speed');
                Brick([2 3],bd,'BombCount');
                Brick([3 2],bd,'BombRange');
                Brick([1 4],bd);
                Brick([15 12],bd,'Speed');
                Brick([14 13],bd,'BombCount');
                Brick([13 14],bd,'BombRange');
                Brick([12 15],bd);
                for i = 1:15
                    if isempty(bd.MyBoardPieces{8,i})
                        Brick([8 i],bd);
                    end
                end
                for i = 2:2:15
                    for j = 2:2:15
                        FilledSpace([i j],bd);
                    end
                end
                for x = 1:15
                    for y = 1:15
                        if isempty(bd.MyBoardPieces{x,y})
                            EmptySpace([x y],bd);
                        end
                    end
                end
            else
                error('Incorrect number of inputs.')
            end
        end
        
        function addPiece(board,piece) %Adds a board piece to the MyBoardPiece cell array
            board.MyBoardPieces{piece.Position(1),piece.Position(2)} = piece;
        end
        
    end
    methods (Static)
        function isValid = isValidMove(pos) %Checks movement such that nothing moves outside of the bounds of the board
            %Returns true if position is within boundaries of board
            if Correction(pos(1)) < 1 || Correction(pos(1)) > Board.Size(1) || ...
                    Correction(pos(2)) < 1 || Correction(pos(2))> Board.Size(2)
                isValid = 0;
            else
                isValid = 1;
            end
        end
    end
    
end

