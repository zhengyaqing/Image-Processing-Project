function hog_image = computeHOG(input_img)
    % Convert to grayscale if needed
    if size(input_img, 3) > 1
        input_img = rgb2gray(input_img);
    end
    input_img = im2double(input_img);
    
    % Parameters
    cell_size = 24;  % Increased cell size
    num_bins = 9;
    min_magnitude = 0.1; % Minimum gradient magnitude threshold
    
    % Compute gradients using larger Sobel kernels for smoother gradients
    dx = [-1 0 1; -2 0 2; -1 0 1];
    dy = dx';
    Gx = imfilter(input_img, dx, 'replicate');
    Gy = imfilter(input_img, dy, 'replicate');
    
    % Compute gradient magnitude and orientation
    magnitude = sqrt(Gx.^2 + Gy.^2);
    orientation = atan2d(Gy, Gx);
    orientation = mod(orientation, 180);
    
    % Smooth the magnitude using Gaussian filter
    magnitude = imgaussfilt(magnitude, 1.5);
    
    % Image dimensions
    [rows, cols] = size(input_img);
    
    % Create output visualization image (white background)
    hog_image = ones(rows, cols, 'double');
    
    % Calculate number of cells
    num_cells_y = floor(rows / cell_size);
    num_cells_x = floor(cols / cell_size);
    
    % Prepare histogram bins
    bin_edges = linspace(0, 180, num_bins + 1);
    bin_centers = (bin_edges(1:end-1) + bin_edges(2:end)) / 2;
    
    % Process cells
    for i = 1:num_cells_y
        for j = 1:num_cells_x
            % Get cell range
            row_start = (i-1)*cell_size + 1;
            row_end = min(i*cell_size, rows);
            col_start = (j-1)*cell_size + 1;
            col_end = min(j*cell_size, cols);
            
            % Extract cell data
            cell_mag = magnitude(row_start:row_end, col_start:col_end);
            cell_ori = orientation(row_start:row_end, col_start:col_end);
            
            % Skip cells with low gradient magnitude
            if mean(cell_mag(:)) < min_magnitude
                continue;
            end
            
            % Compute weighted histogram
            hist = zeros(1, num_bins);
            for b = 1:num_bins
                mask = (cell_ori >= bin_edges(b)) & (cell_ori < bin_edges(b+1));
                hist(b) = sum(cell_mag(mask));
            end
            
            % Normalize histogram
            hist = hist / (norm(hist) + 1e-6);
            
            % Cell center
            center_y = (row_start + row_end) / 2;
            center_x = (col_start + col_end) / 2;
            
            % Draw oriented lines for dominant orientations
            max_line_length = cell_size * 0.4;  % Reduced line length
            
            % Sort histogram bins by magnitude and keep only top 2
            [sorted_hist, sorted_idx] = sort(hist, 'descend');
            for b = 1:min(2, sum(sorted_hist > 0.2))  % Only draw top 2 strongest orientations
                angle = bin_centers(sorted_idx(b));
                line_length = sorted_hist(b) * max_line_length;
                
                % Calculate line endpoints
                dx = cosd(angle) * line_length;
                dy = sind(angle) * line_length;
                
                % Draw line with varying thickness based on magnitude
                thickness = max(1, round(sorted_hist(b) * 3));
                hog_image = drawThickLine(hog_image, ...
                    [center_x-dx, center_y-dy, center_x+dx, center_y+dy], ...
                    thickness);
            end
        end
    end
    
    % Invert colors and enhance contrast
    hog_image = 1 - hog_image;
    hog_image = imadjust(hog_image);
end

function img = drawThickLine(img, line, thickness)
    x1 = round(line(1)); y1 = round(line(2));
    x2 = round(line(3)); y2 = round(line(4));
    
    % Draw line with anti-aliasing
    dx = x2 - x1;
    dy = y2 - y1;
    N = max(abs(dx), abs(dy)) * 2;
    t = linspace(0, 1, N);
    x = x1 + t * dx;
    y = y1 + t * dy;
    
    % Add thickness
    for i = -thickness:thickness
        for j = -thickness:thickness
            if i^2 + j^2 <= thickness^2
                xp = round(x) + i;
                yp = round(y) + j;
                
                % Boundary check
                valid = xp >= 1 & xp <= size(img,2) & yp >= 1 & yp <= size(img,1);
                if any(valid)
                    ind = sub2ind(size(img), yp(valid), xp(valid));
                    img(ind) = 0;
                end
            end
        end
    end
end