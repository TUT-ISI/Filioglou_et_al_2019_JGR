function [] = plot_CCT_vs_Temp_errorbars_subroutine(f_DB)
% Merge seasons to one
dset.par = struct('Geo',[f_DB(1).par.Geo;f_DB(2).par.Geo;f_DB(3).par.Geo;f_DB(4).par.Geo],...         
    'Top_Height',[f_DB(1).par.Top_Height;f_DB(2).par.Top_Height;f_DB(3).par.Top_Height;f_DB(4).par.Top_Height],...
    'Bot_Height',[f_DB(1).par.Bot_Height;f_DB(2).par.Bot_Height;f_DB(3).par.Bot_Height;f_DB(4).par.Bot_Height],...         
    'Top_Temp',[f_DB(1).par.Top_Temp;f_DB(2).par.Top_Temp;f_DB(3).par.Top_Temp;f_DB(4).par.Top_Temp],...        
    'Base_Temp',[f_DB(1).par.Base_Temp;f_DB(2).par.Base_Temp;f_DB(3).par.Base_Temp;f_DB(4).par.Base_Temp],...        
    'Avg_or_SatWaterLayer',[f_DB(1).par.Avg_or_SatWaterLayer;f_DB(2).par.Avg_or_SatWaterLayer;f_DB(3).par.Avg_or_SatWaterLayer;f_DB(4).par.Avg_or_SatWaterLayer],...        
    'Confidense',[f_DB(1).par.Confidense;f_DB(2).par.Confidense;f_DB(3).par.Confidense;f_DB(4).par.Confidense],...        
    'CPhase_or_APhase',[f_DB(1).par.CPhase_or_APhase;f_DB(2).par.CPhase_or_APhase;f_DB(3).par.CPhase_or_APhase;f_DB(4).par.CPhase_or_APhase],...        
    'CType_or_ARH',[f_DB(1).par.CType_or_ARH;f_DB(2).par.CType_or_ARH;f_DB(3).par.CType_or_ARH;f_DB(4).par.CType_or_ARH],...        
    'AOD_532',[f_DB(1).par.AOD_532;f_DB(2).par.AOD_532;f_DB(3).par.AOD_532;f_DB(4).par.AOD_532],...        
    'AOD_1064',[f_DB(1).par.AOD_1064;f_DB(2).par.AOD_1064;f_DB(3).par.AOD_1064;f_DB(4).par.AOD_1064],...        
    'Depol',[f_DB(1).par.Depol;f_DB(2).par.Depol;f_DB(3).par.Depol;f_DB(4).par.Depol],...        
    'CPhaseConf',[f_DB(1).par.CPhaseConf;f_DB(2).par.CPhaseConf;f_DB(3).par.CPhaseConf;f_DB(4).par.CPhaseConf],...        
    'AType_CType_Confidence',[f_DB(1).par.AType_CType_Confidence;f_DB(2).par.AType_CType_Confidence;f_DB(3).par.AType_CType_Confidence;f_DB(4).par.AType_CType_Confidence]);        

% Create random indices from the final dataset in order to calculate the std
% using bootstrapping technique
% Boot strapping
n = 200; %How many samples to extract
nS = ceil(length(dset.par.Geo)/2); %How many cases in each turn


O_v4=[];
O_s=[];

O_A_v4=[];
O_A_s=[];

HO_A_s = [];
LO_A_s = [];

