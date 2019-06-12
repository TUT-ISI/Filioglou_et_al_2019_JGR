function [Geo_Sat,Clo_Sat] = CloudSat_Read_suboutine(Filename,G,T)
% combined CloudSat/CALIPSO Layer Reader
% This function reads hdf ClouSat/Lidar products
% It also reads the AUX-ECMWF data 
%% Read and extract the data from the hdf file.
CloudLayerTop             = hdfread(Filename, '2B-CLDCLASS-LIDAR', 'Fields', 'CloudLayerTop');
CloudLayerBase            = hdfread(Filename, '2B-CLDCLASS-LIDAR', 'Fields', 'CloudLayerBase');
CloudPhase                = hdfread(Filename, '2B-CLDCLASS-LIDAR', 'Fields', 'CloudPhase');
CloudPhaseConfidenceLevel = hdfread(Filename, '2B-CLDCLASS-LIDAR', 'Fields', 'CloudPhaseConfidenceLevel');
Water_layer_top           = hdfread(Filename, '2B-CLDCLASS-LIDAR', 'Fields', 'Water_layer_top');
Cloud_Type                = hdfread(Filename, '2B-CLDCLASS-LIDAR', 'Fields', 'CloudLayerType');
TopFlag                   = hdfread(Filename, '2B-CLDCLASS-LIDAR', 'Fields', 'LayerTopFlag');
BaseFlag                  = hdfread(Filename, '2B-CLDCLASS-LIDAR', 'Fields', 'LayerBaseFlag');
% Geolocation fields
Latitude                  = hdfread(Filename, '2B-CLDCLASS-LIDAR', 'Fields', 'Latitude');
Longitude                 = hdfread(Filename, '2B-CLDCLASS-LIDAR', 'Fields', 'Longitude');
Profile_time              = hdfread(Filename, '2B-CLDCLASS-LIDAR', 'Fields', 'Profile_time');
DataQ                     = hdfread(Filename, '2B-CLDCLASS-LIDAR', 'Fields', 'Data_quality');

% Replacing missing values with NaNs
CloudLayerTop = double(CloudLayerTop);
CloudLayerTop(CloudLayerTop == -99) = NaN;
CloudLayerBase = double(CloudLayerBase);
CloudLayerBase(CloudLayerBase == -99) = NaN;
CloudPhase = double(CloudPhase);
CloudPhase(CloudPhase == -9 | CloudPhase == 0) = NaN;
CloudPhaseConfidenceLevel = double(CloudPhaseConfidenceLevel);
CloudPhaseConfidenceLevel(CloudPhaseConfidenceLevel == -9) = NaN;
Water_layer_top = double(Water_layer_top);
Water_layer_top (Water_layer_top == -9) = NaN;
Cloud_Type = double(Cloud_Type);
Cloud_Type (Cloud_Type == 0) = NaN;
TopFlag = double(TopFlag);
TopFlag (TopFlag == -9) = NaN;
BaseFlag = double(BaseFlag);
BaseFlag (BaseFlag == -9) = NaN;
Latitude = double(Latitude);
Longitude = double(Longitude);
Profile_time = double(Profile_time);
DataQ = double(DataQ);

%% Read and extract the data from the AUX file.
% Create a proper nae file for the cloud layer product.
expression1 = '2B-CLDCLASS-LIDAR';
expression2 = 'CloudSat';
replace1 = 'ECMWF-AUX';
newStr = regexprep(Filename,expression1,replace1);
Fname = regexprep(newStr,expression2,replace1);

%Read and extract the data from the hdf file.
if exist(Fname, 'file') == 2
    Temperature  = hdfread(Fname, 'ECMWF-AUX', 'Fields', 'Temperature');
    Pressure  = hdfread(Fname, 'ECMWF-AUX', 'Fields', 'Pressure');
    Surface_Temp  = hdfread(Fname, 'ECMWF-AUX', 'Fields', 'Temperature_2m');
    Surface_Pres  = hdfread(Fname, 'ECMWF-AUX', 'Fields', 'Surface_pressure');
    EC_height    = hdfread(Fname, 'ECMWF-AUX', 'Fields', 'EC_height');
    Temperature  = double(Temperature);
    Temperature(Temperature == -999) = NaN;
    Pressure  = double(Pressure);
    Pressure(Pressure == -999) = NaN;
    Pressure = Pressure/100;
    Surface_Temp  = double(Surface_Temp);
    Surface_Temp(Surface_Temp == -999) = NaN;
    Surface_Pres  = double(Surface_Pres);
    Surface_Pres(Surface_Pres == -999) = NaN;
    Surface_Pres = Surface_Pres/100;    
    
    EC_height = double(EC_height);
