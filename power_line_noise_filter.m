function [ h ] = power_line_noise_filter( fs, fc, Aa, Ap )

% Granicne ucestanosti propusnog opsega% 
Fp1 = (fc-2)/fs;
Fp2 = (fc+2)/fs;
%granicne ucestanosti nepropusnog opsega
Fa1 = (fc-0.5)/fs;
Fa2 = (fc+0.5)/fs;

dp = (10^(0.05*Ap)-1) / (10^(0.05*Ap)+1);	
da = 10^(-0.05*Aa);
Nfft = 34000;  % broj tacaka mora da bude dovoljan da bi moao da se nadje red filtra

%%%%%%%%% izracunavanje potrebnog reda filtra %%%%%%%%%%%
% % % D=(0.001201*log10(dp)*log10(dp)+0.09664*log10(dp)-0.51325)*log10(da);
% % % D=D+(0.00203*log10(dp)*log10(dp)-0.57054*log10(dp)-0.44314);
% % % f=-16.9-14.6*(log10(dp)-log10(da));
D=(0.005309*log10(dp)*log10(dp)+0.07114*log10(dp)-0.4761)*log10(da);
D=D-(0.00266*log10(dp)*log10(dp)+0.5941*log10(dp)+0.4278);
f=11.01217+0.51244*(log10(dp)-log10(da));

Bt1 = (Fa1-Fp1)*2*pi;
Bt2 = (Fp2-Fa2)*2*pi;
B = [Bt1 Bt2];
Bt = min(B);

M=2*pi*D/Bt-f*Bt/(2*pi) + 1;
M=ceil(M);		% duzina impulsnog odziva
N=M+1;	% red filtra
% OVO SMO DODALI DA BI BILO UNIVERZNO
N=N-1;

%%%%%%%%% projektovanje filtra na osnovu zadatih parametara %%%%%
fp1 = Fp1*2;
fp2 = Fp2*2; 
fa1 = Fa1*2;
fa2 = Fa2*2;                         % normalizacija ucestanosti 
Hd = [1   1   0   0   1   1];         % zeljena amplitudska karakteristika
F = [0 fp1 fa1 fa2 fp2 1];        % vektor ucestanosti za koje se zadaje Hd(w)


%Asistent uradio ovako u zadatku 2, cas14, pratimo vezbe. :)
kp1=ceil(Nfft*2*Fp1)+1;
kp2=floor(Nfft*2*Fp2)+1;
ka1=floor(Nfft*2*Fa1)+1;
ka2=ceil(Nfft*2*Fa2)+1;


%OVDE UBACUJEMO PETLJU, posto nema do petlja u MATLABu koristimo metod zastavice
zadovoljava=0;
while (zadovoljava~=1)
N=N+1;
h = remez(N,F,Hd);
[H,~] = freqz(h,1,Nfft);
Ha = abs(H);
Hno = Ha(ka1:ka2)';
Hpo=[Ha(1:kp1)' Ha(kp2:end)'];
    if ((max(Hno)<=da) && (min(Hpo)>=(1-dp))&&(max(Hpo)<=(1+dp))),
        zadovoljava=1; 
    end   
end

disp('Potreban red za NPO filtar je:');
disp(N);

end

