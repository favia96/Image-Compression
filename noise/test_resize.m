function Iatt = test_resize(Iw, nPower)

n = size(Iw);
Iw = double(Iw);
Iatt = imresize(Iw, nPower);
Iatt = imresize(Iatt, 1/nPower);
Iatt = uint8(Iatt(1:n(1), 1:n(2)));




