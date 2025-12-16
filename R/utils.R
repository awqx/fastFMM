#' Get functional covariate names
#'
#' Checks for consistency between the functional domain implied by the outputs
#' and the functional domain of covariates.
#'
#' @param frm the model formula passed to `fui()`
#' @param df the data frame passed to `fui()`
#' @param silent logical for message printing, inherited from `fui()`
#'
#' @return chr vector of detected valid functional covariates
#'
#' @noRd
#' @keywords internal

get_functional_covariates <- function(frm, df, silent) {
  # helper function that gets functional domain length from name
  get_L <- function(column_name) {
    col_indxs <- grep(paste0("^", column_name), names(df))
    if (length(col_indxs) == 1) {
      L <- ncol(df[, col_indxs])
    } else {
      L <- length(col_indxs)
    }
  }

  # Detect functional covariates by matching length to L
  model_formula <- as.character(frm)
  y_name <- model_formula[2]
  L <- get_L(y_name)

  # Get covariate names
  x_names <- all.vars(frm)[-1]

  # Case 1: functional covariates are encoded in a matrix ######################

  # check if any covariates correspond to a multidimensional class
  x_ismatrix <- sapply(x_names,
    function(x) any(class(df[[x]]) == "matrix" | class(df[[x]]) == "AsIs"))
  x_ismatrix <- x_names[x_ismatrix]

  # check matrix columns are correct
  if (length(x_ismatrix) > 0) {
    if (!silent)
      message("Detected functional covariates in matrix columns: ",
              paste0(x_ismatrix, collapse = ", "))

    x_ismatrix_Ls <- sapply(x_ismatrix, get_L)
    if (sum(x_ismatrix_Ls != L) > 0)
      stop("Width of functional covariates not equal to outcome", "\n",
           "Expected ", L, ", found ", paste0(x_ismatrix_Ls, collapse = ", "))

    x_ismatrix <- x_ismatrix[x_ismatrix_Ls == L]
  }

  # Case 2: functional covariates are multiple columns #########################
  # count number of columns associated with each covariate name
  x_ncols <- sapply(x_names,
    function(x) length(grep(paste0("^", x), names(df))))

  x_ncols <- x_names[x_ncols > 1]

  if (length(x_ncols) > 0) {
    if (!silent)
      message("Detected functional covariates by shared column names: ",
              paste0(x_ncols, collapse = ", "))

    x_ncols_Ls <- sapply(x_ncols, get_L)
    if (sum(x_ncols_Ls != L) > 0)
      stop("Width of functional covariates not equal to outcome", "\n",
           "Expected L = ", L, ", found ", paste0(x_ncols_Ls, collapse = ", "))

    x_ncols <- x_ncols[x_ncols_Ls == L]
  }

  c(x_ismatrix, x_ncols)
}
