function [] = plot_Fig7(dset)

%% Aerosol Types
LTS(1:3000,1:4,1:30) = NaN; %Create a random size matrix
RH(1:3000,1:4,1:30) = NaN; 

for k = 1 : 30
    % For every 2 C bin, I find the cases that fall into that temperature 
    %Top Temperature is taken CTT
    LTS_sMs = 0;
    LTS_sCs = 0;
    LTS_sDs = 0;
    LTS_sEs = 0;
    RH_sMs = 0;
    RH_sCs = 0;
    RH_sDs = 0;
    RH_sEs = 0;

    LTS_tempM = 0;
    LTS_tempC = 0;
    LTS_tempD = 0;
    LTS_tempE = 0;
    RH_tempM = 0;
    RH_tempC = 0;
    RH_tempD = 0;
    RH_tempE = 0;
    
    for s = 1 : 4 % For each season
        % For each cloud dataset
        inbox_s = find(dset(s).par.Top_Temp(:,11) <=(-50+2*k) & dset(s).par.Top_Temp(:,11)>=(-50+2*(k-1)));
                
        
        Ds = find(dset(s).par.CPhase_or_APhase(inbox_s,16) == 2 | dset(s).par.CPhase_or_APhase(inbox_s,16) == 2);
        Ms = find(dset(s).par.CPhase_or_APhase(inbox_s,16) == 1 | dset(s).par.CPhase_or_APhase(inbox_s,16) == 7);
        Es = find(dset(s).par.CPhase_or_APhase(inbox_s,16) == 6);
        Cs = find(dset(s).par.CPhase_or_APhase(inbox_s,16) == 3 | dset(s).par.CPhase_or_APhase(inbox_s,16) == 4);
    
        %LTS
        if ~isempty(Ms) 
            LTS_sMs = LTS_sMs + LTS_tempM + 1;
            LTS_eHs = LTS_sMs + length(Ms)-1;
            LTS(LTS_sMs:LTS_eHs,1,k) =  dset(s).par.Geo(inbox_s(Ms),12);
            LTS_tempM = length(Ms);
        end
        if ~isempty(Cs) 
            LTS_sCs = LTS_sCs + LTS_tempC + 1;
            LTS_eLs = LTS_sCs + length(Cs)-1;
            LTS(LTS_sCs:LTS_eLs,2,k) =  dset(s).par.Geo(inbox_s(Cs),12);
            LTS_tempC = length(Cs);
        end
        if ~isempty(Ds) 
            LTS_sDs = LTS_sDs + LTS_tempD + 1;
            LTS_eLs = LTS_sDs + length(Ds)-1;
            LTS(LTS_sDs:LTS_eLs,3,k) =  dset(s).par.Geo(inbox_s(Ds),12);
            LTS_tempD = length(Ds);
        end
        if ~isempty(Es) 
            LTS_sEs = LTS_sEs + LTS_tempE + 1;
            LTS_eLs = LTS_sEs + length(Es)-1;
            LTS(LTS_sEs:LTS_eLs,4,k) =  dset(s).par.Geo(inbox_s(Es),12);
            LTS_tempE = length(Es);
        end    
        
        %RH
        if ~isempty(Ms) 
            RH_sMs = RH_sMs + RH_tempM + 1;
            RH_eHs = RH_sMs + length(Ms)-1;
            RH(RH_sMs:RH_eHs,1,k) =  dset(s).par.CType_or_ARH(inbox_s(Ms),16);
            RH_tempM = length(Ms);
        end
        if ~isempty(Cs) 
            RH_sCs = RH_sCs + RH_tempC + 1;
            RH_eLs = RH_sCs + length(Cs)-1;
            RH(RH_sCs:RH_eLs,2,k) =  dset(s).par.CType_or_ARH(inbox_s(Cs),16);
            RH_tempC = length(Cs);
        end
        if ~isempty(Ds) 
            RH_sDs = RH_sDs + RH_tempD + 1;
            RH_eLs = RH_sDs + length(Ds)-1;
            RH(RH_sDs:RH_eLs,3,k) =  dset(s).par.CType_or_ARH(inbox_s(Ds),16);
            RH_tempD = length(Ds);
        end
        if ~isempty(Es) 
            RH_sEs = RH_sEs + RH_tempE + 1;
            RH_eLs = RH_sEs + length(Es)-1;
            RH(RH_sEs:RH_eLs,4,k) =  dset(s).par.CType_or_ARH(inbox_s(Es),16);
            RH_tempE = length(Es);
        end        
        
    end   
