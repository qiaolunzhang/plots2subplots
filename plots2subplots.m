function hFig = plots2subplots(haxes, varargin)
%PLOTS2SUBPLOTS Copy multiple figures to a single subplot-formatted figure.
%   PLOTS2SUBPLOTS() creates a single subplot-formatted figure from copies
%   of all open figures.
%
%   PLOTS2SUBPLOTS('all') has the same effect as PLOTS2SUBPLOTS().
%
%   PLOTS2SUBPLOTS(haxes) creates a single subplot-formatted figure from
%   the axes handles specified in haxes.
%
%   PLOTS2SUBPLOTS(...,'Colormap',MAP) sets the subplots' colormaps to MAP.
%   Type HELP GRAPH3D to see a number of useful colormaps.
%
%   hFig = PLOTS2SUBPLOTS(...) retrieves the subplot figure handle.
%
%   The order of subplots is made as square as possible (width >= height).
%
%   See also PRETTYPLOTS, COLORMAP.
%   https://github.com/keelanc/

%   Author: Keelan Chu For
%   2014-12-09
%   https://github.com/keelanc/plots2subplots


if nargin == 0 || strcmp(haxes,'all') % find all open figures
    haxes = findobj('type','axes');
    haxes = haxes(end:-1:1);                      % plot oldest first
end

% make as square as possible, longest dimension along horizontal
ll = length(haxes);
if ll < 2
    error('plots2subplots requires at least two figures')
end
yy = floor(sqrt(ll));
xx = ceil(ll/yy);
hFig = figure;                                  % new figure
for ii=1:ll
    dummy = subplot(yy,xx,ii,'Parent',hFig);    % temporary subplot
    newPos = get(dummy,'Position');             % get its position
    delete(dummy);
    haxesnew = copyobj(haxes(ii),hFig);         % copy a figure to hFigure
    set(haxesnew,'Position',newPos);            % and adjust position
    set(get(haxesnew,'parent'), 'Colormap',...  % and maintain original
        get(get(haxes(ii),'parent'), 'Colormap')); % colormap
    
    if nargin > 1
        if any(strcmp(varargin, 'Colormap'))
            ind = find(strcmp(varargin, 'Colormap'));
            try
                set(get(haxesnew,'parent'), 'Colormap',...
                colormap(varargin{ind+1}));
            catch
                error('Invalid colormap');
            end
        end
    end
end
