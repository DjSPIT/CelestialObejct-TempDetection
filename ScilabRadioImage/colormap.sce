b = 3*(10^6);
c = 3*(10^8);
base_freq = 10*(10^8);

T = (b*base_freq)/c;

x = 1:1:T;

mymap = uint16(zeros(T,3));

for i=2:1:T
    myvar = (i*16777215/T);
    r = (floor(myvar/(256*256)));
    g = modulo(floor(myvar/256),256);
    b = modulo(myvar,256);
    mymap(i,:) = uint16([r g b]);
    i = i-1;
    i = i*10000;
end

finalmap = uint16(zeros(100000,1,3))

for j=1:1:100
    finalmap
end

imwrite(mymap,"colormap.jpg");