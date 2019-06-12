function [f_DB] = Constrains_subroutine(strctr)

% Remove entries with more than 1 aerosol layers or with no aerosols at all
for s=1:4
   h = find(~isnan(strctr(s).par.Top_Height(:,17)) | isnan(strctr(s).par.Top_Height(:,16))); 
   strctr(s).par.Geo(h,:) = [];
   strctr(s).par.Top_Height(h,:) = [];
   strctr(s).par.Bot_Height(h,:) = [];
   strctr(s).par.Top_Temp(h,:) = [];
   strctr(s).par.Base_Temp(h,:) = [];
   strctr(s).par.Avg_or_SatWaterLayer(h,:) = [];
   strctr(s).par.Confidense(h,:) = [];
   strctr(s).par.CPhase_or_APhase(h,:) = [];
   strctr(s).par.CType_or_ARH(h,:) = [];
   strctr(s).par.AOD_532(h,:) = [];
   strctr(s).par.AOD_1064(h,:) = [];
   strctr(s).par.Depol(h,:) = [];
   strctr(s).par.CPhaseConf(h,:) = [];
   strctr(s).par.AType_CType_Confidence(h,:) = [];
   
   clear h
end

% Remove entries where CloudSat didnt find any cloud layer or detected more
% than 1 cloud layers
for s=1:4
   h = find(isnan(strctr(s).par.Top_Height(:,11)) | ~isnan(strctr(s).par.Top_Height(:,12))); 
   strctr(s).par.Geo(h,:) = [];
   strctr(s).par.Top_Height(h,:) = [];
   strctr(s).par.Bot_Height(h,:) = [];
   strctr(s).par.Top_Temp(h,:) = [];
   strctr(s).par.Base_Temp(h,:) = [];
   strctr(s).par.Avg_or_SatWaterLayer(h,:) = [];
   strctr(s).par.Confidense(h,:) = [];
   strctr(s).par.CPhase_or_APhase(h,:) = [];
   strctr(s).par.CType_or_ARH(h,:) = [];
   strctr(s).par.AOD_532(h,:) = [];
   strctr(s).par.AOD_1064(h,:) = [];
   strctr(s).par.Depol(h,:) = [];
   strctr(s).par.CPhaseConf(h,:) = [];
   strctr(s).par.AType_CType_Confidence(h,:) = [];
   
   clear h
end

% Remove entries where CloudSat confidence cloud layer is below 5
for s=1:4
   h = find(strctr(s).par.Confidense(:,11)< 5); 
   strctr(s).par.Geo(h,:) = [];
   strctr(s).par.Top_Height(h,:) = [];
   strctr(s).par.Bot_Height(h,:) = [];
   strctr(s).par.Top_Temp(h,:) = [];
   strctr(s).par.Base_Temp(h,:) = [];
   strctr(s).par.Avg_or_SatWaterLayer(h,:) = [];
   strctr(s).par.Confidense(h,:) = [];
   strctr(s).par.CPhase_or_APhase(h,:) = [];
   strctr(s).par.CType_or_ARH(h,:) = [];
   strctr(s).par.AOD_532(h,:) = [];
   strctr(s).par.AOD_1064(h,:) = [];
   strctr(s).par.Depol(h,:) = [];
   strctr(s).par.CPhaseConf(h,:) = [];
   strctr(s).par.AType_CType_Confidence(h,:) = [];
   
   clear h
end

%Keep cases where aerosol is located 1 km from the cloud
for s = 1:4

    T_to_T = min(abs(strctr(s).par.Top_Height(:,1)-strctr(s).par.Top_Height(:,16)),abs(strctr(s).par.Top_Height(:,11)-strctr(s).par.Top_Height(:,16)));
    T_to_B = min(abs(strctr(s).par.Top_Height(:,1)-strctr(s).par.Bot_Height(:,16)),abs(strctr(s).par.Top_Height(:,11)-strctr(s).par.Bot_Height(:,16)));
    B_to_T = min(abs(strctr(s).par.Bot_Height(:,1)-strctr(s).par.Top_Height(:,16)),abs(strctr(s).par.Bot_Height(:,11)-strctr(s).par.Top_Height(:,16)));
    B_to_B = min(abs(strctr(s).par.Bot_Height(:,1)-strctr(s).par.Bot_Height(:,16)),abs(strctr(s).par.Bot_Height(:,11)-strctr(s).par.Bot_Height(:,16)));
    
    %Database having only 1 to 1 layer within 1 km
    compoundCondInd = (T_to_T <= 1) | (T_to_B <= 1) | (B_to_T <= 1) | (B_to_B <= 1);
    f_DB_count = sum(compoundCondInd == 1);    %Final number of events left per season!
    
    f_DB(s).par = struct('Geo',strctr(s).par.Geo((compoundCondInd==1),:),...         
         'Top_Height',strctr(s).par.Top_Height((compoundCondInd==1),:),...
         'Bot_Height',strctr(s).par.Bot_Height((compoundCondInd==1),:),...
         'Top_Temp',strctr(s).par.Top_Temp((compoundCondInd==1),:),...
         'Base_Temp',strctr(s).par.Base_Temp((compoundCondInd==1),:),...
         'Avg_or_SatWaterLayer',strctr(s).par.Avg_or_SatWaterLayer((compoundCondInd==1),:),...
         'Confidense',strctr(s).par.Confidense((compoundCondInd==1),:),...
         'CPhase_or_APhase',strctr(s).par.CPhase_or_APhase((compoundCondInd==1),:),...
         'CType_or_ARH',strctr(s).par.CType_or_ARH((compoundCondInd==1),:),...
         'AOD_532',strctr(s).par.AOD_532((compoundCondInd==1),:),...
         'AOD_1064',strctr(s).par.AOD_1064((compoundCondInd==1),:),...
         'Depol',strctr(s).par.Depol((compoundCondInd==1),:),...
         'CPhaseConf',strctr(s).par.CPhaseConf((compoundCondInd==1),:),...
         'AType_CType_Confidence',strctr(s).par.AType_CType_Confidence((compoundCondInd==1),:));
         
     clear compoundCondInd T_to_T T_to_B B_to_T B_to_B
