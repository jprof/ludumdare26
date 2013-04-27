
OUTDIR=out

build:
	mkdir -p $(OUTDIR)/lib
	cp -r lib $(OUTDIR)/
	cp -r assets $(OUTDIR)/
	cp index.html $(OUTDIR)/.
	coffee --compile --output $(OUTDIR)/lib coffee/

toServer: build
	scp -r out/* ludumdare@tourian:~/public_html/$(USER)/.

.PHONY: build

clean:
	rm -rf $(OUTDIR)
