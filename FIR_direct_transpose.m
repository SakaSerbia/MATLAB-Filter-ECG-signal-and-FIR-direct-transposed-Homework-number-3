%Teorija
%Transpozicija se vrsi tako sto ulazni i izlazni signali promene mesta,
%svim granama se promeni smer, cvorovi granjanja postanu sabiraci, a
%sabiraci postanu tacke granjanja.

%Dodatna objasnjenja MIT OpenCourseWare http://ocw.mit.edu
%Signal Processing: Continuous and Discrete, Fall 2008

function [ y ] = FIR_direct_transpose( h, x)

% function [ y ] = FIR_direct( b, x )
% %FIR_DIREXT Function that implements direct realizaton of FIR filter
%     delay_line = zeros(length(b),1);
%     if isfi(b) 
%         delay_line = fi( delay_line, b.Signed, b.WordLength, b.FractionLength); 
%     end;
%     
%     for k = 1:length(x)
%         delay_line = [x(k); delay_line(1:end-1)];
%         accumulator_contents = b*delay_line;
%         y(k) = accumulator_contents;
%     end
% end

delay_line = zeros(1,length(h)-1);
if isfi(h)
    delay_line = fi( delay_line, h.Signed, h.WordLength, h.FractionLength);
end

y = zeros(1,length(x));

 for k=1:length(x)
     accumulator_contents = fliplr(h)*x(k); 
     y(k) = accumulator_contents(length(accumulator_contents)) + delay_line(length(delay_line)); 
     delay_line=[accumulator_contents(1),accumulator_contents(2:length(accumulator_contents)-1)+delay_line(1:length(delay_line)-1)];   
 end
 
end

