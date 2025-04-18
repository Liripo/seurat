# Tests for functions in differential_expression.R
suppressWarnings(RNGversion(vstr = "3.5.3"))
set.seed(seed = 42)

# Tests for FindMarkers
# --------------------------------------------------------------------------------
context("FindMarkers")

clr.obj <- suppressWarnings(NormalizeData(pbmc_small, normalization.method = "CLR"))
sct.obj <- suppressWarnings(suppressMessages(SCTransform(pbmc_small, vst.flavor = "v1")))

markers.0 <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = 0, verbose = FALSE, base = exp(1),pseudocount.use = 1))
markers.01 <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, verbose = FALSE, base = exp(1),pseudocount.use = 1))
results.clr <- suppressWarnings(FindMarkers(object = clr.obj, ident.1 = 0, ident.2 = 1, verbose = FALSE, base = exp(1), pseudocount.use = 1))
results.sct <- suppressWarnings(FindMarkers(object = sct.obj, ident.1 = 0, ident.2 = 1, verbose = FALSE, base = exp(1), pseudocount.use = 1))


test_that("Default settings work as expected with pseudocount = 1", {
  expect_error(FindMarkers(object = pbmc_small))
  expect_error(FindMarkers(object = pbmc_small, ident.1 = "test"))
  expect_error(FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = "test"))
  expect_equal(colnames(x = markers.0), c("p_val", "avg_logFC", "pct.1", "pct.2", "p_val_adj"))
  expect_equal(markers.0[1, "p_val"], 9.572778e-13, tolerance = 1e-18)
  expect_equal(markers.0[1, "avg_logFC"], -4.180029, tolerance = 1e-6)
  expect_equal(markers.0[1, "pct.1"], 0.083)
  expect_equal(markers.0[1, "pct.2"], 0.909)
  expect_equal(markers.0[1, "p_val_adj"], 2.201739e-10, tolerance = 1e-15)
  expect_equal(nrow(x = markers.0), 228)
  expect_equal(rownames(markers.0)[1], "HLA-DPB1")

  expect_equal(markers.01[1, "p_val"], 1.702818e-11, tolerance = 1e-16)
  expect_equal(markers.01[1, "avg_logFC"], -2.638242, tolerance = 1e-6)
  expect_equal(markers.01[1, "pct.1"], 0.111)
  expect_equal(markers.01[1, "pct.2"], 1.00)
  expect_equal(markers.01[1, "p_val_adj"], 3.916481e-09, tolerance = 1e-14)
  expect_equal(nrow(x = markers.01), 222)
  expect_equal(rownames(x = markers.01)[1], "TYMP")

  # CLR normalization
  expect_equal(results.clr[1, "p_val"], 1.209462e-11, tolerance = 1e-16)
  expect_equal(results.clr[1, "avg_logFC"], -2.946633, tolerance = 1e-6)
  expect_equal(results.clr[1, "pct.1"], 0.111)
  expect_equal(results.clr[1, "pct.2"], 0.96)
  expect_equal(results.clr[1, "p_val_adj"], 2.781762e-09, tolerance = 1e-14)
  expect_equal(nrow(x = results.clr), 213)
  expect_equal(rownames(x = results.clr)[1], "S100A8")

  # SCT normalization
  expect_equal(results.sct[1, "p_val"], 6.225491e-11, tolerance = 1e-16)
  expect_equal(results.sct[1, "avg_logFC"], -2.545867, tolerance = 1e-6)
  expect_equal(results.sct[1, "pct.1"], 0.111)
  expect_equal(results.sct[1, "pct.2"], 0.96)
  expect_equal(results.sct[1, "p_val_adj"], 1.369608e-08, tolerance = 1e-13)
  expect_equal(nrow(x = results.sct), 214)
  expect_equal(rownames(x = results.sct)[1], "TYMP")
})


tymp.results <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = 0, features = "TYMP", verbose = FALSE, base = exp(1),pseudocount.use = 1))
vargenes.results <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = 0, features = VariableFeatures(object = pbmc_small), verbose = FALSE, base = exp(1),pseudocount.use = 1))

