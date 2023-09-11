library(colorspace)

divergingx_hcl(palette = "RdYlGn", n = 5)


col2hex <- function(x, alpha = FALSE) {
  args <- as.data.frame(t(col2rgb(x, alpha = alpha)))
  args <- c(args, list(names = x, maxColorValue = 255))
  do.call(rgb, args)
}
col2hex("grey70")


school_enr <- make_mke_rc() |> 
  filter(school_year == "2021-22") |> 
  select(school_name,
         school_enrollment)
