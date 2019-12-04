%% IMAGE PROCESSING - PROJECT 2, 30.11.2019
%% Yue Song - Federico Favia

%% Initialization
clear ; close all; clc

path_harbour = 'D:\Federico\Documents\Federico\Uni Trento\03 Magistrale EIT\02 EIT VCC 2019-20\2nd period\01 Image and Video Processing EQ2330\project_2\images\harbour512.tif';
path_boats = 'D:\Federico\Documents\Federico\Uni Trento\03 Magistrale EIT\02 EIT VCC 2019-20\2nd period\01 Image and Video Processing EQ2330\project_2\images\boats512.tif';
path_peppers = 'D:\Federico\Documents\Federico\Uni Trento\03 Magistrale EIT\02 EIT VCC 2019-20\2nd period\01 Image and Video Processing EQ2330\project_2\images\peppers512.tif';
path_lena = 'D:\Federico\Documents\Federico\Uni Trento\03 Magistrale EIT\02 EIT VCC 2019-20\2nd period\01 Image and Video Processing EQ2330\project_2\images\lena512.bmp';

%% ==================== Part 1: DCT-based Image Compression ====================
%% DCT 8x8 block
a = rand(8,8);
A = dct2(a);
AA = dct_block(a);
re = sum(sum(A-AA));

B = inverse_dct_block(A);
BB = inverse_dct_block(A);
re1 = sum(sum(B-BB));

%% Uniform Quantizer
[~,A] = dct_block(rand(8,8));
step = linspace(-0.5,0.5,16+1); %16 quantization steps
% Plot mid-tread uniform quantization
x = linspace(-0.5,0.5,1000);
y = mid_tread_quan(x,step);

figure;
PlotAxisAtOrigin(x,y);
hold on
PlotAxisAtOrigin(x,x);
hold off
A_quan = mid_tread_quan(A,step);

%% Distortion and Bit-Rate Estimation
%img = imread(path_lena);

img = rand(8,8);
%dct_img = zeros(size(img));
%recon_img = zeros(size(img));
% for i = 1 : size(img,1)/8
%     for j = 1 : size(img,2)/8
%         [dct_img(8*(i-1)+1:8*i,8*(j-1)+1:8*j),A] = dct_block(double(img(8*(i-1)+1:8*i,8*(j-1)+1:8*j)));
%         recon_img(8*(i-1)+1:8*i,8*(j-1)+1:8*j) = inverse_dct_block(dct_img(8*(i-1)+1:8*i,8*(j-1)+1:8*j));
%     end
% end

dct_img = dct_block(double(img));
step =  linspace(-1,4,2^16);
dct_img_quan = mid_tread_quan(dct_img,step);
recon_img = inverse_dct_block(dct_img_quan);
mse_img = mean_square_error(double(img),recon_img);
mse_transform = mean_square_error(dct_img_quan,dct_img);
mse1 = (double(img)-recon_img)'*(double(img)-recon_img);
mse2 = (dct_img_quan-dct_img)'*(dct_img_quan-dct_img);

%% PSNR Estimation
%DCT-2 for each block
%block_dct = blockproc(x,[8 8],@dct2);
%block_idct = blockproc(block_dct,[8 8],@idct2);
uniform_quantizer = @(x,ssize) round(x/ssize)*ssize;
pepper = im2double(imread(path_peppers));
harbor = im2double(imread(path_harbour));
boat = im2double(imread(path_boats));

step = [2^0,2^1,2^2,2^3,2^4,2^5,2^6,2^7,2^8,2^9];
psnrs_dct = zeros(size(step));
bits_dct = zeros(size(psnrs_dct));

dct_pepper = blkproc(pepper,[8 8],@dct2);
dct_harbor = blkproc(harbor,[8 8],@dct2);
dct_boat = blkproc(boat,[8 8],@dct2);
MAX = max([max(dct_pepper(:)),max(dct_harbor(:)),max(dct_boat(:))]);
MIN = min([min(dct_pepper(:)),min(dct_harbor(:)),min(dct_boat(:))]);

for i = 1 : size(step,2)
    quant = linspace(MIN,MAX,step(i));
    quan_ll = mid_tread_quan(dct_pepper,quant);
    quan_lh_2 = mid_tread_quan(dct_harbor,quant);
    quan_hl = mid_tread_quan(dct_boat,quant);
    psnrs_dct(i) = psnr([quan_ll,quan_lh_2,quan_hl],[dct_pepper,dct_harbor,dct_boat]);
    %psnrs(i)=10*log10((255^2)/psnrs(i));
    mse_dct(i) = mse([quan_ll,quan_lh_2,quan_hl],[dct_pepper,dct_harbor,dct_boat]);
    
    transform = zeros(8,8,64,64,3); 
    k = 1 : 64; l = 1 : 64;
    for w = 1 : 8
        for h = 1 : 8
            transform(w,h,:,:,1) = quan_ll(8*(k-1)+w,8*(l-1)+h);
            transform(w,h,:,:,2) = quan_lh_2(8*(k-1)+w,8*(l-1)+h);
            transform(w,h,:,:,3) = quan_hl(8*(k-1)+w,8*(l-1)+h);
        end
    end

    entropy_dct = zeros(8,8);
    for w = 1 : 8
        for h = 1 : 8
            trans_dct = reshape(transform(w,h,:,:,:),[3*64*64,1]);
            prob_dct = hist(trans_dct,step(i));
            prob_dct = prob_dct/sum(prob_dct);
            entropy_dct(w,h) = sum(-prob_dct.*log2(prob_dct+eps));
        end
    end
    bits_dct(i) = mean2(entropy_dct);
