function [H,theta,rho]=hought(bw)
    [m,n,c]=size(bw);
    D = sqrt((m-1)^2 + (n-1)^2);
    theta=-90:1:89;
    rhoResolution=1;
    diagonal=rhoResolution*ceil(D/rhoResolution);
    rho=-diagonal:rhoResolution:diagonal;
    nrho=length(rho);
    ntheta=length(theta);
    H=zeros(nrho,ntheta);
    for k=1:m
        for l=1:n
            if (bw(k,l)==1)
                for i=1:ntheta
                    r=l*cos(deg2rad(theta(i)))+k*sin(deg2rad(theta(i)));
                    j=round(r)+diagonal+1;
                    H(j,i)=H(j,i)+1;
                end
            end
        end
    end
end

img=imread("img\road2.png");
i=im2gray(img);
bw=imbinarize(i,0.5);

[h,theta,rho]=hought(bw);

% [h,theta,rho]=hough(bw);
% disp(h);
% imshow(h);
% %imshow(imadjust(mat2gray(h)),[], ...
% %    'XData',theta,'YData',rho, ...
% %    'InitialMagnification','fit');
hpeaks=houghpeaks(h,5,'threshold',ceil(0.3*max(h(:))));
x=theta(hpeaks(:,2));
y=rho(hpeaks(:,2));
hlines=houghlines(bw,theta,rho,hpeaks,'FillGap',5,'MinLength',7);

figure, imshow(img), hold on
max_len=0;
for k=1:length(hlines)
    xy=[hlines(k).point1;hlines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

    len = norm(hlines(k).point1 - hlines(k).point2);
    if ( len > max_len) 
        max_len = len; 
        xy_long = xy; 
    end
end
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');