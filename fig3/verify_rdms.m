% verify_rdms.m
% This script verifies the RDMs in the fig3 folder by computing GMN values
% (or Negativity) and comparing them with the reference "n*_results.mat" data.

clear; clc;

% Selection of test indices for fast verification (29 points total)
test_indices = [3 10 17 25];

% -------------------------
% 1. Hexagonal RDM (Tripartite GMN)
% -------------------------
verify_item('rdm_hexagonal.mat', 'n3_plaq_results.mat', 'dat_n3_plaq', {[1 2], [3 4], [5 6]}, 'GMN', test_indices);

% -------------------------
% 2. Fork RDM (Tripartite GMN)
% -------------------------
verify_item('rdm_fork.mat', 'n3_fork_results.mat', 'dat_n3_fork', {[1 2], [3 4], [5 6]}, 'GMN', test_indices);

% -------------------------
% 3. Adj3 RDM (Tripartite GMN)
% -------------------------
verify_item('rdm_adj3.mat', 'n3_adj_results.mat', 'dat_n3_adj', {[1], [2], [3]}, 'GMN', test_indices);

% -------------------------
% 4. Adj2 RDM (Negativity)
% -------------------------
verify_item('rdm_adj2.mat', 'n2_results.mat', 'dat_n2', {[1], [2]}, 'Negativity', test_indices);

fprintf('\nVerification complete.\n');

%% Helper Function
function verify_item(rdmFile, resFile, fieldName, partitions, type, indices)
fprintf('\nVerifying %s vs %s (%s)...\n', rdmFile, resFile, type);

% Load RDM data
rdm_data = load(rdmFile);
hList = rdm_data.hList;
rdmList = rdm_data.rdmList;

% Load reference results
res_data = load(resFile);
ref_table = res_data.(fieldName); % nx2 matrix [h, value]

% Determine order of permutation and corresponding dimensions
order = cell2mat(partitions);
dims = zeros(1, length(partitions));
for i = 1:length(partitions)
    dims(i) = 2^length(partitions{i});
end

for idx = indices
    if idx > length(hList)
        continue;
    end
    h = hList(idx);
    rho = rdmList{idx};

    if isempty(rho)
        continue;
    end

    % Clean the RDM (remove small imaginary parts)
    if ~isreal(rho) && norm(imag(rho)) < 1e-10
        rho = real(rho);
    end

    % Permute RDM according to the required partitions
    if ~issorted(order)
        rho = local_rdm_permute(rho, order);
    end

    % Find matching reference value by h
    [val_h, ref_idx] = min(abs(ref_table(:,1) - h));
    if val_h > 1e-4
        fprintf('  idx %2d | h = %.4f | No matching reference field found (min diff = %.2e)\n', ...
            idx, h, val_h);
        continue;
    end
    ref_val = ref_table(ref_idx, 2);

    if strcmp(type, 'GMN')
        % Tripartite GMN using Mosek
        val = gmn(rho, dims, sdpsettings('solver', 'mosek', 'verbose', 0));
    else
        % Negativity for bipartite systems
        val = negativity(rho, [1]);
    end

    % Ensure positive for comparison
    val = max(0, val);

    diff = abs(val - ref_val);

    fprintf('  MISMATCH (idx %2d) | h = %.4f | Computed = %.6f | Ref = %.6f | Diff = %.2e\n', ...
        idx, h, val, ref_val, diff);
end
fprintf('  Passed.\n');
end

%% Local RDM Permute Function
% Rearranges the subsystems of a multi-qubit density matrix based on
% the specified permutation order using row-major compatible reshaping.
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
