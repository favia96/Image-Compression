%========================
function Sa = csffun(u,v)
%========================
% Contrast Sensitivity Function in spatial frequency
% This file compute the spatial frequency weighting of errors
%
% Reference:
%	Makoto Miyahara
%	"Objective Picture Quality Scale (PQS) for Image Coding"
%	IEEE Trans. on Comm., Vol 46, No.9, 1998.
%
% Input :  	u --- horizontal spatial frequencies
%		v --- vertical spatial frequencies
%		
% Output:	frequency response
%
% Written by Ruizhen Liu, http://www.assuredigit.com

	% Compute Sa -- spatial frequency response
	%syms S w sigma f u v
	sigma = 2;
	f = sqrt(u.*u+v.*v);
	w = 2*pi*f/60;
	Sw = 1.5*exp(-sigma^2*w^2/2)-exp(-2*sigma^2*w^2/2);

	% Modification in High frequency
	sita = atan(v./(u+eps));
	bita = 8;
	f0 = 11.13;
	w0 = 2*pi*f0/60;
	Ow = ( 1 + exp(bita*(w-w0)) * (cos(2*sita))^4) / (1+exp(bita*(w-w0)));

	% Compute final response
	Sa = Sw * Ow;

