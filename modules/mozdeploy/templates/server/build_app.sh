#!/bin/bash

. /data/<%= cluster %>/mozdeploy.cfg

VERSION=$1

/usr/bin/mozdeploy-build-app --hostroot "$HOSTROOT" --build_dir "$BUILD_DIR" --app "<%= app_name %>" --command "<%= build_command %>" --version "$VERSION"
