function [HIce,HWater,HMixed,LIce,LWater,LMixed,HOc_A_s_count,LOc_A_s_count]= CCT_vs_Temp_AOD_counters_subroutine(dset)

HOc_A_s_count(1:3,1:7,1:30) = NaN;
LOc_A_s_count(1:3,1:7,1:30) = NaN;

for k = 1 : 30
    %For every 2 C bin, find the cases that fall into that temperature 
    inbox_s = find(dset.par.Top_Temp(:,11) <=(-50+2*k) & dset.par.Top_Temp(:,11)>=(-50+2*(k-1)));
        
    Ice_s = find(dset.par.CPhase_or_APhase(inbox_s,11) == 1);      
    Water_s = find(dset.par.CPhase_or_APhase(inbox_s,11) == 3);
    Mixed_s = find(dset.par.CPhase_or_APhase(inbox_s,11) == 2);
        
    %Calculate the cloud phase occurence per aerosl type
    for a = 1: 7
        Ice_A_s = find(dset.par.CPhase_or_APhase(inbox_s(Ice_s),16) == a);       
        Water_A_s = find(dset.par.CPhase_or_APhase(inbox_s(Water_s),16) == a);        
        Mixed_A_s = find(dset.par.CPhase_or_APhase(inbox_s(Mixed_s),16) == a);

        HsI = find(dset.par.AOD_532(inbox_s(Ice_s(Ice_A_s)),16) > 0.25 & dset.par.AOD_532(inbox_s(Ice_s(Ice_A_s)),16) < 0.8);
        HsW = find(dset.par.AOD_532(inbox_s(Water_s(Water_A_s)),16) > 0.25 & dset.par.AOD_532(inbox_s(Water_s(Water_A_s)),16) < 0.8);
        HsM = find(dset.par.AOD_532(inbox_s(Mixed_s(Mixed_A_s)),16) > 0.25 & dset.par.AOD_532(inbox_s(Mixed_s(Mixed_A_s)),16)< 0.8);

        LsI = find(dset.par.AOD_532(inbox_s(Ice_s(Ice_A_s)),16) < 0.1);
        LsW = find(dset.par.AOD_532(inbox_s(Water_s(Water_A_s)),16) < 0.1);
        LsM = find(dset.par.AOD_532(inbox_s(Mixed_s(Mixed_A_s)),16) < 0.1);
     
       
        Hsat_A = [length(HsI),length(HsW),length(HsM)];
        Lsat_A = [length(LsI),length(LsW),length(LsM)];
       
       for p = 1 : 3
           %Calcluate per temp bin the occurance of each phase. 
            HOc_A_s_count(p,a,k) = Hsat_A(p);
            LOc_A_s_count(p,a,k) = Lsat_A(p);         
       end           
    end   
end

%for Sat
for j = 1 : 30
    HIce(1,j) = sum(HOc_A_s_count(1,2,j),'omitnan')+ sum(HOc_A_s_count(1,5,j),'omitnan');
    HWater(1,j) = sum(HOc_A_s_count(2,2,j),'omitnan')+ sum(HOc_A_s_count(2,5,j),'omitnan');
    HMixed(1,j) = sum(HOc_A_s_count(3,2,j),'omitnan')+ sum(HOc_A_s_count(3,5,j),'omitnan');

    HIce(2,j) = sum(HOc_A_s_count(1,1,j),'omitnan')+ sum(HOc_A_s_count(1,3,j),'omitnan')+ sum(HOc_A_s_count(1,4,j),'omitnan')+ sum(HOc_A_s_count(1,6,j),'omitnan')+ sum(HOc_A_s_count(1,7,j),'omitnan');
    HWater(2,j) = sum(HOc_A_s_count(2,1,j),'omitnan')+ sum(HOc_A_s_count(2,3,j),'omitnan')+ sum(HOc_A_s_count(2,4,j),'omitnan')+ sum(HOc_A_s_count(2,6,j),'omitnan')+ sum(HOc_A_s_count(2,7,j),'omitnan');
    HMixed(2,j) = sum(HOc_A_s_count(3,1,j),'omitnan')+ sum(HOc_A_s_count(3,3,j),'omitnan')+ sum(HOc_A_s_count(3,4,j),'omitnan')+ sum(HOc_A_s_count(3,6,j),'omitnan')+ sum(HOc_A_s_count(3,7,j),'omitnan');
    
    LIce(1,j) = sum(LOc_A_s_count(1,2,j),'omitnan')+ sum(LOc_A_s_count(1,5,j),'omitnan');
    LWater(1,j) = sum(LOc_A_s_count(2,2,j),'omitnan')+ sum(LOc_A_s_count(2,5,j),'omitnan');
    LMixed(1,j) = sum(LOc_A_s_count(3,2,j),'omitnan')+ sum(LOc_A_s_count(3,5,j),'omitnan');

    LIce(2,j) = sum(LOc_A_s_count(1,1,j),'omitnan')+ sum(LOc_A_s_count(1,3,j),'omitnan')+ sum(LOc_A_s_count(1,4,j),'omitnan')+ sum(LOc_A_s_count(1,6,j),'omitnan')+ sum(LOc_A_s_count(1,7,j),'omitnan');
    LWater(2,j) = sum(LOc_A_s_count(2,1,j),'omitnan')+ sum(LOc_A_s_count(2,3,j),'omitnan')+ sum(LOc_A_s_count(2,4,j),'omitnan')+ sum(LOc_A_s_count(2,6,j),'omitnan')+ sum(LOc_A_s_count(2,7,j),'omitnan');
    LMixed(2,j) = sum(LOc_A_s_count(3,1,j),'omitnan')+ sum(LOc_A_s_count(3,3,j),'omitnan')+ sum(LOc_A_s_count(3,4,j),'omitnan')+ sum(LOc_A_s_count(3,6,j),'omitnan')+ sum(LOc_A_s_count(3,7,j),'omitnan');
    
end