for i = 1 : n
    id = randperm(length(dset.par.Geo),nS);
    id_sort = sort(id);
    
    %we use this index to sample the dataset
    Oc_v4(1:4,1:30) = NaN;
    Oc_s(1:3,1:30) = NaN;

    %Initialize some matrices
    Oc_A_v4(1:4,1:7,1:30) = NaN;
    Oc_A_s(1:3,1:7,1:30) = NaN;
    
    %Initialize some matrices
    HOc_A_s(1:3,1:7,1:30) = NaN;
    LOc_A_s(1:3,1:7,1:30) = NaN;


    for k = 1 : 30
        % For every 2 C bin, find the cases that fall into that temperature 
        %Top Temperature is taken CTT
        
        % For each cloud dataset
        inbox_v4 = find(dset.par.Top_Temp(id_sort,1) <=(-50+2*k) & dset.par.Top_Temp(id_sort,1)>=(-50+2*(k-1)));
        inbox_s = find(dset.par.Top_Temp(id_sort,11) <=(-50+2*k) & dset.par.Top_Temp(id_sort,11)>=(-50+2*(k-1)));
        
        %After finding the cases in that 2 bin temperature region, I check and
        %count the cloud phases falling in that bin
         Ice_v4 = find(dset.par.CPhase_or_APhase(id_sort(inbox_v4),1) == 1);        %For Ice phase
         Ice_s = find(dset.par.CPhase_or_APhase(id_sort(inbox_s),11) == 1);
        
         Water_v4 = find(dset.par.CPhase_or_APhase(id_sort(inbox_v4),1) == 2);       %For Water phase
         Water_s = find(dset.par.CPhase_or_APhase(id_sort(inbox_s),11) == 3);

         Mixed_s = find(dset.par.CPhase_or_APhase(id_sort(inbox_s),11) == 2);        %For Mixed phase (Only in CloudSat)
        
         Unknown_v4 = find(dset.par.CPhase_or_APhase(id_sort(inbox_v4),1) == 0);     %For Unknown phase (Only in Calipso)
        
         HorzIce_v4 = find(dset.par.CPhase_or_APhase(id_sort(inbox_v4),1) == 3);     %For Horizontal Ice phase (Only in Calipso)
        
         cal = [length(Ice_v4),length(Water_v4),length(Unknown_v4),length(HorzIce_v4)];
         sat = [length(Ice_s),length(Water_s),length(Mixed_s)];
          
         for p = 1 : 4
             %Calcluate per temp bin the occurance of each phase. No aerosol
             %distinction yet, just the cloud phases. This is per season.
             Oc_v4(p,k) = cal(p) ./ sum(cal,'omitnan');      
         end
        
            for p = 1 : 3
                %Calcluate per temp bin the occurance of each phase. No aerosol
                %distinction yet, just the cloud phases. This is per season.
                Oc_s(p,k) = sat(p) ./ sum(sat,'omitnan');
            end

            %Calculate the cloud phase occurence per aerosol type
            for a = 1 : 7
                Ice_A_v4 = find(dset.par.CPhase_or_APhase(id_sort(inbox_v4(Ice_v4)),16) == a);
                Ice_A_s = find(dset.par.CPhase_or_APhase(id_sort(inbox_s(Ice_s)),16) == a);
        
                Water_A_v4 = find(dset.par.CPhase_or_APhase(id_sort(inbox_v4(Water_v4)),16) == a);
                Water_A_s = find(dset.par.CPhase_or_APhase(id_sort(inbox_s(Water_s)),16) == a);
        
                Mixed_A_s = find(dset.par.CPhase_or_APhase(id_sort(inbox_s(Mixed_s)),16) == a);
        
                Unknown_A_v4 = find(dset.par.CPhase_or_APhase(id_sort(inbox_v4(Unknown_v4)),16) == a);
        
                HorzIce_A_v4 = find(dset.par.CPhase_or_APhase(id_sort(inbox_v4(HorzIce_v4)),16) == a);
            
                cal_A = [length(Ice_A_v4),length(Water_A_v4),length(Unknown_A_v4),length(HorzIce_A_v4)];
                sat_A = [length(Ice_A_s),length(Water_A_s),length(Mixed_A_s)];
                
                %For High/Low AOD
                HsI = find(dset.par.AOD_532(id_sort(inbox_s(Ice_s(Ice_A_s))),16) > 0.25);
                HsW = find(dset.par.AOD_532(id_sort(inbox_s(Water_s(Water_A_s))),16) > 0.25);
                HsM = find(dset.par.AOD_532(id_sort(inbox_s(Mixed_s(Mixed_A_s))),16) > 0.25);

                LsI = find(dset.par.AOD_532(id_sort(inbox_s(Ice_s(Ice_A_s))),16) < 0.1);
                LsW = find(dset.par.AOD_532(id_sort(inbox_s(Water_s(Water_A_s))),16) < 0.1);
                LsM = find(dset.par.AOD_532(id_sort(inbox_s(Mixed_s(Mixed_A_s))),16) < 0.1);

                Hsat_A = [length(HsI),length(HsW),length(HsM)];
                Lsat_A = [length(LsI),length(LsW),length(LsM)];

                for p = 1 : 4
                    %Calcluate per temp bin the occurance of each phase. No aerosol
                    %distinction yet, just the cloud phases. This is per season.
                    Oc_A_v4(p,a,k) = cal_A(p) ./ sum(cal_A,'omitnan'); 
                end
        
                for p = 1 : 3
                    %Calcluate per temp bin the occurance of each phase. No aerosol
                    %distinction yet, just the cloud phases. This is per season.
                    Oc_A_s(p,a,k) = sat_A(p) ./ sum(sat_A,'omitnan');   
                    
                    HOc_A_s(p,a,k) = Hsat_A(p)./ sum(Hsat_A,'omitnan');  
                    LOc_A_s(p,a,k) = Lsat_A(p)./ sum(Lsat_A,'omitnan');          

                end
            end        
    end  
    O_v4 = [O_v4; Oc_v4];
    O_s = [O_s; Oc_s];
    O_A_v4 = [O_A_v4; Oc_A_v4];
    O_A_s = [O_A_s; Oc_A_s];
    
    HO_A_s = [HO_A_s; HOc_A_s];
    LO_A_s = [LO_A_s; LOc_A_s];
    
