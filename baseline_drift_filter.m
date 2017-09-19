function [ h ] = baseline_drift_filter( fs, fa, fp, Aa, Ap )

dp = (10^(0.05*Ap)-1) / (10^(0.05*Ap)+1);	
da = 10^(-0.05*Aa);
Nfft = 34000;  % broj tacaka mora da bude dovoljan da bi moao da se nadje red filtra

%%%%%%%%% izracunavanje potrebnog reda filtra %%%%%%%%%%%
D=(0.005309*log10(dp)*log10(dp)+0.07114*log10(dp)-0.4761)*log10(da);
D=D-(0.00266*log10(dp)*log10(dp)+0.5941*log10(dp)+0.4278);
f=11.01217+0.51244*(log10(dp)-log10(da));
Bt=2*pi*(fp-fa)/fs;
M=2*pi*D/Bt-f*Bt/(2*pi) + 1;
M=ceil(M);		% duzina impulsnog odziva
N=M+1;	% red filtra
% OVO SMO DODALI DA BI BILO UNIVERZNO
N=N-1;

%%%%%%%%% projektovanje filtra na osnovu zadatih parametara %%%%%
fp_n=fp/(fs/2);fa_n=fa/(fs/2);	% normalizacija ucestanosti 
Hd=[0   0    1   1];	% zeljena amplitudska karakteristika
F=[ 0 fa_n fp_n  1];	% vektor ucestanosti za koje se zadaje Hd(w)

%OVDE UBACUJEMO PETLJU, posto nema do petlja u MATLABu koristimo metod zastavice
zadovoljava=0;
while (zadovoljava~=1)
N=N+1;
h=remez(N,F,Hd);	% projektovanje filtra
[H,~]=freqz(h,1,Nfft);
Ha=abs(H);%Hp=unwrap(angle(H));
ka=ceil((2*fa*Nfft)/fs)+1;
kp=fix((2*fp*Nfft)/fs)+1;
% 
    if (max(Ha(1:ka))<=da) && (min(Ha(kp:Nfft))>=1-dp),
        zadovoljava=1; 
    end   
end

disp('Potreban red za VF filtar je:');
disp(N);


end

