function Fmat = csfmat()
%===================
% Compute CSF frequency response matrix
% Employ function csf.m
% frequency range
% the rang of frequency seems to be:
% 		w = pi = (2*pi*f)/60
%		f = 60*w / (2*pi),	about 21.2
%
	min_f = -20;
	max_f = 20;
	step_f = 1;
	u = min_f:step_f:max_f; 
	v = min_f:step_f:max_f;
	n = length(u);
	Z = zeros(n);
	for i=1:n
		for j=1:n
			Z(i,j)=csffun(u(i),v(j));	% calling function csffun
		end
	end
	Fmat = Z;

