function [Ice,Water,Mixed,IceC,WaterC,IceS,WaterS,MixedS]= CCT_vs_Temp_AT_counters_subroutine(dset)
%% ------------------------------------------------------------------------
%Big loop fo the 2 C temp binning.
%Initialize some matrices
Oc_v4_count(1:4,1:30) = NaN;
Oc_s_count(1:3,1:30) = NaN;

%Initialize some matrices
Oc_A_v4_count(1:4,1:7,1:30) = NaN;
Oc_A_s_count(1:3,1:7,1:30) = NaN;

for k = 1 : 30
    % For every 2 C bin, I find the cases that fall into that temperature 
    % For each cloud dataset
    inbox_v4 = find(dset.par.Top_Temp(:,1) <=(-50+2*k) & dset.par.Top_Temp(:,1)>=(-50+2*(k-1)));
    inbox_s = find(dset.par.Top_Temp(:,11) <=(-50+2*k) & dset.par.Top_Temp(:,11)>=(-50+2*(k-1)));
        
    %After finding the cases in that 2 bin temperature region, check and
    %count the cloud phases falling in that bin
    Ice_v4 = find(dset.par.CPhase_or_APhase(inbox_v4,1) == 1);        %For Ice phase
    Ice_s = find(dset.par.CPhase_or_APhase(inbox_s,11) == 1);
        
    Water_v4 = find(dset.par.CPhase_or_APhase(inbox_v4,1) == 2);       %For Water phase
    Water_s = find(dset.par.CPhase_or_APhase(inbox_s,11) == 3);

    Mixed_s = find(dset.par.CPhase_or_APhase(inbox_s,11) == 2); %For Mixed phase (Only in CloudSat)
        
    Unknown_v4 = find(dset.par.CPhase_or_APhase(inbox_v4,1) == 0);     %For Unknown phase (Only in Calipso)
        
    HorzIce_v4 = find(dset.par.CPhase_or_APhase(inbox_v4,1) == 3);     %For Horizontal Ice phase (Only in Calipso)
        
    cal = [length(Ice_v4),length(Water_v4),length(Unknown_v4),length(HorzIce_v4)];
    sat = [length(Ice_s),length(Water_s),length(Mixed_s)];
        
    for p = 1 : 4
        Oc_v4_count(p,k) = cal(p);
    end
        
    for p = 1 : 3
        Oc_s_count(p,k) = sat(p);
    end

    %Calculate the cloud phase occurence per aerosol type
    for a = 1 : 7
        Ice_A_v4 = find(dset.par.CPhase_or_APhase(inbox_v4(Ice_v4),16) == a);
        Ice_A_s = find(dset.par.CPhase_or_APhase(inbox_s(Ice_s),16) == a);
        
        Water_A_v4 = find(dset.par.CPhase_or_APhase(inbox_v4(Water_v4),16) == a);
        Water_A_s = find(dset.par.CPhase_or_APhase(inbox_s(Water_s),16) == a);
        
        Mixed_A_s = find(dset.par.CPhase_or_APhase(inbox_s(Mixed_s),16) == a);
        
        Unknown_A_v4 = find(dset.par.CPhase_or_APhase(inbox_v4(Unknown_v4),16) == a);
        
        HorzIce_A_v4 = find(dset.par.CPhase_or_APhase(inbox_v4(HorzIce_v4),16) == a);
            
        cal_A = [length(Ice_A_v4),length(Water_A_v4),length(Unknown_A_v4),length(HorzIce_A_v4)];
        sat_A = [length(Ice_A_s),length(Water_A_s),length(Mixed_A_s)];
            
        for p = 1 : 4
            Oc_A_v4_count(p,a,k) = cal_A(p);
        end
        
        for p = 1 : 3
            Oc_A_s_count(p,a,k) = sat_A(p);
        end
    end   
end


%for Sat
IceC = Oc_v4_count(1,:);
WaterC = Oc_v4_count(2,:);

IceS = Oc_s_count(1,:);
WaterS = Oc_s_count(2,:);
MixedS = Oc_s_count(3,:);

for j = 1 : 30
    Ice(1,j) = sum(Oc_A_s_count(1,1,j),'omitnan')+ sum(Oc_A_s_count(1,7,j),'omitnan');
    Water(1,j) = sum(Oc_A_s_count(2,1,j),'omitnan')+ sum(Oc_A_s_count(2,7,j),'omitnan');
    Mixed(1,j) = sum(Oc_A_s_count(3,1,j),'omitnan')+ sum(Oc_A_s_count(3,7,j),'omitnan');

    Ice(2,j) = sum(Oc_A_s_count(1,4,j),'omitnan')+ sum(Oc_A_s_count(1,3,j),'omitnan');
    Water(2,j) = sum(Oc_A_s_count(2,4,j),'omitnan')+ sum(Oc_A_s_count(2,3,j),'omitnan');
    Mixed(2,j) = sum(Oc_A_s_count(3,4,j),'omitnan')+ sum(Oc_A_s_count(3,3,j),'omitnan');
    
    
    Ice(3,j) = sum(Oc_A_s_count(1,2,j),'omitnan')+ sum(Oc_A_s_count(1,5,j),'omitnan');
    Water(3,j) = sum(Oc_A_s_count(2,2,j),'omitnan')+ sum(Oc_A_s_count(2,5,j),'omitnan');
    Mixed(3,j) = sum(Oc_A_s_count(3,2,j),'omitnan')+ sum(Oc_A_s_count(3,5,j),'omitnan');
    
        
    Ice(4,j) = sum(Oc_A_s_count(1,6,j),'omitnan');
    Water(4,j) = sum(Oc_A_s_count(2,6,j),'omitnan');
    Mixed(4,j) = sum(Oc_A_s_count(3,6,j),'omitnan');
end




