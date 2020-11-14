/////////
// Material Defines
/////////
#define GLASS_COLOR_ALIEN    "#3a5a9a"
#define MATERIAL_GLASS_ALIEN "alien glass"
#define MATERIAL_STROT_ALIEN "alien material"

/////////
// Alien Burnchamber Material - This will never be used by players, aside from off-site spawns.
/////////
/material/glass/alien
	name = MATERIAL_GLASS_ALIEN
	display_name = "durable glass composite"
	wall_name = "bulkhead"
	flags = MATERIAL_UNMELTABLE
	stack_type = null
	icon_colour = GLASS_COLOR_PHORON
	integrity = 6800
	melting_point = 16000
	explosion_resistance = 1200
	hardness = 500
	weight = 500
	construction_difficulty = MATERIAL_HARD_DIY
	hidden_from_codex = TRUE
	value = 100

/material/alienwall
	name = MATERIAL_STROT_ALIEN
	display_name = "durable alloy"
	wall_name = "bulkhead"
	flags = MATERIAL_UNMELTABLE
	stack_type = null
	icon_colour = "#6c7364"
	integrity = 6800
	melting_point = 16000
	explosion_resistance = 1200
	hardness = 500
	weight = 500
	construction_difficulty = MATERIAL_HARD_DIY
	hidden_from_codex = TRUE
	value = 100

/////////
// Structure Types
/////////
/turf/simulated/wall/alienwall/New(var/newloc)
	..(newloc, MATERIAL_STROT_ALIEN)

/obj/effect/wallframe_spawn/alien
	name = "alien wall frame window spawner"
	icon_state = "p-wingrille"
	win_path = /obj/structure/window/alien/full

/obj/structure/window/alien
	name = "alien window"
	color = GLASS_COLOR_ALIEN
	init_material = MATERIAL_GLASS_ALIEN

/obj/structure/window/alien/full
	dir = 5
	icon_state = "window_full"
