function recon_signal = fwt_synthesis(approx_coeff,detail_coeff,scaling_vector)
%FWT_SYNTHESIS Summary of this function goes here
%   Detailed explanation goes here
    lp_rec = scaling_vector ./ norm(scaling_vector);
    hp_rec = qmf(lp_rec);

    F = upsample(approx_coeff,2);
    F_ext = wextend('1D','per',F,length(scaling_vector)); % periodic extension
    f = conv(F_ext,lp_rec,'same');
    %f = f(1+2*length(F) : 3*length(F)); % truncate keeping central part
    f = f(length(scaling_vector)+1 : end-length(scaling_vector));
    
    G = upsample(detail_coeff,2);
    G_ext = wextend('1D','per',G,length(scaling_vector)); % periodic extension
    g = conv(G_ext, hp_rec,'same');
    %g = g(1+2*length(G) : 3*length(G)); % truncate keeping central part
    g = g(length(scaling_vector)+1 : end-length(scaling_vector));

    recon_signal = circshift(f + g,1); % summing and circshift 
%     recon_signal = f + g;
    
end