test_that("features parameter behaves correctly ", {
  expect_equal(nrow(x = tymp.results), 1)
  expect_equal(tymp.results[1, "p_val"], 3.227445e-07, tolerance = 1e-12)
  expect_equal(tymp.results[1, "avg_logFC"], -2.188179, tolerance = 1e-6)
  expect_equal(tymp.results[1, "pct.1"], 0.111)
  expect_equal(tymp.results[1, "pct.2"], 0.682)
  expect_equal(tymp.results[1, "p_val_adj"], 7.423123e-05, tolerance = 1e-10)
  expect_equal(rownames(x = tymp.results)[1], "TYMP")

  expect_equal(nrow(x = vargenes.results), 20)
  expect_equal(vargenes.results[20, "p_val"], 4.225151e-01, tolerance = 1e-6)
  expect_equal(vargenes.results[20, "avg_logFC"], 1.796863, tolerance = 1e-6)
  expect_equal(vargenes.results[20, "pct.1"], 0.139)
  expect_equal(vargenes.results[20, "pct.2"], 0.091)
  expect_equal(vargenes.results[20, "p_val_adj"], 1.000000e+00)
  expect_equal(rownames(x = vargenes.results)[20], "PARVB")
})


results <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = Cells(x = pbmc_small)[1:40], ident.2 = Cells(x = pbmc_small)[41:80], verbose = FALSE, base = exp(1),pseudocount.use = 1))
test_that("passing cell names works", {
  expect_equal(nrow(x = results), 216)
  expect_equal(results[1, "p_val"], 0.0001690882)
  expect_equal(results[1, "avg_logFC"], -1.967123, tolerance = 1e-6)
  expect_equal(results[1, "pct.1"], 0.075)
  expect_equal(results[1, "pct.2"], 0.450)
  expect_equal(results[1, "p_val_adj"], 0.03889028)
  expect_equal(rownames(x = results)[1], "IFI30")
})

results <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, verbose = FALSE, base = exp(1), pseudocount.use = 0.1))
results.clr <- suppressWarnings(FindMarkers(object = clr.obj, ident.1 = 0, ident.2 = 1, verbose = FALSE, base = exp(1), pseudocount.use = 0.1))
results.sct <- suppressWarnings(FindMarkers(object = sct.obj, ident.1 = 0, ident.2 = 1, verbose = FALSE, base = exp(1), pseudocount.use = 0.1, vst.flavor = "v1"))
test_that("setting pseudocount.use works", {
  expect_equal(nrow(x = results), 222)
  expect_equal(results[1, "avg_logFC"], -2.640848, tolerance = 1e-6)
  expect_equal(nrow(x = results.clr), 214)
  expect_equal(results.clr[1, "avg_logFC"], -3.322368, tolerance = 1e-6)
  expect_equal(nrow(results.sct), 215)
  expect_equal(results.sct[1, "avg_logFC"], -2.668866, tolerance = 1e-6)
})

results <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, verbose = FALSE, base = exp(1), pseudocount.use = 1, mean.fxn = rowMeans))
results.clr <- suppressWarnings(FindMarkers(object = clr.obj, ident.1 = 0, ident.2 = 1, verbose = FALSE, base = exp(1), pseudocount.use = 1, mean.fxn = rowMeans))
results.sct <- suppressWarnings(FindMarkers(object = sct.obj, ident.1 = 0, ident.2 = 1, verbose = FALSE, base = exp(1), pseudocount.use = 1, mean.fxn = rowMeans, vst.flaovr = "v1"))
test_that("setting mean.fxn works", {
  expect_equal(nrow(x = results), 216)
  expect_equal(results[1, "avg_logFC"], -4.204346, tolerance = 1e-6)
  expect_equal(results.clr[1, "avg_logFC"], -1.353025, tolerance = 1e-6)
  expect_equal(results.sct[1, "avg_logFC"], -1.064042, tolerance = 1e-6)
})

results <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, logfc.threshold = 2, verbose = FALSE, base = exp(1), pseudocount.use = 1))
test_that("logfc.threshold works", {
  expect_equal(nrow(x = results), 139)
  expect_gte(min(abs(x = results$avg_logFC)), 2)
})

results <- expect_warning(FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, logfc.threshold = 100, verbose = FALSE, base = exp(1), pseudocount.use = 1))
test_that("logfc.threshold warns when none met", {
  expect_equal(nrow(x = results), 0)
})

