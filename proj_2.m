%% DCT 8x8 block
a=rand(8,8);
A=dct2(a);
AA=dct_block(a);
re=sum(sum(A-AA));

B=inverse_dct_block(A);
BB=inverse_dct_block(A);
re1=sum(sum(B-BB));
%% Uniform Quantizer
[~,A]=dct_block(rand(8,8));
step=linspace(-0.5,0.5,16+1); %16 quantization steps
% Plot mid-tread uniform quantization
x=linspace(-0.5,0.5,1000);
y=mid_tread_quan(x,step);
figure;
PlotAxisAtOrigin(x,y);
hold on
PlotAxisAtOrigin(x,x);
hold off
A_quan=mid_tread_quan(A,step);
%% Distortion and Bit-Rate Estimation
%img=imread('lena512.bmp');

img=rand(8,8);
%dct_img=zeros(size(img));
%recon_img=zeros(size(img));
% for i=1:size(img,1)/8
%     for j=1:size(img,2)/8
%         [dct_img(8*(i-1)+1:8*i,8*(j-1)+1:8*j),A]=dct_block(double(img(8*(i-1)+1:8*i,8*(j-1)+1:8*j)));
%         recon_img(8*(i-1)+1:8*i,8*(j-1)+1:8*j)=inverse_dct_block(dct_img(8*(i-1)+1:8*i,8*(j-1)+1:8*j));
%     end
% end
dct_img=dct_block(double(img));
step=linspace(-1,4,2^16);
dct_img_quan=mid_tread_quan(dct_img,step);
recon_img=inverse_dct_block(dct_img_quan);
mse_img=mean_square_error(double(img),recon_img);
mse_transform=mean_square_error(dct_img_quan,dct_img);
mse1=(double(img)-recon_img)'*(double(img)-recon_img);
mse2=(dct_img_quan-dct_img)'*(dct_img_quan-dct_img);
%% PSNR Estimation
%DCT-2 for each block
%block_dct = blockproc(x,[8 8],@dct2);
%block_idct = blockproc(block_dct,[8 8],@idct2);
uniform_quantizer = @(x,ssize) round(x/ssize)*ssize;
pepper=im2double(imread('images/peppers512x512.tif'));
harbor=im2double(imread('images/harbour512x512.tif'));
boat=im2double(imread('images/boats512x512.tif'));

step=[2^0,2^1,2^2,2^3,2^4,2^5,2^6,2^7,2^8,2^9];
psnrs=zeros(size(step));
bits=zeros(size(psnrs));

dct_pepper=blkproc(pepper,[8 8],@dct2);
dct_harbor=blkproc(harbor,[8 8],@dct2);
dct_boat=blkproc(boat,[8 8],@dct2);
MAX=max([max(dct_pepper(:)),max(dct_harbor(:)),max(dct_boat(:))]);
MIN=min([min(dct_pepper(:)),min(dct_harbor(:)),min(dct_boat(:))]);
for i=1:size(step,2)
    quant=linspace(MIN,MAX,step(i));
    quan_pepper=mid_tread_quan(dct_pepper,quant);
    quan_harbor=mid_tread_quan(dct_harbor,quant);
    quan_boat=mid_tread_quan(dct_boat,quant);
    psnrs(i)=psnr([quan_pepper,quan_harbor,quan_boat],[dct_pepper,dct_harbor,dct_boat]);
    %psnrs(i)=10*log10((255^2)/psnrs(i));
transform = zeros(8,8,64,64,3); 
k=1:64; l=1:64;
for w=1:8
    for h=1:8
        transform(w,h,:,:,1)=quan_pepper(8*(k-1)+w,8*(l-1)+h);
        transform(w,h,:,:,2)=quan_harbor(8*(k-1)+w,8*(l-1)+h);
        transform(w,h,:,:,3)=quan_boat(8*(k-1)+w,8*(l-1)+h);
    end
end
entropy=zeros(8,8);
for w=1:8
    for h=1:8
        trans=reshape(transform(w,h,:,:,:),[3*64*64,1]);
        prob=hist(trans,step(i));
        prob=prob/sum(prob);
        entropy(w,h)=sum(-prob.*log2(prob+eps));
    end
end
bits(i)=mean2(entropy);
end   
%% Plot Bitrates- PSNR curve
figure;
surf(entropy);
figure;
plot(bits,psnrs)
%axis([0 5 -10 50])
grid on
xlabel('Bit rates ','fontSize',18)
ylabel('PSNR [dB]','fontSize',18)
title('Rates-PSNR Curve','fontSize',18)