else
    Geo_Sat(1:size(G,1),1:6) = -555;     %ECMWF-AUX file doesn't exist
    Clo_Sat(1:size(G,1),1:5,1:15) = -555;
    return
end

%% Select only the same data as in v4
idxs = [];
dist = [];
for c = 1:size(G,1)
    CalCord = [G(c,3),G(c,4)];
    d = SpherConv (CalCord,Latitude,Longitude);
    [s,id] = sort(d);
    idxs = [idxs; id(1:3)];
    dist = [dist; s(1:3)];   
end
ridxs = reshape(idxs',[size(idxs,1)*size(idxs,2),1]); 
%rdist = reshape(dist',[size(dist,1)*size(dist,2),1]); 

CloudLayerTop = CloudLayerTop(ridxs,1:8);
CloudLayerBase = CloudLayerBase(ridxs,1:8);
CloudPhase = CloudPhase(ridxs,1:8);
CloudPhaseConfidenceLevel = CloudPhaseConfidenceLevel(ridxs,1:8);
Water_layer_top = Water_layer_top(ridxs,1:8);
Cloud_Type = Cloud_Type(ridxs,1:8);
TopFlag = TopFlag(ridxs,1:8);
BaseFlag = BaseFlag(ridxs,1:8);
Latitude = Latitude(idxs(:,1));
Longitude = Longitude(idxs(:,1));
Profile_time = Profile_time(idxs(:,1));
DataQ = DataQ(idxs(:,1));
Pressure = Pressure(idxs(:,1),:);
Temperature1 = Temperature(idxs(:,1),:);
Temperature = Temperature(ridxs,:);

%Extract Surf Temp and LTS
Surface_Temp = Surface_Temp(idxs(:,1));
Surface_Pres = Surface_Pres(idxs(:,1));
[x, ind] = min(abs(Pressure - 700),[],2);
P700 = x + 700;
T700(1:length(ind))=NaN;
for i = 1  : length(ind)
    T700(i) = Temperature1(i,ind(i)) ;
end    
LTS = T700.*(1000./P700').^0.286 - Surface_Temp.*(1000./Surface_Pres).^0.286;



%% Avg. around the Cloud Top/Base atlitude to get the temperature value from the AUX.
% I search for the top height and take one bin above/below and calculate the mean
% temp for that. The same applies to the base of the cloud.
Temp_Base(1:size(ridxs,1),1:8) = NaN;
Temp_Top(1:size(ridxs,1),1:8)  = NaN;
for i = 1 : size(ridxs,1)
    for j=1:8
        Dif_Height_Top = abs(CloudLayerTop(i,j)- EC_height*0.001);
        Dif_Height_Base = abs(CloudLayerBase(i,j)- EC_height*0.001);

        h1 = find(Dif_Height_Top <= 0.24);
        if any(h1)
            Temp_Top(i,j) = interp1(EC_height(h1),Temperature(i,h1),CloudLayerTop(i,j)*1000); 
        end
        
        h2 = find(Dif_Height_Base <= 0.24);
        if any(h2)
            Temp_Base(i,j) = interp1(EC_height(h2),Temperature(i,h2),CloudLayerBase(i,j)*1000);      
        end
    end
end
Temp_Top = Temp_Top - 273.15;
Temp_Base = Temp_Base - 273.15;

%% Change resolution to 5km by avg. 3 points at a time...
%(the resolution is ~1.4 by 1.7, cross/along - after this code it goes at ~1.4 by 5.1)
%The three points are already known from above. So I just average every
%three rows the data

CTop_Alt_Sat(1:size(idxs,1), 1:8)= NaN;
CBase_Alt_Sat(1:size(idxs,1), 1:8)= NaN;
CTop_Temp_Sat(1:size(idxs,1), 1:8)= NaN;
CBase_Temp_Sat(1:size(idxs,1), 1:8)= NaN;
CPhase_Sat(1:size(idxs,1), 1:8)= NaN;
CType_Sat(1:size(idxs,1), 1:8)= NaN;
CConf(1:size(idxs,1), 1:8)= NaN;
CWT(1:size(idxs,1), 1:8)= NaN;
TF(1:size(idxs,1), 1:8)= NaN;
BF(1:size(idxs,1), 1:8)= NaN;

%Start binning
e = 0;
for i=1:size(idxs,1)
    b = e+1;
    e = b+2;

    entries = ceil(((max(max(CloudLayerTop(b:e,:))) - min(min(CloudLayerBase(b:e,:))))*1000)/10+1);
    clear matrix
    if isnan(entries) == 0
        matrix(1:entries) = 0;
    else       
        continue 
    end
    
    bot = ceil(((CloudLayerBase(b:e,:) - min(min(CloudLayerBase(b:e,:))))*1000)/10);
    bot(bot==0) = 1;
    top = ceil(((CloudLayerTop(b:e,:) - min(min(CloudLayerBase(b:e,:))))*1000)/10);
    top(top>length(matrix)) = length(matrix);
    sel_b = bot(~isnan( bot )) ;
    sel_t = top(~isnan( top )) ;

    for s = 1 : length(sel_b)
        matrix(sel_b(s):sel_t(s)) = matrix(sel_b(s):sel_t(s)) + 1;
    end
      
   %Define layers and values
    ma = matrix;
    ma(matrix>=1) = 1;
    temp       = diff(ma) ;
    blockStart = find( temp == 1 ) ;
    blockStart = [1, blockStart];
    blockEnd = find( temp == -1 ) ;
    
    lay = [];
    for bl = 1 : length(blockEnd)
       lay = [lay; blockStart(bl) blockEnd(bl)]; 
    end
    
    %Calculate the mean values of the layer
    for l = 1 : size(lay,1)
        [lr,lc] = find(CloudLayerBase(b:e,:) >= min(min(CloudLayerBase(b:e,:)))+(lay(l,1)-1)*0.01 & CloudLayerTop(b:e,:) <= min(min(CloudLayerBase(b:e,:)))+(lay(l,2))*0.01);
        CTop_Alt_Sat(i,l) = mean(diag(CloudLayerTop(b+lr-1,lc)));
        CBase_Alt_Sat(i,l) = mean(diag(CloudLayerBase(b+lr-1,lc)));
        CTop_Temp_Sat(i,l) = mean(diag(Temp_Top(b+lr-1,lc)));
        CBase_Temp_Sat(i,l) = mean(diag(Temp_Base(b+lr-1,lc)));
        CPhase_Sat(i,l) = mean(diag(CloudPhase(b+lr-1,lc)));
        CType_Sat(i,l) = mean(diag(Cloud_Type(b+lr-1,lc))); 
        CConf(i,l) = mean(diag(CloudPhaseConfidenceLevel(b+lr-1,lc))); 
        CWT(i,l) = mean(diag(Water_layer_top(b+lr-1,lc))); 
        TF(i,l) = mean(diag(TopFlag(b+lr-1,lc))); 
        BF(i,l) = mean(diag(BaseFlag(b+lr-1,lc)));       
    end   
end

%Initialize and FIll Cloud matrix
Clo_Sat(1:size(G,1),1:5,1:13) = NaN;
Clo_Sat(:,1:5,1) = CTop_Alt_Sat(:,1:5);   %Top Height
Clo_Sat(:,1:5,2) = CBase_Alt_Sat(:,1:5);  %Base Height
Clo_Sat(:,1:5,3) = CTop_Temp_Sat(:,1:5);  %Top Temp
Clo_Sat(:,1:5,4) = CBase_Temp_Sat(:,1:5); %Base Temp
Clo_Sat(:,1:5,5) = CWT(:,1:5);            %Water Layer on top   
Clo_Sat(:,1:5,6) = CConf(:,1:5);          %Confidence
Clo_Sat(:,1:5,7) = CPhase_Sat(:,1:5);     %Phase of Cloud
Clo_Sat(:,1:5,8) = CType_Sat(:,1:5);      %Type of Cloud
Clo_Sat(:,1:5,9) = TF(:,1:5);             %Cloud Top Flag
Clo_Sat(:,1:5,10)= BF(:,1:5);             %Cloud Base Flag
%Clo_Sat(:,1:5,11)                        %empty 
%Clo_Sat(:,1:5,12)                        %empty 
%Clo_Sat(:,1:5,13)                        %empty 

%Export Geo for CloudSat
Tim = datenum(T + seconds(Profile_time)); 
Geo_Sat = [Tim;Latitude;Longitude; DataQ; Surface_Temp; LTS]';

    


    
    
    
    
    
 