end

%% High/Low AOD
LTSH(1:1400,1:30) = NaN; %Create a random size matrix
LTSL(1:1400,1:30) = NaN;
RHH(1:1400,1:30) = NaN; 
RHL(1:1400,1:30) = NaN;

for k = 1 : 30
    % For every 2 C bin, I find the cases that fall into that temperature 
    %Top Temperature is taken CTT
    LTS_sHs = 0;
    LTS_sLs = 0;
    LTS_tempH = 0;
    LTS_tempL = 0;   
    
    RH_sHs = 0;
    RH_sLs = 0;
    RH_tempH = 0;
    RH_tempL = 0;   

    for s = 1 : 4 % For each season
        % For each cloud dataset
        inbox_s = find(dset(s).par.Top_Temp(:,11) <=(-50+2*k) & dset(s).par.Top_Temp(:,11)>=(-50+2*(k-1)));
                
        Hs = find(dset(s).par.AOD_532(inbox_s,16) > 0.25);
        Ls = find(dset(s).par.AOD_532(inbox_s,16) < 0.1);
        
        %LTS
        if ~isempty(Hs) 
            LTS_sHs = LTS_sHs + LTS_tempH + 1;
            LTS_eHs = LTS_sHs + length(Hs)-1;
            LTSH(LTS_sHs:LTS_eHs,k) =  dset(s).par.Geo(inbox_s(Hs),12);
            LTS_tempH = length(Hs);
        end
        if ~isempty(Ls) 
            LTS_sLs = LTS_sLs + LTS_tempL + 1;
            LTS_eLs = LTS_sLs + length(Ls)-1;
            LTSL(LTS_sLs:LTS_eLs,k) =  dset(s).par.Geo(inbox_s(Ls),12);
            LTS_tempL = length(Ls);
        end
        
        %RH
        if ~isempty(Hs) 
            RH_sHs = RH_sHs + LTS_tempH + 1;
            RH_eHs = RH_sHs + length(Hs)-1;
            RHH(RH_sHs:RH_eHs,k) =  dset(s).par.CType_or_ARH(inbox_s(Hs),16);
            RH_tempH = length(Hs);
        end
        if ~isempty(Ls) 
            RH_sLs = RH_sLs + RH_tempL + 1;
            RH_eLs = RH_sLs + length(Ls)-1;
            RHL(RH_sLs:RH_eLs,k) =  dset(s).par.CType_or_ARH(inbox_s(Ls),16);
            RH_tempL = length(Ls);
        end

    end   
end

%% Plot
figure
set(gcf, 'Position', [100, 50, 1300, 800])
    
ha = tight_subplot(2,2,[.05 .03],[.1 .04],[.07 .03]);
axes(ha(1))
for i = 1 : 30
    boxplotx(LTS(:,1,i),i,0.4,'lines','b');
    hold on
end
axesHandlesToAllLines = findobj(gca, 'Type', 'line');
for i = 1 : length(axesHandlesToAllLines)
    axesHandlesToAllLines(i).Color = [0, 0.45, 0.74];
end
ylim([0 40]);
xlim([5 25]);
set(gca, 'Fontsize',18,'LineWidth',2);
set(gca,'LineWidth',1.5,'TickLength',[0.025 0.025])
ylabel('LTS (K)')
yticks(0:10:40)
xticks(5:5:25)
set(gca,'xticklabels',[]);
%make 2nd axes:
a2=axes;
for i = 1 : 30
    boxplotx(LTS(:,2,i),i,0.4,'lines','r');
    hold on
end
axesHandlesToAllLines = findobj(gca, 'Type', 'line');
for i = 1 : length(axesHandlesToAllLines)
    axesHandlesToAllLines(i).Color = [0.85, 0.33, 0.1];