results <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, min.pct = 0.5, verbose = FALSE, base = exp(1), pseudocount.use = 1))
test_that("min.pct works", {
  expect_equal(nrow(x = results), 66)
  expect_gte(min(apply(X = results, MARGIN = 1, FUN = function(x) max(x[3], x[4]))), 0.5)
})

results <- expect_warning(FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, min.pct = 2.0, verbose = FALSE, base = exp(1), pseudocount.use = 1))
test_that("min.pct warns when none met", {
  expect_equal(nrow(x = results), 0)
})

results <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, min.diff.pct = 0.5, verbose = FALSE, base = exp(1), pseudocount.use = 1))
test_that("min.diff.pct works", {
  expect_equal(nrow(x = results), 44)
  expect_gte(min(apply(X = results, MARGIN = 1, FUN = function(x) abs(x[4] - x[3]))), 0.5)
})

results <- expect_warning(FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, min.diff.pct = 1.0, verbose = FALSE, base = exp(1), pseudocount.use = 1))
test_that("min.diff.pct warns when none met", {
  expect_equal(nrow(x = results), 0)
})

results <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, only.pos = TRUE, verbose = FALSE, base = exp(1), pseudocount.use = 1))
test_that("only.pos works", {
  expect_equal(nrow(x = results), 127)
  expect_true(all(results$avg_logFC > 0))
})

results <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, max.cells.per.ident = 20, verbose = FALSE, base = exp(1),pseudocount.use = 1))
test_that("max.cells.per.ident works", {
  expect_equal(nrow(x = results), 222)
  expect_equal(results[1, "p_val"], 3.428568e-08, tolerance = 1e-13)
  expect_equal(results[1, "avg_logFC"], -2.638242, tolerance = 1e-6)
  expect_equal(results[1, "pct.1"], 0.111)
  expect_equal(results[1, "pct.2"], 1)
  expect_equal(results[1, "p_val_adj"], 7.885706e-06)
  expect_equal(rownames(x = results)[1], "TYMP")
})

results <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, latent.vars= "groups", verbose = FALSE, test.use = 'LR', base = exp(1), pseudocount.use = 1))
test_that("latent.vars works", {
  expect_error(FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, latent.vars= "fake", verbose = FALSE))
  expect_warning(FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, latent.vars= "groups", verbose = FALSE))
  expect_equal(nrow(x = results), 222)
  expect_equal(results[1, "p_val"], 2.130202e-16, tolerance = 1e-21)
  expect_equal(results[1, "avg_logFC"], -3.102866, tolerance = 1e-6)
  expect_equal(results[1, "pct.1"], 0.417)
  expect_equal(results[1, "pct.2"], 1)
  expect_equal(results[1, "p_val_adj"], 4.899466e-14, tolerance = 1e-19)
  expect_equal(rownames(x = results)[1], "LYZ")
})

results <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = "g1", ident.2 = "g2", group.by= "groups", verbose = FALSE, base = exp(1), pseudocount.use = 1))
t2 <- pbmc_small
Idents(object = t2) <- "groups"
results2 <- suppressWarnings(FindMarkers(object = t2, ident.1 = "g1", ident.2 = "g2", verbose = FALSE, base = exp(1), pseudocount.use = 1))

test_that("group.by works", {
  expect_equal(nrow(x = results), 190)
  expect_equal(results, results2)
  expect_equal(results[1, "p_val"], 0.02870319)
  expect_equal(results[1, "avg_logFC"], 0.8473584, tolerance = 1e-6)
  expect_equal(results[1, "pct.1"], 0.455)
  expect_equal(results[1, "pct.2"], 0.194)
  expect_equal(results[1, "p_val_adj"], 1)
  expect_equal(rownames(x = results)[1], "NOSIP")
})

results <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = "g1", ident.2 = "g2", group.by= "groups", subset.ident = 0, verbose = FALSE, base = exp(1), pseudocount.use = 1))
t2 <- subset(x = pbmc_small, idents = 0)
Idents(object = t2) <- "groups"
results2 <- suppressWarnings(FindMarkers(object = t2, ident.1 = "g1", ident.2 = "g2", verbose = FALSE, base = exp(1), pseudocount.use = 1))

