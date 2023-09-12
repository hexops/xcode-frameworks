#!/usr/bin/env bash
set -euo pipefail
set -x

sdk='/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX13.3.sdk'
frameworks="$sdk/System/Library/Frameworks"
includes="$sdk/usr/include"
libs="$sdk/usr/lib"

rm -rf System/Library/Frameworks/

mkdir -p ./System/Library/Frameworks

# General includes
mkdir -p ./usr/include/libDER/
cp $includes/libDER/DERItem.h ./usr/include/libDER/
cp $includes/libDER/libDER_config.h ./usr/include/libDER/
mkdir -p ./usr/include/cups
cp -R $includes/cups ./usr/include/

# General libraries
mkdir -p ./usr/lib/
cp $libs/libobjc.tbd ./usr/lib/
cp $libs/libobjc.A.tbd ./usr/lib/

# General frameworks
cp -R $frameworks/CoreFoundation.framework ./System/Library/Frameworks/CoreFoundation.framework
cp -R $frameworks/Foundation.framework ./System/Library/Frameworks/Foundation.framework
cp -R $frameworks/IOKit.framework ./System/Library/Frameworks/IOKit.framework
cp -R $frameworks/Security.framework ./System/Library/Frameworks/Security.framework
cp -R $frameworks/CoreServices.framework ./System/Library/Frameworks/CoreServices.framework
cp -R $frameworks/DiskArbitration.framework ./System/Library/Frameworks/DiskArbitration.framework
cp -R $frameworks/CFNetwork.framework ./System/Library/Frameworks/CFNetwork.framework
cp -R $frameworks/ApplicationServices.framework ./System/Library/Frameworks/ApplicationServices.framework
cp -R $frameworks/ImageIO.framework ./System/Library/Frameworks/ImageIO.framework

# Audio frameworks
cp -R $frameworks/AudioToolbox.framework ./System/Library/Frameworks/AudioToolbox.framework
cp -R $frameworks/CoreAudio.framework ./System/Library/Frameworks/CoreAudio.framework
cp -R $frameworks/CoreAudioTypes.framework ./System/Library/Frameworks/CoreAudioTypes.framework
cp -R $frameworks/AudioUnit.framework ./System/Library/Frameworks/AudioUnit.framework

# Graphics frameworks
cp -R $frameworks/Metal.framework ./System/Library/Frameworks/Metal.framework
cp -R $frameworks/OpenGL.framework ./System/Library/Frameworks/OpenGL.framework
cp -R $frameworks/CoreGraphics.framework ./System/Library/Frameworks/CoreGraphics.framework
cp -R $frameworks/IOSurface.framework ./System/Library/Frameworks/IOSurface.framework
cp -R $frameworks/QuartzCore.framework ./System/Library/Frameworks/QuartzCore.framework
cp -R $frameworks/CoreImage.framework ./System/Library/Frameworks/CoreImage.framework
cp -R $frameworks/CoreVideo.framework ./System/Library/Frameworks/CoreVideo.framework
cp -R $frameworks/CoreText.framework ./System/Library/Frameworks/CoreText.framework
cp -R $frameworks/ColorSync.framework ./System/Library/Frameworks/ColorSync.framework

# GLFW dependencies
cp -R $frameworks/Carbon.framework ./System/Library/Frameworks/Carbon.framework
cp -R $frameworks/Cocoa.framework ./System/Library/Frameworks/Cocoa.framework
cp -R $frameworks/AppKit.framework ./System/Library/Frameworks/AppKit.framework
cp -R $frameworks/CoreData.framework ./System/Library/Frameworks/CoreData.framework
cp -R $frameworks/CloudKit.framework ./System/Library/Frameworks/CloudKit.framework
cp -R $frameworks/CoreLocation.framework ./System/Library/Frameworks/CoreLocation.framework
cp -R $frameworks/Kernel.framework ./System/Library/Frameworks/Kernel.framework

# Remove unnecessary files
find . | grep '\.swiftmodule' | xargs rm -rf
rm -rf ./System/Library/Frameworks/IOKit.framework/Versions/A/Headers/ndrvsupport
# rm -rf ./System/Library/Frameworks/IOKit.framework/Versions/A/Headers/pwr_mgt
rm -rf ./System/Library/Frameworks/IOKit.framework/Versions/A/Headers/scsi
rm -rf ./System/Library/Frameworks/IOKit.framework/Versions/A/Headers/firewire
rm -rf ./System/Library/Frameworks/IOKit.framework/Versions/A/Headers/storage
rm -rf ./System/Library/Frameworks/IOKit.framework/Versions/A/Headers/usb

# Trim large frameworks

# 4.9M -> 1M
cat ./System/Library/Frameworks/Foundation.framework/Versions/C/Foundation.tbd | grep -v 'libswiftFoundation' > tmp
mv tmp ./System/Library/Frameworks/Foundation.framework/Versions/C/Foundation.tbd

# 13M -> 368K
find ./System/Library/Frameworks/Kernel.framework -type f | grep -v IOKit/hidsystem | xargs rm -rf

# 29M -> 28M
find . | grep '\.apinotes' | xargs rm -rf
find . | grep '\.r' | xargs rm -rf
find . | grep '\.modulemap' | xargs rm -rf

# 668K
rm ./System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libLLVMContainer.tbd

# 672K
rm ./System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/3425AMD/libLLVMContainer.tbd

# 444K
rm ./System/Library/Frameworks/CloudKit.framework/Versions/A/CloudKit.tbd
