function [Geo_v4,Aer_v4,Clo_v4,Geo_Sat,Clo_Sat] = Calipso_Read_v4_suboutine(Filename_v4,DateCloudSat,Filename_Sat)

%% Read and extract the data from the hdf file.
ID                 = hdfread(Filename_v4, 'Profile_ID');
CAD                = hdfread(Filename_v4, 'CAD_Score');
FCF                = hdfread(Filename_v4, 'Feature_Classification_Flags');
Base_A             = hdfread(Filename_v4, 'Layer_Base_Altitude');
Top_A              = hdfread(Filename_v4, 'Layer_Top_Altitude');
Base_T             = hdfread(Filename_v4, 'Layer_Base_Temperature');
Top_T              = hdfread(Filename_v4, 'Layer_Top_Temperature');
RH                 = hdfread(Filename_v4, 'Relative_Humidity');
Avg                = hdfread(Filename_v4, 'Horizontal_Averaging');
AOD_532            = hdfread(Filename_v4, 'Feature_Optical_Depth_532');
AOD_1064           = hdfread(Filename_v4, 'Feature_Optical_Depth_1064');
Depol              = hdfread(Filename_v4, 'Integrated_Particulate_Depolarization_Ratio');

% Geolocation fields
Lat	               = hdfread(Filename_v4, 'Latitude');
Lon                = hdfread(Filename_v4, 'Longitude');
Time               = hdfread(Filename_v4, 'Profile_Time');
Surf_Type          = hdfread(Filename_v4, 'IGBP_Surface_Type');

%% Convert singles to doubles.
ID       = double(ID);
ID       = ID(:,1);
CAD      = double(CAD);
Base_A   = double(Base_A);
Top_A    = double(Top_A);
Base_T   = double(Base_T);
Top_T    = double(Top_T);
RH       = double(RH);
Avg      = double(Avg);
AOD_532  = double(AOD_532);
AOD_1064 = double(AOD_1064);
Depol    = double(Depol);
Lat      = double(Lat);
Lat      = Lat(:,2);
Lon      = double(Lon);
Lon      = Lon(:,2);
Time     = double(Time);
Time     = Time(:,2);
Surf_Type= double(Surf_Type);

%Replace -999 with NaN 
CAD(CAD ==-127)             = NaN;
Base_A(Base_A == -9999)     = NaN;
Top_A(Top_A == -9999)       = NaN;
Base_T(Base_T == -9999)     = NaN;
Top_T(Top_T == -9999)       = NaN;
RH(RH == -9999)             = NaN;
Avg(Avg == 0)               = NaN;
AOD_532(AOD_532 == -9999)   = NaN;
AOD_1064(AOD_1064 == -9999) = NaN;
Depol(Depol == -9999)       = NaN;

%% Limitations and QC flags 
%Limiting to Latitudes >= 62
IntLat = find(Lat >= 62);

ID       = ID(IntLat);
CAD      = CAD(IntLat,:);
FCF      = FCF(IntLat,:);
Base_A   = Base_A(IntLat,:);
Top_A    = Top_A(IntLat,:);
Base_T   = Base_T(IntLat,:);
Top_T    = Top_T(IntLat,:);
RH       = RH(IntLat,:);
Avg      = Avg(IntLat,:);
AOD_532  = AOD_532(IntLat,:);
AOD_1064 = AOD_1064(IntLat,:);
Depol    = Depol(IntLat,:);
Lat      = Lat(IntLat);
Lon      = Lon(IntLat);
Time     = Time(IntLat);
Surf_Type= Surf_Type(IntLat);

% Limiting to single cloud layer cases
[row,~] = find(CAD > 0);
x = sort(row);
y = unique(x);
z = histc(x,y);
One_layer = y(z==1);

