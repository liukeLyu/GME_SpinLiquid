# Dataset: Multiparty entanglement loops in quantum spin liquids

This repository contains the numerical dataset supporting the paper **"Multiparty entanglement loops in quantum spin liquids"**.

The dataset provides pre-extracted Reduced Density Matrices (RDMs) for various geometric subregions (such as hexagons, bowties, and triangles) across different quantum spin liquid (QSL) models, including the Kitaev Honeycomb model, Kagome $J_1$-$J_2$ Heisenberg model and the Kagome Chiral Spin Liquid (CSL) state.

## Repository Structure

The data is organized by the figures presented in the main text and supplementary materials:

- **`fig3/`**: Kitaev Honeycomb model (N=32 Dyck Lattice) in a [111] field. Contains RDMs for various smaller subsystem clusters (e.g., hexagonal, fork, adjacent sites) and GMN values. Panel (a) is plotted using the Hexagon subregion. Panel (b) is plotted using the fork subregion. Panel (c) is plotted using the 2- and 3-site adjacent subregion.
- **`fig4/`**: Kitaev Honeycomb model (Thermodynamic limit) in a [111] field. Contains GMN values as a function of anisotropy in the Ising exchange interactions.
- **`fig5/`**: Kagome $J_1$-$J_2$ system (N=36), as a function of the $J_2/J_1$ ratio. Contains RDMs for various subsystem clusters and GMN values. Panel (a) is plotted using the Hexagon and Bowtie subregion. Panel (b) is plotted using the linear 5-site subregion. Panel (c) is plotted using the 2- and 3- and 4-site subregions.
- **`fig6/`**: Kagome Chiral Spin Liquid (CSL) (N=36), as a function of the scalar spin chirality intearction. Contains RDMs for various subsystem clusters and GMN values. Panel (a) is plotted using the Bowtie subregion. Panel (b) is plotted using the Hexagon subregion. Panel (c) is plotted using the Triangle subregion.
- **`figS1/`**: All data can be obtained from the hexagon subregion data in folder `fig3/`.
- **`figS2/`**: similar to `fig3/` data, but with a N=24 lattice. Data available from the corresponding authors upon request.
- **`figS5/`**: All data can be obtained from the hexagon and fork RDMs in folder `fig3/`.
- **`figS10/`**: GMN as a function of the system size for the Kagome $J_1-J_2$ system. The last point can be obtained from `fig5/`, at $J_2=0$. Other data are available upon request.

## Exploring the Data

Fig3-6 folders contain the data saved in `.mat` files, a script which uses the gmn data to make the corresponding plots in the manuscript, and a MATLAB script named `verify_rdms.m`. 

You can run `verify_rdms.m` in any directory to see an example of how to:
1. Load the subregion density matrices (`rho`).
2. Partition the state spaces into the correct groupings for the specific geometry.
3. Compute the Genuine Multiparty Entanglement (GMN) for the state.
4. Verify the computed values against the reference results in the dataset.

## Requirements

To run the `verify_rdms.m` scripts and compute the GMN metric yourself, you will need:
- Add the gmn.m file to your MATLAB path, this function is modified from the version on Mathwork File Exchange https://www.mathworks.com/matlabcentral/fileexchange/30968-pptmixer-a-tool-to-detect-genuine-multipartite-entanglement, where we remove one constraint, following the renormalized definition in https://iopscience.iop.org/article/10.1088/1751-8113/47/15/155301.
- An SDP parser YALMIP (https://yalmip.github.io/)
- An SDP Solver compatible with YALMIP, such as [Mosek](https://www.mosek.com/).

## Additional Data
All other data that support the findings of this study are available from the corresponding authors upon request