classdef Brick < BoardPiece
%Brick is a subclass of BoardPiece. It calls the BoardPiece constructor to 
%create its properties. If the object has a third input, it assigns that to
%an upgrade type. If it has two inputs, the upgrade type is blank. It has 
%its own die method, which overloads the BoardPiece's die method. Finally, 
%it has a static method for getSym, which returns "BR".
    
    properties
        MyUpgrade;
    end
    
    methods
        function obj = Brick(position,board,upgrade)
            obj = obj@BoardPiece(position,board);
            if nargin == 3
                obj.MyUpgrade = upgrade;
            elseif nargin == 2
                obj.MyUpgrade = [];
                return
            else
                error('Incorrect number of inputs.')
            end
        end
        
         function die(obj)
             if isempty(obj.MyUpgrade) == 1
                 obj.MyBoard.addPiece(EmptySpace(obj.Position,obj.MyBoard));
             else
                 obj.MyBoard.addPiece(Upgrade(obj.Position,obj.MyBoard,obj.MyUpgrade));
             end
         end
    end
    
    methods (Static)
        function symbol = getSym()
            symbol = 'BR';
        end
    end
    
end

