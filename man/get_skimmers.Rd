% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_skimmers.R
\name{get_skimmers}
\alias{get_skimmers}
\alias{modify_default_skimmers}
\title{Retrieve the summary functions for a specific data type}
\usage{
get_skimmers(column)

modify_default_skimmers(skim_type, new_skim_type = NULL, new_funs = list())
}
\arguments{
\item{column}{An atomic vector or list. A column from a data frame.}

\item{skim_type}{A character scalar. The class of the object with default
skimmers.}

\item{new_skim_type}{The type to assign to the looked up set of skimmers.}

\item{new_funs}{Replacement functions for those in}
}
\value{
A \code{skim_function_list} object.
}
\description{
These functions are used to set the default skimming functions for a data
type.  When creating your own set of skimming functions, call \code{\link[=sfl]{sfl()}}
within a \code{\link[=get_skimmers]{get_skimmers()}} method for your particular type. Your call to
\code{\link[=sfl]{sfl()}} should also provide a matching class in the \code{skim_type} argument.
Otherwise, it will not be possible to dynamically reassign your default
functions when working interactively.
}
\details{
Summary functions are provided for the following classes:
\itemize{
\item \code{numeric}
\item \code{character}
\item \code{factor}
\item \code{logical}
\item \code{complex}
\item \code{Date}
\item \code{POSIXct}
\item \code{difftime}
\item \code{ts}
\item \code{AsIs}
}

Call \code{\link[=get_default_skimmers]{get_default_skimmers()}} to see the functions for each. Call
\code{\link[=get_default_skimmer_names]{get_default_skimmer_names()}} to just see the names of these functions. Use
\code{\link[=modify_default_skimmers]{modify_default_skimmers()}} for a method for changing the \code{skim_type} or
functions for a default \code{sfl}. This is useful for creating new default
\code{sfl}'s.
}
\examples{
# Defining default skimming functions for a new class, `my_class`.
# Note that the class argument is required for dynamic reassignment.
get_skimmers.my_class <- function(column) {
  sfl(
    skim_type = "my_class",
    mean,
    sd
  )
}

# Integer and float columns are both "numeric" and are treated the same
# by default. To switch this behavior in another package, add a method.
get_skimmers.integer <- function(column) {
  sfl(
    skim_type = "integer",
    p50 = ~ stats::quantile(
      .,
      probs = .50, na.rm = TRUE, names = FALSE, type = 1
    )
  )
}
x <- mtcars[c("gear", "carb")]
class(x$carb) <- "integer"
skim(x)
\dontrun{
# In a package, to revert to the V1 behavior of skimming separately with the
# same functions, assign the numeric `get_skimmers`.
get_skimmers.integer <- skimr::get_skimmers.numeric

# Or, in a local session, use `skim_with` to create a different `skim`.
new_skim <- skim_with(integer = skimr::get_skimmers.numeric())

# To apply a set of skimmers from an old type to a new type
get_skimmers.new_type <- function(column) {
  modify_default_skimmers("old_type", new_skim_type = "new_type")
}
}
}
\seealso{
\code{\link[=sfl]{sfl()}}
}
