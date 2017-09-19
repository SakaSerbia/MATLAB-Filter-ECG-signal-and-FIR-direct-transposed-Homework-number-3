%%%%%%%%%%%%%%%%%%%
% Deo 1 - Stefan Tesanovic 675/2016
%%%%%%%%%%%%%%%%%%%

clear all; close all; clc; warning off;

fs = 360; % ucestanost odabiranja
time = 17; % maksimalno trajanje signala


% Ucitavanje EKG signala
ekg = load('ecg_corrupted.mat');
ekg_signal = ekg.val(1,1:time*fs);  
t = 1/fs:1/fs:time;

figure(1)
plot(t,ekg_signal);
xlabel('t[s]'), ylabel('signal x(s)'); grid on;
title('Ucitan EKG signal'); 

%%%%%%%%%%%%
% Tacka 3
%%%%%%%%%%%%

%Zadati gabariti
fa_vf = 0.4;
fp_vf = 1;
Aa_vf = 30;
Ap_vf = 0.5;

% Kreiranje filtra
h1 = baseline_drift_filter (fs,fa_vf,fp_vf,Aa_vf,Ap_vf);

% Filtriranje signala
x = filter(h1,1,ekg_signal); 

figure(2)
plot(t,x);
xlabel('t[s]'); ylabel('signal x(t)'); grid on;
title('EKG signal propusten kroz VF filtar');

%%%%%%%%%%%%
%%% Tacka 4
%%%%%%%%%%%%

% Zadati gabariti
fc_npo = 60;
Aa_npo = 40;
Ap_npo = 0.5;


% Kreiranje filtra
h2 = power_line_noise_filter (fs,fc_npo,Aa_npo,Ap_npo);

% Filtriranje signala
y = filter(h2,1,x);   

figure(3)
plot(t,y);
xlabel('t[s]'); ylabel('signal y(t)'); grid on;
title('EKG signal propusten kroz VF filtar NPO');



%%%%%%%%%%%%
% Tacka 5
%%%%%%%%%%%%

%VF filtar
[H1,w1] = freqz(h1,1,4096);
Ha1 = abs(H1);            
Hp1 = unwrap(angle(H1)); 

dp = (10^(0.05*Ap_vf)-1) / (10^(0.05*Ap_vf)+1);	
da = 10^(-0.05*Aa_vf);
wp = 2*pi*fp_vf/fs;
wa = 2*pi*fa_vf/fs;

x_g1 = [0 wa]; 
x_g2 = [wa wa];
x_g3 = [wp wp];
x_g4 = [wp pi];
x_g5 = [wp pi];

y_g1 = [da da];
y_g2 = [da 1+dp];   
y_g3 = [da/10 1+dp];
y_g4 = [1-dp 1-dp];
y_g5 = [1+dp 1+dp]; 

%U zadatku ne pise da amplituda i fazna karakteristika moraju na istom
%grafiku tako da sam ih crtao odvojeno
figure(4)
plot(w1,Ha1)
title('Amplitudska karakteristika VF filtra')
xlabel('F[Hz]'); ylabel('|X|[dB]');
grid on; hold on; axis ([0 0.2 0 1.2]);
line(x_g1,y_g1,'LineWidth',2,'Color','r');
line(x_g2,y_g2,'LineWidth',2,'Color','r');
line(x_g3,y_g3,'LineWidth',2,'Color','r');
line(x_g4,y_g4,'LineWidth',2,'Color','r');
line(x_g5,y_g5,'LineWidth',2,'Color','r');
hold off

figure(5)
plot(w1,Hp1)
title('Fazna karakteristika VF filtra')
xlabel('F[Hz]');ylabel('Faza X'); grid on


% NPO filtar
[H2,w2] = freqz(h2,1,4096); 
Ha2 = abs(H2); 
Hp2 = unwrap(angle(H2));

Fp1 = (fc_npo-2)/fs;
Fp2 = (fc_npo+2)/fs;
Fa1 = (fc_npo-0.5)/fs;
Fa2 = (fc_npo+0.5)/fs;

dp = (10^(0.05*Ap_npo)-1 )/( 10^(0.05*Ap_npo)+1 );
da = 10^(-0.05*Aa_npo);
wp1 = 2*pi*Fp1;
wp2 = 2*pi*Fp2;
wa1 = 2*pi*Fa1;
wa2 = 2*pi*Fa2;

x_g1 = [0 wp1];   
x_g2 = [0 wp1];      
x_g3 = [wp1 wp1]; 
x_g4 = [wa1 wa1]; 
x_g5 = [wa1 wa2]; 
x_g6 = [wa2 wa2]; 
x_g7 = [wp2 pi];  
x_g8 = [wp2 pi];     
x_g9 = [wp2 wp2]; 

y_g1 = [1+dp 1+dp];
y_g2 = [1-dp 1-dp];
y_g3 = [da/10 1+dp];
y_g4 = [da/10 da];
y_g5 = [da da];
y_g6 = [da/10 da];
y_g7 = [1+dp 1+dp];
y_g8 = [1-dp 1-dp];
y_g9 = [da/10 1+dp];

figure(6)
plot(w2,Ha2)
title('Amplitudska karakteristika NPO filtra');
xlabel('F[Hz]'); ylabel('|Y|[dB]');
grid on; hold on; axis ([0.5 1.5 0 1.2]);
line(x_g1,y_g1,'LineWidth',2,'Color','r');
line(x_g2,y_g2,'LineWidth',2,'Color','r');
line(x_g3,y_g3,'LineWidth',2,'Color','r');
line(x_g4,y_g4,'LineWidth',2,'Color','r');
line(x_g5,y_g5,'LineWidth',2,'Color','r');
line(x_g6,y_g6,'LineWidth',2,'Color','r');
line(x_g7,y_g7,'LineWidth',2,'Color','r');
line(x_g8,y_g8,'LineWidth',2,'Color','r');
line(x_g9,y_g9,'LineWidth',2,'Color','r');
hold off

figure(7)
plot(w2,Hp2)
title('Fazna karakteristika NPO filtra')
xlabel('F[Hz]'); ylabel('Faza Y');
grid on




















