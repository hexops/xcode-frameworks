#!/usr/bin/env bash
set -euo pipefail
set -x

sdk='/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX13.3.sdk'
frameworks="$sdk/System/Library/Frameworks"
includes="$sdk/usr/include"
libs="$sdk/usr/lib"

rm -rf Frameworks/

mkdir -p ./Frameworks
mkdir -p ./include
mkdir -p ./lib

# General includes
mkdir -p include/libDER/
cp $includes/libDER/DERItem.h ./include/libDER/
cp $includes/libDER/libDER_config.h ./include/libDER/
mkdir -p include/cups
cp -R $includes/cups ./include/

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

# Remove unnecessary files
find . | grep '\.swiftmodule' | xargs rm -rf
rm -rf Frameworks/IOKit.framework/Versions/A/Headers/ndrvsupport
rm -rf Frameworks/IOKit.framework/Versions/A/Headers/pwr_mgt
rm -rf Frameworks/IOKit.framework/Versions/A/Headers/scsi
rm -rf Frameworks/IOKit.framework/Versions/A/Headers/firewire
rm -rf Frameworks/IOKit.framework/Versions/A/Headers/storage
rm -rf Frameworks/IOKit.framework/Versions/A/Headers/hid
rm -rf Frameworks/IOKit.framework/Versions/A/Headers/usb



# rm -rf ./root ./MacOSX13.3.sdk
# mkdir -p MacOSX13.3.sdk
# cp -R /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX13.3.sdk/* ./MacOSX13.3.sdk/
# cp -R /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX13.3.sdk/* ./MacOSX13.3.sdk/

# # Remove unnecessary files (570M -> 112M)
# rm -rf MacOSX13.3.sdk/usr/include/apache2
# rm -rf MacOSX13.3.sdk/usr/share/man/
# rm -rf MacOSX13.3.sdk/System/PrivateFrameworks/
# rm -rf MacOSX13.3.sdk/System/Library/PrivateFrameworks
# rm -rf MacOSX13.3.sdk/usr/lib/swift
# rm -rf MacOSX13.3.sdk/System/iOSSupport/usr/lib/swift
# rm -rf MacOSX13.3.sdk/System/Library/Perl/

# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/MusicKit.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/TabularData.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/RealityFoundation.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/CreateML.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/SwiftUI.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/Ruby.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/Python.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/SwiftUI.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/Combine.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/Accelerate.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/WebKit.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/Python.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/RealityKit.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/AVFoundation.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/Intents.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/CoreTelephony.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/Quartz.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/OpenCL.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/CryptoKit.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/DriverKit.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/Tcl.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/Tk.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/IOBluetooth.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/DiscRecording.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/JavaScriptCore.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/HIDDriverKit.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/GameKit.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/SceneKit.framework
# rm -rf MacOSX13.3.sdk/System/Library/Frameworks/WidgetKit.framework

# mv MacOSX13.3.sdk root

# # Remove reexported libraries section from all tbd files. These have absolute paths that zld would
# # not be able to resolve unless sysroot was set.
# # See https://github.com/hexops/mach/issues/108
# go build ./strip-reexported.go 
# find root/System -type f -name "*.tbd" -print0 | xargs -P128 -n1 -0 -- ./strip-reexported