end
ylim([0 40]);
xlim([5 25]);
set(a2,'color','none')
set(a2, 'Position', ha(1).Position)
set(a2, 'Fontsize',18,'LineWidth',2);
set(a2,'LineWidth',1.5,'TickLength',[0.025 0.025])
set(gca,'xtick',[],'ytick',[])
%make 3nd axes:
a3=axes;
for i = 1 : 30
    boxplotx(LTS(:,3,i),i,0.4,'lines','y');
    hold on
end
axesHandlesToAllLines = findobj(gca, 'Type', 'line');
for i = 1 : length(axesHandlesToAllLines)
    axesHandlesToAllLines(i).Color = [0.93, 0.69, 0.13];
end
ylim([0 40]);
xlim([5 25]);
set(a3,'color','none')
set(a3, 'Position', ha(1).Position)
set(a3, 'Fontsize',18,'LineWidth',2);
set(a3,'LineWidth',1.5,'TickLength',[0.025 0.025])
set(gca,'xtick',[],'ytick',[])
%make 4th axes:
a4=axes;
for i = 1 : 30
    boxplotx(LTS(:,4,i),i,0.4,'lines','k');
    hold on
end
axesHandlesToAllLines = findobj(gca, 'Type', 'line');
for i = 1 : length(axesHandlesToAllLines)
    axesHandlesToAllLines(i).Color = [0.49, 0.15, 0.56];
end
ylim([0 40]);
xlim([5 25]);
set(a4,'color','none')
set(a4, 'Position', ha(1).Position)
set(a4, 'Fontsize',18,'LineWidth',2);
set(a4,'LineWidth',1.5,'TickLength',[0.025 0.025])
set(gca,'xtick',[],'ytick',[])


axes(ha(2))
for i = 1 : 30
    boxplotx(LTSH(:,i),i,0.4,'lines','k');
    hold on
end
ylim([0 40]);
xlim([5 25]);
set(gca, 'Fontsize',18,'LineWidth',2);
set(gca,'LineWidth',1.5,'TickLength',[0.025 0.025])
yticks(0:10:40)
set(gca,'yticklabels',[]);
xticks(5:5:25)
set(gca,'xticklabels',[]);
%make 2nd axes:
a2=axes;
for i = 1 : 30
    boxplotx(LTSL(:,i),i,0.4,'lines','r');
    hold on
end
ylim([0 40]);
xlim([5 25]);
set(a2,'color','none')
set(a2, 'Position', ha(2).Position)
set(a2, 'Fontsize',18,'LineWidth',2);
set(a2,'LineWidth',1.5,'TickLength',[0.025 0.025])
set(gca,'xtick',[],'ytick',[])


axes(ha(3))
for i = 1 : 30
    boxplotx(RH(:,1,i)*100,i,0.4,'lines','b');
    hold on
end
axesHandlesToAllLines = findobj(gca, 'Type', 'line');
for i = 1 : length(axesHandlesToAllLines)
    axesHandlesToAllLines(i).Color = [0, 0.45, 0.74];
end
ylim([0 120]);
xlim([5 25]);
set(gca, 'Fontsize',18,'LineWidth',2);
set(gca,'LineWidth',1.5,'TickLength',[0.025 0.025])
ylabel('RH (%)')
yticks(0:40:120)
yticklabels({'0','40','80','120'})
xlabel('CTT (^oC)');
xticks(5:5:25)
xticklabels({'-40','-30','-20','-10','0'})
%make 2nd axes:
a2=axes;
for i = 1 : 30
    boxplotx(RH(:,2,i)*100,i,0.4,'lines','r');
    hold on
end
axesHandlesToAllLines = findobj(gca, 'Type', 'line');
for i = 1 : length(axesHandlesToAllLines)
    axesHandlesToAllLines(i).Color = [0.85, 0.33, 0.1];
