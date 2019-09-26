local modules_to_load = {
    'hammerspoon_preferences',
    'window_management',
    'window_screen_management',
    'reload_configuration', --> last item to ensure everything loaded nicely
}

for _, module in pairs(modules_to_load) do
    require(module)
end
