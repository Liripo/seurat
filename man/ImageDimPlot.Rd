% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/visualization.R
\name{ImageDimPlot}
\alias{ImageDimPlot}
\title{Spatial Cluster Plots}
\usage{
ImageDimPlot(
  object,
  fov = NULL,
  boundaries = NULL,
  group.by = NULL,
  split.by = NULL,
  cols = NULL,
  shuffle.cols = FALSE,
  size = 0.5,
  molecules = NULL,
  mols.size = 0.1,
  mols.cols = NULL,
  mols.alpha = 1,
  nmols = 1000,
  alpha = 1,
  border.color = "white",
  border.size = NULL,
  na.value = "grey50",
  dark.background = TRUE,
  crop = FALSE,
  cells = NULL,
  overlap = FALSE,
  axes = FALSE,
  combine = TRUE,
  coord.fixed = TRUE,
  flip_xy = TRUE
)
}
\arguments{
\item{object}{A \code{\link[SeuratObject]{Seurat}} object}

\item{fov}{Name of FOV to plot}

\item{boundaries}{A vector of segmentation boundaries per image to plot;
can be a character vector, a named character vector, or a named list.
Names should be the names of FOVs and values should be the names of
segmentation boundaries}

\item{group.by}{Name of one or more metadata columns to group (color) cells by
(for example, orig.ident); pass 'ident' to group by identity class}

\item{split.by}{A factor in object metadata to split the plot by, pass 'ident'
to split by cell identity}

\item{cols}{Vector of colors, each color corresponds to an identity class. This may also be a single character
or numeric value corresponding to a palette as specified by \code{\link[RColorBrewer]{brewer.pal.info}}.
By default, ggplot2 assigns colors. We also include a number of palettes from the pals package.
See \code{\link{DiscretePalette}} for details.}

\item{shuffle.cols}{Randomly shuffle colors when a palette or
vector of colors is provided to \code{cols}}

\item{size}{Point size for cells when plotting centroids}

\item{molecules}{A vector of molecules to plot}

\item{mols.size}{Point size for molecules}

\item{mols.cols}{A vector of color for molecules. The "Set1" palette from
RColorBrewer is used by default.}

\item{mols.alpha}{Alpha value for molecules, should be between 0 and 1}

\item{nmols}{Max number of each molecule specified in `molecules` to plot}

\item{alpha}{Alpha value for plotting (default is 1)}

\item{border.color}{Color of cell segmentation border; pass \code{NA}
to suppress borders for segmentation-based plots}

\item{border.size}{Thickness of cell segmentation borders; pass \code{NA}
to suppress borders for centroid-based plots}

\item{na.value}{Color value for NA points when using custom scale}

\item{dark.background}{Set plot background to black}

\item{crop}{Crop the plots to area with cells only}

\item{cells}{Vector of cells to plot (default is all cells)}

\item{overlap}{Overlay boundaries from a single image to create a single
plot; if \code{TRUE}, then boundaries are stacked in the order they're
given (first is lowest)}

\item{axes}{Keep axes and panel background}

\item{combine}{Combine plots into a single
\code{patchwork} ggplot object.If \code{FALSE},
return a list of ggplot objects}

\item{coord.fixed}{Plot cartesian coordinates with fixed aspect ratio}

\item{flip_xy}{Flag to flip X and Y axes. Default is FALSE.}
}
\value{
If \code{combine = TRUE}, a \code{patchwork}
ggplot object; otherwise, a list of ggplot objects
}
\description{
Visualize clusters or other categorical groupings in a spatial context
}
\concept{spatial}
\concept{visualization}
