#!/bin/sh
 
 
# Download Neko
 
curl -L http://nekovm.org/_media/neko-2.0.0-osx.tar.gz > neko-2.0.0-osx.tar.gz
 
 
# Extract and copy files to /usr/lib/neko
 
tar xvzf neko-2.0.0-osx.tar.gz
sudo mkdir -p /usr/lib/neko
sudo cp -r neko-2.0.0-osx/* /usr/lib/neko
 
 
# Add symlinks
 
sudo rm -rf /usr/bin/neko
sudo rm -rf /usr/bin/nekoc
sudo rm -rf /usr/bin/nekotools
sudo rm -rf /usr/lib/libneko.dylib
 
sudo ln -s /usr/lib/neko/neko /usr/bin/neko
sudo ln -s /usr/lib/neko/nekoc /usr/bin/nekoc
sudo ln -s /usr/lib/neko/nekotools /usr/bin/nekotools
sudo ln -s /usr/lib/neko/libneko.dylib /usr/lib/libneko.dylib
 
 
# Cleanup
 
rm -r neko-2.0.0-osx
rm neko-2.0.0-osx.tar.gz
 
 
# Rebuild haxelib
 
cd /usr/lib/haxe/std/tools/haxelib
sudo haxe haxelib.hxml
sudo cp ./haxelib /usr/lib/haxe/haxelib
