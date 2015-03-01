classdef Bomb < BoardPiece
%The Bomb class is a subclass of BoardPiece. It has four inputs, a
%position, board, myOwner (a Player object), and a myRange (a property of
%the Player object). It calls the BoardPiece constructor, then creates its
%own additional properties of Range, Owner, Time, and StartTime in the
%constructor. It has an explode function that works with its getObstacles 
%function, which destroys the bomb and surrounding objects around it within
%it's Range. It also checks if the bomb hits a player, with the
%checkPlayerSafety method. The Bomb class has a method called update, which
%when called calls its Time property and subtracts one. If the Time = 0, it
%calls the die method, which overloads the BoardPiece die and calls the
%explode method instead. Lastly, it has a static method getSym, which
%returns "BO".
    
    properties
        Range;
        Owner;
        Time;
        StartTime;
    end
    
    methods
        function newBomb = Bomb(position,board,myOwner,myRange)
            newBomb = newBomb@BoardPiece(position,board);
            newBomb.StartTime = clock;
            if nargin > 2
                newBomb.Range = myRange;
                newBomb.Owner = myOwner;
                newBomb.Time = 3; % Blow up after 3 seconds
            end
        end
        
        function explode(b)
            b.MyBoard.addPiece(EmptySpace(b.Position,b.MyBoard));
            b.MyBoard.Bombs(1) = [];
            b.Owner.BombCount = b.Owner.BombCount + 1;
            obstacles = b.getObstacles();
            
            e_c = imread('explosion_center.png','Back',[0 .6 .3]);
            e_h = imread('explosion_hor.png','Back',[0 .6 .3]);
            e_v = imread('explosion_ver.png','Back',[0 .6 .3]);
            e_h_l = imread('explosion_hor_left.png','Back',[0 .6 .3]);
            e_h_r = imread('explosion_hor_right.png','Back',[0 .6 .3]);
            e_v_b = imread('explosion_ver_bottom.png','Back',[0 .6 .3]);
            e_v_t = imread('explosion_ver_top.png','Back',[0 .6 .3]);
            exp_hor = flipdim(e_h,2);
            exp_ver = flipdim(e_v,2);
            exp_hor_lef = flipdim(e_h_l,2);
            exp_hor_rig = flipdim(e_h_r,2);
            exp_ver_bot = flipdim(e_v_b,2);
            exp_ver_top = flipdim(e_v_t,2);
            
            hold on 
            %n s e w
            x = b.Position(1); y = b.Position(2); z = b.Range;
            imagesc([x+.5 x-.5],[16-(y+.5) 16-(y-.5)],e_c);
            
            %North
            pc = obstacles{1};
            if isa(pc,'FilledSpace')
                pc = b.MyBoard.MyBoardPieces{x,y+1};
            end
            pos = pc.Position;
            if pos(2) == y
                %do nothing
            else
                dist = y-pos(2);
                if dist == 1
                    imagesc([x+.5 x-.5],[16-(y-1+.5) 16-(y-1-.5)],exp_ver_bot);
                elseif dist > 1
                    i = 1;
                    while i < dist
                        imagesc([x+.5 x-.5],[16-(y-i+.5) 16-(y-i-.5)],exp_ver);
                        i = i+1;
                    end
                    imagesc([x+.5 x-.5],[16-(y-i+.5) 16-(y-i-.5)],exp_ver_bot);
                end
            end

            %South
            pc = obstacles{2};
            if isa(pc,'FilledSpace')
                pc = b.MyBoard.MyBoardPieces{x,y-1};
            end
            pos = pc.Position;
            if pos(2) == y
                %do nothing
            else
                dist = pos(2)-y;
                if dist == 1
                    imagesc([x+.5 x-.5],[16-(y+1+.5) 16-(y+1-.5)],exp_ver_top);
                elseif dist > 1
                    i = 1;
                    while i < dist
                        imagesc([x+.5 x-.5],[16-(y+i+.5) 16-(y+i-.5)],exp_ver);
                        i = i+1;
                    end
                    imagesc([x+.5 x-.5],[16-(y+i+.5) 16-(y+i-.5)],exp_ver_top);
                end
            end
            
            %East
            pc = obstacles{3};
            if isa(pc,'FilledSpace')
                pc = b.MyBoard.MyBoardPieces{x-1,y};
            end
            pos = pc.Position;
            if pos(1) == x
                %do nothing
            else
                dist = pos(1)-x;
                if dist == 1
                    imagesc([x+1+.5 x+1-.5],[16-(y+.5) 16-(y-.5)],exp_hor_rig);
                elseif dist > 1
                    i = 1;
                    while i < dist
                        imagesc([x+i+.5 x+i-.5],[16-(y+.5) 16-(y-.5)],exp_hor);
                        i = i+1;
                    end
                    imagesc([x+i+.5 x+i-.5],[16-(y+.5) 16-(y-.5)],exp_hor_rig);
                end
            end
            
            %West
            pc = obstacles{4};
            if isa(pc,'FilledSpace')
                pc = b.MyBoard.MyBoardPieces{x+1,y};
            end
            pos = pc.Position;
            if pos(1) == x
                %do nothing
            else
                dist = x-pos(1);
                if dist == 1
                    imagesc([x-1+.5 x-1-.5],[16-(y+.5) 16-(y-.5)],exp_hor_lef);
                elseif dist > 1
                    i = 1;
                    while i < dist
                        imagesc([x-i+.5 x-i-.5],[16-(y+.5) 16-(y-.5)],exp_hor);
                        i = i+1;
                    end
                    imagesc([x-i+.5 x-i-.5],[16-(y+.5) 16-(y-.5)],exp_hor_lef);
                end
            end
                    
            hold off
            
            p1 = b.Owner.MyGame.PlayerList{1};
            p2 = b.Owner.MyGame.PlayerList{2};
            if ~b.checkPlayerSafety(p1,obstacles)
                p1.IsAlive = false;
            end
            if ~b.checkPlayerSafety(p2,obstacles)
                p2.IsAlive = false;
            end
            for i = 1:4
                if obstacles{i} ~= b
                    obstacles{i}.die();
                end
            end
        end
        
        function obstacles = getObstacles(b)
            noNorthObstacle = true;
            noSouthObstacle = true;
            noWestObstacle = true;
            noEastObstacle = true;
            i = 0;
            n = 0;
            s = 0;
            w = 0;
            e = 0;
            obstacles = cell(1,4);       
            while (i<b.Range)
                if noNorthObstacle
                    n = n+1;
                    obstacles{1} = b.MyBoard.MyBoardPieces{b.Position(1),max(b.Position(2)-n,1)};
                    if ~strcmp(obstacles{1}.getSym,'ES')
                        noNorthObstacle = false;
                    end
                end
                if noSouthObstacle
                    s = s+1;
                    obstacles{2} = b.MyBoard.MyBoardPieces{b.Position(1),min(b.Position(2)+s,15)};
                    if ~strcmp(obstacles{2}.getSym,'ES')
                        noSouthObstacle = false;
                    end
                end
                if noEastObstacle
                    e = e+1;
                    obstacles{3} = b.MyBoard.MyBoardPieces{min(b.Position(1)+e,15),b.Position(2)};
                    if ~strcmp(obstacles{3}.getSym,'ES')
                        noEastObstacle = false;
                    end
                end
                if noWestObstacle
                    w = w+1;
                    obstacles{4} = b.MyBoard.MyBoardPieces{max(b.Position(1)-w,1),b.Position(2)};
                    if ~strcmp(obstacles{4}.getSym,'ES')
                        noWestObstacle = false;
                    end
                end
                i = i+1;
            end
        end
        
        function safe = checkPlayerSafety(b,p,obstacles)
            safe = true;
            pos = Player.nearby(p.Position);
            danger = false; %Is player 1 within range of bomb
            hitbox = 0; %which part of the player was hit
            direction = 'D'; % Direction of bomb blast towards player
            % D is a null value
            for j = 1:4
                if (abs(pos{j}(1) - b.Position(1))<=b.Range && ...
                        pos{j}(2) == b.Position(2))
                    %Player is east or west of bomb
                    danger = true;
                    hitbox = j;
                    if (pos{j}(1) - b.Position(1))>0
                        direction = 'E';
                    elseif (pos{j}(1) - b.Position(1))<0
                        direction = 'W';
                    elseif (pos{j}(1) - b.Position(1))==0
                        safe = false;
                    end
                elseif (abs(pos{j}(2) - b.Position(2))<=b.Range && ...
                        pos{j}(1) == b.Position(1))
                    %Player is north or south of bomb
                    hitbox = j;
                    danger = true;
                    if (pos{j}(2) - b.Position(2))>0
                        direction = 'S';
                    elseif (pos{j}(2) - b.Position(2))<0
                        direction = 'N';
                    elseif (pos{j}(1) - b.Position(1))==0
                        safe = false;
                    end
                end
            end
            if danger
                %Check if there is something between bomb blast and player
                placehit = pos{hitbox};
                pos1 = Correction(placehit(2));
                pos2 = Correction(placehit(2));
                switch direction
                    
                    case 'N'
                        obstype = obstacles{1}.getSym;
                        if (strcmp(obstype,'FS')||strcmp(obstype,'BR'))
                            if ~(obstacles{1}.Position>=[pos1 pos2])
                                safe = false;
                            end
                        elseif (strcmp(obstype,'ES'))
                            safe = false;
                        end
                    case 'S'
                        obstype = obstacles{2}.getSym;
                        if (strcmp(obstype,'FS')||strcmp(obstype,'BR'))
                            if ~(obstacles{2}.Position<=[pos1 pos2])
                                safe = false;
                            end
                        elseif (strcmp(obstype,'ES'))
                            safe = false;
                        end
                    case 'E'
                        obstype = obstacles{3}.getSym;
                        if (strcmp(obstype,'FS')||strcmp(obstype,'BR'))
                            if ~(obstacles{3}.Position>=[pos1 pos2])
                                safe = false;
                            end
                        elseif (strcmp(obstype,'ES'))
                            safe = false;
                        end
                    case 'W'
                        obstype = obstacles{4}.getSym;
                        if (strcmp(obstype,'FS')||strcmp(obstype,'BR'))
                            if ~(obstacles{4}.Position<=[pos1 pos2])
                                safe = false;
                            end
                        elseif (strcmp(obstype,'ES'))
                            safe = false;
                        end
                end
            end
        end
        
        function die(thisBomb)
            thisBomb.explode();
        end
        
        function update(thisBomb)
            thisBomb.Time = thisBomb.Time - 1;
            if thisBomb.Time == 0
                thisBomb.explode();
            end
        end            
    end
    
    methods (Static)
        function symbol = getSym()
            symbol = 'BO';
        end
    end
    
end

