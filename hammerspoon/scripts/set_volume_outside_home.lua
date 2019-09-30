wifiwatcher = hs.wifi.watcher.new(function ()
    homeSSID = "EnDuvaSattPaEnGren"
    currentSSID = hs.wifi.currentNetwork()
    if currentSSID==homeSSID then
        hs.audiodevice.defaultOutputDevice():setVolume(25)
    else
        hs.audiodevice.defaultOutputDevice():setVolume(0)
    end
end)
wifiwatcher:start()