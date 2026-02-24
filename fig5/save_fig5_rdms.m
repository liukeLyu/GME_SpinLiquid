% save_fig5_rdms.m
% Generates and saves Reduced Density Matrices (RDMs) for 5 specific subregions
% across various J2 values for the Kagome Lattice model.
% Saved directly to the public Figshare Data directory.

clear; clc;

% Input directory for raw state files (.dat)
inputDir = '/Users/liukelyu/Documents/Entanglement/2-3.SpinLiquids/3.11_Kagome_J2/Kagome.N36.J2';

% Define subregions: names and corresponding selection indices
subregions = {
    'hexagon',      [2 3 6 9 8 5];      ... % 6 spins
    'bowtie',       [1 2 3 4 6];        ... % 5 spins
    'linear',       [2 4 7 3 5];        ... % 5 spins (partition A, parallel)
    'triangle_plus',[2 7 5 8];          ... % 4 spins (partition A, 27_58)
    'triangle',     [1 2 3];            ... % 3 spins
    };

numSubregions = size(subregions, 1);

% Search for all relevant .dat files
files = dir(fullfile(inputDir, 'rdm11.kag36mz.Other.*.dat'));
f0 = dir(fullfile(inputDir, 'rdm11.kag36mz.isotropic.Sz.00.dat'));
files = [files; f0];

nf = length(files);
J2List = zeros(1, nf);

% Preallocate cell arrays for RDM lists
allRdmLists = cell(numSubregions, 1);
for k = 1:numSubregions
    allRdmLists{k} = cell(1, nf);
end

fprintf('Processing %d RDM files...\n', nf);

for i = 1:nf
    f = files(i);
    fpath = fullfile(f.folder, f.name);

    % Parse J2 value from filename
    if contains(fpath, 'kag36mz.isotropic.Sz')
        J2 = 0;
    else
        hstr = extractBetween(fpath, 'Other.J2', '.Sz');
        J2 = str2double(hstr{1});
    end
    J2List(i) = J2;

    % Load 11-qubit RDM
    rho11 = readrealRDM(fpath, 2^11);

    % Generate subregion RDMs
    for k = 1:numSubregions
        indices = subregions{k, 2};
        allRdmLists{k}{i} = rdm(rho11, indices);
    end

    if mod(i, 5) == 0
        fprintf('  Processed %d / %d...\n', i, nf);
    end
end

% Sort results by parameter J2
[J2List, order] = sort(J2List);

for k = 1:numSubregions
    allRdmLists{k} = allRdmLists{k}(order);
end

% Save ordered lists
fprintf('Saving RDM files...\n');
for k = 1:numSubregions
    name = subregions{k, 1};
    saveFile = sprintf('rdm_%s.mat', name);
    rdmList = allRdmLists{k};
    save(saveFile, 'J2List', 'rdmList', '-v7.3');
    fprintf('  Saved %s\n', saveFile);
end

fprintf('Done.\n');