end

% Calculate overall trend
[Ice,Water,Mixed,IceC,WaterC,IceS,WaterS,MixedS] = CCT_vs_Temp_AT_counters_subroutine(dset);
[HIce,HWater,HMixed,LIce,LWater,LMixed,HOc_A_s_count,LOc_A_s_count] = CCT_vs_Temp_AOD_counters_subroutine(dset);

%% Fig4: for low-level clouds with all the constrains!!!!
t = -49:2:9;

%For Cal
Ic_std = std(O_v4(1:4:length(O_v4),:),'omitnan');
Wc_std = std(O_v4(2:4:length(O_v4),:),'omitnan');

%For Sat
I_std = std(O_s(1:3:length(O_s),:),'omitnan');
W_std = std(O_s(2:3:length(O_s),:),'omitnan');
M_std = std(O_s(3:3:length(O_s),:),'omitnan');

figure
set(gcf, 'Position', [50, 50, 1400, 800])    
ha = tight_subplot(1,1,[.03 .06],[.13 .22],[.07 .03]);
axes(ha(1))
errorbar(t,IceS./(IceS+WaterS+MixedS),I_std,'LineWidth',2);
hold on
errorbar(t, WaterS./(IceS+WaterS+MixedS),W_std,'LineWidth',2);
hold on
errorbar(t, MixedS./(IceS+WaterS+MixedS),M_std,'LineWidth',2);
hold on
errorbar(t, (WaterS+MixedS)./(IceS+WaterS+MixedS),M_std,'k','LineWidth',2);
hold on
errorbar(t, IceC./(IceC+WaterC),Ic_std,'--','color',[0 0.45 0.74],'LineWidth',2);
hold on
errorbar(t, WaterC./(IceC+WaterC),Wc_std,'--','color',[0.85 0.33 0.1],'LineWidth',2);
xlim([-40 0]);
ylim([0 1]);
ylabel('Relative Cloud Phase Occurrence');
xlabel('Cloud Top Temperature (^oC)');
legend({'Ice, combined CloudSat/CALIPSO','Water, combined CloudSat/CALIPSO','Mixed, combined CloudSat/CALIPSO','Water + Mixed, combined CloudSat/CALIPSO', 'Ice, CALIPSO','Water, CALIPSO'},'Location','northwestoutside');
set(gca, 'Fontsize',22,'LineWidth',2);

