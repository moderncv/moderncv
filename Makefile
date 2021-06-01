.ONESHELL:
SHELL := /bin/bash
MODERNCVDIR =.
MANUALDIR = $(MODERNCVDIR)/manual

# version and date of the current release. This gets updated upon calling
# either the rule version or the rule release
VERSION = v2.1.0-40-gfe4d968-dirty
VERSIONDATE = 2021/01/25
# user callable NEW option, to specify the new version. If unspecified, the
# new version gets determined by git.
ifdef NEW
    VERSIONNEXT = $(NEW)
else
    VERSIONNEXT = $(shell git describe --tags --dirty)
endif
VERSIONDATENEXT = $(shell date +"%Y\/%m\/%d")
TARBALL=moderncv-$(VERSIONNEXT).tar

EXAMPLESDIR = examples
# MANUALTEX is used by the userguide method that operates in the 
# $(MANUALDIR) folder. MANUAL is used by methods operating in 
# the $(MODERNCVDIR) folder. This is to ensuer that the userguide 
# is also buildable within the manual folder.
MANUALTEX = moderncv_userguide.tex
MANUAL = $(MANUALDIR)/$(MANUALTEX)
TEMPLATE = $(MODERNCVDIR)/template.tex
TEMPLATEBIB = publications.bib
TEMPLATEBASE = $(basename $(TEMPLATE))
TEMPLATEPDF = $(addsuffix .pdf,$(TEMPLATEBASE))
MANUAL_BASE = $(basename $(MANUAL))
MANUALPDF = $(addsuffix .pdf,$(MANUAL_BASE))

# redefine the template rule depending on whether the user has specified STYLE
# or not.
ifdef STYLE
	# in this case user has specified STYLE
else
	STYLE = casual
endif
template: $(TEMPLATE) $(TEMPLATEBIB)
	if [[ $(strip $(STYLE)) == "casual" ]]; then
		# build template in default style
		latexmk -pdflua -bibtex -quiet "$<"
	else
		# build template in style $(STYLE). This assumes that casual is the default.
		sedstring="s/moderncvstyle{casual}/moderncvstyle{$(STYLE)}/g"
		sed -i $$sedstring $(TEMPLATE)
		# build template in specified style
		latexmk -pdflua -bibtex -quiet "$<"
		# reset template to default value
		sedstring="s/moderncvstyle{$(STYLE)}/moderncvstyle{casual}/g"
		sed -i $$sedstring $(TEMPLATE)
	fi


templates: $(TEMPLATE) $(TEMPLATEBIB)
	# build the template for each style and store pdfs in the examples folder
	# this is done to include these expamples in release tar balls.
	mkdir -p $(EXAMPLESDIR)
	previousstyle="casual"
	for style in casual classic banking oldstyle fancy; do
		sedstring="s/moderncvstyle{$$previousstyle}/moderncvstyle{$$style}/g"
		sed -i $$sedstring $(TEMPLATE)
		latexmk -pdflua -bibtex -quiet $(TEMPLATE)
		cp $(TEMPLATEPDF) $(EXAMPLESDIR)/$(TEMPLATEBASE)-$$style.pdf
		mv $(TEMPLATEPDF) $(MANUALDIR)/$(TEMPLATEBASE)-$$style.pdf
		previousstyle=$$style
		unset sedstring
	done
	sedstring="s/moderncvstyle{$$previousstyle}/moderncvstyle{casual}/g"
	sed -i $$sedstring $(TEMPLATE)


userguide: templates $(MANUAL)
	# build the user guide. Since the guide includes the template examples, we
	# build those first by calling the templates rule.
	cd $(MANUALDIR)
	./format_files_for_userguide.py 
	lualatex $(MANUALTEX)
	lualatex $(MANUALTEX)
	cd ..


