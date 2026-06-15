-- Motion language: IBM Carbon (oxocarbon's design source).
-- Productive, purposeful, no bounce, no overshoot. Entrances decelerate
-- into place; exits accelerate away; durations stay short (100-300ms).
-- speed is in 100ms units, so speed = 2 -> 200ms.

-- Carbon easing curves, mapped to Hyprland beziers (two control points each)
hl.curve("productive", { type = "bezier", points = { { 0.2, 0 }, { 0.38, 0.9 } } }) -- standard
hl.curve("entrance", { type = "bezier", points = { { 0, 0 }, { 0.38, 0.9 } } })     -- decelerate in
hl.curve("exit", { type = "bezier", points = { { 0.2, 0 }, { 1, 0.9 } } })          -- accelerate out
hl.curve("expressive", { type = "bezier", points = { { 0.4, 0.14 }, { 0.3, 1 } } }) -- big moments
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })

hl.config({ animations = { enabled = true } })

-- Global fallback
hl.animation({ leaf = "global", enabled = true, speed = 1.5, bezier = "entrance" })

-- Windows — subtle scale, mostly a crisp fade-forward. Snap in immediately, fly out.
hl.animation({ leaf = "windows", enabled = true, speed = 1.1, bezier = "entrance", style = "popin 96%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 1.1, bezier = "entrance", style = "popin 96%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 0.9, bezier = "exit", style = "popin 96%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 1.1, bezier = "entrance" })

-- Layers — rofi, eww, notifications. Snappy fade, gets out of the way instantly.
hl.animation({ leaf = "layers", enabled = true, speed = 0.9, bezier = "entrance", style = "fade" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 0.9, bezier = "entrance", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 0.7, bezier = "exit", style = "fade" })

-- Fades — quick, just enough to soften the cut
hl.animation({ leaf = "fade", enabled = true, speed = 0.9, bezier = "entrance" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 0.8, bezier = "entrance" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 0.7, bezier = "exit" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 0.8, bezier = "entrance" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 0.8, bezier = "entrance" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 0.9, bezier = "entrance" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 0.8, bezier = "entrance" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 0.7, bezier = "exit" })

-- Border — color transition, quick
hl.animation({ leaf = "border", enabled = true, speed = 1.2, bezier = "entrance" })

-- Workspaces — the one expressive moment: a confident, fast directional slide
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.3, bezier = "expressive", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.3, bezier = "expressive", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.1, bezier = "exit", style = "slide" })

-- Zoom
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 1.5, bezier = "entrance" })
