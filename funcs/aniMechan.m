% function of animate the mechanism process
function [] = aniMechan(aviObj,tit,odet,rA,rB,rC,rD,rE,rF,rG)

open(aviObj);

num = length(odet);
xhi = max([rD(:,1);rE(:,1);rF(:,1);rG(:,1)],[],'all') + 0.1;
xlo = min([rD(:,1);rE(:,1);rF(:,1);rG(:,1)],[],'all') - 0.1;
yhi = max([rD(:,2);rE(:,2);rF(:,2);rG(:,2)],[],'all') + 0.1;
ylo = min([rD(:,2);rE(:,2);rF(:,2);rG(:,2)],[],'all') - 0.1;

for k = 1:num
    % bends
    plot([rA(1),  rB(1)],   [rA(2),  rB(2)],   'Color',[0,0,0],          'LineWidth',2); hold on;
    plot([rA(1),  rC(1)],   [rA(2),  rC(2)],   'Color',[0,0,0],          'LineWidth',2);
    plot([rC(1),  rB(1)],   [rC(2),  rB(2)],   'Color',[0,0,0],          'LineWidth',2);
    plot([rD(k,1),rE(k,1)], [rD(k,2),rE(k,2)], 'Color',[0,0.45,0.74],    'LineWidth',3);
    plot([rF(k,1),rG(k,1)], [rF(k,2),rG(k,2)], 'Color',[0.93,0.69,0.13], 'LineWidth',2);

    % points
    scatter(rA(1),   rA(2),   16*pi, 'MarkerEdgeColor',[0,0,0],          'MarkerFaceColor',[1,1,1], 'LineWidth',2);
    scatter(rB(1),   rB(2),   16*pi, 'MarkerEdgeColor',[0,0,0],          'MarkerFaceColor',[1,1,1], 'LineWidth',2);
    scatter(rC(1),   rC(2),   16*pi, 'MarkerEdgeColor',[0,0.45,0.74],    'MarkerFaceColor',[1,1,1], 'LineWidth',2);
    scatter(rD(k,1), rD(k,2), 16*pi, 'MarkerEdgeColor',[0.93,0.69,0.13], 'MarkerFaceColor',[1,1,1], 'LineWidth',2);  

    % texts
    text(rA(1)-0.01,    rA(2)+0.015,   'A', 'Color', [0,0,0]);
    text(rB(1)+0.01,    rB(2)+0.015,   'B', 'Color', [0,0,0]);
    text(rC(1)+0.01,    rC(2)+0.015,   'C', 'Color', [0,0,0]);
    text(rD(k,1)-0.015, rD(k,2)+0.015, 'D', 'Color', [0,0.45,0.74]);
    text(rE(k,1)-0.015, rE(k,2)+0.015, 'E', 'Color', [0,0.45,0.74]);
    text(rF(k,1)-0.015, rF(k,2)+0.015, 'F', 'Color', [0.93,0.69,0.13]);
    text(rG(k,1)-0.015, rG(k,2)+0.015, 'G', 'Color', [0.93,0.69,0.13]);

    xlabel('x(m)');
    ylabel('y(m)');
    title(['Mechanism Simulation ','(t = ',num2str(odet(k),'%.4f'),'s)'],tit);
    grid on; axis equal;
    xlim([xlo,xhi]);
    ylim([ylo,yhi]);
    hold off;
    % set(gcf, 'visible', 'off');     % 不显示窗口
    fr = getframe(gcf);
%     im = frame2im(fr);
%     [im,map] = rgb2ind(im,256);
%     if picNum == 1
%         imwrite(im,map,gifObj,'gif','LoopCount',inf,'DelayTime',delayTime);
%     else
%         imwrite(im,map,gifObj,'gif','WriteMode','append','DelayTime',delayTime);
%     end
%     picNum = picNum + 1;
    writeVideo(aviObj,fr);
    % disp(k);
end
close(aviObj);

end