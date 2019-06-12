function [strctr] = CAD_manip_subroutine(strctr,score)

for s = 1:4
    A = find(strctr(s).par.Confidense(:,1) < score | strctr(s).par.Confidense(:,16) > -score);
    strctr(s).par.Geo(A,:) = [];   
    strctr(s).par.Top_Height(A,:) = [];
    strctr(s).par.Bot_Height(A,:) = [];
    strctr(s).par.Top_Temp(A,:) = [];
    strctr(s).par.Base_Temp(A,:) = [];
    strctr(s).par.Avg_or_SatWaterLayer(A,:) = [];
    strctr(s).par.Confidense(A,:) = [];
    strctr(s).par.CPhase_or_APhase(A,:) = [];
    strctr(s).par.CType_or_ARH(A,:) = [];
    strctr(s).par.AOD_532(A,:) = [];
    strctr(s).par.AOD_1064(A,:) = [];
    strctr(s).par.Depol(A,:) = [];
    strctr(s).par.CPhaseConf(A,:) = [];
    strctr(s).par.AType_CType_Confidence(A,:) = [];

end

end


