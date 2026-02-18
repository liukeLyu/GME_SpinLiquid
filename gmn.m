function [N, witness] = gmn(rho, dimensions, sdp_options)
% Renormalized Genuine Multiparticle Negativity (GMN)
% defined in https://dx.doi.org/10.1088/1751-8113/47/15/155301
%
% Inputs:
%   rho        : Density matrix (must be square and Hermitian).
%   dimensions : (Optional) Vector specifying subsystem dimensions.
%                Default is qubits (2 for all subsystems).
%   solverName : (Optional) Solver for optimization (default: 'mosek').
%
% Outputs:
%   N        : Genuine Multiparticle Negativity (GMN).
%   witness  : Corresponding witness operator (optional).

% Always start by clearing the internals
yalmip('clear');

% ****** Error Handling *****
% Verify that rho is square
opdims = size(rho);
if opdims(1) ~= opdims(2)
    error('The input density matrix must be square.');
end

% Verify that rho is Hermitian
precision = 1e-12;
if max(max(abs(rho' - rho))) > precision
    error('The input density matrix must be Hermitian.');
end

% Set default dimensions to qubits if not specified
if nargin < 2 || isempty(dimensions)
    dimensions = 2 * ones(1, log2(opdims(1)));
end

% Verify that dimensions are valid
if any(dimensions < 2)
    error('Subsystem dimensions must be greater than 1.');
end

if prod(dimensions) ~= opdims(1)
    error('Dimensions do not match the size of the density matrix.');
end

% ****** Optimization Setup *****
% Number of subsystems
n = length(dimensions);
D = opdims(1);
N = log2(D); % number of spins, used to estimate the sdp_cost. even if it's not a qubit system it's  still OK
m_part = 2^(n-1) - 1; % number of partitions

% Set default solver
if nargin < 3 || isempty(sdp_options)
    sdp_options = sdpsettings('verbose', 1, 'solver', 'mosek');
end

% Define the witness operator W
W = sdpvar(D, D, 'hermitian', 'complex');

% Initialize constraints
constraints = [];

% Define SDP variables for decomposability constraints
% P is a 3D array: opdims(1) x opdims(2) x (2^(n-1) - 1)
P = sdpvar(D, D, m_part, 'hermitian', 'complex');

% Loop through all inequivalent bipartitions
for m = 1:m_part
    % Convert m to binary vector (integer valued)
    Mvec = bitget(m,1:n);

    % Add positivity constraint for P_M
    constraints = [constraints, P(:, :, m) >= 0];

    % Add decomposability constraint: Q_M = (W - P_M)^(T_M)
    Q = ptrans(W - P(:, :, m), Mvec, dimensions);
    constraints = [constraints, Q >= 0];

    % Add normalization constraints: Q_M <= I
    % in the newly renormalized
    % constraints = [constraints, eye(opdims(1)) - P(:, :, m) >= 0];
    constraints = [constraints, eye(opdims(1)) - Q >= 0];
end

% Objective: Minimize the expectation value of W w.r.t. rho
objective = real(trace(rho * W));

% Solve the SDP
result = optimize(constraints, objective, sdp_options);

% Check for solver errors
if result.problem ~= 0
    disp(result.info);
end

% Compute GMN
N = -value(objective);
N = real(N); % Ensure numerical stability

% Output the witness if requested
if nargout == 2
    if N > precision
        witness = value(W); % Return the witness
    else
        witness = zeros(opdims(1), opdims(2)); % Return a zero matrix
    end
end
end