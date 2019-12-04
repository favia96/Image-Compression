function Iatt = test_sharpening(Iw, nRad, nPower)

    Iatt = imsharpen(Iw, 'Radius', nRad, 'Amount', nPower);



