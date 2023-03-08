# setup -------------------------------------------------------------------
# library(survminer)

ff.col <- "steelblue" # good for single groups scale fill/color brewer
ff.pal <- "Paired"    # good for binary groups scale fill/color brewer

gg <- analytical %>%
  ggplot() +
  scale_color_brewer(palette = ff.pal) +
  scale_fill_brewer(palette = ff.pal) +
  theme_ff()

# plots -------------------------------------------------------------------

gg.outcome <- gg +
  geom_density(
    data = analytical %>%
      select(exposure, age, gender, cal = outcome, rec, pd, tp,) %>%
      pivot_longer(c(cal, rec, pd, tp)),
    aes(value, fill = exposure), alpha = .8) +
  # geom_bar(aes(outcome, fill = exposure)) +
  facet_wrap(~name, scales = "free") +
  labs(
    # x = attr(analytical$outcome, "label"),
    x = "",
    y = "Distribution density",
    fill = "",
    caption = paste("N = ", Nobs_final),
  )

gg.age <- gg +
  geom_density(aes(age, fill = gender), alpha = .8) +
  labs(
    x = attr(analytical$age, "label"),
    # x = "",
    y = "Distribution density",
    fill = "",
    caption = paste("N = ", Nobs_final),
  )

# cool facet trick from https://stackoverflow.com/questions/3695497 by JWilliman
# gg +
#   geom_histogram(bins = 5, aes(outcome, y = ..count../tapply(..count.., ..PANEL.., sum)[..PANEL..]), fill = ff.col) +
#   scale_y_continuous(labels = scales::label_percent(accuracy = 1)) +
#   xlab(attr(analytical$outcome, "label")) +
#   ylab("") +
#   facet_wrap(~ exposure, ncol = 2)
