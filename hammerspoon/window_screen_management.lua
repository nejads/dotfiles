local hyper = {"ctrl", "cmd"}

hs.loadSpoon("WindowScreenLeftAndRight")

spoon.WindowScreenLeftAndRight:bindHotkeys({
  screen_right = {hyper, "right"},
  screen_left = {hyper, "left"},
})
