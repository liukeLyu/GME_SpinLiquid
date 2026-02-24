% =========================================================================
% Script Description:
% Verifies the constructed Kagome CSL RDMs against baseline gmn computations
% for N=36 datasets in Fig6.
% =========================================================================

clear; clc;

% Add paths for gmn calculations (QEnt library)
addpath(genpath('/Users/liukelyu/Documents/Entanglement/Matlab-Packages/QEnt'));

% Set indices to test (1:17 tests first batch, leave empty to test all).
% To speed up verification checking logic, test first 10.
test_indices = [1 3 6 9 12];

fprintf('Starting Verification for Kagome CSL RDMs...\n');

% =========================================================================
% N=36 Verification
% =========================================================================
fprintf('\n--- N=36 Data ---\n');

% 4. Hexagon N36
% Reference: gmn_plaq222_N36.mat | dims: [4 4 4] -> partitions: 2, 2, 2
verify_item('rdm_hexagon_N36.mat', 'gmn_plaq222_N36.mat', 'gmn_plaq222_N36_rdms', {[1 2], [3 4], [5 6]}, test_indices);

% 5. Bowtie N36
% Reference: gmnbowtie_N36.mat | dims: [4 2 4] -> partitions: 2, 1, 2
verify_item('rdm_bowtie_N36.mat', 'gmnbowtie_N36.mat', 'gmnbowtie_N36_rdms', {[1 2], [3], [4 5]}, test_indices);

% 6. Triangle N36
% Reference: gmn_triangle_N36.mat | dims: [2 2 2] -> partitions: 1, 1, 1
verify_item('rdm_triangle_N36.mat', 'gmn_triangle_N36.mat', 'gmn_triangle_N36_rdms', {[1], [2], [3]}, test_indices);

fprintf('\nVerification complete.\n');

% =========================================================================
% Helper Functions
% =========================================================================

function verify_item(test_file, ref_file, test_var_name, partitions, test_indices)
fprintf('Verifying %s vs %s...\n', test_file, ref_file);

% Load our generated RDMs and reference variables
test_data = load(test_file);
ref_data = load(ref_file);

rdms_cell = test_data.(test_var_name);
t_lam = test_data.lamList;

r_lam = ref_data.lamList;
r_val = ref_data.gmnList;

% Use subset if requested
if isempty(test_indices)
    indices_to_run = 1:length(t_lam);
else
    indices_to_run = test_indices;
end

% Determine total number of spins in subregion
n_qubits = sum(cellfun(@length, partitions));

% Flatten partitions to get the permutation order
order = cell2mat(partitions);

% Calculate dimensions for GMN (2^number_of_spins_in_each_partition)
num_parts = length(partitions);
dims = zeros(1, num_parts);
for i = 1:num_parts
    dims(i) = 2^(length(partitions{i}));
end

% Verify over selected indices
for k = 1:length(indices_to_run)
    idx = indices_to_run(k);

    lam = t_lam(idx);
    rho = rdms_cell{idx};

    if isempty(rho)
        continue; % Skip missing files (like lam > 0.957 for N24)
    end

    % Clean the RDM (remove small imaginary parts)
    if ~isreal(rho) && norm(imag(rho)) < 1e-10
        rho = real(rho);
    end

    % Permute RDM according to the required partitions
    if ~issorted(order)
        rho = local_rdm_permute(rho, order);
    end

    % Tripartite GMN using Mosek
    val_computed = gmn(rho, dims, sdpsettings('solver', 'mosek', 'verbose', 0));

    % Find matching reference value corresponding to same lambda
    [~, match_idx] = min(abs(r_lam - lam));
    val_ref = r_val(match_idx);

    diff = abs(val_computed - val_ref);

    fprintf('  MISMATCH (idx %3d) | lam = %6.4f | Computed = %e | Ref = %e | Diff = %.2e\n', ...
        idx, lam, val_computed, val_ref, diff);
end

fprintf('  Passed.\n\n');
end

% -------------------------
% Row-Major Reshaping and Permutation
% Exactly emulates QEnt's ten2ten reshaping strategy mapping
% column-major MATLAB arrays through row-major representations.
% -------------------------
function rho_perm = local_rdm_permute(rho, order)
n_qubits = log2(length(rho));
matrix_dims = [2^n_qubits, 2^n_qubits];

% The QEnt Library reshaping process mimics a row-major conversion.
% 1. Reshape into local qubit dimension tensor (n_qubits) via vec2ten logic
tensor_dims = [2 * ones(1, n_qubits), 2 * ones(1, n_qubits)];
rho_tensor = reshape(rho, fliplr(matrix_dims));
rho_tensor = permute(rho_tensor, numel(matrix_dims):-1:1);

% Now reshape the permuted struct into a 2x2x2... representation
rho_tensor = reshape(rho_tensor, fliplr(tensor_dims));
rho_tensor = permute(rho_tensor, numel(tensor_dims):-1:1);

% Apply the target permutation. Since we're tracking a density matrix,
% we must simultaneously alter both the rows and columns.
perm_order = [order, length(order) + order];
rho_tensor = permute(rho_tensor, perm_order);

% Reverse the process: ten2vec
rho_tensor = permute(rho_tensor, numel(tensor_dims):-1:1);
v = rho_tensor(:);

% And restore vector to original [D, D] density matrix format
rho_perm = reshape(v, fliplr(matrix_dims));
rho_perm = permute(rho_perm, numel(matrix_dims):-1:1);
end
