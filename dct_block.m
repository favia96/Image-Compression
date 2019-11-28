function [Y,A,A_quan]=dct_block(block)
    A=zeros(size(block));
    M=size(A,1);
    for i=1:M
        if i==1
            ai=sqrt(1/M);
        else
            ai=sqrt(2/M);
        end
        for k=1:M
            A(i,k)=ai*cos((2*k-1)*(i-1)*pi/2/M);
        end
    end
    quant=linspace(-0.5,0.5,8+1);
    A_quan=mid_tread_quan(A,quant);
    Y=A_quan*block*(A_quan');
end