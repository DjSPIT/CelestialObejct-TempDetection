clc();
clear();
//vid = aviopen(fullpath(getIPCVpath() + "/images/video.avi"));
//disp(aviinfo(n));
//[a,w,h,b] = aviinfo(vid);
//im = avireadframe(vid,20); //get a frame
//imshow(xm, hotcolormap(256));
//matplot(im);

//control variables
    //for img size
    width = 200;
    height = 200;
    
    //for circular celestial object
    x_cco_offset1 = width*rand();
    y_cco_offset1 = height*rand();
    r1_cco = 72;
    
    //for elliptical celestial object
    a1_eco = 20;
    b1_eco = 30;
    x_eco_offset1 = width*rand();
    y_eco_offset1 = height*rand();
    a2_eco = 40;
    b2_eco = 50;
    x_eco_offset2 = width*rand();
    y_eco_offset2 = height*rand();
    
//    //for rectangular celestial object
    x1_rco = width*rand();
    y1_rco = height*rand();
    x2_rco = width*rand();
    y2_rco = height*rand();
    x3_rco = width*rand();
    y3_rco = height*rand();
    x4_rco = width*rand();
    y4_rco = height*rand();
    


//data structs
thermal_image = double(zeros(width,height));
final_integer = int(ones(width,height));
freq_mat = int(ones(width,height));
final_img = uint16(ones(width,height,3));

//final_img = final_img*255;

t=-10:0.01:10;

b = 3*(10^6);
c = 3*(10^8);

base_freq = 10*(10^8);
samp_freq = 50*(10^8);
buff_length = 300;
n = 0:(buff_length-1);

HalfBufferLength = buff_length/2;
HorizAxisIncrement = (samp_freq/2)/HalfBufferLength;
DFTHorizAxis = 0:HorizAxisIncrement:((samp_freq/2)-HorizAxisIncrement);

m = (samp_freq/base_freq);

w = 2*%pi*n;

for i=1:1:width
    for j=1:1:height
        f = 0;
        y = rand()*sin((w/m)-(rand()*w/(m))) + rand()*sin((w/m)-(rand()*w/(m))) + rand()*sin((w/m)-(rand()*w/(m)))
//        y = rand()*sin(/*rand()*/1.9*w/(10*m)) + rand()*sin(/*rand()*/1.09*w/(10*m)) + rand()*sin(/*rand()*/1.11*w/(10*m));
//        y = rand()*sin(rand()*w/(10*m)) + rand()*sin(rand()*w/(10*m)) + rand()*sin(rand()*w/(10*m));
        T = 0;
        //getting the required data
        
//        //rectangular celestial Object1
//        if (i>x1_rco && i<(x1_rco+1))
//            if (j>y1_rco && j<(y1_rco+1))
//                //fake input wave
//                y = rand()*sin(rand()*w/m) + rand()*sin(rand()*w/m) + rand()*sin(rand()*w/m);
//            end
//        end
//        
//        //rectangular celestial Object2
//        if (i>x2_rco && i<(x2_rco+1))
//            if (j>y2_rco && j<(y2_rco+1))
//                //fake input wave
//                y = rand()*sin(rand()*w/m) + rand()*sin(rand()*w/m) + rand()*sin(rand()*w/m);
//            end
//        end
//        
//        //rectangular celestial Object3
//        if (i>x3_rco && i<(x3_rco+1))
//            if (j>y3_rco && j<(y3_rco+1))
//                //fake input wave
//                y = rand()*sin(rand()*w/m) + rand()*sin(rand()*w/m) + rand()*sin(rand()*w/m);
//            end
//        end
//        
//        //rectangular celestial Object4
//        if (i>x4_rco && i<(x4_rco+1))
//            if (j>y4_rco && j<(y4_rco+1))
//                //fake input wave
//                y = rand()*sin(rand()*w/m) + rand()*sin(rand()*w/m) + rand()*sin(rand()*w/m);
//            end
//        end

        //Circular Celestial Object1 
        if ((((i-x_cco_offset1)^2) + (j-y_cco_offset1)^2)<=(r1_cco^2))
            if (1)
                //fake input wave
                y = rand()*sin((w/m)-(rand()*w/(10*m))) + rand()*sin((w/m)-(rand()*w/(10*m))) + rand()*sin((w/m)-(rand()*w/(10*m)));
            end
        end

