classdef Player < handle
%The Player class takes in three inputs, a name, game, and position. It has
%properties of Position, MaxBomb, BombCount, BombRange, Speed, Name,
%MyGame, Kills, BoardIncr, IsAlive, and MyBoard. These are all defined in
%the Player constructor. The Player has an upgrade method, which depending
%on the type, augments on of the Player properties. There are also a series
%of move functions, such as move and moveToEmptySpace, which uses collision
%detection and floating point arithmetic to move by a specified increment
%(BoardIncr). The Player also has a placeBomb method, which drops a bomb on
%the current position of the player on the board. Lastly, Player has a
%static method which checks the nearby objects around the current location
%of the player.
    
    properties
        Position;
        MaxBomb; %Max number bombs that player can have on the board
        BombCount; %Current number of bombs left
        BombRange;
        Speed;
        Name;
        MyGame; % Which game the player is part of;
        BoardIncr;
        IsAlive;
        MyBoard;
    end
    
    methods
        function p = Player(name,game,position)
            if nargin == 3
                p.Name = name;
                p.MyGame = game;
                p.MaxBomb = 1;
                p.BombCount = 1;
                p.BombRange = 2;
                p.Speed = 6;
                p.Position = position;
                p.BoardIncr = .03;
                p.IsAlive = true;
                p.MyBoard = game.GameBoard;
            else
                error('Incorrect number of inputs.')
            end
        end
        
        function upgrade(p,type)
            if type == 1
                p.maxBomb = p.maxBomb + 1;
                p.BombCount = p.BombCount + 1;
            elseif type == 2
                p.BombRange = p.BombRange + 1;
            elseif type == 3
                p.Speed = p.Speed + 2;
            end
        end
        
        function move(p,dir)
            switch dir
                case 'N'
                    newPos = p.Position - [0 p.Speed*p.BoardIncr];
                case 'S'
                    newPos = p.Position + [0 p.Speed*p.BoardIncr];
                case 'W'
                    newPos = p.Position - [p.Speed*p.BoardIncr 0];
                case 'E'
                    newPos = p.Position + [p.Speed*p.BoardIncr 0];
            end
            if Board.isValidMove(newPos)
                finalPos = p.moveToEmptySpace(newPos,dir);
                p.Position = finalPos;
            end
        end
        
        function newpos = moveToEmptySpace(p,pos,dir)
            nearGrid = Player.nearby(pos);
            myBoard = p.MyBoard.MyBoardPieces;
            bpiece = cell(1,4);
            obs = cell(1,4);
            for i = 1:4
                bpiece{i} = myBoard{Correction(nearGrid{i}(1)),Correction(nearGrid{i}(2))};
                obs{i} = strcmp(bpiece{i}.getSym,'ES')||isa(bpiece{i},'Upgrade');
            end
            if obs{1} && obs{2} && obs{3} && obs{4}
                newpos = pos;
            else
                switch dir
                    case 'N'
                        if (obs{1}&&obs{3})
                            newpos = pos;
                        elseif (obs{1}) && abs(bpiece{1}.Position(1)-pos(1))<=2*p.Speed*p.BoardIncr
                            newpos = pos + [bpiece{1}.Position(1)-pos(1) 0];
                        elseif (obs{3}) && abs(bpiece{3}.Position(1)-pos(1))<=2*p.Speed*p.BoardIncr
                            newpos = pos + [bpiece{3}.Position(1)-pos(1) 0];
                        else
                            newpos = pos + [0 p.Speed*p.BoardIncr];
                        end
                    case 'S'
                        if (obs{2}&&obs{4})
                            newpos = pos;
                        elseif (obs{4}) && abs(bpiece{4}.Position(1)-pos(1))<=2*p.Speed*p.BoardIncr
                            newpos = pos + [bpiece{4}.Position(1)-pos(1) 0];
                        elseif (obs{2}) && abs(bpiece{2}.Position(1)-pos(1))<=2*p.Speed*p.BoardIncr
                            newpos = pos + [bpiece{2}.Position(1)-pos(1) 0];
                        else
                            newpos = pos - [0 p.Speed*p.BoardIncr];
                        end
                    case 'W'
                        if (obs{1}&&obs{2})
                            newpos = pos;
                        elseif (obs{1}) && abs(bpiece{1}.Position(2)-pos(2))<=2*p.Speed*p.BoardIncr
                            newpos = pos + [0 bpiece{1}.Position(2)-pos(2)];
                        elseif (obs{2}) && abs(bpiece{2}.Position(2)-pos(2))<=2*p.Speed*p.BoardIncr
                            newpos = pos + [0 bpiece{2}.Position(2)-pos(2)];
                        else
                            newpos = pos + [p.Speed*p.BoardIncr 0];
                        end
                    case 'E'
                        if (obs{3}&&obs{4})
                            newpos = pos;
                        elseif (obs{3}) && abs(bpiece{3}.Position(2)-pos(2))<=2*p.Speed*p.BoardIncr
                            newpos = pos + [0 bpiece{3}.Position(2)-pos(2)];
                        elseif (obs{4}) && abs(bpiece{4}.Position(2)-pos(2))<=2*p.Speed*p.BoardIncr
                            newpos = pos + [0 bpiece{4}.Position(2)-pos(2)];
                        else
                            newpos = pos - [p.Speed*p.BoardIncr 0];
                        end
                end
            end
            
            nearGrid = Player.nearby(newpos);
            myBoard = p.MyBoard.MyBoardPieces;
            for i = 1:4
                tempPiece = myBoard{Correction(nearGrid{i}(1)),Correction(nearGrid{i}(2))};
                if (isa(tempPiece,'Upgrade'))
                    tempPiece.upgradePlayer(p);
                end
            end
        end
        
        function b = placeBomb(p)
            if p.BombCount >= 1
                x = round(p.Position(1));
                y = round(p.Position(2));
                b = Bomb([x y],p.MyGame.GameBoard,p,p.BombRange);
                if isempty(p.MyGame.GameBoard.Bombs)
                    p.MyGame.GameBoard.Bombs{1} = b;
                else
                    p.MyGame.GameBoard.Bombs{end+1} = b;
                end
                p.BombCount = p.BombCount - 1;
            end
        end
    end
    methods (Static)
        function nearpieces = nearby(pos)
            p1 = Correction(pos(1));
            p2 = Correction(pos(2));
            nearpieces{1} = [floor(p1) floor(p2)];
            nearpieces{2} = [floor(p1) ceil(p2)];
            nearpieces{3} = [ceil(p1) floor(p2)];
            nearpieces{4} = [ceil(p1) ceil(p2)];
        end
    end
end


