classdef Game < handle
%The Game function takes no inputs, and it creates an instance of the game.
%It has properties of GameBoard, which is created by the Board class. It
%also has a GameFigure property, which sets the GUI for the game. The
%PlayerList property is a cell array of both the players currently playing
%hte game. This class has a constructor and a display function. Upon
%calling the Game class, it displays "splash" method of the game. The 
%"play" method creates an input dialog that asks the player for a name, for
%both players 1 and 2. Then it starts the game and begings the initialize
%function.

    properties (Access = public)
        GameBoard;
        GameFigure;
        PlayerList = {};
    end
    
    methods
        function game = Game()
            if nargin == 0
                game.GameBoard = Board();
            else
                error('Incorrect number of inputs.')
            end
        end
        
        function display(game)
            if nargin ~= 1
                error('Incorrect number of inputs.')
            else
                game.splash();
            end
        end
        
        function play(game)
            ans = inputdlg({'Please enter name for Player 1:' 'Please enter name for Player 2:'},'Player Names');
            name1 = ans{1}; name2 = ans{2};
            if isempty(name1) == 1
                name1 = 'Player 1';
            end
            if isempty(name2) == 1
                name2 = 'Player 2';
            end
            P1 = Player(name1,game,[1 1]);
            P2 = Player(name2,game,[15 15]);
            game.PlayerList = {P1 P2};
            bd = game.GameBoard;
            game.GameFigure = gcf;
            p = [];
            pcol = {[1 0 0],[0 0 1]};
            ax = gca;
            set(ax,'Parent',game.GameFigure);
            for i = 1:length(game.PlayerList)
                player = game.PlayerList{i};
                x = player.Position(1); y = player.Position(2);
                box = patch([x-.5 x-.5 x+.5 x+.5], [16-y-.5 16-y+.5 16-y+.5 16-y-.5],pcol{i});
                set(box,'Parent',ax);
                p(end+1) = box;
            end
            guidata(game.GameFigure,p);
            [y Fs] = wavread('level.wav');
            music = audioplayer([y;y;y;y;y],Fs);
            play(music);
            game.initialize();
            stop(music);
        end
       
    end
end

