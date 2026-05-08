----------------
---- CURVES ----
----------------

hl.curve("bounce", { type = "spring", mass = 1, stiffness = 50, dampening = 10 })
hl.curve("slight_bounce", { type = "spring", mass = 1, stiffness = 35, dampening = 10 })

----------------------
---- ANIMATIONS ------
----------------------
hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "windows", enabled = true, speed = 8, spring = "bounce", style = "popin 80%" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, spring = "slight_bounce", style = "slight_bounce" })
