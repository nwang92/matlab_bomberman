classdef EmptySpace < BoardPiece
%EmptySpace is a subclass of BoardPiece. It calls the BoardPiece
%constructor to create it's properties. It also has a static method for
%getSym, which returns "ES".
   
    methods
        function obj = EmptySpace(position,board)
            obj = obj@BoardPiece(position,board);
        end
    end
    
    methods (Static)
        function symbol = getSym()
            symbol = 'ES';
        end
    end
    
end

