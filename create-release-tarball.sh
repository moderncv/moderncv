#!/bin/sh
# script to create a tarball for the files that should be in the CTAN upload
#
# do not forget to replace comments/headers beforehand
# 1. date and version in moderncv_userguide.tex
# 2. find . -type f -exec sed -i 's/$OLD_DATE $OLD_VERSION/$NEW_DATE $NEW_VERSION/g' {} \;
# 3. find . -type f -exec sed -i 's|-$OLD_YEAR moderncv maintainers (github.com/moderncv)|-$NEW_YEAR moderncv maintainers (github.com/moderncv)|g' {} \;

# fetch version via git
VERSION=$(git describe --tags --dirty)
TARBALL=moderncv-$VERSION.tar

# remove existing tarballs
rm -f $TARBALL $TARBALL.gz

# create tar with all files in git repo
git archive --prefix=moderncv/ HEAD > $TARBALL

# remove git specific files
tar -f $TARBALL --delete moderncv/.github/ moderncv/.gitignore moderncv/create-release-tarball.sh moderncv/.codespellrc

# compress
gzip $TARBALL
