function arr=img_to_arr (image)
	arr=(image(:, :, 1)+image(:, :, 2)+image(:, :, 3))/3.0 ;
endfunction

function ret=autoscale_arr2(arr2)
	arr2 = double(arr2);
	mn = min(min(arr2)) ;
	mx = max(max(arr2)) ;
	rg = mx - mn ;
	ret = (arr2 - mn) / rg * 256.0   ;  #jet colormap has 64 entries, unless jet(256)
endfunction

function ret=flip_png(image)
	#ret = fliplr(flipud(image));
	ret = flipud(image);
endfunction

vehicle= 	flip_png( img_to_arr( imread ("truck.png" )));
#vehicle= 	flip_png( img_to_arr( imread ("many_headlights.png" )));
#vehicle = 	flip_png(img_to_arr( imread ("Le_Mans_2007_-_Night_250x250.jpg")));

#target=	flip_png( img_to_arr( imread ("headlights3bigger.png" )));
#target=	flip_png( img_to_arr( imread ("headlights_bothsizes.png" )));
#target=	flip_png( img_to_arr( imread ("headlights_three.png" )));
target=		flip_png( img_to_arr( imread ("headlights_target.png")));

M1=vehicle;
M2=target;

# Alternate approach
# http://www.mathworks.com/matlabcentral/newsreader/view_thread/11947
# Performing the 2D cross-correlation of f(x,y) with g(x,y) is the same as
# performing the 2D convolution of f(x,y) with g(-x,-y). So, in Matlab,
# the 2D cross correlation of matrices M1 and M2 can be done in the
# frequency domain like this:
# 
# convolved = ifft2(fft2(M1).*fft2(fliplr(flipud(M2))));

convolved = ifft2(fft2(M1).* conj(fft2(M2)));
result =fftshift(abs(convolved));
result2 =fftshift(arg(convolved));

stronger = result .* result;
unconvolved = fftshift(ifft2(fft2(stronger) .* conj(fft2(target))));

# clf
hold off
figure(1);
colormap(jet(256));
subplot(3,5,1)
	image(autoscale_arr2(target));
	title("target");
subplot(3,5,2)
	image(autoscale_arr2(log(abs(fftshift(fft2(target))))));
	title("target FFT mag (log)");
subplot(3,5,3)
	image(autoscale_arr2(arg(fftshift(fft2(target)))));
	title("target FFT phase");

subplot(3,5,6)
	image(autoscale_arr2(vehicle));
	title("vehicle");
subplot(3,5,7)
	image(autoscale_arr2(log(abs(fftshift(fft2(vehicle))))));
	title("vehicle FFT (log)");
subplot(3,5,8)
	image(autoscale_arr2(arg(fftshift(fft2(vehicle)))));
	title("vehicle FFT phase");
	
subplot(3,5,9)
	image(autoscale_arr2(abs(unconvolved)));
	title("Unconvolved mag^2");
	

subplot(3,5,11)
	image(autoscale_arr2(result));
	title("Correlation (magnitude)");
subplot(3,5,12)
	image(autoscale_arr2(result2));
	title("Correlation (phase)");
	
subplot(3,5,13)
	image( autoscale_arr2(autoscale_arr2(result)   .* autoscale_arr2(abs(vehicle)) ) );
	title("Correlation (magnitude) * vehicle");
subplot(3,5,14)
	image( autoscale_arr2(autoscale_arr2(abs(unconvolved))   .* autoscale_arr2(abs(vehicle)) ) );
	title("Unconvolved * vehicle");

#this takes a while to run, so commented out

# figure(2);
# 		colormap(gray(256));
# 		filt = abs(fftshift(fft2(target, 16.0 *size(target)(1), 16.0 * size(target)(2) )));
# 		noise = (rand(size(filt)) - 0.5)*2;   #to dither the 256 level image. 16bit images not available in all installations of octave
# 		image((noise + autoscale_arr2(filt * -1))/(256.0 +1 +1) * 256.0);
# 		title("target FFT mag (log)");
# 
# 		
# #imwrite(((noise + autoscale_arr2(filt * -1))/(256.0 +1 +1)), "foo2.png", 'Quality',100);


	
	
	
	