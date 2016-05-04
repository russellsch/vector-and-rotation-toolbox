function v_hat = randunit(m, n)

% randunit
%
% Creates random unit vectors (m-by-n).
%
% Inputs:
%
% m  Dimension of each vector (default is 3)
% n  Number of random unit vectors to create (default is 1)
%
% Outputs:
%
% v  Matrix whose columns are the n random unit vectors (m-by-n)

% Copyright 2016 An Uncommon Lab

%#ok<*EMTAG>
%#eml
%#codegen

    % Defaults
    if nargin < 1, m = 3; end;
    if nargin < 2, n = 1; end;

    v_hat = normalize(randn(m, n));

end % randunit