print(gcf,'-dpng','-r600','Fig4.png');

%% Fig5
t = -49:2:9;

%For Sat
I_std(1,:) = std([O_A_s(1:3:length(O_A_s),1,:); O_A_s(1:3:length(O_A_s),7,:)],'omitnan');
W_std(1,:) = std([O_A_s(2:3:length(O_A_s),1,:);  O_A_s(2:3:length(O_A_s),7,:)],'omitnan');
M_std(1,:) = std([O_A_s(3:3:length(O_A_s),1,:);  O_A_s(3:3:length(O_A_s),7,:)],'omitnan');

I_std(2,:) = std([O_A_s(1:3:length(O_A_s),4,:); O_A_s(1:3:length(O_A_s),3,:)],'omitnan');
W_std(2,:) = std([O_A_s(2:3:length(O_A_s),4,:); O_A_s(2:3:length(O_A_s),3,:)],'omitnan');
M_std(2,:) = std([O_A_s(3:3:length(O_A_s),4,:); O_A_s(3:3:length(O_A_s),3,:)],'omitnan');

I_std(3,:) = std([O_A_s(1:3:length(O_A_s),2,:); O_A_s(1:3:length(O_A_s),5,:)],'omitnan');
W_std(3,:) = std([O_A_s(2:3:length(O_A_s),2,:); O_A_s(2:3:length(O_A_s),5,:)],'omitnan');
M_std(3,:) = std([O_A_s(3:3:length(O_A_s),2,:); O_A_s(3:3:length(O_A_s),5,:)],'omitnan');

I_std(4,:) = std(O_A_s(1:3:length(O_A_s),6,:),'omitnan');
W_std(4,:) = std(O_A_s(2:3:length(O_A_s),6,:),'omitnan');
M_std(4,:) = std(O_A_s(3:3:length(O_A_s),6,:),'omitnan');


hf=figure;
set(gcf, 'Position', [100, 50, 1600, 800])    
ha = tight_subplot(1,3,[.03 .06],[.13 .22],[.07 .03]);
axes(ha(1))
for i = 1:4
errorbar(t,Ice(i,:)./(Ice(i,:)+Water(i,:)+Mixed(i,:)),I_std(i,:)/2,'LineWidth',2);
xlim([-40 0]);
ylim([0 1]);
ylabel('RCPO');
xlabel('CTT (^oC)');
th = title('Ice');
titlePos = get( th , 'position');
set( th , 'position' , [-19.9999744807886 1.25 1.42108547152020e-14]);
hold on
end

ymin = min(ylim);
yrng = diff(ylim);
nrxt = 10; 
a_1 = linspace(-38, -2, nrxt);
xt = round(a_1);
a_1 = cellstr(strsplit(num2str(sum(reshape(Ice(4,6:25),2,10)),'%d '),' '));
text([(xt(1)-xt(2))*0.5 xt], ones(1,nrxt+1)*ymin+1.05*yrng, [' ' a_1],'HorizontalAlignment','center','Color',[0.49 0.18 0.56],'FontSize',14)
a_2 = cellstr(strsplit(num2str(sum(reshape(Ice(2,6:25),2,10)),'%d '),' '));
text([(xt(1)-xt(2))*0.5 xt], ones(1,nrxt+1)*ymin+1.10*yrng, [' ' a_2],'HorizontalAlignment','center','Color',[0.93 0.69 0.13],'FontSize',14)
a_3 = cellstr(strsplit(num2str(sum(reshape(Ice(3,6:25),2,10)),'%d '),' '));
text([(xt(1)-xt(2))*0.5 xt], ones(1,nrxt+1)*ymin+1.15*yrng, [' ' a_3],'HorizontalAlignment','center','Color',[0.85 0.33 0.1],'FontSize',14)
a_4 = cellstr(strsplit(num2str(sum(reshape(Ice(1,6:25),2,10)),'%d '),' '));
text([(xt(1)-xt(2))*0.5 xt], ones(1,nrxt+1)*ymin+1.20*yrng, [' ' a_4],'HorizontalAlignment','center','Color',[0 0.45 0.74],'FontSize',14)
set(gca, 'Fontsize',22,'LineWidth',2);
     
       
axes(ha(2))
for i = 1:4
errorbar(t,Water(i,:)./(Ice(i,:)+Water(i,:)+Mixed(i,:)),W_std(i,:)/2,'LineWidth',2);
xlim([-40 0]);
ylim([0 1]);
xlabel('CTT (^oC)');
th = title('Water');
titlePos = get( th , 'position');
set( th , 'position' , [-19.9999744807886 1.25 1.42108547152020e-14]);
legend({'Marine (CM+DM)','Continental (PC,S+CC)','Dust (D+PD)','Elev. Smoke'},'Location','Northwest');
hold on
end

