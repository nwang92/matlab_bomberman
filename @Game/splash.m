function splash(game)
%The "splash" method is written externally, and it creates a figure with a
%black background and image. It has an audioplayer object which plays
%music, and a uicontrol text string which has the authors of this program.
%A uicontorl pushbutton is located on the botton, which when pressed calls
%the "play" method of the Game. 

game.GameFigure = figure('Color','k','Name','BOMBERMAN!');
sp = imshow('359768-bomberman.jpg');
set(gcf,'Units','normalized')
set(gcf,'Position',[.25 .25 .5 .5]);
[y Fs] = wavread('intro.wav');
music = audioplayer(y,Fs);
play(music)
author = uicontrol('Parent',game.GameFigure,'Style','text','BackgroundColor','k','ForegroundColor',[1 1 1],'Units','normalized','Position',[.7,.1,.25,.1],'String','Created by Nelson Wang, Tianyu Wang, and Peter Kwon');
playButton = uicontrol('Parent',game.GameFigure,'BackgroundColor','k','ForegroundColor',[1 1 1],'Style','pushbutton','Units','normalized','Position',[.4,.05,.2,.08],'String','PLAY','FontSize',20,'HorizontalAlignment','center','Callback',@play_callback);  

    function play_callback(hObject,eventdata)
        pause(music);
        close(game.GameFigure)
        game.play();
    end

end