test_that("subset.ident works", {
  expect_equal(nrow(x = results), 183)
  expect_equal(results, results2)
  expect_equal(results[1, "p_val"], 0.01293720)
  expect_equal(results[1, "avg_logFC"], 1.912603, tolerance = 1e-6)
  expect_equal(results[1, "pct.1"], 0.50)
  expect_equal(results[1, "pct.2"], 0.125)
  expect_equal(results[1, "p_val_adj"], 1)
  expect_equal(rownames(x = results)[1], "TSPO")
})

results <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, reduction = "pca", verbose = FALSE, base = exp(1), pseudocount.use = 1))
test_that("reduction works", {
  expect_equal(results[1, "p_val"], 1.664954e-10, tolerance = 1e-15)
  expect_equal(results[1, "avg_diff"], -2.810453669, tolerance = 1e-6)
  expect_equal(results[1, "p_val_adj"], 3.163412e-09, tolerance = 1e-14)
  expect_equal(rownames(x = results)[1], "PC_2")
})

results <- FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, test.use = "bimod", verbose = FALSE, base = exp(1), pseudocount.use = 1)
test_that("bimod test works", {
  expect_equal(nrow(x = results), 222)
  expect_equal(results[1, "p_val"], 4.751376e-17, tolerance = 1e-22)
  expect_equal(results[1, "avg_logFC"], -2.57219, tolerance = 1e-6)
  expect_equal(results[1, "pct.1"], 0.306)
  expect_equal(results[1, "pct.2"], 1.00)
  expect_equal(results[1, "p_val_adj"], 1.092816e-14, tolerance = 1e-19)
  expect_equal(rownames(x = results)[1], "CST3")
})

results <- FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, test.use = "roc", verbose = FALSE, base = exp(1), pseudocount.use = 1)
test_that("roc test works", {
  expect_equal(nrow(x = results), 222)
  # expect_equal(colnames(x = results), c("myAUC", "avg_diff", "power", "pct.1", "pct.2"))
  expect_equal(colnames(x = results), c("myAUC", "avg_diff", "power", "avg_logFC", "pct.1", "pct.2"))
  expect_equal(results["CST3", "myAUC"], 0.018)
  expect_equal(results["CST3", "avg_diff"], -2.552769, tolerance = 1e-6)
  expect_equal(results["CST3", "power"], 0.964)
  expect_equal(results["CST3", "pct.1"], 0.306)
  expect_equal(results["CST3", "pct.2"], 1.00)
  expect_equal(rownames(x = results)[1], "LYZ")
})

results <- FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, test.use = "t", verbose = FALSE, base = exp(1), pseudocount.use = 1)
test_that("t test works", {
  expect_equal(nrow(x = results), 222)
  expect_equal(results["CST3", "p_val"], 1.170112e-15, tolerance = 1e-20)
  expect_equal(results["CST3", "avg_logFC"], -2.57219, tolerance = 1e-6)
  expect_equal(results["CST3", "pct.1"], 0.306)
  expect_equal(results["CST3", "pct.2"], 1.00)
  expect_equal(results["CST3", "p_val_adj"], 2.691258e-13, tolerance = 1e-18)
  expect_equal(rownames(x = results)[1], "TYMP")
})

results <- suppressWarnings(
  FindMarkers(
    object = pbmc_small,
    ident.1 = 0, ident.2 = 1,
    test.use = "negbinom",
    verbose = FALSE,
    base = exp(1),
    fc.slot = "counts",
    pseudocount.use = 1
  )
)
test_that("negbinom test works", {
  expect_equal(nrow(x = results), 204)
  expect_equal(results["CST3", "p_val"], 1.354443e-17, tolerance = 1e-22)
  expect_equal(results["CST3", "avg_logFC"], -2.878123, tolerance = 1e-6)
  expect_equal(results["CST3", "pct.1"], 0.306)
  expect_equal(results["CST3", "pct.2"], 1.00)
  expect_equal(results["CST3", "p_val_adj"], 3.115218e-15, tolerance = 1e-20)
  expect_equal(rownames(x = results)[1], "LYZ")
})

