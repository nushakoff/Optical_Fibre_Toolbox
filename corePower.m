function hand = corePower(MODES, d, V,nu,caption)
% Displays modal curves for the MODES array.
% 
% Each element in MODES contains fields ARG, NEFF, ARGTYPE and PAR that are
% needed for this function.

hand = [];
if isempty(MODES), return; end; 


% If parameter is wavelength, the modal curves can be coloured according to
% this wavelength.
parIsLambda = strcmpi(partype(MODES), 'wvl');

argmin = Inf;
argmax = -Inf;
neffmin = Inf;
neffmax = -Inf;
c=3e8;

coreP=[];
color=['g','b','r','v'];

nmax= max(MODES(1).NEFF)+0.1
nmin= min(MODES(1).NEFF)-0.1
for i = 1:numel(MODES)
    hold on;
    for cnt=1:numel(MODES(i).ARG)
        
        if cnt<20
            u=10e9*((2*pi*sqrt((nmax*nmax)-(MODES(i).NEFF(cnt)^2)))/MODES(i).ARG(cnt));
            w=10e9*((-2*pi*sqrt((nmin*nmin)+(MODES(i).NEFF(cnt)^2)))/MODES(i).ARG(cnt)); 
            bessel_term=1-((besselj(nu(i),u*d)^2)/(besselj(nu(i)-1,u*d)*besselj(nu(i)+1,u*d)))
            other_term=1-((u)^2/(w)^2)
        else
            u=10e9*((2*pi*sqrt((nmax*nmax)-(MODES(i).NEFF(cnt)^2)))/MODES(i).ARG(cnt));
            w=10e9*((-2*pi*sqrt((nmin*nmin)+(MODES(i).NEFF(cnt)^2)))/MODES(i).ARG(cnt)); 
            bessel_term=1-((besselj(nu(i),u*d)^2)/(besselj(nu(i)-1,u*d)*besselj(nu(i)+1,u*d)));
            other_term=1-((u)^2/(w)^2);
        end
        coreP=[coreP other_term*bessel_term];
    end
    h = plot(MODES(i).ARG, coreP, 'Color', color(i), 'LineWidth', 1);
    hand = [hand h]; %#ok<AGROW>
    if i==numel(MODES)
        drawnow;
    end
    argmin = min(argmin, min(MODES(i).ARG));
    argmax = max(argmax, max(MODES(i).ARG));
    neffmax = max(argmin, 1);
    neffmin = min(argmin, -1);
    coreP=[];
end

ylabel('Velocity');
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

