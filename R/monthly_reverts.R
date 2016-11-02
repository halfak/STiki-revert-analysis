library(data.table)
library(ggplot2)

mr = data.table(read.table("../datasets/enwiki.monthly_stiki_reverts.tsv",
                           sep="\t", header=T))
mr$month = as.Date(paste(mr$month, "01"), format="%Y%m%d")

ggplot(
  mr[,list(reverts=sum(reverts), reverted_edits=sum(reverted_edits)),month],
  aes(x=month, y=reverts)
) +
theme_bw() +
geom_bar(stat="identity", color="#cccccc", fill="#eeeeee") +
geom_line(aes(y=reverted_edits))