results <- suppressWarnings(
  FindMarkers(
    object = pbmc_small,
    ident.1 = 0,
    ident.2 = 1,
    test.use = "poisson",
    verbose = FALSE,
    base = exp(1),
    fc.slot = "counts",
    pseudocount.use = 1
  )
)
test_that("poisson test works", {
  expect_equal(nrow(x = results), 204)
  expect_equal(results["CST3", "p_val"], 3.792196e-78, tolerance = 1e-83)
  expect_equal(results["CST3", "avg_logFC"], -2.878123, tolerance = 1e-6)
  expect_equal(results["CST3", "pct.1"], 0.306)
  expect_equal(results["CST3", "pct.2"], 1.00)
  expect_equal(results["CST3", "p_val_adj"], 8.722050e-76, tolerance = 1e-81)
  expect_equal(rownames(x = results)[1], "LYZ")
})

results <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, test.use = "LR", verbose = FALSE, base = exp(1), pseudocount.use = 1))
test_that("LR test works", {
  expect_equal(nrow(x = results), 222)
  expect_equal(results["CST3", "p_val"], 3.990707e-16, tolerance = 1e-21)
  expect_equal(results["CST3", "avg_logFC"], -2.57219, tolerance = 1e-6)
  expect_equal(results["CST3", "pct.1"], 0.306)
  expect_equal(results["CST3", "pct.2"], 1.00)
  expect_equal(results["CST3", "p_val_adj"], 9.178625e-14, tolerance = 1e-19)
  expect_equal(rownames(x = results)[1], "LYZ")
})

test_that("FindMarkers with wilcox_limma works", {
  skip_on_cran()
  skip_if_not_installed("limma")
  markers.0.limma <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = 0, verbose = FALSE, base = exp(1),pseudocount.use = 1,test.use='wilcox_limma'))
  markers.01.limma <- suppressWarnings(FindMarkers(object = pbmc_small, ident.1 = 0, ident.2 = 1, verbose = FALSE, base = exp(1),pseudocount.use = 1,test.use='wilcox_limma'))
  results.clr.limma <- suppressWarnings(FindMarkers(object = clr.obj, ident.1 = 0, ident.2 = 1, verbose = FALSE, base = exp(1), pseudocount.use = 1,test.use='wilcox_limma'))
  results.sct.limma <- suppressWarnings(FindMarkers(object = sct.obj, ident.1 = 0, ident.2 = 1, verbose = FALSE, base = exp(1), pseudocount.use = 1,test.use='wilcox_limma'))

  expect_equal(colnames(x = markers.0.limma), c("p_val", "avg_logFC", "pct.1", "pct.2", "p_val_adj"))
  expect_equal(markers.0.limma[1, "p_val"], 9.572778e-13, tolerance = 1e-18)
  expect_equal(markers.0.limma[1, "avg_logFC"], -4.180029, tolerance = 1e-6)
  expect_equal(markers.0.limma[1, "pct.1"], 0.083)
  expect_equal(markers.0.limma[1, "pct.2"], 0.909)
  expect_equal(markers.0.limma[1, "p_val_adj"], 2.201739e-10, tolerance = 1e-15)
  expect_equal(nrow(x = markers.0.limma), 228)
  expect_equal(rownames(markers.0.limma)[1], "HLA-DPB1")

  expect_equal(markers.01.limma[1, "p_val"], 1.702818e-11, tolerance = 1e-16)
  expect_equal(markers.01.limma[1, "avg_logFC"], -2.638242, tolerance = 1e-6)
  expect_equal(markers.01.limma[1, "pct.1"], 0.111)
  expect_equal(markers.01.limma[1, "pct.2"], 1.00)
  expect_equal(markers.01.limma[1, "p_val_adj"], 3.916481e-09, tolerance = 1e-14)
  expect_equal(nrow(x = markers.01.limma), 222)
  expect_equal(rownames(x = markers.01.limma)[1], "TYMP")

  expect_equal(results.clr.limma[1, "p_val"], 1.209462e-11, tolerance = 1e-16)
  expect_equal(results.clr.limma[1, "avg_logFC"], -2.946633, tolerance = 1e-6)
  expect_equal(results.clr.limma[1, "pct.1"], 0.111)
  expect_equal(results.clr.limma[1, "pct.2"], 0.96)
  expect_equal(results.clr.limma[1, "p_val_adj"], 2.781762e-09, tolerance = 1e-14)
  expect_equal(nrow(x = results.clr.limma), 213)
  expect_equal(rownames(x = results.clr.limma)[1], "S100A8")

  expect_equal(results.sct.limma[1, "p_val"], 6.225491e-11, tolerance = 1e-16)
  expect_equal(results.sct.limma[1, "avg_logFC"], -2.545867, tolerance = 1e-6)
  expect_equal(results.sct.limma[1, "pct.1"], 0.111)
  expect_equal(results.sct.limma[1, "pct.2"], 0.96)
  expect_equal(results.sct.limma[1, "p_val_adj"], 1.369608e-08, tolerance = 1e-13)
  expect_equal(nrow(x = results.sct.limma), 214)
  expect_equal(rownames(x = results.sct.limma)[1], "TYMP")
})

