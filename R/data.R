#' Jeong et al. (2022) licking behavior data
#'
#' Data includes photometry recordings from an experiment where head-fixed mice
#' were randomly administered sucrose. Columns are downsampled for convenience.
#'
#' @format A data frame with 2120 rows and 94 columns:
#' \describe{
#'  \item{id}{Unique mouse ID}
#'  \item{session}{Session}
#'  \item{trial}{Trial}
#'  \item{lick_rate_050, lick_rate_100, lick_rate_150, lick_rate_200}{The average licking rate 0.5, 1.0, 1.5, and 2.0 seconds after sucrose administration}
#'  \item{iri}{The inter-reward interval relative to the previous lick}
#'  \item{photometry_1, ..., photometry_43}{Photometry recordings over the trial}
#'  \item{lick_1, ..., lick_43}{Whether a mouse was licking at a time point}
#' }
#' @source \url{https://dandiarchive.org/dandiset/000351/draft} Jeong H, Taylor
#'   A, Floeder JR, Lohmann M, Mihalas S, Wu B, Zhou M, Burke DA, Namboodiri
#'   VMK. Mesolimbic dopamine release conveys causal associations. Science. 2022
#'  Dec 23;378(6626):eabq6740. doi: 10.1126/science.abq6740.

"lick"

#' Machen et al. (2025) variable trial length data
#'
#' Data from an experiment where mice ran through a maze where they received
#' either a strawberry milkshake (SMS) or water (H2O) reward. Mice entered the
#' reward zone at variable times.
#'
#' @format A data frame with 1335 rows and 248 columns:
#' \describe{
#'  \item{id}{Unique mouse ID}
#'  \item{session}{Session}
#'  \item{outcome}{The outcome of the trial, either SMS or H2O}
#'  \item{SMS}{Redundant encoding for binary encoding of SMS reward}
#'  \item{latency}{Time, in seconds, for mouse tor each the reward}
#'  \item{trial}{Trial}
#'  \item{photometry_1, ..., photometry_121}{Photometry recordings at time point}
#'  \item{rewarded_1, ..., rewarded_121}{Whether the mouse had been rewarded by time point}
#' }
#'
#' @source \url{https://doi.org/10.1101/2025.03.10.642469}. Briana Machen,
#'   Sierra N. Miller, Al Xin, Carine Lampert, Lauren Assaf, Julia Tucker, Sarah
#'   Herrell, Francisco Pereira, Gabriel Loewinger, Sofia Beas. The encoding of
#'   interoceptive-based predictions by the paraventricular nucleus of the
#'   thalamus D2+ neurons. DOI: 10.1101/2025.03.10.642469. bioRxiv (2025).

"d2pvt"

ignore_unused_imports <- function() {
  dplyr::mutate
}
