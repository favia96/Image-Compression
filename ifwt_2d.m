function recon_img = ifwt_2d(ll,lh,hl,hh,scaling_vector)
%IFWT_2D Summary of this function goes here
%   Detailed explanation goes here
    
    for j = 1 : size(ll,2)
         l(:,j) = fwt_synthesis(ll(:,j),lh(:,j),scaling_vector);

         h(:,j) = fwt_synthesis(hl(:,j),hh(:,j),scaling_vector);
    end
    
    for i = 1 : size(l,1)
        recon_img(i,:) = fwt_synthesis(l(i,:),h(i,:),scaling_vector);
    end
    
end

