# Defined in /var/folders/dp/ydg52xtj6lj10xfc3hk881v00000gp/T//fish.4SUwBt/disable-osx-photos.fish @ line 1
function disable-osx-photos
	defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
end
