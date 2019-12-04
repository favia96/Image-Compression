function [approx_coeff, detail_coeff] = fwt_analysis(signal,scaling_vector)
%FWT_ANALYSIS Summary of this function goes here
%   Detailed explanation goes here
    lp_rec = scaling_vector ./ norm(scaling_vector);
    lp_dec = wrev(lp_rec);
    hp_rec = qmf(lp_rec);
    hp_dec = wrev(hp_rec);
    
    signal_ext = wextend('1D','per',signal,length(scaling_vector)); % periodic extension
    
    F = conv(signal_ext,lp_dec,'same');
    F = F(length(scaling_vector)+1 : end-length(scaling_vector)); % truncate keeping central part
    approx_coeff = downsample(F,2);   
    
    G = conv(signal_ext, hp_dec,'same');
    G = G(length(scaling_vector)+1 : end-length(scaling_vector)); % truncate keeping central part
    detail_coeff = downsample(G,2);

end