ID       = ID(One_layer);
CAD      = CAD(One_layer,:);
FCF      = FCF(One_layer,:);
Base_A   = Base_A(One_layer,:);
Top_A    = Top_A(One_layer,:);
Base_T   = Base_T(One_layer,:);
Top_T    = Top_T(One_layer,:);
RH       = RH(One_layer,:);
Avg      = Avg(One_layer,:);
AOD_532  = AOD_532(One_layer,:);
AOD_1064 = AOD_1064(One_layer,:);
Depol    = Depol(One_layer,:);
Lat      = Lat(One_layer);
Lon      = Lon(One_layer);
Time     = Time(One_layer);
Surf_Type= Surf_Type(One_layer);


%Limiting to Aerosol CAD* score <= -50, Cloud CAD score >= 50 
%*That is a preliminary threshold to leave out low quality observations
Top_A(CAD > -50 & CAD < 0) = NaN; %For the aerosol limitation
CAD(isnan(Top_A))      = NaN;
FCF(isnan(Top_A))      = NaN;
Base_A(isnan(Top_A))   = NaN;
Top_A(isnan(Top_A))    = NaN;
Base_T(isnan(Top_A))   = NaN;
Top_T(isnan(Top_A))    = NaN;
RH(isnan(Top_A))       = NaN;
Avg(isnan(Top_A))      = NaN;
AOD_532(isnan(Top_A))  = NaN;
AOD_1064(isnan(Top_A)) = NaN;
Depol(isnan(Top_A))    = NaN;

Top_A(CAD < 50 & CAD > 0) = NaN; %For the cloud limitation
CAD(isnan(Top_A))     = NaN;
FCF(isnan(Top_A))     = NaN;
Base_A(isnan(Top_A))  = NaN;
Top_A(isnan(Top_A))   = NaN;
Base_T(isnan(Top_A))  = NaN;
Top_T(isnan(Top_A))   = NaN;
RH(isnan(Top_A))      = NaN;
Avg(isnan(Top_A))     = NaN;
Depol(isnan(Top_A))    = NaN;

%Limiting to Cloud Tops < 3.5 km 
[row, ~] = find(CAD > 0 & Top_A <= 3.5);
T = sort(row);

ID       = ID(T);
CAD      = CAD(T,:);
FCF      = FCF(T,:);
Base_A   = Base_A(T,:);
Top_A    = Top_A(T,:);
Base_T   = Base_T(T,:);
Top_T    = Top_T(T,:);
RH       = RH(T,:);
Avg      = Avg(T,:);
AOD_532  = AOD_532(T,:);
AOD_1064 = AOD_1064(T,:);
Depol    = Depol(T,:);
Lat      = Lat(T);
Lon      = Lon(T);
Time     = Time(T);
Surf_Type= Surf_Type(T);

%Keep entries that have aerosol and cloud layers together
[r1,~] = find(CAD < 0);
x = sort(r1);
y = unique(x);

[r2,~] = find(CAD(y,:) > 0);
x = sort(r2);
g = unique(x);

ID       = ID(y(g));
CAD      = CAD(y(g),:);
FCF      = FCF(y(g),:);
Base_A   = Base_A(y(g),:);
Top_A    = Top_A(y(g),:);
Base_T   = Base_T(y(g),:);
Top_T    = Top_T(y(g),:);
RH       = RH(y(g),:);
Avg      = Avg(y(g),:);
AOD_532  = AOD_532(y(g),:);
AOD_1064 = AOD_1064(y(g),:);
Depol    = Depol(y(g),:);
Lat      = Lat(y(g));
Lon      = Lon(y(g));
Time     = Time(y(g));
Surf_Type= Surf_Type(y(g));

