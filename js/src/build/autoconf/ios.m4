dnl This Source Code Form is subject to the terms of the Mozilla Public
dnl License, v. 2.0. If a copy of the MPL was not distributed with this
dnl file, You can obtain one at http://mozilla.org/MPL/2.0/.

dnl ========================================================
dnl = First test to make it work for iOS
dnl = Xcode >= 4.3.1 required
dnl ========================================================

AC_DEFUN([MOZ_IOS_SDK],
[

MOZ_ARG_WITH_STRING(ios-version,
[  --with-ios-version=VER
                          version of the iOS SDK, defaults to 5.1],
    ios_sdk_version=$withval,
    ios_sdk_version=5.1)

MOZ_ARG_WITH_STRING(ios-min-version,
[  --with-ios-min-version=VER
                          deploy target version, defaults to 5.1],
    ios_deploy_version=$withval,
    ios_deploy_version=4.3)

dnl test for Xcode 4.3.1
if ! test -d "/Applications/Xcode.app/Contents/Developer/Platforms" ; then
    AC_MSG_ERROR([You must install Xcode first])
fi

if test -z "$ios_deploy_version" ; then
    ios_deploy_version="4.3"
fi

if test -z "$ios_sdk_version" ; then
    ios_sdk_version="4.3"
fi

if test "$ios_target" == "iPhoneSimulator" ; then
    ios_arch=i386
    target_name=x86
    target=i386-darwin
else
    ios_arch=armv7
    target_name=x86
    target=arm-darwin
fi
target_os=darwin

xcode_base="/Applications/Xcode.app/Contents/Developer/Platforms"
ios_sdk_root=""
ios_toolchain="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin"

dnl test to see if the actual sdk exists
ios_sdk_root="$xcode_base"/$ios_target.platform/Developer/SDKs/$ios_target"$ios_sdk_version".sdk
if ! test -d "$ios_sdk_root" ; then
    AC_MSG_ERROR([Wrong SDK version])
fi

dnl set the compilers
AS="$ios_toolchain"/as
CC="$ios_toolchain"/clang
CXX="$ios_toolchain"/clang++
CPP="$ios_toolchain/clang -E"
LD="$ios_toolchain"/ld
AR="$ios_toolchain"/ar
RANLIB="$ios_toolchain"/ranlib
STRIP="$ios_toolchain"/strip
LDFLAGS="-L$ios_sdk_root/usr/lib/"

CFLAGS="-isysroot $ios_sdk_root -arch $ios_arch -miphoneos-version-min=$ios_deploy_version -I$ios_sdk_root/usr/include -pipe -Wno-implicit-int"
CXXFLAGS="$CFLAGS"
CPPFLAGS=""

dnl prevent cross compile section from using these flags as host flags
if test -z "$HOST_CPPFLAGS" ; then
    HOST_CPPFLAGS=" "
fi
if test -z "$HOST_CFLAGS" ; then
    HOST_CFLAGS=" "
fi
if test -z "$HOST_CXXFLAGS" ; then
    HOST_CXXFLAGS=" "
fi
if test -z "$HOST_LDFLAGS" ; then
    HOST_LDFLAGS=" "
fi

AC_DEFINE(IPHONEOS)
CROSS_COMPILE=1

])
