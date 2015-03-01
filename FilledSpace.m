classdef FilledSpace < BoardPiece
%FilledSpace is a subclass of BoardPiece. It calls the BoardPiece
%constructor to create its properties. It has its own die method, which
%overloads the BoardPiece's die method. Finally, it has a static method for
%getSym, which returns "FS".
    
    methods
        function obj = FilledSpace(position,board)
            obj = obj@BoardPiece(position,board);
        end
        
        function die(f)
            %do nothing
        end
    end
    
    methods (Static)
        function symbol = getSym()
            symbol = 'FS';
        end
    end
    
end