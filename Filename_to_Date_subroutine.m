function FName = Filename_to_Date_subroutine(Files)
%Convert CloudSat/AUX-ECMWF date file name to common dateformat

temp = {Files.name};
temp = char(temp);
temp = string(temp(:,1:4));
Y = str2double(regexp(temp,'\d*','match'));
find_years = unique(Y);

FName = [];

for i = 1 : length(find_years)
    h = find( Y == find_years(i));
    for j = 1 : length(h)   
        whichMonth = datestr(datenum(strcat('1/1/,',num2str(find_years(i)))) + str2double(Files(h(j)).name(5:7))-1,'mm');
        whichDay = datestr(datenum(strcat('1/1/,',num2str(find_years(i)))) + str2double(Files(h(j)).name(5:7))-1,'dd');

        Merge = strcat(Files(h(j)).name(1:4),whichMonth,whichDay,'T',Files(h(j)).name(8:13));
        FName = [FName; Merge];
    end
end

