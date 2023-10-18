#!/usr/bin/env bash
set -euo pipefail
set -x

sdk='/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX13.3.sdk'
frameworks="$sdk/System/Library/Frameworks"
includes="$sdk/usr/include"
libs="$sdk/usr/lib"

rm -rf Frameworks/
rm -rf include/
rm -rf lib/

mkdir -p ./Frameworks
mkdir -p ./include
mkdir -p ./lib

# General includes, removing uncommon or useless ones
cp -R $includes/ ./include
rm -rf ./include/apache2

# General libraries
mkdir -p lib/
cp $libs/libobjc.tbd ./lib/
cp $libs/libobjc.A.tbd ./lib/

# General frameworks
cp -R $frameworks/CoreFoundation.framework ./Frameworks/CoreFoundation.framework
cp -R $frameworks/Foundation.framework ./Frameworks/Foundation.framework
cp -R $frameworks/IOKit.framework ./Frameworks/IOKit.framework
cp -R $frameworks/Security.framework ./Frameworks/Security.framework
cp -R $frameworks/CoreServices.framework ./Frameworks/CoreServices.framework
cp -R $frameworks/DiskArbitration.framework ./Frameworks/DiskArbitration.framework
cp -R $frameworks/CFNetwork.framework ./Frameworks/CFNetwork.framework
cp -R $frameworks/ApplicationServices.framework ./Frameworks/ApplicationServices.framework
cp -R $frameworks/ImageIO.framework ./Frameworks/ImageIO.framework

# Audio frameworks
cp -R $frameworks/AudioToolbox.framework ./Frameworks/AudioToolbox.framework
cp -R $frameworks/CoreAudio.framework ./Frameworks/CoreAudio.framework
cp -R $frameworks/CoreAudioTypes.framework ./Frameworks/CoreAudioTypes.framework
cp -R $frameworks/AudioUnit.framework ./Frameworks/AudioUnit.framework

# Graphics frameworks
cp -R $frameworks/Metal.framework ./Frameworks/Metal.framework
cp -R $frameworks/OpenGL.framework ./Frameworks/OpenGL.framework
cp -R $frameworks/CoreGraphics.framework ./Frameworks/CoreGraphics.framework
cp -R $frameworks/IOSurface.framework ./Frameworks/IOSurface.framework
cp -R $frameworks/QuartzCore.framework ./Frameworks/QuartzCore.framework
cp -R $frameworks/CoreImage.framework ./Frameworks/CoreImage.framework
cp -R $frameworks/CoreVideo.framework ./Frameworks/CoreVideo.framework
cp -R $frameworks/CoreText.framework ./Frameworks/CoreText.framework
cp -R $frameworks/ColorSync.framework ./Frameworks/ColorSync.framework

# GLFW dependencies
cp -R $frameworks/Carbon.framework ./Frameworks/Carbon.framework
cp -R $frameworks/Cocoa.framework ./Frameworks/Cocoa.framework
cp -R $frameworks/AppKit.framework ./Frameworks/AppKit.framework
cp -R $frameworks/CoreData.framework ./Frameworks/CoreData.framework
cp -R $frameworks/CloudKit.framework ./Frameworks/CloudKit.framework
cp -R $frameworks/CoreLocation.framework ./Frameworks/CoreLocation.framework
cp -R $frameworks/Kernel.framework ./Frameworks/Kernel.framework

# Remove unnecessary files
find . | grep '\.swiftmodule' | xargs rm -rf
rm -rf Frameworks/IOKit.framework/Versions/A/Headers/ndrvsupport
rm -rf Frameworks/IOKit.framework/Versions/A/Headers/pwr_mgt
rm -rf Frameworks/IOKit.framework/Versions/A/Headers/scsi
rm -rf Frameworks/IOKit.framework/Versions/A/Headers/firewire
rm -rf Frameworks/IOKit.framework/Versions/A/Headers/storage
rm -rf Frameworks/IOKit.framework/Versions/A/Headers/usb

# Trim large frameworks

# 4.9M -> 1M
cat ./Frameworks/Foundation.framework/Versions/C/Foundation.tbd | grep -v 'libswiftFoundation' > tmp
mv tmp ./Frameworks/Foundation.framework/Versions/C/Foundation.tbd

# 13M -> 368K
find ./Frameworks/Kernel.framework -type f | grep -v IOKit/hidsystem | xargs rm -rf

# 29M -> 28M
find . | grep '\.apinotes' | xargs rm -rf
find . | grep '\.r' | xargs rm -rf
find . | grep '\.modulemap' | xargs rm -rf

# 668K
rm ./Frameworks/OpenGL.framework/Versions/A/Libraries/libLLVMContainer.tbd

# 672K
rm ./Frameworks/OpenGL.framework/Versions/A/Libraries/3425AMD/libLLVMContainer.tbd

# 444K
rm ./Frameworks/CloudKit.framework/Versions/A/CloudKit.tbd

# Remove broken symlinks
find . -type l ! -exec test -e {} \; -print | xargs rm

# # Replace symlinks with their actual file contents
# dir=Frameworks
# tar -hcf tmp.tar $dir && rm -rf $dir && mkdir tmp && tar -xf tmp.tar
# rm -rf tmp tmp.tar

# dir=include
# tar -hcf tmp.tar $dir && rm -rf $dir && mkdir tmp && tar -xf tmp.tar
# rm -rf tmp tmp.tar

# dir=lib
# tar -hcf tmp.tar $dir && rm -rf $dir && mkdir tmp && tar -xf tmp.tar
# rm -rf tmp tmp.tar

# rm -r Frameworks/Security.framework/Headers
# rm -r Frameworks/QuartzCore.framework/Headers
# rm -r Frameworks/OpenGL.framework/Headers
# rm -r Frameworks/Metal.framework/Headers
# rm -r Frameworks/Kernel.framework/Headers
# rm -r Frameworks/ImageIO.framework/Headers
# rm -r Frameworks/IOSurface.framework/Headers
# rm -r Frameworks/IOKit.framework/Headers
# rm -r Frameworks/Foundation.framework/Headers
# rm -r Frameworks/DiskArbitration.framework/Headers
# rm -r Frameworks/CoreVideo.framework/Headers
# rm -r Frameworks/CoreText.framework/Headers
# rm -r Frameworks/CoreServices.framework/Headers
# rm -r Frameworks/CoreLocation.framework/Headers
# rm -r Frameworks/CoreImage.framework/Headers
# rm -r Frameworks/CoreGraphics.framework/Headers
# rm -r Frameworks/CoreFoundation.framework/Headers
# rm -r Frameworks/CoreData.framework/Headers
# rm -r Frameworks/CoreAudioTypes.framework/Headers
# rm -r Frameworks/CoreAudio.framework/Headers
# rm -r Frameworks/ColorSync.framework/Headers
# rm -r Frameworks/Cocoa.framework/Headers
# rm -r Frameworks/CloudKit.framework/Headers
# rm -r Frameworks/Carbon.framework/Headers
# rm -r Frameworks/CFNetwork.framework/Headers
# rm -r Frameworks/AudioUnit.framework/Headers
# rm -r Frameworks/AudioToolbox.framework/Headers
# rm -r Frameworks/ApplicationServices.framework/Headers
# rm -r Frameworks/AppKit.framework/Headers

# # Now that /Versions/Current symlinks are realized, we no longer need the duplicate
# find Frameworks | grep '/Versions/A/' | xargs rm -rf
# find Frameworks | grep '/Versions/C/' | xargs rm -rf
