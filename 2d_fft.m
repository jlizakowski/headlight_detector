function arr=img_to_arr (image)
	arr=(image(:, :, 1)+image(:, :, 2)+image(:, :, 3))/3.0 ;
endfunction

function ret=autoscale_arr2(arr2)
	arr2 = double(arr2);
	mn = min(min(arr2)) ;
	mx = max(max(arr2)) ;
	rg = mx - mn ;
	ret = (arr2 - mn) / rg * 64.0   ;  #jet colormap has 64 entries
endfunction

function ret=flip_png(image)
	#ret = fliplr(flipud(image));
	ret = flipud(image);
endfunction

truck= 	flip_png( img_to_arr( imread ("headlights2.png" )));
target=	flip_png( img_to_arr( imread ("headlights_bothsizes.png" )));

M1=truck;
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
colormap jet
figure(1);
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
	image((truck));
	title("truck");
subplot(3,5,7)
	image(autoscale_arr2(log(abs(fftshift(fft2(truck))))));
	title("truck FFT (log)");
subplot(3,5,8)
	image(autoscale_arr2(arg(fftshift(fft2(truck)))));
	title("truck FFT phase");
	
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
	image( autoscale_arr2(autoscale_arr2(result)   .* autoscale_arr2(abs(truck)) ) );
	title("Correlation (magnitude) * truck");
subplot(3,5,14)
	image( autoscale_arr2(autoscale_arr2(abs(unconvolved))   .* autoscale_arr2(abs(truck)) ) );
	title("Unconvolved * truck");

figure(2);
	colormap gray
		filter = abs(fftshift(fft2(target)));
		image(autoscale_arr2(autoscale_arr2(filter) + autoscale_arr2(log(filter)) / 3.0) );
		title("target FFT mag (log)");
	
