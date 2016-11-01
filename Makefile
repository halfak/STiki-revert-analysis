
# host=enwiki.labsdb
# user=u2041
host=analytics-store.eqiad.wmnet
user=research

mysql_args = -h $(host) -u $(user)
mysqlc = mysql $(mysql_args)
mysqlc_import = mysqlimport $(mysql_args) --local



datasets/enwiki.monthly_stiki_reverts.tsv: sql/monthly_stiki_reverts.sql
	cat sql/monthly_stiki_reverts.sql | \
	$(mysqlc) enwiki > \
	datasets/enwiki.monthly_stiki_reverts.tsv
