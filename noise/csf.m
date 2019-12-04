function fc = csf()
%=============
% Program to compute CSF
% Compute contrast sensitivity function of HVS
%
% Output:	fc	---	filter coefficients of CSF
%
% Reference:
%	Makoto Miyahara
%	"Objective Picture Quality Scale (PQS) for Image Coding"
%	IEEE Trans. on Comm., Vol 46, No.9, 1998.
%
% Written by Ruizhen Liu, http://www.assuredigit.com

	% compute frequency response matrix
	Fmat = csfmat;

	% Plot frequency response
	%mesh(Fmat); pause

	% compute 2-D filter coefficient using FSAMP2
	fc = fsamp2(Fmat);   
	%mesh(fc)