test_that("BPCells FindMarkers gives same results", {
  skip_on_cran()
  skip_if_not_installed("BPCells")
  library(BPCells)
  library(Matrix)
  mat_bpcells <- t(as(t(pbmc_small[['RNA']]$counts ), "IterableMatrix"))
  pbmc_small[['RNAbp']] <- CreateAssay5Object(counts = mat_bpcells)
  pbmc_small <- NormalizeData(pbmc_small, assay = "RNAbp")
  markers.bp <- suppressWarnings(FindMarkers(object = pbmc_small, assay = "RNAbp", ident.1 = 0, verbose = FALSE, base = exp(1),pseudocount.use = 1))
  expect_equal(colnames(x = markers.bp), c("p_val", "avg_logFC", "pct.1", "pct.2", "p_val_adj"))
  expect_equal(markers.bp[1, "p_val"], 9.572778e-13)
  expect_equal(markers.bp[1, "avg_logFC"], -4.180029, tolerance = 1e-6)
  expect_equal(markers.bp[1, "pct.1"], 0.083)
  expect_equal(markers.bp[1, "pct.2"], 0.909)
  expect_equal(markers.bp[1, "p_val_adj"], 2.201739e-10)
  expect_equal(nrow(x = markers.bp), 228)
  expect_equal(rownames(markers.bp)[1], "HLA-DPB1")
})

# Tests for FindAllMarkers
# -------------------------------------------------------------------------------

test_that("FindAllMarkers works as expected", {
  pbmc_copy <- pbmc_small
  Idents(pbmc_copy) <- "orig.ident"

  results <- suppressMessages(suppressWarnings(FindAllMarkers(object = pbmc_small, pseudocount.use = 1)))
  results.clr <- suppressMessages(suppressWarnings(FindAllMarkers(object = clr.obj, pseudocount.use = 1)))
  results.sct <- suppressMessages(suppressWarnings(FindAllMarkers(object = sct.obj, pseudocount.use = 1, vst.flavor = "v1")))
  results.pseudo <- suppressMessages(suppressWarnings(FindAllMarkers(object = pbmc_small, pseudocount.use = 0.1)))
  results.gb <- suppressMessages(suppressWarnings(FindAllMarkers(object = pbmc_copy, pseudocount.use = 1, group.by = "RNA_snn_res.1")))

  expect_equal(colnames(x = results), c("p_val", "avg_log2FC", "pct.1", "pct.2", "p_val_adj", "cluster", "gene"))
  expect_equal(results[1, "p_val"], 9.572778e-13, tolerance = 1e-18)
  expect_equal(results[1, "avg_log2FC"], -6.030507, tolerance = 1e-6)
  expect_equal(results[1, "pct.1"], 0.083)
  expect_equal(results[1, "pct.2"], 0.909)
  expect_equal(results[1, "p_val_adj"], 2.201739e-10, tolerance = 1e-15)
  expect_equal(nrow(x = results), 222)
  expect_equal(rownames(results)[1], "HLA-DPB1")

  # CLR normalization
  expect_equal(results.clr[1, "p_val"], 1.338858e-12, tolerance = 1e-17)
  expect_equal(results.clr[1, "avg_log2FC"], -4.088546, tolerance = 1e-6)
  expect_equal(results.clr[1, "pct.1"], 0.083)
  expect_equal(results.clr[1, "pct.2"], 0.909)
  expect_equal(results.clr[1, "p_val_adj"], 3.079373e-10, tolerance = 1e-15)
  expect_equal(nrow(x = results.clr), 222)
  expect_equal(rownames(x = results.clr)[1], "HLA-DPB1")

  # SCT normalization
  expect_equal(results.sct[1, "p_val"],  4.25861e-12, tolerance = 1e-17)
  expect_equal(results.sct[1, "avg_log2FC"], -5.088014, tolerance = 1e-6)
  expect_equal(results.sct[1, "pct.1"], 0.167)
  expect_equal(results.sct[1, "pct.2"], 0.909)
  expect_equal(results.sct[1, "p_val_adj"], 9.368941e-10, tolerance = 1e-15)
  expect_equal(nrow(x = results.sct), 212)
  expect_equal(rownames(x = results.sct)[1], "HLA-DPB1")

  # pseudocount.use = 0.1
  expect_equal(results.pseudo[1, "p_val"], 9.572778e-13, tolerance = 1e-18)
  expect_equal(results.pseudo[1, "avg_log2FC"], -6.036353, tolerance = 1e-6)
  expect_equal(results.pseudo[1, "pct.1"], 0.083)
  expect_equal(results.pseudo[1, "pct.2"], 0.909)
  expect_equal(results.pseudo[1, "p_val_adj"], 2.201739e-10, tolerance = 1e-15)
  expect_equal(nrow(x = results.pseudo), 222)
  expect_equal(rownames(results.pseudo)[1], "HLA-DPB1")

  # Setting `group.by` the group by parameter is equivalent
  # to setting the object's `Idents` before running `FindAllMarkers`.
  expect_equal(results.gb, results)
})


