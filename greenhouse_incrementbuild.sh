#!/bin/bash
buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "Portfolio/Info.plist")
echo Adding CI postfix to buildnumber to buildnumber from buildNumber to $buildNumber.$GREENHOUSE_BUILD_NUMBER
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber.$GREENHOUSE_BUILD_NUMBER" Portfolio/Info.plist
