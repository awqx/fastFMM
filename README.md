# fastFMM: Fast Functional Mixed Models using Fast Univariate Inference (FUI)

## Repository Description

Repository for the development version of the R Package `fastFMM` with a particular focus on the concurrent model extension. For more information, see the official `fastFMM` $\texttt{CRAN}$ [site](https://CRAN.R-project.org/package=fastFMM).  

## Installation

Download the CRAN version of `fastFMM`  with the following `R` command:

```{R}
install.packages("fastFMM", dependencies = TRUE)
```

Download this particular development version with `devtools`:

```{R}
if (!require("devtools")) install.packages("devtools")
devtools::install_github("awqx/fastFMM")
```

##  Package Usage

See the [vignettes](https://github.com/awqx/fastFMM/tree/main/vignettes) for walkthroughs on the package functions. The vignette [fastFMM](https://github.com/awqx/fastFMM/blob/main/vignettes/fastFMM.Rmd) contains a broad introduction to using the concurrent and non-concurrent versions of the `fui` model-fitting function. The vignette [d2pvt](https://github.com/awqx/fastFMM/blob/main/vignettes/d2pvt.Rmd) details how to model experiments with variable trial length with a concurrent functional mixed model. 

## Repository Folders

1. `R/`: the code of the package, including `fui.R` and `plot_fui.R`, the main callable functions in `fastFMM`. 
2. `vignettes/`: demonstrations for how to use different arguments of the `fui` function. 
3. `data/`: example data for fitting functional mixed models.
4. `data-raw/`: code for producing the files in `data/`. 

## Dataset Links

We provide the sample dataset `data/lick.rda`, a cleaned downsample of a dataset made publicly available by [Jeong et al. (2022)](https://doi.org/10.1126/science.abq6740) on [the DANDI archive](https://dandiarchive.org/dandiset/000351/draft).

We also use experimental data from [Machen et al. (2025)](https://doi.org/10.1101/2025.03.10.642469) in the `d2pvt` vignette.

## References

Erjia Cui, Andrew Leroux, Ekaterina Smirnova, and Ciprian Crainiceanu. [Fast Univariate Inference for Longitudinal Functional Models](https://doi.org/10.1080/10618600.2021.1950006). Journal of Computational and Graphical Statistics (2022).

Huijeong Jeong, Annie Taylor, Joseph R Floeder, Martin Lohmann, Stefan Mihalas, Brenda Wu, Mingkang Zhou, Dennis A Burke, Vijay Mohan K Namboodiri. [Mesolimbic dopamine release conveys causal associations](https://doi.org/10.1126/science.abq6740). Science (2022).

Gabriel Loewinger, Erjia Cui, David Lovinger, Francisco Pereira. [A Statistical Framework for Analysis of Trial-Level Temporal Dynamics in Fiber Photometry Experiments](https://doi.org/10.7554/eLife.95802.2). eLife Neuroscience (2024).

Briana Machen, Sierra N. Miller, Al Xin, Carine Lampert, Lauren Assaf, Julia Tucker, Sarah Herrell, Francisco Pereira, Gabriel Loewinger, Sofia Beas. [The encoding of interoceptive-based predictions by the paraventricular nucleus of the thalamus D2+ neurons](https://doi.org/10.1101/2025.03.10.642469). bioRxiv (2025).

Alison W Xin, Erjia Cui, Francisco Pereira, Gabriel Loewinger. Extending fast functional mixed models to concurrent photometry analysis. biorXiv (2025). 
