function f = WPSNR(A,B,varargin)

% This function computes WPSNR (weighted peak signal-to-noise ratio) between
% two images. The answer is in decibels (dB).
%
% Using contrast sensitivity function (CSF) to weight spatial frequency
% of error image.
%
% Using: 	WPSNR(A,B)
%
% Written by Ruizhen Liu, http://www.assuredigit.com
A=mat2gray(A,[0 255]);
B=mat2gray(B,[0 255]);

	

	max2_A = max(max(A));
	max2_B = max(max(B));
	min2_A = min(min(A));
	min2_B = min(min(B));

	if max2_A > 1 | max2_B > 1 | min2_A < 0 | min2_B < 0
   	error('input matrices must have values in the interval [0,1]')
	end

	e = A - B;
	if nargin<3
		fc = csf;	% filter coefficients of CSF
	else
		fc = varargin{1};
	end
	ew = filter2(fc, e);		% filtering error with CSF
	if A == B
   %	error('Images are identical: PSNR has infinite value')
   decibels=9999999;
    else
	decibels = 20*log10(1/(sqrt(mean(mean(ew.^2)))));
    end;
%	disp(sprintf('WPSNR = +%5.2f dB',decibels))
	f=decibels;


