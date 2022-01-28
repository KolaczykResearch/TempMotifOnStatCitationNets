library('ggplot2')

get_counts_distribution = function(journal, delta, motif_order=c(1:36)){
  counts_0 = read.table(paste('../output_counts/counts_', journal, '_0', '.txt', sep=''))
  counts_delta = read.table(paste('../output_counts/counts_', journal, '_', delta, '.txt', sep=''))
  counts_0 = as.matrix(counts_0)
  counts_delta = as.matrix(counts_delta)
  # motif counts with one source of over-count subtracted
  counts = counts_delta - counts_0
  counts_frac = counts/sum(counts)
  counts_frac = counts_frac[motif_order]
  # error
  counts_0_frac = counts_0/sum(counts)
  counts_0_frac = counts_0_frac[motif_order]
  return(list(counts=counts_frac, counts_0=counts_0_frac))
}

#----------
# Figure 1
#----------
## Motif distribution change in journal sub-categories
journal_set = c('all_journals', 'Top4', 'IMS_family', 'RSS_family')
# temp = get_counts_distribution('all_journals', 5)
# motif_order = order(temp$counts)
data = NULL
motif_order = c(12, 11, 5, 6, 20, 27, 
                14, 28, 34, 13, 33, 19, 
                17, 10, 22, 8, 15, 29, 
                32, 9, 25, 30, 7, 2, 
                23, 21, 26, 35, 16, 18, 
                3, 24, 4, 31, 36, 1)
for (journal in journal_set){
  cat(journal,', ')
  aa = get_counts_distribution(journal, 5, motif_order)
  temp = data.frame(Motif=c(1:36), pdf = c(aa$counts), Journal = rep(journal, 36), 
                    Type = rep('Adjusted Counts', 36))
  data = rbind(data, temp)
  temp = data.frame(Motif=c(1:36), pdf = c(aa$counts_0), Journal = rep(journal, 36), 
                    Type = rep('False Counts (due to non-unique timestamps in networks and the restriction of current counting algorithms)', 36))
  data = rbind(data, temp)
}

# bar plot
Journal_names = list(
  'all_journals'='All journals',
  'Top4'='AoS, Bka, JASA, & JRSSB',
  'IMS_family'='IMS family',
  'RSS_family'='RSS family'
)
labeller = function(variable, value){
  return(Journal_names[value])
}
ggplot(data=data, aes(x=Motif, y=pdf, fill=Type)) +
  geom_bar(stat="identity") + 
  facet_wrap(~Journal, labeller=labeller, nrow=2, ncol=2) + 
  theme_bw() + 
  labs(y='Motif Frequency', x='Motif ID') +
  theme(legend.position="bottom") +
  scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9")) + 
  theme(strip.text.x = element_text(size = 15), 
        axis.title = element_text(size = 15),
        legend.text = element_text(size = 15),
        legend.title = element_text(size = 15))

#----------
# Figure 2
#----------
## Motif change in time
motif_order = c(12, 11, 5, 6, 20, 27,
                14, 28, 34, 13, 33, 19, 
                17, 10, 22, 8, 15, 29, 
                32, 9, 25, 30, 7, 2, 
                23, 21, 26, 35, 16, 18, 
                3, 24, 4, 31, 36, 1)
journal_set = c('decade_1', 'decade_2', 'decade_3', 'decade_4')
data = NULL
for (journal in journal_set){
  cat(journal,', ')
  aa = get_counts_distribution(journal, 5, motif_order)
  temp = data.frame(Motif=c(1:36), pdf = c(aa$counts), Journal = rep(journal, 36))
  data = rbind(data, temp)
}
gg_color_hue  = function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}
cols = gg_color_hue(4)
# line plot
ggplot(data=data, aes(x = Motif, y = pdf, shape = Journal, colour = Journal)) + 
  geom_point(size=2) + geom_line() + 
  theme_bw() +
  labs(x='Motif ID', y='Motif Frequency') + 
  theme(legend.position="right") +
  theme(strip.text.x = element_text(size = 15), 
        axis.title = element_text(size = 15),
        legend.text = element_text(size = 15),
        legend.title = element_text(size = 15)) + 
  scale_color_manual(name = 'Year periods', 
                     labels = c("1975-1985", "1986-1995", '1996-2005', '2006-2015'),
                     values = cols) + 
  scale_shape_manual(name = 'Year periods',
                     labels = c("1975-1985", "1986-1995", '1996-2005', '2006-2015'),
                     values = c(21, 17, 18, 4)) 