end

% Remove bases located <0.75 km from the CloudSat height parameter 
for s = 1:4
    h = find(f_DB(s).par.Bot_Height(:,11)<0.75);
    f_DB(s).par.Geo(h,:) = [];
    f_DB(s).par.Top_Height(h,:) = [];
    f_DB(s).par.Bot_Height(h,:) = [];
    f_DB(s).par.Top_Temp(h,:) = [];
    f_DB(s).par.Base_Temp(h,:) = [];
    f_DB(s).par.Avg_or_SatWaterLayer(h,:) = [];
    f_DB(s).par.Confidense(h,:) = [];
    f_DB(s).par.CPhase_or_APhase(h,:) = [];
    f_DB(s).par.CType_or_ARH(h,:) = [];
    f_DB(s).par.AOD_532(h,:) = [];
    f_DB(s).par.AOD_1064(h,:) = [];
    f_DB(s).par.Depol(h,:) = [];
    f_DB(s).par.CPhaseConf(h,:) = [];
    f_DB(s).par.AType_CType_Confidence(h,:) = [];
   
    clear h
end

% Remove cases where there is non-integer cloud phase. This is valid for the
% CloudSat when I combined 3 footprints to match with calipso
for s = 1:4
   h = find(mod(f_DB(s).par.CPhase_or_APhase(:,11),1)~=0);
   f_DB(s).par.Geo(h,:) = [];
   f_DB(s).par.Top_Height(h,:) = [];
   f_DB(s).par.Bot_Height(h,:) = [];
   f_DB(s).par.Top_Temp(h,:) = [];
   f_DB(s).par.Base_Temp(h,:) = [];
   f_DB(s).par.Avg_or_SatWaterLayer(h,:) = [];
   f_DB(s).par.Confidense(h,:) = [];
   f_DB(s).par.CPhase_or_APhase(h,:) = [];
   f_DB(s).par.CType_or_ARH(h,:) = [];
   f_DB(s).par.AOD_532(h,:) = [];
   f_DB(s).par.AOD_1064(h,:) = [];
   f_DB(s).par.Depol(h,:) = [];
   f_DB(s).par.CPhaseConf(h,:) = [];
   f_DB(s).par.AType_CType_Confidence(h,:) = [];

   clear h
end

% Remove cloud cases in calipso that have been produced with 20km averaging
% to match the 5 km in the CloudSat/Calipso product
for s = 1:4
   h = find(f_DB(s).par.Avg_or_SatWaterLayer(:,1)~= 5);
   f_DB(s).par.Geo(h,:) = [];
   f_DB(s).par.Top_Height(h,:) = [];
   f_DB(s).par.Bot_Height(h,:) = [];
   f_DB(s).par.Top_Temp(h,:) = [];
   f_DB(s).par.Base_Temp(h,:) = [];
   f_DB(s).par.Avg_or_SatWaterLayer(h,:) = [];
   f_DB(s).par.Confidense(h,:) = [];
   f_DB(s).par.CPhase_or_APhase(h,:) = [];
   f_DB(s).par.CType_or_ARH(h,:) = [];
   f_DB(s).par.AOD_532(h,:) = [];
   f_DB(s).par.AOD_1064(h,:) = [];
   f_DB(s).par.Depol(h,:) = [];
   f_DB(s).par.CPhaseConf(h,:) = [];
   f_DB(s).par.AType_CType_Confidence(h,:) = [];

   clear h
end

% Remove Aerosol layers with negative Depol value or <0.4 as unrealistic
% for aerosols
for s = 1:4
   h = find(f_DB(s).par.Depol(:,16)< 0 | f_DB(s).par.Depol(:,16)> 0.4);
   f_DB(s).par.Geo(h,:) = [];
   f_DB(s).par.Top_Height(h,:) = [];
   f_DB(s).par.Bot_Height(h,:) = [];
   f_DB(s).par.Top_Temp(h,:) = [];
   f_DB(s).par.Base_Temp(h,:) = [];
   f_DB(s).par.Avg_or_SatWaterLayer(h,:) = [];
   f_DB(s).par.Confidense(h,:) = [];
   f_DB(s).par.CPhase_or_APhase(h,:) = [];
   f_DB(s).par.CType_or_ARH(h,:) = [];
   f_DB(s).par.AOD_532(h,:) = [];
   f_DB(s).par.AOD_1064(h,:) = [];
   f_DB(s).par.Depol(h,:) = [];
   f_DB(s).par.CPhaseConf(h,:) = [];
   f_DB(s).par.AType_CType_Confidence(h,:) = [];

   clear h
end


end