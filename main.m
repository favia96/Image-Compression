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
quant=linspace(-0.5,0.5,16+1); %16 quantization steps
% Plot mid-tread uniform quantization
x=linspace(-0.5,0.5,1000);
y=mid_tread_quan(x,quant);
figure;
PlotAxisAtOrigin(x,y);
hold on
PlotAxisAtOrigin(x,x);
hold off
A_quan=mid_tread_quan(A,quant);
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
[dct_img,A,A_quan]=dct_block(double(img));
recon_img=inverse_dct_block(dct_img);
err_img=mse(img,zeros(size(img)));
re1=mean_square_error(double(img),recon_img);
re2=mean_square_error(A_quan,A);
re3=mean_square_error(A_quan'*A_quan,A'*A);
% re3=mean_square_error(zeros(size(img)),(A_quan'*A_quan-eye(size(A)))*img*(A_quan'*A_quan-eye(size(A))));

