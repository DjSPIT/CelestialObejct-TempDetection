t=-1:0.01:1;

base_freq = 10*(10^8);
samp_freq = 10*(10^9);
buff_length = 300;
n = 0:(buff_length-1);

HalfBufferLength = buff_length/2;
HorizAxisIncrement = (samp_freq/2)/HalfBufferLength;
DFTHorizAxis = 0:HorizAxisIncrement:((samp_freq/2)-HorizAxisIncrement);

m = (samp_freq/base_freq);

w = 2*%pi*n;
y = sin(w/m);//rand()*sin(rand()*w/m) + rand()*sin(rand()*w/m) + rand()*sin(rand()*w/m);
vm = abs(fft(y));
plot(DFTHorizAxis, vm(1:HalfBufferLength));
a = 0;
for n=1:100
    //disp(n);
    if (abs(vm(n))>abs(vm(n+1))) then
        //freq_list(a) = n;
        a = a+1;
    end
end