# Tests for running FindMarkers post integration/transfer
ref <- pbmc_small
ref <- FindVariableFeatures(object = ref, verbose = FALSE, nfeatures = 100)
query <- CreateSeuratObject(CreateAssayObject(
  counts = as.sparse(GetAssayData(object = pbmc_small[['RNA']], layer = "counts") + rpois(n = ncol(pbmc_small), lambda = 1))
))

query2 <- CreateSeuratObject(CreateAssayObject(
  counts = as.sparse(GetAssayData(object = pbmc_small[['RNA']], layer = "counts")[, 1:40] + rpois(n = ncol(pbmc_small), lambda = 1))
))



query.list <- list(query, query2)
query.list <- lapply(X = query.list, FUN = NormalizeData, verbose = FALSE)
query.list <- lapply(X = query.list, FUN = FindVariableFeatures, verbose = FALSE, nfeatures = 100)
query.list <- lapply(X = query.list, FUN = ScaleData, verbose = FALSE)
query.list <- suppressWarnings(lapply(X = query.list, FUN = RunPCA, verbose = FALSE, npcs = 20))

anchors <- suppressMessages(suppressWarnings(FindIntegrationAnchors(object.list = c(ref, query.list), k.filter = NA, verbose = FALSE)))
object <- suppressWarnings(suppressMessages(IntegrateData(anchorset = anchors,  k.weight = 25, verbose = FALSE)))
object <- suppressMessages(ScaleData(object, verbose = FALSE))
object <- suppressMessages(RunPCA(object, verbose = FALSE))
object <- suppressMessages(FindNeighbors(object = object, verbose = FALSE))
object <- suppressMessages(FindClusters(object, verbose = FALSE))
markers <- FindMarkers(object = object, ident.1="0", ident.2="1",pseudocount.use = 1, verbose=FALSE)
test_that("FindMarkers recognizes log normalization", {
  expect_equal(markers[1, "p_val"], 1.598053e-14, tolerance = 1e-19)
  expect_equal(markers[1, "avg_log2FC"], -2.634458, tolerance = 1e-6)
})


test_that("BPCells FindAllMarkers gives same results", {
  skip_on_cran()
  skip_if_not_installed("BPCells")
  library(BPCells)
  library(Matrix)
  mat_bpcells <- t(as(t(pbmc_small[['RNA']]$counts ), "IterableMatrix"))
  pbmc_small[['RNAbp']] <- CreateAssay5Object(counts = mat_bpcells)
  pbmc_small <- NormalizeData(pbmc_small, assay = "RNAbp")

  results.bp <- suppressMessages(suppressWarnings(FindAllMarkers(object = pbmc_small, assay = "RNAbp", pseudocount.use=1)))

  expect_equal(colnames(x = results.bp), c("p_val", "avg_log2FC", "pct.1", "pct.2", "p_val_adj", "cluster", "gene"))
  expect_equal(results.bp[1, "p_val"], 9.572778e-13)
  expect_equal(results.bp[1, "avg_log2FC"], -6.030507, tolerance = 1e-6)
  expect_equal(results.bp[1, "pct.1"], 0.083)
  expect_equal(results.bp[1, "pct.2"], 0.909)
  expect_equal(results.bp[1, "p_val_adj"], 2.201739e-10)
  expect_equal(nrow(x = results.bp), 222)
  expect_equal(rownames(results.bp)[1], "HLA-DPB1")
})



