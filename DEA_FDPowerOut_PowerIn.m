%DEA_FDPowerOut_PowerIn
%By Rocco Ruan
%Last edited August 10th, 2019
%This program reads the displacement over time of an antagonistic DEA
%couple, and calculates power output and efficiency based on the data and
%on other experimental parameters.

masses = [0 50 60 150 200 300 400 500 600 800 1300 1500]; %a list of all masses tested
powers = []; %placeholder list

for testmass = masses
    
dvoltage_to_velocity = -27.853; %constant that converts change in voltage to velocity.
selfweight = 55.3+0.6+5; %grams
addedweight = testmass; %grams
mass = selfweight + addedweight; %grams
period = 5; %input in seconds
cycles = 1; %number of cycles we want to read
g = 9.7804; %in m/s^2
g = g / 1000;%in mm/ms^2
mu = 0.2977; %coefficient of kinetic friction
capacitance = 2 * 10^(-9); %capacitance of one DEA, in Farads
resistance = 2; %resistance of wires, in ohms
voltage = 2000; %in volts

baseFileName = [sprintf('bp5l%d.lvm.xlsx',testmass)];
folder = 'C:\DEADEG\DEA Power Experiment Data\xlsx\Data';
fullFileName = fullfile(folder, baseFileName);
if exist(fullFileName, 'file')
  % File exists.  Read it into a table.
  range = sprintf('3000:%d',2000+period*cycles*1000);
  t = readtable(fullFileName,'Range',range);
  t = t{:,1:2}; %this is the voltage data
  fclose('all');
  
else
  % File does not exist.  Warn the user.
  errorMessage = sprintf('Error: file not found:\n\n%s', fullFileName);
  uiwait(errordlg(errorMessage));
  return;
end

[m,n] = size(t); %finds size of matrix (voltage data)


testmass

%initializes variables
v = zeros(m-1,n);
a = zeros(m-2,n);

%adds times
v(:,1) = t(1:end-1,1); 
a(:,1) = t(1:end-2,1);

%differentiates to find velocity and acceleration
v(:,2) = diff(t(:,2)).*dvoltage_to_velocity; %constant is multiplied in to find velocity from change in voltage
a(:,2) = diff(v(:,2));

%adds back deceleration due to friction, to find acceleration from DEA
a(:,2) = a(:,2) + g*mu;

%calculates power by multiplying mass, velocity, and acceleration
p_inst = zeros(m-2,n);
p_inst(:,1) = a(:,1);
p_inst(:,2) = v(1:end-1,2).*a(:,2).*mass;

%calculates total work, work per cycle, and average power
total_work = rms(p_inst(:,2))
work_per_cycle = total_work/cycles %work in joules
p_ave = total_work/(period*cycles/1000) %power in watts, per cycle

%adds average power to a list for graphing later
powers = cat(1,powers,p_ave);

%calculates energy input using energy of capacitor
energy_used_per_charge = (capacitance*voltage^2)/2
energy_used_per_cycle = energy_used_per_charge * 2

%calculates efficiency
efficiency = work_per_cycle / energy_used_per_cycle

end

%finds best fitting quadratic
quadratic = polyfit(transpose(masses),powers,2)
x = (1:1:4500);
bestfit = x.^2.*quadratic(1,1)+x.*quadratic(1,2)+quadratic(1,3)
zero = (x.*0);

%plots graph
figure
plot(masses,powers,'r*',x,bestfit,'b-',x,zero,'k-')
title('Power vs Mass')
xlabel('Mass (grams)')
ylabel('Power (Watts)')