a_1 = cellstr(strsplit(num2str(sum(reshape(Water(4,6:25),2,10)),'%d '),' '));
text([(xt(1)-xt(2))*0.5 xt], ones(1,nrxt+1)*ymin+1.05*yrng, [' ' a_1],'HorizontalAlignment','center','Color',[0.49 0.18 0.56],'FontSize',14)
a_2 = cellstr(strsplit(num2str(sum(reshape(Water(2,6:25),2,10)),'%d '),' '));
text([(xt(1)-xt(2))*0.5 xt], ones(1,nrxt+1)*ymin+1.10*yrng, [' ' a_2],'HorizontalAlignment','center','Color',[0.93 0.69 0.13],'FontSize',14)
a_3 = cellstr(strsplit(num2str(sum(reshape(Water(3,6:25),2,10)),'%d '),' '));
text([(xt(1)-xt(2))*0.5 xt], ones(1,nrxt+1)*ymin+1.15*yrng, [' ' a_3],'HorizontalAlignment','center','Color',[0.85 0.33 0.1],'FontSize',14)
a_4 = cellstr(strsplit(num2str(sum(reshape(Water(1,6:25),2,10)),'%d '),' '));
text([(xt(1)-xt(2))*0.5 xt], ones(1,nrxt+1)*ymin+1.20*yrng, [' ' a_4],'HorizontalAlignment','center','Color',[0 0.45 0.74],'FontSize',14)
set(gca, 'Fontsize',22,'LineWidth',2);

axes(ha(3))
for i = 1:4
errorbar(t,Mixed(i,:)./(Ice(i,:)+Water(i,:)+Mixed(i,:)),M_std(i,:)/2,'LineWidth',2);
xlim([-40 0]);
ylim([0 1]);
xlabel('CTT (^oC)');
th = title('Mixed');
titlePos = get( th , 'position');
set( th , 'position' , [-19.9999744807886 1.25 1.42108547152020e-14]);
hold on
end

a_1 = cellstr(strsplit(num2str(sum(reshape(Mixed(4,6:25),2,10)),'%d '),' '));
text([(xt(1)-xt(2))*0.5 xt], ones(1,nrxt+1)*ymin+1.05*yrng, [' ' a_1],'HorizontalAlignment','center','Color',[0.49 0.18 0.56],'FontSize',14)
a_2 = cellstr(strsplit(num2str(sum(reshape(Mixed(2,6:25),2,10)),'%d '),' '));
text([(xt(1)-xt(2))*0.5 xt], ones(1,nrxt+1)*ymin+1.10*yrng, [' ' a_2],'HorizontalAlignment','center','Color',[0.93 0.69 0.13],'FontSize',14)
a_3 = cellstr(strsplit(num2str(sum(reshape(Mixed(3,6:25),2,10)),'%d '),' '));
text([(xt(1)-xt(2))*0.5 xt], ones(1,nrxt+1)*ymin+1.15*yrng, [' ' a_3],'HorizontalAlignment','center','Color',[0.85 0.33 0.1],'FontSize',14)
a_4 = cellstr(strsplit(num2str(sum(reshape(Mixed(1,6:25),2,10)),'%d '),' '));
text([(xt(1)-xt(2))*0.5 xt], ones(1,nrxt+1)*ymin+1.20*yrng, [' ' a_4],'HorizontalAlignment','center','Color',[0 0.45 0.74],'FontSize',14)
set(gca, 'Fontsize',22,'LineWidth',2);