version:
	# Upate version information and date of all moderncv files. A call make version
	# will define VERSIONNEXT=$(shell git describe --tags). Alternatively, call
	# "make version NEW=v5.13.298" to set v5.13.298 as the new version number.
	# The date gets calculated by the date function.
	if [[ $(strip $(VERSION)) == $(strip $(VERSIONNEXT)) ]]; then
		echo "Old version number $(VERSION)  same as new version number $(VERSIONNEXT)"
		echo "nothing to do, aborting."
	else
		# we need to split the $(VERSION) date format into substrings to using
		# sed. This is due to / being a special character in sed.
		YEAR=$(shell echo $(VERSIONDATE) | cut -d "/" -f 1)
		MONTH=$(shell echo $(VERSIONDATE) | cut -d "/" -f 2)
		DAY=$(shell echo $(VERSIONDATE) | cut -d "/" -f 3)
		# update version info and date of *.sty, *.cls and *.tex files
		# prepare find and replace with sed
		findstr="$$YEAR\\/$$MONTH\\/$$DAY $(VERSION)"
		replacestr="$(VERSIONDATENEXT) $(VERSIONNEXT)"
		for currentdir in $(MODERNCVDIR) $(MANUALDIR); do
			for file in $$currentdir/*.cls $$currentdir/*.sty $$currentdir/*.tex; do
				if [[ -f "$$file" ]] && [[ ! -h "$$file" ]]; then
					echo "updating version info of file $$file to $(VERSIONNEXT) (was $(VERSION))";
					sed -i "s/$$findstr/$$replacestr/g" $$file;
					# update version info in the title of documentation
					sed -i "s/Package version $(VERSION)}/Package version $(VERSIONNEXT)}/g" $$file;
				fi
			done
		done
		unset findstr; unset replacestr
		# update VERSION and VERSIONDATE variable of this very file
		sed -i "s/VERSION = $(VERSION)/VERSION = $(VERSIONNEXT)/g" $(MODERNCVDIR)/Makefile
		findstr="VERSIONDATE = $$YEAR\\/$$MONTH\\/$$DAY"
		replacestr="VERSIONDATE = $(shell date +"%Y")\\/$(shell date +"%m")\\/$(shell date +"%d")"
		sed -i "s/$$findstr/$$replacestr/g" $(MODERNCVDIR)/Makefile
		unset findstr; unset replacestr
	fi

tarball:
	# build a tarball for release puposes. If the examples directory exist,
	# include them
	# remove existing tarballs
	rm -f *.gz *.tar
	# create tar with all files in git repo
	git archive HEAD > $(TARBALL)
	# remove git specific files
	tar -f $(TARBALL) --delete .github/ .gitignore create-release-tarball.sh
	# if examples exist include them in the tarball
	if [[ -d "$(EXAMPLESDIR)" ]]; then
		tar -rf $(TARBALL) --append $(EXAMPLESDIR)
	fi
	# include precompiled template pdfs and userguide from manual folder,
	# the idea being that the userguide can be build from the manual folder
	# and has everything that it needs to compile. If the release method gets
	# called this ensures that a precompiled version of the userguide is
	# included in the tar ball.
	tar -rf $(TARBALL) --append $(MANUALDIR)
	# compress
	gzip $(TARBALL)

release: userguide version clean tarball

#.PHONY: clean
clean:
	for dir in $(MODERNCVDIR) $(MANUALDIR); do
		echo cleaning directory $$dir
		cd $$dir/
		rm -fv *.acn *.acr *.alg *.aux *.bcf *.blg *.dvi *.fdb_latexmk *.fls;
		rm -fv *.glg *.idx *.ilg *.ist *.spl *.lof *.log *.lot *.out *.pdfsync;
		rm -fv *.run.xml *.snm *.synctex.gz *.tdo *.toc *.vrb *blx.bib *~;
		if [[ "$$dir" != "." ]]; then
			cd ..
		fi
	done

delete:
	rm -fv $(TEMPLATEPDF)
	rm -fv $(MANUALPDF)

deleteexamples:
	rm -rfv $(EXAMPLESDIR)
	rm -fv $(MANUALDIR)/*.pdf

force:  delete deleteexamples userguide clean
