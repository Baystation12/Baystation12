#define MATERIAL_SCRAP "scrap"
#define MATERIAL_SCRAP_REFINED "refined scrap"

/material/scrap
	name = MATERIAL_SCRAP
	stack_type = /obj/item/stack/material/scrap
	icon_base = "metal"
	door_icon_base = "metal"
	icon_colour = "#999966"
	icon_reinf = "reinf_over"
	shard_can_repair = 0
	melting_point = 540
	brute_armor = 3.2
	integrity = 100
	explosion_resistance = 3
	alloy_materials = list(DEFAULT_WALL_MATERIAL = 720, "plastic" = 420)
	weight = 18
	hardness = 30
	hitsound = 'sound/weapons/smash.ogg'
	sale_price = 1

/material/scrap/refined
	name = MATERIAL_SCRAP_REFINED
	stack_type = /obj/item/stack/material/refined_scrap
	melting_point = 820
	brute_armor = 4
	integrity = 120
	explosion_resistance = 4
	alloy_materials = list(DEFAULT_WALL_MATERIAL = 940, "plastic" = 210)
	weight = 18
	hardness = 40

/obj/item/stack/material/scrap
	name = MATERIAL_SCRAP
	icon = 'refine.dmi'
	icon_state = "refined"
	default_type = MATERIAL_SCRAP

/obj/item/stack/material/refined_scrap
	name = MATERIAL_SCRAP_REFINED
	icon = 'refine.dmi'
	icon_state = "refined"
	default_type = MATERIAL_SCRAP_REFINED
