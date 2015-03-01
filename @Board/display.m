function display(board,handle)
%This is the display function for the Board object. It creates an axes, and
%checks each position in reference to the Board property MyBoardPieces.
%Depending on the type of board piece, it creates the relevant patch object
%to portray it.

X=0:16;
Y=X;
Z=ones(17,17);
Z(2:2:end,2:2:end)=-1;
if nargin == 2
    h = pcolor(handle,X,Y,Z);
else
    h = pcolor(X,Y,Z);
end
set(h,'EdgeColor','none')
colormap([1 1 1])
axis xy
axis square
axis off
a = gca;
set(a,'DrawMode','fast');
patch([0 0 16 16],[0 16 16 0], [.35 .35 .35])
patch([.5 .5 15.5 15.5], [.5 15.5 15.5 .5], [0 .6 .3],'FaceAlpha',1,'EdgeColor', [0 0 0]);
stone_color = [.75 .75 .75];
stone_edge = [.15 .15 .15];
for x = 2:2:15
    for y = 2:2:15
        patch([x-.5 x-.5 x+.5 x+.5], [16-y-.5 16-y+.5 16-y+.5 16-y-.5],stone_color,'EdgeColor',stone_edge);
    end
end

ti = get(gca,'TightInset');
set(gca,'Position',[ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);

bomb = imread('bomb.png','Back',[0 .6 .3]);
z = flipdim(bomb,1);

for x = 1:15
    for y = 1:15
        pc = board.MyBoardPieces{x,y};
        type = class(pc);
        switch type
            case 'Brick'
                color = [.7 .4 .2];
                edgesetting = [.5 .2 0];
            case 'Bomb'
                color = [0 0 0];
                edgesetting = 'none';
            case 'Upgrade'
                color = [1 1 0];
                edgesetting = [0 0 0];
        end
        if strcmp(type,'Brick') == 1
            patch([x-.5 x-.5 x+.5 x+.5], [16-y-.5 16-y+.5 16-y+.5 16-y-.5],color,'EdgeColor',edgesetting);
        elseif strcmp(type,'Bomb') == 1
            hold on
            imagesc([x+.4 x-.4],[16-(y+.4) 16-(y-.4)],z);
            text(x,16-y,num2str(pc.Time),'Color',[1 1 1]);
            hold off
        elseif strcmp(type,'Upgrade') == 1
            patch([x-.5 x-.5 x+.5 x+.5], [16-y-.5 16-y+.5 16-y+.5 16-y-.5],color,'EdgeColor',edgesetting);
            if strcmp(pc.getSym,'US') == 1
                text(x-.35,16-y,'SPEED','FontSize',6,'Color',[0 0 0]);
            elseif strcmp(pc.getSym,'UC') == 1
                text(x-.35,16-y,'# of B','FontSize',7,'Color',[0 0 0]);
            elseif strcmp(pc.getSym,'UR') == 1
                text(x-.35,16-y,'RANGE','FontSize',6,'Color',[0 0 0]);
            end
        end
    end
end

end