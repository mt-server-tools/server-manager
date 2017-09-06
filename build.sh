# This is a developer script.
# Before comitting a release, run this script
# You will need bash-builder [1] to run the build task
#
# [1] https://github.com/taikedz/bash-builder

# Build the main install script
BUILDOUTD=./ bbuild sh-src/install

# Build the main executable
BUILDOUTD=./pkg/usr/share/mt-server-tools/bin bbuild sh-src/mtst
