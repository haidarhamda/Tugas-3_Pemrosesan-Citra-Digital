function [result, result_edge] = objectsegmentation(input, method)
    input = double(input) / 255;

    switch method
        case 'laplace'
            result_edge = laplace(input);
        case 'log'
            result_edge = laplacian_of_gaussian(input);
        case 'sobel'
            result_edge = sobel(input);
        case 'prewitt'
            result_edge = prewitt(input);
        case 'roberts'
            result_edge = roberts(input);
        case 'canny'
            result_edge = canny(input);
    end

    threshold = graythresh(result_edge);
    result_edge = double(result_edge > threshold);

    se = strel('disk', 4);
    closed_segment = imclose(result_edge, se);
    filled_segment = imfill(closed_segment, 'holes');
    open_segment = imopen(filled_segment, se);
    
    edge = bwareaopen(open_segment, 500);

    if size(input, 3) > 1
        red = input(:, :, 1) .* edge;
        green = input(:, :, 2) .* edge;
        blue = input(:, :, 3) .* edge;
    else
        red = input .* edge;
        green = red;
        blue = red; 
    end

    result = cat(3, red, green, blue);
end

function edge=laplace(input)
    kernel = [
         0  -1   0;
        -1   4  -1;
         0  -1   0;
    ];

    edge = conv2(im2gray(input), kernel, 'same');
end

function edge=laplacian_of_gaussian(input)
    kernel = fspecial('log');
    edge = conv2(im2gray(input), kernel, 'same');
end

function edge=sobel(input)
    Gx = [
        -1 0 1;
        -2 0 2;
        -1 0 1;
    ];

    Gy = [
        -1 -2 -1;
         0  0  0;
         1  2  1;
    ];

    gray = im2gray(input);
    img_x = conv2(gray, Gx, 'same');
    img_y = conv2(gray, Gy, 'same');
    edge = sqrt(img_x .^ 2 + img_y .^ 2);
end

function edge=prewitt(input)
    Gx = [
        -1 0 1;
        -1 0 1;
        -1 0 1;
    ];

    Gy = [
        -1 -1 -1;
         0  0  0;
         1  1  1;
    ];

    gray = im2gray(input);
    img_x = conv2(gray, Gx, 'same');
    img_y = conv2(gray, Gy, 'same');
    edge = sqrt(img_x .^ 2 + img_y .^ 2);
end

function edge=roberts(input)
    Gx = [
         1  0;
         0 -1;
    ];

    Gy = [
         0  1;
        -1  0;
    ];

    gray = im2gray(input);
    img_x = conv2(gray, Gx, 'same');
    img_y = conv2(gray, Gy, 'same');
    edge = sqrt(img_x .^ 2 + img_y .^ 2);
end

function e=canny(input)
    e = double(edge(im2gray(input), 'canny'));
end