# Tests for FindConservedMarkers
# -------------------------------------------------------------------------------

if (requireNamespace('metap', quietly = TRUE)) {
  context("FindConservedMarkers")
  pbmc_small$groups

  markers <- suppressWarnings(FindConservedMarkers(object = pbmc_small, ident.1 = 0, grouping.var = "groups", verbose = FALSE, base = exp(1), pseudocount.use = 1))

  standard.names <- c("p_val", "avg_logFC", "pct.1", "pct.2", "p_val_adj")

  test_that("FindConservedMarkers works", {
    expect_equal(colnames(x = markers), c(paste0("g2_", standard.names), paste0("g1_", standard.names), "max_pval", "minimump_p_val"))
    expect_equal(markers[1, "g2_p_val"], 4.983576e-05)
    expect_equal(markers[1, "g2_avg_logFC"], -4.364959, tolerance = 1e-6)
    # expect_equal(markers[1, "g2_pct.1"], 0.062)
    expect_equal(markers[1, "g2_pct.2"], 0.75)
    expect_equal(markers[1, "g2_p_val_adj"], 0.0114622238)
    expect_equal(markers[1, "g1_p_val"], 3.946643e-08, tolerance = 1e-13)
    expect_equal(markers[1, "g1_avg_logFC"], -3.69215, tolerance = 1e-6)
    expect_equal(markers[1, "g1_pct.1"], 0.10)
    expect_equal(markers[1, "g1_pct.2"], 0.958)
    expect_equal(markers[1, "g1_p_val_adj"], 9.077279e-06)
    expect_equal(markers[1, "max_pval"], 4.983576e-05)
    expect_equal(markers[1, "minimump_p_val"], 7.893286e-08, tolerance = 1e-13)
    expect_equal(nrow(markers), 219)
    expect_equal(rownames(markers)[1], "HLA-DRB1")
    expect_equal(markers[, "max_pval"], unname(obj = apply(X = markers, MARGIN = 1, FUN = function(x) max(x[c("g1_p_val", "g2_p_val")]))))
  })

  test_that("FindConservedMarkers errors when expected", {
    expect_error(FindConservedMarkers(pbmc_small))
    expect_error(FindConservedMarkers(pbmc_small, ident.1 = 0))
    expect_error(FindConservedMarkers(pbmc_small, ident.1 = 0, grouping.var = "groups", meta.method = "minimump"))
  })

  pbmc.test <- pbmc_small
  Idents(object = pbmc.test) <- "RNA_snn_res.1"
  pbmc.test$id.group <- paste0(pbmc.test$RNA_snn_res.1, "_", pbmc.test$groups)
  pbmc.test <- subset(x = pbmc.test, id.group == "0_g1", invert = TRUE)
  markers.missing <- suppressWarnings(FindConservedMarkers(object = pbmc.test, ident.1 = 0, grouping.var = "groups", test.use = "t", verbose = FALSE, base = exp(1), pseudocount.use = 1))

  test_that("FindConservedMarkers handles missing idents in certain groups", {
    expect_warning(FindConservedMarkers(object = pbmc.test, ident.1 = 0, grouping.var = "groups", test.use = "t"))
    expect_equal(colnames(x = markers.missing), paste0("g2_", standard.names))
    expect_equal(markers.missing[1, "g2_p_val"], 1.672911e-13, tolerance = 1e-18)
    expect_equal(markers.missing[1, "g2_avg_logFC"], -4.796379, tolerance = 1e-6)
    # expect_equal(markers.missing[1, "g2_pct.1"], 0.062)
    expect_equal(markers.missing[1, "g2_pct.2"], 0.95)
    expect_equal(markers.missing[1, "g2_p_val_adj"], 3.847695e-11, tolerance = 1e-16)
    expect_equal(nrow(markers.missing), 226)
    expect_equal(rownames(markers.missing)[1], "HLA-DPB1")
  })
}

