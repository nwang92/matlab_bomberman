classdef Upgrade < BoardPiece
%Upgrade is a subclass of BoardPiece. It calls the BoardPiece
%constructor to create its properties. It checks the type of upgrade it is,
%and assigns the property UpgradeType to a letter associated with the
%upgrade. It has its own die method, which overloads the BoardPiece's die
%method. It also has a method for getSym, which returns either "UR", 
%"UC",' or "US". Lastly, it has a method that when interacted with a
%Player, it boosts a specific attribute or property of that Player. After
%that, it calls the die method.
    
    properties
        UpgradeType;
        Used;
    end
    
    methods
        function obj = Upgrade(pos,board,myUpgrade)
            obj = obj@BoardPiece(pos,board);
            obj.Used = false;
            if nargin == 3
                if (strcmp(myUpgrade, 'Speed'))
                    obj.UpgradeType = 'S';
                elseif (strcmp(myUpgrade,'BombCount'))
                    obj.UpgradeType = 'C';
                elseif (strcmp(myUpgrade,'BombRange'))
                    obj.UpgradeType = 'R';
                else
                    error('Invalid upgrade type.');
                end
            else
                error('Incorrect number of inputs.')
            end
        end
        
        function symb = getSym(b)
            symb = ['U' b.UpgradeType];
        end
        
        function die(obj)
            obj.MyBoard.addPiece(EmptySpace(obj.Position,obj.MyBoard));
        end
        
        function upgradePlayer(myUpgrade,myPlayer)
            if ~myUpgrade.Used
                myUpgrade.Used = true;
                switch myUpgrade.UpgradeType
                    case 'S'
                        myPlayer.Speed = myPlayer.Speed + 1;
                    case 'C'
                        myPlayer.MaxBomb = myPlayer.MaxBomb + 1;
                        myPlayer.BombCount = myPlayer.BombCount + 1;
                    case 'R'
                        myPlayer.BombRange = myPlayer.BombRange + 1;
                    otherwise
                        error('Invalid Upgrade');
                end
                myUpgrade.die();
            end
        end
        
    end
    
end

