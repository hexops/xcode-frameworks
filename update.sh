#!/usr/bin/env bash
set -eu

if [[ $(id -u) -ne 0 ]]; then
    clear
    echo -e "Superuser is required for \"${BASH_SOURCE[*]}\", please run it with either sudo or doas.\n" >&2
    exit 1
fi

readonly sdk="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX13.3.sdk"
if [[ ! -d "${sdk}" ]]; then
    clear
    echo -e "\nERROR: Directory \"${sdk}\" does not exist. \
    \nPlease install Command Line Tools for Xcode! \
    \nIf this is a bug, make a pull request updating the macOS SDK version.\n"
    exit 1
fi

readonly frameworks="${sdk}/System/Library/Frameworks"
readonly includes="${sdk}/usr/include"
readonly libs="${sdk}/usr/lib"

# Cosmetic. Debug using https://bashdb.sourceforge.net/ if there's issues.
set -x

# Remove prior output of the script you are currently inside.
rm -rf "Frameworks/"

mkdir -p "{./Frameworks, ./include, ./lib}"

# General includes
mkdir -p "include/libDER/"
cp "${includes}/libDER/DERItem.h" ./include/libDER/
cp "${includes}/libDER/libDER_config.h" ./include/libDER/
mkdir -p include/cups
cp -R "${includes}"/cups ./include/

# General libraries
mkdir -p lib/
cp "${libs}"/libobjc.tbd ./lib/
cp "${libs}"/libobjc.A.tbd ./lib/

# General frameworks
cp -R "${frameworks}/CoreFoundation.framework"       "./Frameworks/CoreFoundation.framework"
cp -R "${frameworks}/Foundation.framework"           "./Frameworks/Foundation.framework"
cp -R "${frameworks}/IOKit.framework"                "./Frameworks/IOKit.framework"
cp -R "${frameworks}/Security.framework"             "./Frameworks/Security.framework"
cp -R "${frameworks}/CoreServices.framework"         "./Frameworks/CoreServices.framework"
cp -R "${frameworks}/DiskArbitration.framework"      "./Frameworks/DiskArbitration.framework"
cp -R "${frameworks}/CFNetwork.framework"            "./Frameworks/CFNetwork.framework"
cp -R "${frameworks}/ApplicationServices.framework"  "./Frameworks/ApplicationServices.framework"
cp -R "${frameworks}/ImageIO.framework"              "./Frameworks/ImageIO.framework"

# Audio frameworks
cp -R "${frameworks}/AudioToolbox.framework"    "./Frameworks/AudioToolbox.framework"
cp -R "${frameworks}/CoreAudio.framework"       "./Frameworks/CoreAudio.framework"
cp -R "${frameworks}/CoreAudioTypes.framework"  "./Frameworks/CoreAudioTypes.framework"
cp -R "${frameworks}/AudioUnit.framework"       "./Frameworks/AudioUnit.framework"

# Graphics frameworks
cp -R "${frameworks}/Metal.framework"         "./Frameworks/Metal.framework"
cp -R "${frameworks}/OpenGL.framework"        "./Frameworks/OpenGL.framework"
cp -R "${frameworks}/CoreGraphics.framework"  "./Frameworks/CoreGraphics.framework"
cp -R "${frameworks}/IOSurface.framework"     "./Frameworks/IOSurface.framework"
cp -R "${frameworks}/QuartzCore.framework"    "./Frameworks/QuartzCore.framework"
cp -R "${frameworks}/CoreImage.framework"     "./Frameworks/CoreImage.framework"
cp -R "${frameworks}/CoreVideo.framework"     "./Frameworks/CoreVideo.framework"
cp -R "${frameworks}/CoreText.framework"      "./Frameworks/CoreText.framework"
cp -R "${frameworks}/ColorSync.framework"     "./Frameworks/ColorSync.framework"

# GLFW dependencies
cp -R "${frameworks}/Carbon.framework"        "./Frameworks/Carbon.framework"
cp -R "${frameworks}/Cocoa.framework"         "./Frameworks/Cocoa.framework"
cp -R "${frameworks}/AppKit.framework"        "./Frameworks/AppKit.framework"
cp -R "${frameworks}/CoreData.framework"      "./Frameworks/CoreData.framework"
cp -R "${frameworks}/CloudKit.framework"      "./Frameworks/CloudKit.framework"
cp -R "${frameworks}/CoreLocation.framework"  "./Frameworks/CoreLocation.framework"
cp -R "${frameworks}/Kernel.framework"        "./Frameworks/Kernel.framework"

# Remove unnecessary files
find . | grep "\.swiftmodule" | xargs rm -rf
rm -rf "Frameworks/IOKit.framework/Versions/A/Headers/ndrvsupport"
rm -rf "Frameworks/IOKit.framework/Versions/A/Headers/pwr_mgt"
rm -rf "Frameworks/IOKit.framework/Versions/A/Headers/scsi"
rm -rf "Frameworks/IOKit.framework/Versions/A/Headers/firewire"
rm -rf "Frameworks/IOKit.framework/Versions/A/Headers/storage"
rm -rf "Frameworks/IOKit.framework/Versions/A/Headers/usb"

# == Trim large frameworks ==
# 4.9M -> 1M
< "./Frameworks/Foundation.framework/Versions/C/Foundation.tbd" grep -v "libswiftFoundation" | tmp
mv tmp "./Frameworks/Foundation.framework/Versions/C/Foundation.tbd"

# 13M -> 368K
find "./Frameworks/Kernel.framework" -type f | grep -v "IOKit/hidsystem" | xargs rm -rf

# 29M -> 28M
find . | grep "\.apinotes" | xargs rm -rf
find . | grep "\.r" | xargs rm -rf
find . | grep "\.modulemap" | xargs rm -rf

# 668K
rm "./Frameworks/OpenGL.framework/Versions/A/Libraries/libLLVMContainer.tbd"

# 672K
rm "./Frameworks/OpenGL.framework/Versions/A/Libraries/3425AMD/libLLVMContainer.tbd"

# 444K
rm "./Frameworks/CloudKit.framework/Versions/A/CloudKit.tbd"