//        //Elliptical Celestial Object1 
//        if ((((i-x_eco_offset1)^2)/(a1_eco^2) + ((j-y_eco_offset1)^2)/(b1_eco^2))<=1) then
//            if (1)
//                //fake input wave
//                y = rand()*sin(rand()*w/m) + rand()*sin(rand()*w/m) + rand()*sin(rand()*w/m);
//            end
//        end
//        
//        //Elliptical celestial Object2
//        if (((i-(x_eco_offset2))^2/(a2_eco^2) + (j-(y_eco_offset2))^2/(b2_eco^2))<=1) then
//            if (1)
//                //fake input wave
//                y = rand()*sin(rand()*w/m) + rand()*sin(rand()*w/m) + rand()*sin(rand()*w/m);
//            end
//        end

        ft = abs(fft(y));
        //plot(DFTHorizAxis, vm(1:HalfBufferLength));
        [val,index] = max(ft);
        freq_mat(i,j) = val;
        f = DFTHorizAxis(index);
        T = (b*f)/c;
        thermal_image(i,j) = T;
        
    end
end

//matplot(thermal_image);

//m = fft(arr(:,1),1);
//plot(abs(m));
//avilistopened();
//aviclose(n);


//changing thermal image to rgb
T = (b*base_freq)/c;

for i=1:1:width
    for j=1:1:height
        //old code
//        if (thermal_image(i,j)==0)
//            //final_img(i,j,1) = uint16 (myvar);
//            continue;
//        end
        myvar = ((thermal_image(i,j))*16777215/T);
        
        final_integer(i,j) = myvar;
        
        r = (floor(myvar/(256*256)));
        g = modulo((floor((myvar/256)),256));
        b = modulo(myvar,256); 
        
        final_img(i,j,:) = uint16([r g b]);
//        image(i,j,1) = r; 
//        image(i,j,2) = g;
//        image(i,j,3) = b;
        
        //old code
//        if (thermal_image(i,j)>6.66*(10^6))
//            final_img(i,j,1) = /final_img(i,j,1) +/ uint16 (myvar);
//            continue;
//        end
//        if (thermal_image(i,j)>3.33*(10^6))
//            final_img(i,j,2) = /final_img(i,j,2) +/ uint16 (myvar);
//            continue;
//        end
//        if (thermal_image(i,j)<3.33*(10^6))
//            final_img(i,j,3) = /final_img(i,j,3) +/ uint16 (myvar);
//            continue;
//        end

    end
end

//image = new_Mat()
scicv_Init();
//image = new_Mat(width, height, CV_8UC3);
//image = final_img;
//

//imshow(image);
//f = scf();
//imshow(image, 1);
//if with_tk() then
//imshow(image, 2);
//end
//imshow(final_img)

matplot(final_img);

//RGB = final_img;//imread ("teaset.png");
//Image = rgb2gray(RGB);
//InvertedImage = uint8(255 * ones(size(Image,1), size(Image,2))) - Image;
//Threshold=100;
//level=Threshold/255;
//LogicalImage = im2bw(InvertedImage, level);
//StructureElement = imcreatese('rect',21,21);
//FilteredLogicalImage = imclose(LogicalImage,StructureElement)
//[ObjectImage,n] = imlabel(FilteredLogicalImage);
//
//f1=scf(1);f1.name='Logical Image';
//matplot(LogicalImage);
//f2=scf(2);f2.name='Filtered Logical Image';
//matplot(FilteredLogicalImage,jetcolormap(n))
//f3=scf(3);f3.name='Result of Blob Analysis';
//matplot(ObjectImage,jetcolormap(n))
//
//[Area, BB] = imblobprop(ObjectImage);
//f4=scf(4);f4.name='Result of Blob Analysis';
//matplot(RGB);
//imrects(BB,[255 0 0]);

imwrite("Final.jpg",final_img);
s = imread("Final.jpg");
