# Statistical Significance Calculations for Scenarios in Visual Inference

## Abstract
Statistical inference provides the protocols for conducting rigorous science, but data plots provide the opportunity to discover the unexpected. These disparate endeavors are bridged by visual inference, where a lineup protocol can be employed for statistical testing. Human observers are needed  to assess the lineups, typically using a crowd-sourcing service.  This paper describes a new approach for computing statistical significance associated with the results from applying a lineup protocol. It utilizes a Dirichlet distribution to accommodate different levels of visual interest in individual null panels. The suggested procedures facilitate statistical inference for a broader range of data problems.

## Repository structure
- index.Rnw contains the code necessary to generate the paper, figures, and quantitative results
- code/functions.R contains some auxiliary functions used in the paper calculations.
- data/
    - all-turk-studies-summary.csv contains summarized results from many different lineup studies; each line describes aggregated results for a single lineup panel.
        - study: a string indicating the study the lineup panel was used in
        - param: a string indicating the parameter settings (study specific) used to generate the lineup
        - test_param: a string indicating a (usually human readable) description of the lineup
        - pic_id: a numeric ID specific to the lineup
        - pic_name: the picture name (pictures aren't provided in this repository, but are stored elsewhere and can be made available upon request)
        - obs_plot_location: the panel of the lineup containing the data or target
        - response_no: the panel number of the lineup
        - n: the number of times the panel was selected
    - turk6_60_96_1_8.csv contains the data necessary to generate the lineup provided in the example section of the paper
        - vals: the y-values used in boxplot construction
        - group: the group used to separate values into two boxplots
        - .sample: the panel the value is included in
- extra/
    - multivariate_derivation.tex contains a derivation of the dirichlet-multinomial mixture distribution
