function [IntDICdata_Struct] = DICInterpolate(RawDICdata_Struct)
% Interpolates DIC raw data
%     Input:  Raw DIC data struct from DICparser.
%     Output: New struct containing the interpolated matrices
%
% Created by Renato Vieira

D = RawDICdata_Struct;
Step = D.Step;

%Obtaining dimensions of raw data
Width  = abs(D.Xu(end) - D.Xu(1));
Height = abs(D.Yu(end) - D.Yu(1));

%Declaring raw data grid (step pixels) and interpolated grid (1 pixel)
[Xg,Yg] = ndgrid(0:Step:Height, 0:Step:Width);
[Xn,Yn] = ndgrid(0:1:Height-1, 0:1:Width-1);

%Initializing ouput struct
IntDICdata_Struct = D;

%Interpolating each displacemnt component
fn = fieldnames(D.Disp);
for k=1:numel(fn)
    if( isnumeric(D.Disp.(fn{k})) )
        IntDICdata_Struct.IntDisp.(fn{k}) = interpn(Xg, Yg, D.Disp.(fn{k}), Xn, Yn, 'spline');
    end
end

%Interpolating each strain component
fn = fieldnames(D.Strains);
for k=1:numel(fn)
    IntDICdata_Struct.IntStrains.(fn{k}) = interpn(Xg, Yg, D.Strains.(fn{k}), Xn, Yn, 'spline');
end

%Interpolating Core-Mantle for rotated strains
fn = fieldnames(D);
if max(strcmp(fn,'CM')) == 1
    IntDICdata_Struct.CM = interpn(Xg, Yg, D.CM, Xn, Yn, 'nearest');
end

end

