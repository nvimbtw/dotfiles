hl.gesture({ fingers = 3, direction = "left", action = function() hl.dispatch(hl.dsp.focus({ workspace = "e+1" })) end })
hl.gesture({ fingers = 3, direction = "right", action = function() hl.dispatch(hl.dsp.focus({ workspace = "e-1" })) end })
hl.gesture({ fingers = 2, direction = "pinchin", action = "cursorZoom", zoom_level = "2.0", mode = "mult" })
hl.gesture({ fingers = 2, direction = "pinchout", action = "cursorZoom", zoom_level = "0.5", mode = "mult" })
