function hand = group_vel(MODES, caption)
% Displays modal curves for the MODES array.
% 
% Each element in MODES contains fields ARG, NEFF, ARGTYPE and PAR that are
% needed for this function.

hand = [];
if isempty(MODES), return; end; 

if nargin == 1
    caption = '';
end

assert(ischar(caption));

% If parameter is wavelength, the modal curves can be coloured according to
% this wavelength.
parIsLambda = strcmpi(partype(MODES), 'wvl');

argmin = Inf;
argmax = -Inf;
neffmin = Inf;
neffmax = -Inf;
c=3e8;

% Vg = vp-lmbda*(dvp/dlmbda)
VG=[];
for i = 1:numel(MODES)
    if parIsLambda
        colour = colourVsLambda(MODES(i).par);
    else
        colour = 'k';
    end;
    hold on;
    for cnt=1:numel(MODES(i).ARG)
    	vp=c/MODES(i).NEFF(cnt);
    	lambda=MODES(i).ARG(cnt);
    	if cnt ~= 1
    		vp_past=c/MODES(i).NEFF(cnt-1);
    		lambda_past=MODES(i).ARG(cnt-1);
    	else
    		vp_past=c;
    		lambda_past=MODES(i).ARG(1);
    	end
    	delta_term=lambda*((vp-vp_past)/(lambda-lambda_past));	
    	VG=[VG vp-delta_term];
    end
    h = plot(MODES(i).ARG, VG, 'Color', colour, 'LineWidth', 1);
    hand = [hand h]; %#ok<AGROW>
    drawnow;
    argmin = min(argmin, min(MODES(i).ARG));
    argmax = max(argmax, max(MODES(i).ARG));
    neffmax = max(neffmax, max(VG));
    neffmin = min(neffmin, min(VG));
end

ylabel('Group Velocity');
if strcmpi(MODES(1).argtype, 'WVL')
    xlabel('Wavelength, nm');
elseif strcmpi(MODES(1).argtype, 'DIA')
    xlabel('Diameter, \mu{}m');
elseif strcmpi(MODES(1).argtype(1:2), 'VP')
    xlabel('V-parameter');
else
    error('Invalid argtype: %s\n', MODES(1).argtype);
end;

title(caption);
    
neffRange = neffmax - neffmin;
axis([argmin argmax neffmin - 0.1 * neffRange neffmax + 0.1 * neffRange]);
grid on;

