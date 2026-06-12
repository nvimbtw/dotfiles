-- Curves
hl.curve("snap", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1 } } }) -- instant accel, hard stop
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("quickOut", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.config({ animations = { enabled = true } })

-- Global fallback
hl.animation({ leaf = "global", enabled = true, speed = 8, bezier = "snap" })

-- Windows — nearly instant popin, barely any scale change
hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "snap", style = "popin 92%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 1.5, bezier = "snap", style = "popin 92%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.2, bezier = "linear", style = "popin 92%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2, bezier = "snap" })

-- Layers — rofi, eww, notifications just appear
hl.animation({ leaf = "layers", enabled = true, speed = 1.5, bezier = "snap", style = "fade" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 1.2, bezier = "snap", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1, bezier = "linear", style = "fade" })

-- Fades — very short, just enough to not be jarring
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "quickOut" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.5, bezier = "quickOut" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.2, bezier = "linear" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 1, bezier = "linear" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 1, bezier = "linear" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 1.5, bezier = "quickOut" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.2, bezier = "quickOut" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1, bezier = "linear" })

-- Border
hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "snap" })

-- Workspaces — fast directional slide, no fade blending
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "snap", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.8, bezier = "snap", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.5, bezier = "linear", style = "slide" })

-- Zoom
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 3, bezier = "snap" })
