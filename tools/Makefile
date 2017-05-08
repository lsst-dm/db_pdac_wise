CC=g++
CFLAGS=-std=c++11

all: unl2tsv allwise_p3as_cdd_tbl2tsv allwise_p3am_cdd_tbl2tsv  allsky_4band_p1bm_frm_tbl2tsv allsky_3band_p1bm_frm_tbl2tsv allsky_2band_p1bm_frm_tbl2tsv

unl2tsv: unl2tsv.cc
	$(CC) $(CFLAGS) -o $@ $<

allwise_p3as_cdd_tbl2tsv: allwise_p3as_cdd_tbl2tsv.cc
	$(CC) $(CFLAGS) -o $@ $<

allwise_p3am_cdd_tbl2tsv: allwise_p3am_cdd_tbl2tsv.cc
	$(CC) $(CFLAGS) -o $@ $<
allsky_4band_p1bm_frm_tbl2tsv: allsky_4band_p1bm_frm_tbl2tsv.cc
	$(CC) $(CFLAGS) -o $@ $<

allsky_3band_p1bm_frm_tbl2tsv: allsky_3band_p1bm_frm_tbl2tsv.cc
	$(CC) $(CFLAGS) -o $@ $<

allsky_2band_p1bm_frm_tbl2tsv: allsky_2band_p1bm_frm_tbl2tsv.cc
	$(CC) $(CFLAGS) -o $@ $<
