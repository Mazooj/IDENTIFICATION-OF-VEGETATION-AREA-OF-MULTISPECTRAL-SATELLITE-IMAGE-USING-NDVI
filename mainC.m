clear all
% defininig near infrared image
nir_img = 'C:\Users\mazoo\Downloads\LC08_L2SP_142049_20210320_20210328_02_T1\LC08_L2SP_142049_20210320_20210328_02_T1_SR_B5.TIF';

% defining red image
r_img = 'C:\Users\mazoo\Downloads\LC08_L2SP_142049_20210320_20210328_02_T1\LC08_L2SP_142049_20210320_20210328_02_T1_SR_B4.TIF';

% calling ndvi function (red image, near infrared image, index min value, plot figures, parallel processing)
ndvi(r_img, nir_img, 0, true, false);