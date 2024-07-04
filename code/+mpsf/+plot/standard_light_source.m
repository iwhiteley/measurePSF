function standard_light_source(dirToSearch)
    % Make plots of data from the standard light source
    %
    % mpsf.plot.standard_light_source(dirToSearch)
    %
    % Purpose
    % Showing PMT response as a function of gain using the standard light source
    %
    % Inputs
    % dirToSearch - Directory in which to search for standard light source data.
    %              Searches the current directory if is empty or missing.


    if nargin<1 || isempty(dirToSearch)
        dirToSearch = pwd;
    end

    files = dir(fullfile(dirToSearch,'*_standard_light_source_*.tif'));

    if isempty(files)
        fprintf('Found no standard light source data to plot\n')
        return
    end


    PMT_gain = zeros(1,length(files));
    mean_value = zeros(length(files),4);
    for jj = 1:length(files)
        fname = fullfile(dirToSearch,files(jj).name);
        [imstack,metadata] = mpsf.tools.scanImage_stackLoad(fname,false);

        % Fail gracefully if the file could not be loaded
        if isempty(imstack)
            continue
        end

        % Log gain and mean pixel values
        PMT_gain(jj) = metadata.gains(1);
        mean_value(jj,:) = squeeze(mean(imstack,[1,2]));
    end

    % Quit if nothing was loaded
    if all(mean_value==0)
        return
    end

    % Plot!
    % Make a new figure or return a plot handle as appropriate
    fig = mpsf.tools.returnFigureHandleForFile([dirToSearch,mfilename]);
    offset_subtracted = mean_value-mean_value(1,:);
    plot(offset_subtracted(:,1:4),'o-');
    legend(metadata.channelName,'Location','NorthWest')
    set(gca,'XTickLabels',PMT_gain)
    xlabel('Gain')
    ylabel('Signal (AU relative to zero gain)')
    grid on