end   

%% Plot Bitrates-PSNR curve
figure()
surf(entropy_dct); title('Entropy DCT');

figure()
plot(bits_dct,psnrs_dct)
%axis([0 5 -10 50])
grid on
xlabel('Bit rates ','fontSize',18)
ylabel('PSNR [dB]','fontSize',18)
title('Rates-PSNR Curve','fontSize',18)

%% ==================== Part 2: FWT-based Image Compression ====================
%% 1D case: analysis and synthesis 2-band filter banks
load('D:\Federico\Documents\Federico\Uni Trento\03 Magistrale EIT\02 EIT VCC 2019-20\2nd period\01 Image and Video Processing EQ2330\project_2\project_2_image_proc\coeffs.mat');
scaling_vector = db4;
signal = rand(1,randi([2 1000],1,1)); % 1-d signal of random values and random size

[approx_coeff, detail_coeff] = fwt_analysis(signal,scaling_vector);

recon_signal = fwt_synthesis(approx_coeff,detail_coeff,scaling_vector);
recon_signal = recon_signal(1:length(signal)); % adjust result in case of odd size of input

% check accuracy of rec. signal without qtz down to machine precision
disp('Mse reconstructed by fwt 1d signal = ');
disp(mse(recon_signal,signal)); 

%% 2D case: FWT on image
img = imread(path_harbour);
scaling_vector = dbwavf('db8'); % Daubechies 8-tap filter
scale = 5;

[ll,lh,hl,hh] = fwt_2d(img,scaling_vector); % scale 4

[ll_o,lh_o,hl_o,hh_o] = dwt2(img,'db8'); % Matlab method to compare

figure()
subplot(2,2,1); showgrey(ll); title('LL');
subplot(2,2,2); showgrey(hl); title('HL');
subplot(2,2,3); showgrey(lh); title('LH');
subplot(2,2,4); showgrey(hh); title('HH');
sgtitle('Wavelet coefficients Our method');
% figure()
% multi = cat(3,mat2gray(ll),mat2gray(hl),mat2gray(lh),mat2gray(hh));
% montage(multi);

figure() % to compare our borders effect on wavelet coeff. wrt the ones obtained by Matlab official function
subplot(2,2,1); showgrey(ll_o); title('LL');
subplot(2,2,2); showgrey(hl_o); title('HL');
subplot(2,2,3); showgrey(lh_o); title('LH');
subplot(2,2,4); showgrey(hh_o); title('HH');
sgtitle('Wavelet coefficients Matlab method');

recon_img = ifwt_2d(ll,lh,hl,hh,scaling_vector);
recon_img_official = idwt2(ll_o,lh_o,hl_o,hh_o,'db8');

figure() % comparison of original image, reconstructed image by our method and by Matlab method
subplot(1,3,1); imshow(img); title('Original image');
subplot(1,3,2); showgrey(recon_img); title('Rec. image Our method');
subplot(1,3,3); showgrey(recon_img_official); title('Rec. image Matlab method');

% check accuracy of rec. image without qtz down to machine precision
disp('Mse reconstructed by fwt on harbour image = ');
disp(mse(double(img),recon_img));

%% Uniform Quantizer of wavelet coeff
uniform_quantizer = @(x,ssize) round(x/ssize)*ssize;
pepper = im2double(imread(path_peppers));
harbour = im2double(imread(path_harbour));
boat = im2double(imread(path_boats));

% same step as DCT
psnrs_fwt = zeros(size(step));
bits_fwt = zeros(size(psnrs_fwt));

[ll_1,lh_1,hl_1,hh_1] = fwt_2d(pepper,scaling_vector);
[ll_2,lh_2,hl_2,hh_2] = fwt_2d(harbour,scaling_vector);
[ll_3,lh_3,hl_3,hh_3] = fwt_2d(boat,scaling_vector);

