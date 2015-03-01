classdef BoardPiece < handle
%BoardPiece is an abstract class that takes two inputs, a position and a
%board. It has a constructor that assigns the position to the Position
%property, and board to the MyBoard property. It has a die method which
%takes the current position and board of a block, and replaces it with an
%EmptySpace object. Finally, it has an abstract method getSym, which
%acquires a two-letter string depending on the type of block it is.
    
    properties 
        Position;
        MyBoard;
    end
    
    methods
        function obj = BoardPiece(pos,bd)
            if nargin == 2
                obj.Position = pos;
                bd.addPiece(obj);
                obj.MyBoard = bd;
            else
                error('Incorrect number of inputs.')
            end
        end
        
        function die(block)
            pos = block.Position;
            bd = block.MyBoard;
            EmptySpace(pos,bd);
        end
    end
    
    methods (Abstract)
        pieceType = getSym(boardpiece);
    end
    
end

