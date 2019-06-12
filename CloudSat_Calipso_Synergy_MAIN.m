%Input: This program reads .hdf files from the CloudSat CALIPSO 2B CLDCLASS 
%       LiDAR R04 product (hereafter combined CloudSat/CALIPSO), 
%       the European Centre for Medium-Range Weather Forecasts Auxiliary 
%       (ECWMF AUX) product, and the Merged aerosol and cloud CALIPSO 5 km 
%       (level 2, v4.1) layer product
%       Note: The satellite data should already be downloaded and be 
%             available to some local folder
%Ouput: The main output are seasonally collocated aerosol and cloud layers.
%       On top, different constrains can be applied to the data according 
%       to the user's preference. 
%--------------------------------------------------------------------------
%---------------This code was written using Matlab 2017b-------------------
% % Copyright (C) 2019 Maria Filioglou
%--------------------------------------------------------------------------
clear all; clc;
%% ------------------------------------------------------------------------
% Specify input directory (CALIPSO Merge Aerosol and Cloud Layer L2 data)
dir_v4   = 'E:\Calipso_v4\';
% Specify input directory (combined CloudSat/CALIPSO data)
dir_CSat = 'E:\CloudSat\';
% Specify input directory (AUX-ECMWF data)
dir_Met  = 'E:\ECMWF-AUX\';

% Retrieve filelist for CALIPSO. 
% Calipso database should be already separated per season. 
% So here,4 directories, one for each season
SeasCal_v4 = dir(strcat(dir_v4));
SeasCal_v4(1:2) = [];
% Retrieve filelist for combined CloudSat/CALIPSO. 
% Combined CloudSat/CALIPSO data are not per season
FilesCloudSat = dir(strcat(dir_CSat,'*.hdf'));
FNameCloudSat = Filename_to_Date_subroutine(FilesCloudSat); %Convert to dateformat
fd_CloudSat = datetime(FNameCloudSat);
FullName_Sat = strcat(dir_CSat,{FilesCloudSat.name}');
% Retrieve filelist for AUX-ECMWF
% AUX-ECMWF data are not per season
FilesAUX = dir(strcat(dir_Met,'*.hdf'));
FNameAUX = Filename_to_Date_subroutine(FilesAUX); %Convert to dateformat
fd_AUX = datetime(FNameAUX);

%% ------------------------------------------------------------------------
% For each season go throught the files and collocate the two datasets, if
% both aerosols and clouds are found keep that information for further 
% analysis.
for s = 1 : length(SeasCal_v4) %seasons
    season_Cal_v4   = strcat(dir_v4,SeasCal_v4(s).name,'\'); %Order: DJF,JJA,MAM,SON
    Files_Cal_v4    = dir(strcat(season_Cal_v4,'*.hdf'));
    FullName_Cal_v4 = strcat(season_Cal_v4, {Files_Cal_v4.name}');
   
    clear Geo
    clear Dat
    Geo = [];
    Data = [];

    for f = 1 : length(Files_Cal_v4) %files in each season
        disp(FullName_Cal_v4{f})
        [Geo_v4, Aer_v4, Clo_v4, Geo_Sat, Clo_Sat] = Calipso_Read_v4_suboutine(FullName_Cal_v4{f}, fd_CloudSat, FullName_Sat);      
        if isempty(Geo_v4) == 0
            Geo  = [Geo; Geo_v4, Geo_Sat];
            Data = [Data; Clo_v4, Clo_Sat, Aer_v4];
        end
    end
   %Output per season: Structure type
   ss(s).par = struct('Geo',Geo,...
                      'Top_Height',Data(:,:,1),...
                      'Bot_Height',Data(:,:,2),...
                      'Top_Temp',Data(:,:,3), ...
                      'Base_Temp',Data(:,:,4),...
                      'Avg_or_SatWaterLayer',Data(:,:,5),...
                      'Confidense',Data(:,:,6),...
                      'CPhase_or_APhase',Data(:,:,7), ...
                      'CType_or_ARH',Data(:,:,8),...
                      'AOD_532',Data(:,:,9),...
                      'AOD_1064',Data(:,:,10),...
                      'Depol',Data(:,:,11),...
                      'CPhaseConf',Data(:,:,12),...
                      'AType_CType_Confidence',Data(:,:,13));
end

fclose('all');

%% Apply constrains to the dataset
[DB] = Constrains_subroutine(ss);
%Set CAD scores
[f_DB] = CAD_manip_subroutine(DB,70); 
%% Figure 3
StereoMap_Data_subroutine(f_DB)
%% FigureS 4-6
plot_CCT_vs_Temp_errorbars_subroutine(f_DB)
%% Figure 7
plot_Fig7_subroutine(f_DB)