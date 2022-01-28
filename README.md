# TempMotifOnStatCitationNets
This repository contains code supporting the article ''Discussion of 'Co-citation and Co-authorship Networks of Statisticians' ''. 

## Data 
We use data set provided in Ji et al.'s paper ''Co-citation and Co-authorship Networks of Statisticians'', which is available [here](https://www.dropbox.com/sh/roft5xpbw1n2g8p/AABNQgo_iPRVCyVWmwDW6nfla/Ready-to-use%20data%20matrices/Full%20data?dl=0&subfolder_nav_tracking=1). The temporal networks analyzed in this discussion paper are constructed from the data set named `AuthorPaperInfo.RData`.

## Code
The corresponding code for network construction and motif analysis is provided in `Code/`.

* `Code/get_temporal_networks_author_nodes_all.R`: code for network construction.
* `Code/plot_motif_counts_bar_error.R/`: code for plotting Figure 1 and 2. 
* `run.sh` : executing code for motif counting.

The following are the steps to reproduce Figure 1 and 2: 
*  Download `AuthorPaperInfo.RData` from the link above. 
*  Download the temporal motif counting package [snap](https://github.com/snap-stanford/snap).  
*  Make directory `data_edge_streams2/`, and run `Code/get_temporal_networks_author_nodes_all.R` to construct temporal networks. 
*  Run `run.sh` to obtain motif counts. 
*  Run `Code/plot_motif_counts_bar_error.R/` to plot Figure 1 and 2.

For issues encountered in running the code, please contact Xiaojing Zhu at xiaojzhu@bu.edu
