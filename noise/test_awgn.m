
function Iatt = test_awgn(Iw, noisePower, seed)

rng(seed); % Seed random generator

Iatt = imnoise(Iw,'gaussian',0,noisePower);

