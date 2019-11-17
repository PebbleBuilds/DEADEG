%Kinetic Friction Calculator
%By Rocco Ruan
%Finds the coefficient of kinetic friction between two surfaces, based on
%some data from an experiment I conducted.


dvoltage_to_velocity = -27.853; %produces mm of displacement
theta = 0.379; %in radians
g = 9.7804 / 1000 %in mm/ms^2


baseFileName = ['KineticFriction2.xlsx'];
folder = 'C:\DEADEG\DEA Power Experiment Data\xlsx';
fullFileName = fullfile(folder, baseFileName);

ranges = ["5786:6052","9028:9300","12659:13300","16525:17337","19900:20272","22894:23201","26471:26847","29427:30100","33032:33270","36059:36357","38590:39403"]
[sz,placeholder] = size(ranges)
mus = zeros(sz,1);
trialNum = 0;


for range = ranges
    trialNum = trialNum + 1;
    disp(range)
    if exist(fullFileName, 'file')
        % File exists.  Read it into a table.
        t = readtable(fullFileName,'Range',range) %SPECIFY RANGE HERE!
        t = t{:,:};
        fclose('all');
  
    else
        % File does not exist.  Warn the user.
        errorMessage = sprintf('Error: file not found:\n\n%s', fullFileName);
        uiwait(errordlg(errorMessage));
        return;
    end

    [m,n] = size(t); %finds size of matrix


    %initializes variables
    v = zeros(m-1,1);
    a = zeros(m-2,1);

    %differentiates to find velocity and acceleration
    v(:,1) = diff(t(:,2)).*dvoltage_to_velocity; %constant is multiplied in to find velocity from change in voltage
    a(:,1) = diff(v(:,1))

    %finds average acceleration
    a_ave = mean(a)

    %finds coefficient of kinetic friction
    mus(trialNum,1) = (g*sin(theta)-abs(a_ave))/(g*cos(theta))
end

mu = mean(mus)