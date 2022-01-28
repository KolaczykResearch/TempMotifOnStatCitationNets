library('dplyr')
library('data.table')

load('../AuthorPaperInfo.RData')

# ------------------------------------------
# Construct raw sequence of interactions
# ------------------------------------------
PapPapMat = PapPapMat[PapPapMat$FromYear>=PapPapMat$ToYear,]
datalist = list()
for(i in 1:nrow(PapPapMat)){
  if ((i %% 1e4) == 0) cat(i, '...\n')
  authors_one = AuPapMat[AuPapMat$idxPap==PapPapMat[i, 1], ]$idxAu
  authors_two = AuPapMat[AuPapMat$idxPap==PapPapMat[i, 2], ]$idxAu
  journal_name1 = AuPapMat[AuPapMat$idxPap==PapPapMat[i, 1], ]$journal[1]
  journal_name2 = AuPapMat[AuPapMat$idxPap==PapPapMat[i, 2], ]$journal[1]
  cart_len = length(authors_one)*length(authors_two)
  temp = data.frame(merge(authors_one, authors_two), 
               rep(PapPapMat[i, ]$FromYear, cart_len), rep(journal_name1, cart_len), 
               rep(PapPapMat[i, 1], cart_len),
               rep(PapPapMat[i, ]$ToYear, cart_len), rep(journal_name2, cart_len),
               rep(PapPapMat[i, 2], cart_len))
  datalist[[i]] = temp
}
AuAuCit = rbindlist(datalist)
colnames(AuAuCit) = c('FromAuId', 'ToAuId', 'FromYear', 'FromJournal', 'FromPap',
                      'ToYear', 'ToJournal', 'ToPap')
write.table(AuAuCit, file = '../data_edge_streams2/data_edge_streams_raw.txt', col.names = T, 
            row.names = F)

# ------------------------------------------
# Preprocess data and get subsequences
# ------------------------------------------
# -------------------------
# for all journals --------
# -------------------------
edges = read.table('../data_edge_streams2/data_edge_streams_raw.txt', header=TRUE) # 2429104
# remove self-cites
edges = edges[edges$FromAuId!=edges$ToAuId, ] # 2325313
# Remove duplicated rows 
edges = (edges[, 1:3] %>% distinct()) # 1768050
# sort 
edges = edges[order(edges$FromYear), ]
write.table(edges, file = '../data_edge_streams2/data_edge_streams_all_journals.txt', col.names = F, 
            row.names = F)

# ------------------------------------
# for each sub-category of journals --
# ------------------------------------
Top4 = c('AoS', 'JASA', 'Bka', 'JRSSB')
IMS_family = c('AoAS', 'AoP', 'AoS', 'StSci', 'EJS', 'JCGS')  
RSS_family = c('JRSSA', 'JRSSB', 'JRSSC')

catergory_set = list()
catergory_set[[1]] = Top4
catergory_set[[2]] = IMS_family
catergory_set[[3]] = RSS_family
category_name_set = c('Top4', 'IMS_family', 'RSS_family')
for (i in c(1:3)){
  edges = read.table('../data_edge_streams2/data_edge_streams_raw.txt', header=TRUE) 
  edges = edges[(edges$FromJournal %in% catergory_set[[i]]) & (edges$ToJournal %in% catergory_set[[i]]),] 
  # remove self-cites
  edges = edges[edges$FromAuId!=edges$ToAuId, ] 
  # Remove duplicated rows 
  edges = (edges[, 1:3] %>% distinct()) 
  # sort 
  edges = edges[order(edges$FromYear), ]
  cat('-->', category_name_set[i], ':', nrow(edges), '\n')
  output = paste('../data_edge_streams2/data_edge_streams_', category_name_set[i], '.txt', sep='')
  write.table(edges, file = output, col.names = F, row.names = F)
}

# -----------------------------------------------------
# split data_edge_streams_all_journals.txt into decades
# -----------------------------------------------------
edges = read.table('../data_edge_streams2/data_edge_streams_all_journals.txt', header = FALSE)
temp1 = edges[edges[, 3]<=1985, ]
temp2 = edges[(edges[, 3]>1985) & (edges[, 3]<=1995), ]
temp3 = edges[(edges[, 3]>1995) & (edges[, 3]<=2005), ]
temp4 = edges[edges[, 3]>2005, ]
write.table(temp1, file = '../data_edge_streams2/data_edge_streams_all_family_decade_1.txt', 
            col.names = F, row.names = F)
write.table(temp2, file = '../data_edge_streams2/data_edge_streams_all_family_decade_2.txt', 
            col.names = F, row.names = F)
write.table(temp3, file = '../data_edge_streams2/data_edge_streams_all_family_decade_3.txt', 
            col.names = F, row.names = F)
write.table(temp4, file = '../data_edge_streams2/data_edge_streams_all_family_decade_4.txt', 
            col.names = F, row.names = F)

# # --------------------------------
# # for each individual journals ---
# # --------------------------------
# journal_name_set = levels(AuPapMat$journal)
# journal_name_set
# # [1] "AIHPP"  "AISM"   "AoAS"   "AoP"    "AoS"    "AuNZ"   "Bay"    "Bcs"    "Bern"   "Biost"  "Bka"    "CanJS"  "CSDA"
# # [14] "CSTM"   "EJS"    "Extrem" "ISRe"   "JASA"   "JCGS"   "JClas"  "JMLR"   "JMVA"   "JNS"    "JoAS"   "JRSSA"  "JRSSB"
# # [27] "JRSSC"  "JSPI"   "JTSA"   "PTRF"   "ScaJS"  "SCmp"   "Sini"   "SMed"   "SPLet"  "StSci"
# length(journal_name_set) # 36
# for (journal_name in journal_name_set){
#   edges = read.table('../data_edge_streams2/data_edge_streams_raw.txt', header=TRUE)
#   edges = edges[(edges$FromJournal==journal_name & edges$ToJournal==journal_name),]
#   # remove self-cites
#   edges = edges[edges$FromAuId!=edges$ToAuId, ]
#   # Remove duplicated rows
#   edges = (edges[, 1:3] %>% distinct())
#   # sort
#   edges = edges[order(edges$FromYear), ]
#   cat('-->', journal_name, ':', nrow(edges), '\n')
#   output = paste('../data_edge_streams2/edge_streams_by_journals/data_edge_streams_', journal_name, '.txt', sep='')
#   write.table(edges, file = output, col.names = F, row.names = F)
# }
