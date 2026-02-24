% verify_rdms.m
% Verifies the generated Kagome J2 RDMs against reference results

clear; clc;

% Selection of test indices for fast verification across the 17 points
% test_indices = [1 4 8 13 17];
test_indices = 1:17;

% -------------------------
% 1. Hexagon (GMN)
% Subregion is 6 spins. To get [4 4 4] dims, we partition them into three pairs.
% Original 11-qubit indices were [2 3 6 9 8 5]. The subregion RDM
% corresponds to [1 2 3 4 5 6] of that specific 6-spin selection.
% -------------------------
verify_item('rdm_hexagon.mat', 'gmn_KagJ2_plaq_N3.mat', {[1 2], [3 4], [5 6]}, test_indices);

% -------------------------
% 2. Bowtie (GMN)
% Subregion is [1 2 3 4 6] in original 11-qubit vector.
% GMN dims were [4 2 4], implying partitions of 2, 1, and 2 spins.
% -------------------------
verify_item('rdm_bowtie.mat', 'gmn_KagJ2_bowtie_N3.mat', {[1 2], [3], [4 5]}, test_indices);

% -------------------------
% 3. Linear (GMN)
% Subregion is [2 4 7 3 5].
% GMN dims were [2 4 4], implying partitions of 1, 2, and 2 spins.
% -------------------------
verify_item('rdm_linear.mat', 'gmn_KagJ2_angle_parallel_N3.mat', {[1], [2 3], [4 5]}, test_indices);
% [2] [4 5] [3 7]
verify_item('rdm_linear.mat', 'gmn_KagJ2_angle_cross_N3.mat', {[1], [2 5], [3 4]}, test_indices);

% -------------------------
% 4. Triangle Plus (GMN Tripartite)
% Subregion is [2 7 5 8].
% GMN dims were [2 2 4], implying partitions of 1, 1, and 2 spins.
% -------------------------
verify_item('rdm_triangle_plus.mat', 'gmn_KagJ2_4spin_27_58_N3.mat', {[1], [2], [3 4]}, test_indices);
% [2] [8] [5 7]
verify_item('rdm_triangle_plus.mat', 'gmn_KagJ2_4spin_28_57_N3.mat', {[1], [4], [2 3]}, test_indices);

% -------------------------
% 5. Triangle (GMN)
% Subregion is [1 2 3].
% GMN dims were [2 2 2], implying partitions of 1, 1, and 1 spins.
% -------------------------
verify_item('rdm_triangle.mat', 'gmn_KagJ2_triangle_N3.mat', {[1], [2], [3]}, test_indices);

fprintf('\nVerification complete.\n');

%% Helper Function
function verify_item(rdmFile, resFile, partitions, indices)
fprintf('\nVerifying %s vs %s...\n', rdmFile, resFile);

% Load RDM data
rdm_data = load(rdmFile);
J2List = rdm_data.J2List;
rdmList = rdm_data.rdmList;

% Load reference results
res_data = load(resFile);
ref_J2List = res_data.J2List;
ref_gmnList = res_data.gmnList;

% Determine order of permutation and corresponding dimensions
order = cell2mat(partitions);
dims = zeros(1, length(partitions));
for i = 1:length(partitions)
    dims(i) = 2^length(partitions{i});
end

for idx = indices
    if idx > length(J2List)
        continue;
    end
    J2 = J2List(idx);
    rho = rdmList{idx};

    % Find matching reference value by J2
    [val_J2, ref_idx] = min(abs(ref_J2List - J2));
    if val_J2 > 1e-4
        fprintf('  idx %2d | J2 = %.4f | No matching reference field found (min diff = %.2e)\n', ...
            idx, J2, val_J2);
        continue;
    end
    ref_val = ref_gmnList(ref_idx);

    % Permute RDM according to the required partitions
    if ~issorted(order)
        rho = local_rdm_permute(rho, order);
    end

    % Tripartite GMN using Mosek
    val = gmn(rho, dims, sdpsettings('solver', 'mosek', 'verbose', 0));
    val = max(0, val);

    diff = abs(val - ref_val);
    fprintf('  idx %2d | J2 = %.4f | Computed = %.6e | Ref = %.6e | Diff = %.2e\n', ...
        idx, J2, val, ref_val, diff);
end
end

%% Local RDM Permute Function
% Rearranges the subsystems of a multi-qubit density matrix based on
% the specified permutation order using row-major compatible reshaping.
function rho_perm = local_rdm_permute(rho, order)
n_qubits = log2(size(rho, 1));
if round(n_qubits) ~= n_qubits
    error('Density matrix dimensions must be a power of 2.');
end

if length(order) ~= n_qubits || ~all(sort(order) == 1:n_qubits)
    error('Order array must be a valid permutation of 1 to N.');
end

% 1. Reshape into tensor (emulating ten2ten for row-major)
v1 = permute(rho, [2 1]);
v1 = v1(:);
t1_tensor = reshape(v1, 2 * ones(1, 2 * n_qubits));
rho_tensor = permute(t1_tensor, (2 * n_qubits):-1:1);

% 2. Apply permutation to physical indices (row and col)
perm_order = [order, n_qubits + order];
rho_perm_tensor = permute(rho_tensor, perm_order);

% 3. Reshape back into matrix form (emulating ten2ten for row-major)
t2_tensor = permute(rho_perm_tensor, (2 * n_qubits):-1:1);
v2 = t2_tensor(:);
m2 = reshape(v2, [2^n_qubits, 2^n_qubits]);
rho_perm = permute(m2, [2 1]);
end