MAX1 = max([max(ll_1(:)),max(lh_1(:)),max(hl_1(:)),max(hh_1(:))]);
MAX2 = max([max(ll_2(:)),max(lh_2(:)),max(hl_2(:)),max(hh_2(:))]);
MAX3 = max([max(ll_3(:)),max(lh_3(:)),max(hl_3(:)),max(hh_3(:))]);
MAX = max([MAX1 MAX2 MAX3]);
MIN1 = min([min(ll_1(:)),min(lh_1(:)),min(hl_1(:)),min(hh_1(:))]);
MIN2 = min([min(ll_2(:)),min(lh_2(:)),min(hl_2(:)),min(hh_2(:))]);
MIN3 = min([min(ll_3(:)),min(lh_3(:)),min(hl_3(:)),min(hh_3(:))]);
MIN = min([MIN1 MIN2 MIN3]);

for i = 1 : size(step,2)
    quant = linspace(MIN,MAX,step(i));
    quan_ll_1 = mid_tread_quan(ll_1,quant);
    quan_lh_1 = mid_tread_quan(lh_1,quant);
    quan_hl_1 = mid_tread_quan(hl_1,quant);
    quan_hh_1 = mid_tread_quan(hh_1,quant);
    
    quan_ll_2 = mid_tread_quan(ll_2,quant);
    quan_lh_2 = mid_tread_quan(lh_2,quant);
    quan_hl_2 = mid_tread_quan(hl_2,quant);
    quan_hh_2 = mid_tread_quan(hh_2,quant);
    
    quan_ll_3 = mid_tread_quan(ll_3,quant);
    quan_lh_3 = mid_tread_quan(lh_3,quant);
    quan_hl_3 = mid_tread_quan(hl_3,quant);
    quan_hh_3 = mid_tread_quan(hh_3,quant);

    psnrs_fwt(i) = psnr([quan_ll_1,quan_lh_1,quan_hl_1,quan_hh_1,quan_ll_2,quan_lh_2,quan_hl_2,quan_hh_2,quan_ll_3,quan_lh_3,quan_hl_3,quan_hh_3],[ll_1,lh_1,hl_1,hh_1,ll_2,lh_2,hl_2,hh_2,ll_3,lh_3,hl_3,hh_3]);
    %psnrs_mean(i) = mean([psnr([quan_ll_1,quan_lh_1,quan_hl_1,quan_hh_1],[ll_1,lh_1,hl_1,hh_1]), psnr([quan_ll_2,quan_lh_2,quan_hl_2,quan_hh_2],[ll_2,lh_2,hl_2,hh_2]), psnr([quan_ll_3,quan_lh_3,quan_hl_3,quan_hh_3],[ll_3,lh_3,hl_3,hh_3])]);
    mse_fwt(i) = mse([quan_ll_1,quan_lh_1,quan_hl_1,quan_hh_1,quan_ll_2,quan_lh_2,quan_hl_2,quan_hh_2,quan_ll_3,quan_lh_3,quan_hl_3,quan_hh_3],[ll_1,lh_1,hl_1,hh_1,ll_2,lh_2,hl_2,hh_2,ll_3,lh_3,hl_3,hh_3]);
    
    transform = zeros(256,256,2,2,3); 

    k = 1 : 2; l = 1 : 2;
    for w = 1 : 256
        for h = 1 : 256
            transform(w,h,1,1,1) = quan_ll_1(w,h);
            transform(w,h,1,2,1) = quan_lh_1(w,h);
            transform(w,h,2,1,1) = quan_hl_1(w,h);
            transform(w,h,2,2,1) = quan_hh_1(w,h);
            
            transform(w,h,1,1,2) = quan_ll_2(w,h);
            transform(w,h,1,2,2) = quan_lh_2(w,h);
            transform(w,h,2,1,2) = quan_hl_2(w,h);
            transform(w,h,2,2,2) = quan_hh_2(w,h);
            
            transform(w,h,1,1,3) = quan_ll_3(w,h);
            transform(w,h,1,2,3) = quan_lh_3(w,h);
            transform(w,h,2,1,3) = quan_hl_3(w,h);
            transform(w,h,2,2,3) = quan_hh_3(w,h);
            
        end
    end

    entropy_fwt = zeros(256,256);
    for w = 1 : 256
        for h = 1 : 256
            trans_fwt = reshape(transform(w,h,:,:,:),[3*2*2,1]);
            prob_fwt = hist(trans_fwt,step(i));
            prob_fwt = prob_fwt/sum(prob_fwt);
            entropy_fwt(w,h) = sum(-prob_fwt.*log2(prob_fwt+eps));
        end
    end
    bits_fwt(i) = mean2(entropy_fwt);
end   

%% Distortion and Bit-Rate Estimation
figure()
surf(entropy_fwt); % title('Entropy FWT');

figure() % comparison psnr vs bit rate for fwt and dct
plot(bits_fwt,psnrs_fwt,'r')
hold on
plot(bits_dct,psnrs_dct,'b')
hold off
legend('FWT','DCT')
%axis([0 5 -10 50])
grid on
xlabel('Bit rates ','fontSize',18)
ylabel('PSNR [dB]','fontSize',18)
title('Rates-PSNR Curve FWT and DCT','fontSize',18)

