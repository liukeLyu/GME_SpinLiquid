% =========================================================================
% Script Description:
% Generates subregion RDMs for Kagome CSL N=24 and N=36 states from raw
% .dat files, matching the expected outputs in 'Figshare Data/fig6'.
% =========================================================================

clear; clc;

% Setup paths
repo_path = '../../../3.4 Kagome CSL';
n24_path = fullfile(repo_path, 'Kag2CSL.N24');
n36_path = fullfile(repo_path, 'Kag2CSL.N36');

% Number of qubits in original states
% Wait for N=36 data

%% ========================================================================
% Process N=36 RDMs
% =========================================================================
fprintf('Processing N=36 Kagome CSL RDMs...\n');

files36 = dir(fullfile(n36_path, 'rdm11.kag2csl36mz.isotropic.Sz.00.lam*.dat'));
nh36 = length(files36);

% Struct array to collect lam and keep matching sorting order
lamVals36 = zeros(1, nh36);

% Initialize cells for subset rdms
gmn_plaq222_N36_rdms = cell(1, nh36);
gmnbowtie_N36_rdms = cell(1, nh36);
gmn_triangle_N36_rdms = cell(1, nh36);
gmn_nonloopy_N36_rdms = cell(1, nh36);

for i = 1:nh36
    fpath = fullfile(files36(i).folder, files36(i).name);
    lamstr = extractBetween(fpath, 'lam', '.dat');
    lam = str2double(lamstr{1});
    lamVals36(i) = lam;

    if abs(lam) < 1e-8 % lam=0 uses real values only due to convention check in original script
        rho11 = readrealRDM(fpath, dim36_rdm11);
    else
        rho11 = readcomplexRDM(fpath, dim36_rdm11);
    end

    % Assign extracted matrices based exactly on original indices
    gmn_plaq222_N36_rdms{i} = rdm(rho11, [2 5 8 9 6 3]);
    gmnbowtie_N36_rdms{i}   = rdm(rho11, [3 4 6 9 10]);
    gmn_triangle_N36_rdms{i} = rdm(rho11, [1 2 3]);
    gmn_nonloopy_N36_rdms{i} = rdm(rho11, [3 7 2 9 5 6]);

    fprintf('... N=36 progress: %d / %d\n', i, nh36);
end

% Sort data based on lamList since original files were dir'd arbitrarily
[lamList36_sorted, sort_idx36] = sort(lamVals36);
lamList = lamList36_sorted;

gmn_plaq222_N36_rdms  = gmn_plaq222_N36_rdms(sort_idx36);
gmnbowtie_N36_rdms    = gmnbowtie_N36_rdms(sort_idx36);
gmn_triangle_N36_rdms = gmn_triangle_N36_rdms(sort_idx36);
gmn_nonloopy_N36_rdms = gmn_nonloopy_N36_rdms(sort_idx36);

% Save N36 results
save('rdm_hexagon_N36.mat', 'gmn_plaq222_N36_rdms', 'lamList');
save('rdm_bowtie_N36.mat', 'gmnbowtie_N36_rdms', 'lamList');
save('rdm_triangle_N36.mat', 'gmn_triangle_N36_rdms', 'lamList');
save('rdm_nonloopy_N36.mat', 'gmn_nonloopy_N36_rdms', 'lamList');

fprintf('N=36 data saved to .mat files.\n');
fprintf('RDM extraction completed entirely.\n');
