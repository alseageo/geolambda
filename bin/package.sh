#!/bin/bash

# directory used for deployment
export DEPLOY_DIR=lambda

echo Creating deploy package

# make deployment directory and add lambda handler
mkdir -p $DEPLOY_DIR/lib

# copy libs
cp -P ${PREFIX}/lib/*.so* $DEPLOY_DIR/lib/
cp -P ${PREFIX}/lib64/libjpeg*.so* $DEPLOY_DIR/lib/

strip $DEPLOY_DIR/lib/* || true

# copy GDAL_DATA files over
mkdir -p $DEPLOY_DIR/share
rsync -ax $PREFIX/share/gdal $DEPLOY_DIR/share/

# copy gdal binaries over
rsync -ax $PREFIX/bin/gdal* $DEPLOY_DIR/bin/
rsync -ax $PREFIX/bin/ogr* $DEPLOY_DIR/bin/

# needed by ogr2ogr
ldd /usr/local/bin/ogr2ogr | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -v '{}' $DEPLOY_DIR/lib/

# zip up deploy package
cd $DEPLOY_DIR
zip -ruq ../lambda-deploy.zip ./
