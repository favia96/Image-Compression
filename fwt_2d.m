function [ll,lh,hl,hh] = fwt_2d(img,scaling_vector)
%FWT_2D Summary of this function goes here
%   Detailed explanation goes here

    for i = 1 : size(img,1)
        [l(i,:),h(i,:)] = fwt_analysis(img(i,:),scaling_vector);
    end
    
    for j = 1 : size(l,2)
         [ll(:,j),lh(:,j)] = fwt_analysis(l(:,j),scaling_vector);

         [hl(:,j),hh(:,j)] = fwt_analysis(h(:,j),scaling_vector);

     end

end

