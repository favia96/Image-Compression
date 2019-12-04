function f=PSNR(A,B)

% PURPOSE: To find the PSNR (peak signal-to-noise ratio) between two
%          intensity images A and B, each having values in the interval
%          [0,1]. The answer is in decibels (dB).
%
%          There is also a provision, in EXAMPLE 3 below, for images 
%          stored in the interval [0,255], i.e. 256 gray levels. 
%
% SYNOPSIS: PSNR(A,B)
%
% DESCRIPTION: The following is quoted from "Fractal Image Compression",
%              by Yuval Fisher et al.,(Springer Verlag, 1995),
%              section 2.4, "Pixelized Data".
%
%              "...PSNR is used to measure the difference between two
%              images. It is defined as
%
%                           PSNR = 20 * log10(b/rms)
%
%              where b is the largest possible value of the signal
%              (typically 255 or 1), and rms is the root mean square
%              difference between two images. The PSNR is given in
%              decibel units (dB), which measure the ratio of the peak 
%              signal and the difference between two images. An increase
%              of 20 dB corresponds to a ten-fold decrease in the rms
%              difference between two images.
%              
%              There are many versions of signal-to-noise ratios, but
%              the PSNR is very common in image processing, probably
%              because it gives better-sounding numbers than other
%              measures."
%

if A == B
   error('Images are identical: PSNR has infinite value')
end

A = double(A);
B = double(B);
max2_A = max(max(A));
max2_B = max(max(B));
min2_A = min(min(A));
min2_B = min(min(B));

if max2_A > 255 || max2_B > 255 || min2_A < 0 || min2_B < 0
  error('input matrices must have values in the interval [0,255]')
end

error_diff = A - B;
decibels = 20*log10(255/(sqrt(mean(mean(error_diff.^2)))));
f=decibels;
%disp(sprintf('PSNR = +%5.2f dB',decibels))