%Boxes around the numbers
annotation(hf, 'textbox', [0.07 0.79 0.26 0.14],'LineWidth',2);
annotation(hf, 'textbox', [0.39 0.79 0.26 0.14],'LineWidth',2);
annotation(hf, 'textbox', [0.71 0.79 0.26 0.14],'LineWidth',2);


print(gcf,'-dpng','-r600','Fig5.png');

%% Fig6a
t = -49:2:9;

clear HI HW  HM HI_std HW_std HM_std LI_std LW_std LM_std

%For Sat
HI_std(1,:) = std([HO_A_s(1:3:length(HO_A_s),2,:); HO_A_s(1:3:length(HO_A_s),5,:)],'omitnan');
HW_std(1,:) = std([HO_A_s(2:3:length(HO_A_s),2,:); HO_A_s(2:3:length(HO_A_s),5,:)],'omitnan');
HM_std(1,:) = std([HO_A_s(3:3:length(HO_A_s),2,:); HO_A_s(3:3:length(HO_A_s),5,:)],'omitnan');

HI_std(2,:) = std([HO_A_s(1:3:length(HO_A_s),1,:); HO_A_s(1:3:length(HO_A_s),3,:); HO_A_s(1:3:length(HO_A_s),4,:); HO_A_s(1:3:length(HO_A_s),6,:); HO_A_s(1:3:length(HO_A_s),7,:)],'omitnan');
HW_std(2,:) = std([HO_A_s(2:3:length(HO_A_s),1,:); HO_A_s(2:3:length(HO_A_s),3,:); HO_A_s(2:3:length(HO_A_s),4,:); HO_A_s(2:3:length(HO_A_s),6,:); HO_A_s(2:3:length(HO_A_s),7,:)],'omitnan');
HM_std(2,:) = std([HO_A_s(3:3:length(HO_A_s),1,:); HO_A_s(3:3:length(HO_A_s),3,:); HO_A_s(3:3:length(HO_A_s),4,:); HO_A_s(3:3:length(HO_A_s),6,:); HO_A_s(3:3:length(HO_A_s),7,:)],'omitnan');

LI_std(1,:) = std([LO_A_s(1:3:length(LO_A_s),2,:); LO_A_s(1:3:length(LO_A_s),5,:)],'omitnan');
LW_std(1,:) = std([LO_A_s(2:3:length(LO_A_s),2,:); LO_A_s(2:3:length(LO_A_s),5,:)],'omitnan');
LM_std(1,:) = std([LO_A_s(3:3:length(LO_A_s),2,:); LO_A_s(3:3:length(LO_A_s),5,:)],'omitnan');

LI_std(2,:) = std([LO_A_s(1:3:length(LO_A_s),1,:); LO_A_s(1:3:length(LO_A_s),3,:); LO_A_s(1:3:length(LO_A_s),4,:); LO_A_s(1:3:length(LO_A_s),6,:); LO_A_s(1:3:length(LO_A_s),7,:)],'omitnan');
LW_std(2,:) = std([LO_A_s(2:3:length(LO_A_s),1,:); LO_A_s(2:3:length(LO_A_s),3,:); LO_A_s(2:3:length(LO_A_s),4,:); LO_A_s(2:3:length(LO_A_s),6,:); LO_A_s(2:3:length(LO_A_s),7,:)],'omitnan');
LM_std(2,:) = std([LO_A_s(3:3:length(LO_A_s),1,:); LO_A_s(3:3:length(LO_A_s),3,:); LO_A_s(3:3:length(LO_A_s),4,:); LO_A_s(3:3:length(LO_A_s),6,:); LO_A_s(3:3:length(LO_A_s),7,:)],'omitnan');


