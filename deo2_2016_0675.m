%%%%%%%%%%%%%%%%%%%%
% Tacka 2. Stefan Tesanovic 675/2016
%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc; warning off;

disp('Treba vise vremena da se zavrsi program. Molimo Vas budite strpljivi.');

b=[-0.0136 -0.0139 0.0254 0.0523 -0.0124 -0.0880 0.0252 0.3169 ...
0.4807 0.3169 0.0252 -0.0880 -0.0124 0.0523 0.0254 -0.0139 -0.0136] ;

% figure
% stem(b);

fs = 360; % ucestanost odabiranja
time = 17; % maksimalno trajanje signala

% Ucitavanje EKG signala
ekg = load('ecg_corrupted.mat');
ekg_signal = ekg.val(1,1:time*fs);  


N=length(ekg_signal);
n = 0:N-1; 


% Conversions into fixed point and determining the fixed point behavior of the sums and the products, and the final result
FixedPointAttributes=fimath ( 'ProductMode' , 'SpecifyPrecision' , 'ProductWordLength' , 24 , ...
    'ProductFractionLength' , 22 , 'SumMode' , 'SpecifyPrecision', 'SumWordLength' , 13 , 'SumFractionLength' , 12 ) ;

y = FIR_direct_transpose(b,ekg_signal);
y1 = filter(b,1,ekg_signal);

b_fixed_point = fi ( b , 1 , 12 , 10 ) ;
x_fixed_point = fi (ekg_signal , 1 , 12 , 10 ) ;
b_fixed_point.fimath = FixedPointAttributes ;
x_fixed_point.fimath = FixedPointAttributes ;
y_fixed_point = FIR_direct_transpose(b_fixed_point,x_fixed_point);

figure
subplot(411);
plot(n,ekg_signal);
title('Ulazni signal');

subplot(412);
plot(n,y);
title('Izlazni signal sa double preciznoscu');

subplot(413);
plot(n,y_fixed_point);
title('Izlazni signal sa fixed point preciznoscu');

subplot(414);
plot(n,y-y_fixed_point);
title('Razlika izlazni signala sa double i sa fixed point preciznoscu');

%%%%%%%%%%%%% Posle primene VF filtra iz prvog dela %%%%%%%%%%%%%%%%

%Zadati gabariti
fa_vf = 0.4;
fp_vf = 1;
Aa_vf = 30;
Ap_vf = 0.5;

% Kreiranje filtra
h1 = baseline_drift_filter (fs,fa_vf,fp_vf,Aa_vf,Ap_vf);

% Filtriranje signala
x_ekg_signal = filter(h1,1,ekg_signal); 

y = FIR_direct_transpose(b,x_ekg_signal);
y1 = filter(b,1,x_ekg_signal);

b_fixed_point = fi ( b , 1 , 12 , 10 ) ;
x_fixed_point = fi (x_ekg_signal , 1 , 12 , 10 ) ;
b_fixed_point.fimath = FixedPointAttributes ;
x_fixed_point.fimath = FixedPointAttributes ;
y_fixed_point = FIR_direct_transpose(b_fixed_point,x_fixed_point);

figure
subplot(411);
plot(n,x_ekg_signal);
title('Ulazni signal');

subplot(412);
plot(n,y);
title('Izlazni signal sa double preciznoscu');

subplot(413);
plot(n,y_fixed_point);
title('Izlazni signal sa fixed point preciznoscu');

subplot(414);
plot(n,y-y_fixed_point);
title('Razlika izlazni signala sa double i sa fixed point preciznoscu');


%%%%%%%%%%%%% Posle primene VF i NPO filtra iz prvog dela %%%%%%%%%%%%%%%%

% Zadati gabariti
fc_npo = 60;
Aa_npo = 40;
Ap_npo = 0.5;


% Kreiranje filtra
h2 = power_line_noise_filter (fs,fc_npo,Aa_npo,Ap_npo);

% Filtriranje signala
y_ekg_signal = filter(h2,1,x_ekg_signal);   

y = FIR_direct_transpose(b,y_ekg_signal);
y1 = filter(b,1,y_ekg_signal);

b_fixed_point = fi ( b , 1 , 12 , 10 ) ;
x_fixed_point = fi (y_ekg_signal , 1 , 12 , 10 ) ;
b_fixed_point.fimath = FixedPointAttributes ;
x_fixed_point.fimath = FixedPointAttributes ;
y_fixed_point = FIR_direct_transpose(b_fixed_point,x_fixed_point);

figure
subplot(411);
plot(n,y_ekg_signal);
title('Ulazni signal');

subplot(412);
plot(n,y);
title('Izlazni signal sa double preciznoscu');

subplot(413);
plot(n,y_fixed_point);
title('Izlazni signal sa fixed point preciznoscu');

subplot(414);
plot(n,y-y_fixed_point);
title('Razlika izlazni signala sa double i sa fixed point preciznoscu');


% %Karakteristike filtara
% [H,w]=freqz(b,1,1024);Ha=abs(H);
% [H_fp,w]=freqz(double(fi(b, 1, 8, 3)),1,1024);Ha_fp=abs(H_fp);
% figure
% plot(w,Ha,'LineWidth',2),title('Amplitudska karakteristika FIR filtra - linearna razmera'),grid on, hold on,
% plot(w,Ha_fp,'r','LineWidth',2),
% xlabel('w');
% ylabel('|H(e^(jw))|');


