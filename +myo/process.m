%% PROCESS pre-process data

function [X,opt] = process(X,opt)

% filter data
n = opt.filterOrder;
if isfinite(opt.filterLowCut) && ~isfinite(opt.filterHighCut)
    Wn = opt.filterLowCut;
    filtType = 'high';
    
elseif isfinite(opt.filterHighCut)
    Wn = opt.filterHighCut;
    filtType = 'low';
    
else
    Wn = [opt.filterLowCut, opt.filterHighCut];
    filtType = 'bandpass';
end
[b,a] = butter(n, Wn/(opt.Fs/2), filtType);
dataClass = class(X);
for iChan = 1:size(X,1)
    xF = filtfilt(b,a,double(X(iChan,:)));
    X(iChan,:) = eval(sprintf('%s(xF);',dataClass));
end