end
ylim([0 120]);
xlim([5 25]);
set(a2,'color','none')
set(a2, 'Position', ha(3).Position)
set(a2, 'Fontsize',18,'LineWidth',2);
set(a2,'LineWidth',1.5,'TickLength',[0.025 0.025])
set(gca,'xtick',[],'ytick',[])
%make 3nd axes:
a3=axes;
for i = 1 : 30
    boxplotx(RH(:,3,i)*100,i,0.4,'lines','y');
    hold on
end
axesHandlesToAllLines = findobj(gca, 'Type', 'line');
for i = 1 : length(axesHandlesToAllLines)
    axesHandlesToAllLines(i).Color = [0.93, 0.69, 0.13];
end
ylim([0 120]);
xlim([5 25]);
set(a3,'color','none')
set(a3, 'Position', ha(3).Position)
set(a3, 'Fontsize',18,'LineWidth',2);
set(a3,'LineWidth',1.5,'TickLength',[0.025 0.025])
set(gca,'xtick',[],'ytick',[])
%make 4th axes:
a4=axes;
for i = 1 : 30
    boxplotx(RH(:,4,i)*100,i,0.4,'lines','k');
    hold on
end
axesHandlesToAllLines = findobj(gca, 'Type', 'line');
for i = 1 : length(axesHandlesToAllLines)
    axesHandlesToAllLines(i).Color = [0.49, 0.15, 0.56];
end
ylim([0 120]);
xlim([5 25]);
set(a4,'color','none')
set(a4, 'Position', ha(3).Position)
set(a4, 'Fontsize',18,'LineWidth',2);
set(a4,'LineWidth',1.5,'TickLength',[0.025 0.025])
set(gca,'xtick',[],'ytick',[])
rectangle('Position',[12.5 5.5 12 43],'FaceColor','w','LineWidth',1.5)   % The containing box.
text(15,43, 'Marine (CM+DM)', 'Color', [0, 0.45, 0.74] , 'FontSize', 18); 
text(15,33, 'Continental (PC,S+CC)', 'Color', [0.85, 0.33, 0.1] , 'FontSize', 18);
text(15,23, 'Dust (D+PD)', 'Color', [0.93, 0.69, 0.13] , 'FontSize', 18); 
text(15,13, 'Elev. Smoke', 'Color', [0.49, 0.15, 0.56], 'FontSize', 18);
plot([13 14.5], [43 43],'Color', [0, 0.45, 0.74], 'LineWidth',2);
plot([13 14.5], [33 33],'Color', [0.85, 0.33, 0.1], 'LineWidth',2);
plot([13 14.5], [23 23],'Color', [0.93, 0.69, 0.13] , 'LineWidth',2);
plot([13 14.5], [13 13],'Color', [0.49, 0.15, 0.56], 'LineWidth',2);


axes(ha(4))
for i = 1 : 30
    boxplotx(RHH(:,i)*100,i,0.4,'lines','k');
    hold on
end
ylim([0 120]);
xlim([5 25]);
set(gca, 'Fontsize',18,'LineWidth',2);
set(gca,'LineWidth',1.5,'TickLength',[0.025 0.025])
text(22,23, 'High', 'Color', 'k', 'FontSize', 18); 
text(22,13, 'Low', 'Color', 'k', 'FontSize', 18);
plot([20 21.5], [13 13],'Color', 'r', 'LineWidth',2);
plot([20 21.5], [23 23],'Color', 'k', 'LineWidth',2);
rectangle('Position',[19.5 6.5 5 21],'LineWidth',1.5)   % The containing box.
yticks(0:40:120)
set(gca,'yticklabels',[])
xlabel('CTT (^oC)');
xticks(5:5:25)
xticklabels({'-40','-30','-20','-10','0'})
%make 2nd axes:
a2=axes;
for i = 1 : 30
    boxplotx(RHL(:,i)*100,i,0.4,'lines','r');
    hold on
end
ylim([0 120]);
xlim([5 25]);
set(a2,'color','none')
set(a2, 'Position', ha(4).Position)
set(a2, 'Fontsize',18,'LineWidth',2);
set(a2,'LineWidth',1.5,'TickLength',[0.025 0.025])
set(gca,'xtick',[],'ytick',[])


print(gcf,'-dpng','-r600','Fig7.png');