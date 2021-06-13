function [greyscale_ndvi, rgb_ndvi] = ndvi(red_img, nir_img, min_ndvi, ndvi_figure, parallel)

	% set function options
	if nargin < 3
		min_ndvi = 0;
	end

    if nargin < 4
        ndvi_figure = true;      
    end
    
    if nargin < 5
        parallel = false;      
    end

	% load image data as matrices
	NIR=imread(nir_img);
	R=imread(red_img);

	% Convert matrices from integers to doubles
	NIR=double(NIR); 
	R=double(R);

	% NDVI index computation per pixel
	NDVI=(NIR-R)./(NIR+R);
    
    % initialize ndvi image matrices (red, green, blue)
	[ndviR,ndviC] = size(NDVI); % NDVI image rows and columns 
	ndvi_green=zeros(ndviR,ndviC);
	ndvi_red=zeros(ndviR,ndviC);
	ndvi_blue=zeros(ndviR,ndviC);
    
    % check if parallel toolbox exists
    if parallel
       matlab_version = ver;
       parallel_exists = any(strcmp(cellstr(char(matlab_version.Name)), 'Parallel Computing Toolbox'));
       if ~parallel_exists
            disp('Parallel Computing Toolbox is not available')
            parallel = false;
       end
    end
    
    if parallel    
        parfor i=1:ndviR
            for j=1:ndviC
                % replace NaN values with -1
                if isnan(NDVI(i,j))
                    NDVI(i,j)=-1;
                end

                % replace with zero ndvi index values bellow 'min_ndvi'
                if NDVI(i,j) <= min_ndvi
                    NDVI(i,j) = 0;
                end

                % create RGB NDVI image
                if NDVI(i,j) < 0.2
                    ndvi_green(i,j)=NDVI(i,j);
                    ndvi_red(i,j)=NDVI(i,j);
                    ndvi_blue(i,j)=NDVI(i,j);
                end
                if NDVI(i,j) >= 0.25 && NDVI(i,j) < 0.4
                    ndvi_green(i,j)=NDVI(i,j);
                end
                if NDVI(i,j) >= 0.4
                    ndvi_red(i,j)=NDVI(i,j);
                end
            end
        end
    else    
        for i=1:ndviR
            for j=1:ndviC
                % replace NaN values with -1
                if isnan(NDVI(i,j))
                    NDVI(i,j)=-1;
                end

                % replace with zero ndvi index values bellow 'min_ndvi'
                if NDVI(i,j) <= min_ndvi
                    NDVI(i,j) = 0;
                end

                % create RGB NDVI image
                if NDVI(i,j) < 0.2
                    ndvi_green(i,j)=NDVI(i,j);
                    ndvi_red(i,j)=NDVI(i,j);
                    ndvi_blue(i,j)=NDVI(i,j);
                end
                if NDVI(i,j) >= 0.25 && NDVI(i,j) < 0.4
                    ndvi_green(i,j)=NDVI(i,j);
                end
                if NDVI(i,j) >= 0.4
                    ndvi_red(i,j)=NDVI(i,j);
                end
            end
        end
    end
    
	% create colored NDVI index image matrix
	rgb_ndvi=cat(3,ndvi_red,ndvi_green,ndvi_blue);
	greyscale_ndvi=NDVI;

	% create figure
    if ndvi_figure
        figure;
        figure_title='NDVI Index';
        position0 = [1 6000];
        position1 = [1 6500];
        position2 = [1 7000];
        position3 = [1 7500];
        value0 = ('Red indicates Heavy Vegetation');
        value1 = ('Green indicates Moderate Vegetation');
        value2 = ('Grey indicates less/No Vegetation');
        value3 = ('Black indicates Water');
        RGB0 = insertText(rgb_ndvi,position0, value0,'FontSize',175,'BoxColor','r','BoxOpacity',1);
        RGB1 = insertText(rgb_ndvi,position1, value1,'FontSize',175,'BoxColor','g','BoxOpacity',1);
        RGB2 = insertText(rgb_ndvi,position2, value2,'FontSize',175,'BoxColor',[122 122 121],'BoxOpacity',1);
        RGB3 = insertText(rgb_ndvi,position3, value3,'FontSize',175,'TextColor','white','BoxColor','black','BoxOpacity',1);
        RGB = RGB0+RGB1+RGB2+RGB3;
        imshow(RGB,'DisplayRange',[0 1]), title(figure_title);
        S = size(RGB);
        
    end

	% NDVI Image histogram
	figure; 
	hist(NDVI(:)), xlabel('NDVI value'), ylabel('number of pixels'), title('NDVI Index Histogram'), grid on;
    
end