figure;
set(gcf, 'Position', [100, 50, 1600, 600])
    
ha = tight_subplot(1,3,[.03 .06],[.15 .08],[.07 .03]);
axes(ha(1))
for i = 1:2
errorbar(t, HIce(i,:)./(HIce(i,:)+HWater(i,:)+HMixed(i,:)),HI_std(i,:)/2,'LineWidth',2);
hold on
errorbar(t, LIce(i,:)./(LIce(i,:)+LWater(i,:)+LMixed(i,:)),LI_std(i,:)/2,'LineWidth',2);
xlim([-40 0]);
ylim([0 1]);
ylabel('RCPO');
xlabel('CTT (^oC)');
title('Ice');
hold on
end
set(gca, 'Fontsize',22,'LineWidth',2);


axes(ha(2))
for i = 1:2
errorbar(t, HWater(i,:)./(HIce(i,:)+HWater(i,:)+HMixed(i,:)),HW_std(i,:)/2,'LineWidth',2);
hold on
errorbar(t, LWater(i,:)./(LIce(i,:)+LWater(i,:)+LMixed(i,:)),LW_std(i,:)/2,'LineWidth',2);
xlim([-40 0]);
ylim([0 1]);
xlabel('CTT (^oC)');
title('Water');
legend({'High dust','Low dust','High rest', 'Low rest','High region 1', 'Low region 1'},'Location','Northwest');
hold on
end
set(gca, 'Fontsize',22,'LineWidth',2);


axes(ha(3))
for i = 1:2
errorbar(t, HMixed(i,:)./(HIce(i,:)+HWater(i,:)+HMixed(i,:)),HM_std(i,:)/2,'LineWidth',2);
hold on
errorbar(t, LMixed(i,:)./(LIce(i,:)+LWater(i,:)+LMixed(i,:)),LM_std(i,:)/2,'LineWidth',2);
xlim([-40 0]);
ylim([0 1]);
xlabel('CTT (^oC)');
title('Mixed');
hold on
end
set(gca, 'Fontsize',22,'LineWidth',2);

print(gcf,'-dpng','-r600','Fig6a.png');

%% Fig6b
t = -49:2:9;

%for Sat
HIc(1,:) = HOc_A_s_count(1,1,:);
HWc(1,:) = HOc_A_s_count(2,1,:);
HMc(1,:) = HOc_A_s_count(3,1,:);
HIc(2,:) = HOc_A_s_count(1,2,:);
HWc(2,:) = HOc_A_s_count(2,2,:);
HMc(2,:) = HOc_A_s_count(3,2,:);
HIc(3,:) = HOc_A_s_count(1,3,:);
HWc(3,:) = HOc_A_s_count(2,3,:);
HMc(3,:) = HOc_A_s_count(3,3,:);
HIc(4,:) = HOc_A_s_count(1,4,:);
HWc(4,:) = HOc_A_s_count(2,4,:);
HMc(4,:) = HOc_A_s_count(3,4,:);
HIc(5,:) = HOc_A_s_count(1,5,:);
HWc(5,:) = HOc_A_s_count(2,5,:);
HMc(5,:) = HOc_A_s_count(3,5,:);
HIc(6,:) = HOc_A_s_count(1,6,:);
HWc(6,:) = HOc_A_s_count(2,6,:);
HMc(6,:) = HOc_A_s_count(3,6,:);
HIc(7,:) = HOc_A_s_count(1,7,:);
HWc(7,:) = HOc_A_s_count(2,7,:);
HMc(7,:) = HOc_A_s_count(3,7,:);
    