%% VFM bin reader
% Select the 1-3 bits for Feature Type data. 
%0 = invalid (bad or missing data), 1 = "clear air", 2 = cloud, 3 = aerosol, 4 = stratospheric feature
%5 = surface, 6 = subsurface, 7 = no signal (totally attenuated))
FCF0 = bitshift(bitand((2^0+2^1+2^2),FCF),0);
FCF0 = double(FCF0);
FCF0(isnan(CAD)) = NaN;
%Select the 6-7 bits.Ice/Water Phase bits (0 = unknown/ND, 1= randomly oriented ice, 2 = water, 3 = horizontally oriented ice)
FCF2 = bitshift(bitand((2^5+2^6),FCF),-5);
FCF2 = double(FCF2);
FCF2(isnan(CAD)) = NaN;
%Select the 8-9 bits.Ice/Water Phase QA bits (0 = none, 1 = low, 2 = medium, 3 = high)
FCF3 = bitshift(bitand((2^7+2^8),FCF),-7);
FCF3 = double(FCF3);
FCF3(isnan(CAD)) = NaN;
%Select the 10-12 bits.Cloud Sub-Type (0 = low overcast/transparent/not
%determined,1 = low overcast/opaque/clean marine
%2 = transition stratocumulus/dust, 3 = low, broken cumulus/polluted
%continental/smoke,  4 = altocumulus (transparent)/clean continental
%5 = altostratus (opaque)/polluted dust,6 = cirrus (transparent)/elevated smoke,7 =
%deep convective (opaque)/dusty marine 
FCF4 = bitshift(bitand((2^9+2^10+2^11),FCF),-9);
FCF4 = double(FCF4);
FCF4(isnan(CAD)) = NaN;
%Select the 13 bit. Cloud Sub-Type QA, 0:Not confident, 1:Confident
FCF5 = bitshift(bitand((2^12),FCF),-12);
FCF5 = double(FCF5);
FCF5(isnan(CAD)) = NaN;

PS_flag(1:size(CAD,1),1) = NaN; %Flag entries that PSF is present
[rh,~] = find(FCF0 == 4);
r_h = sort(rh);
PS_flag(r_h) = 1; 

if any(ID) == 0
   Geo_v4 = [];
   Aer_v4 = [];
   Clo_v4 = [];
   Geo_Sat = [];
   Clo_Sat = [];
   return 
end
%% Output
% Create an nth-D matrix to include all the info for v4 together. From this
% matrix Time, Lat,Lon,ID and PS_flag and the counters are not included. 
% They are separate to a 2-D %matrix
Geo_v4 = [ID,Time,Lat,Lon,PS_flag,Surf_Type];

%Since the combined CloudSat/CALIPSO gives only the cloud layers,
%Distiguish them here for CALIPSO as well.
[row,col] = find(CAD>0); %For clouds
[v_r,idx] = sort(row);
v_c= col(idx);

%Initialize and FIll Cloud matrix
Clo_v4(1:size(CAD,1),1:5,1:13) = NaN;
Clo_v4(:,1,1) = diag(Top_A(v_r,v_c));  %Top Height
Clo_v4(:,1,2) = diag(Base_A(v_r,v_c)); %Base Height
Clo_v4(:,1,3) = diag(Top_T(v_r,v_c));  %Top Temp
Clo_v4(:,1,4) = diag(Base_T(v_r,v_c)); %Base Temp
Clo_v4(:,1,5) = diag(Avg(v_r,v_c));    %Avg
Clo_v4(:,1,6) = diag(CAD(v_r,v_c));    %CAD
Clo_v4(:,1,7) = diag(FCF2(v_r,v_c));   %FCF2 : Phase of Cloud
Clo_v4(:,1,8) = diag(FCF4(v_r,v_c));   %FCF4 : Type of Cloud
Clo_v4(:,1,9) = diag(AOD_532(v_r,v_c));%AOD_532
%Clo_v4(:,1,10)                        %empty
Clo_v4(:,1,11)= diag(Depol(v_r,v_c));  %Depol
Clo_v4(:,1,12)= diag(FCF3(v_r,v_c));   %FCF3 : Confidense of Cloud Phase
Clo_v4(:,1,13)= diag(FCF5(v_r,v_c));   %Confidence of cloud type

Top_A(CAD>0) = NaN;       %For aerosols
CAD(isnan(Top_A)) = NaN;
FCF4(isnan(Top_A)) = NaN;
Base_A(isnan(Top_A)) = NaN;
Top_A(isnan(Top_A)) = NaN;
Base_T(isnan(Top_A)) = NaN;
Top_T(isnan(Top_A)) = NaN;
RH(isnan(Top_A)) = NaN;
Avg(isnan(Top_A)) = NaN;
AOD_532(isnan(Top_A)) = NaN;
AOD_1064(isnan(Top_A)) = NaN;
Depol(isnan(Top_A)) = NaN;
FCF5(isnan(Top_A)) = NaN;

%Remove inbetween NaNs and reorder the data
[~, jj]      = sort(isnan(Top_A), 2);
new_Top_A    = Top_A(bsxfun(@plus, (1:size(Top_A,1)).', (jj-1)*size(Top_A,1)));
new_CAD      = CAD(bsxfun(@plus, (1:size(Top_A,1)).', (jj-1)*size(Top_A,1)));
new_FCF4     = FCF4(bsxfun(@plus, (1:size(Top_A,1)).', (jj-1)*size(Top_A,1)));
new_Base_A   = Base_A(bsxfun(@plus, (1:size(Top_A,1)).', (jj-1)*size(Top_A,1)));
new_Base_T   = Base_T(bsxfun(@plus, (1:size(Top_A,1)).', (jj-1)*size(Top_A,1)));
new_Top_T    = Top_T(bsxfun(@plus, (1:size(Top_A,1)).', (jj-1)*size(Top_A,1)));
new_RH       = RH(bsxfun(@plus, (1:size(Top_A,1)).', (jj-1)*size(Top_A,1)));
new_Avg      = Avg(bsxfun(@plus, (1:size(Top_A,1)).', (jj-1)*size(Top_A,1)));
new_AOD_532  = AOD_532(bsxfun(@plus, (1:size(Top_A,1)).', (jj-1)*size(Top_A,1)));
new_AOD_1064 = AOD_1064(bsxfun(@plus, (1:size(Top_A,1)).', (jj-1)*size(Top_A,1)));
new_Depol    = Depol(bsxfun(@plus, (1:size(Top_A,1)).', (jj-1)*size(Top_A,1)));
new_FCF5     = FCF5(bsxfun(@plus, (1:size(Top_A,1)).', (jj-1)*size(Top_A,1)));

%Initialize and FIll Aerosol matrix
Aer_v4(1:size(CAD,1),1:5,1:13) = NaN;
Aer_v4(:,1:5,1) = new_Top_A(:,1:5);    %Top Height
Aer_v4(:,1:5,2) = new_Base_A(:,1:5);   %Base Height
Aer_v4(:,1:5,3) = new_Top_T(:,1:5);    %Top Temp
Aer_v4(:,1:5,4) = new_Base_T(:,1:5);   %Base Temp
Aer_v4(:,1:5,5) = new_Avg(:,1:5);      %Avg
Aer_v4(:,1:5,6) = new_CAD(:,1:5);      %CAD
Aer_v4(:,1:5,7) = new_FCF4(:,1:5);     %FCF4 : Type of Aerosol
Aer_v4(:,1:5,8) = new_RH(:,1:5);       %RH
Aer_v4(:,1:5,9) = new_AOD_532(:,1:5);  %AOD_532
Aer_v4(:,1:5,10)= new_AOD_1064(:,1:5); %AOD_1064
Aer_v4(:,1:5,11)= new_Depol(:,1:5);    %Depol
%Aer_v4(:,1:5,12)                      %empty
Aer_v4(:,1:5,13)= new_FCF5(:,1:5);     %Confidence of aerosol type


%% Read the CloudSat/Calipso cloud layers
%First I Match the day. Then I check how many CloudSat files the Calipso
%Time expands to and then I open each one of them to extract the values.
TL_Cal = datetime(datestr(datenum('01-01-1993 00:00:00')+ Geo_v4(:,2)/86400));    
Match = find(DateCloudSat >= TL_Cal(1)-hours(1.6667) & DateCloudSat< TL_Cal(end)+ minutes(1)); %Time gap between CloudSat files is 1.40 hours
if exist(Filename_Sat{Match},'file')== 2 
    [Geo_Sat,Clo_Sat] = CloudSat_Read_suboutine(Filename_Sat{Match},Geo_v4,DateCloudSat(Match));
else
    Geo_Sat(1:size(CAD,1),1:6) = -999;     %File doesn't exist
    Clo_Sat(1:size(CAD,1),1:5,1:13) = -999; 
end