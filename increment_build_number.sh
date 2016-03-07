cd ..
git pull
buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "Portfolio/Info.plist")
buildNumber=$(($buildNumber + 1))
echo Incrementing buildnumber from $((buildNumber-1)) to $buildNumber
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" Portfolio/Info.plist