LIc(1,:) = LOc_A_s_count(1,1,:);
LWc(1,:) = LOc_A_s_count(2,1,:);
LMc(1,:) = LOc_A_s_count(3,1,:);
LIc(2,:) = LOc_A_s_count(1,2,:);
LWc(2,:) = LOc_A_s_count(2,2,:);
LMc(2,:) = LOc_A_s_count(3,2,:);
LIc(3,:) = LOc_A_s_count(1,3,:);
LWc(3,:) = LOc_A_s_count(2,3,:);
LMc(3,:) = LOc_A_s_count(3,3,:);
LIc(4,:) = LOc_A_s_count(1,4,:);
LWc(4,:) = LOc_A_s_count(2,4,:);
LMc(4,:) = LOc_A_s_count(3,4,:);
LIc(5,:) = LOc_A_s_count(1,5,:);
LWc(5,:) = LOc_A_s_count(2,5,:);
LMc(5,:) = LOc_A_s_count(3,5,:);
LIc(6,:) = LOc_A_s_count(1,6,:);
LWc(6,:) = LOc_A_s_count(2,6,:);
LMc(6,:) = LOc_A_s_count(3,6,:);
LIc(7,:) = LOc_A_s_count(1,7,:);
LWc(7,:) = LOc_A_s_count(2,7,:);
LMc(7,:) = LOc_A_s_count(3,7,:);

figure;
set(gcf, 'Position', [100, 50, 1600, 600])
ha = tight_subplot(1,2,[.05 .06],[.15 .08],[.07 .03]);
    
axes(ha(1))
h=bar(t,[HIc(2,:)+HWc(2,:)+HMc(2,:);HIc(5,:)+HWc(5,:)+HMc(5,:)]', 'stacked','LineStyle','none');
set(h,{'FaceColor'},{rgb('Chocolate');'k'});
hold on
h=bar(t,[LIc(2,:)+LWc(2,:)+LMc(2,:);LIc(5,:)+LWc(5,:)+LMc(5,:)]', 'stacked','BarWidth', 0.4,'LineStyle','none');
set(h,{'FaceColor'},{rgb('DarkRed');rgb('DimGrey')});
xlim([-40 0]);
ylim([0 1100]);
xlabel('CTT (^oC)');
ylabel('Number of cases');
title('Dust');
legend({'High D','High PD','Low D','Low PD'})
set(gca, 'Fontsize',22,'LineWidth',2);

axes(ha(2))
h=bar(t,[HIc(1,:)+HWc(1,:)+HMc(1,:);HIc(3,:)+HWc(3,:)+HMc(3,:);HIc(4,:)+HWc(4,:)+HMc(4,:);HIc(6,:)+HWc(6,:)+HMc(6,:);HIc(7,:)+HWc(7,:)+HMc(7,:)]', 'stacked','LineStyle','none');
set(h,{'FaceColor'},{rgb('DimGrey');[0 0.45 0.74];rgb('LightBlue');rgb('DarkGoldenRod');rgb('FireBrick')});
hold on
h=bar(t,[LIc(1,:)+LWc(1,:)+LMc(1,:);LIc(3,:)+LWc(3,:)+LMc(3,:);LIc(4,:)+LWc(4,:)+LMc(4,:);LIc(6,:)+LWc(6,:)+LMc(6,:);LIc(7,:)+LWc(7,:)+LMc(7,:)]', 'stacked','BarWidth', 0.3,'LineStyle','none');
set(h,{'FaceColor'},{rgb('MidnightBlue');rgb('RoyalBlue');rgb('DarkGreen');[0.75 0.75 0];[0.93 0.69 0.13]});
xlim([-40 0]);
ylim([0 1100]);
xlabel('CTT (^oC)');
title('Rest');
set(gca, 'Fontsize',22,'LineWidth',2);
legend({'High CM','High PC,S','High CC','High ES','High DM','Low CM','Low PC,S','Low CC','Low ES','Low DM'})

print(gcf,'-dpng','-r600','Fig6b.png');

