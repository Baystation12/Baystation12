/obj/item/mech_component/propulsion/spider
	name = "quadlegs"
	exosuit_desc_string = "hydraulic quadlegs"
	desc = "Xion Industrial's arachnid series boasts more leg per leg than the leading competitor."
	icon_state = "spiderlegs"
	max_damage = 80
	move_delay = 4
	turn_delay = 1
	power_use = 25

/obj/item/mech_component/propulsion/tracks
	name = "tracks"
	exosuit_desc_string = "armored tracks"
	desc = "A classic brought back. The Hephaestus' Landmaster class tracks are impervious to most damage and can maintain top speed regardless of load. Watch out for corners."
	icon_state = "tracks"
	max_damage = 150
	move_delay = 2 //It´s fast
	turn_delay = 7
	power_use = 150
	color = COLOR_WHITE

/obj/item/mech_component/chassis/pod
	name = "spherical exosuit chassis"
	hatch_descriptor = "hatch"
	pilot_coverage = 100
	transparent_cabin = TRUE
	hide_pilot = TRUE //Sprite too small, legs clip through, so for now hide pilot
	exosuit_desc_string = "a spherical chassis"
	icon_state = "pod_body"
	max_damage = 70
	power_use = 5
	has_hardpoints = list(HARDPOINT_BACK)
	desc = "The NanoTrasen Katamari series cockpits have won a massive tender by SCG few years back. No one is sure why, but these terrible things keep popping up on every government facility."

/obj/item/mech_component/chassis/pod/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 8,  "y" = 8),
			"[WEST]"  = list("x" = 8,  "y" = 8)
		),
		list(
			"[NORTH]" = list("x" = 8,  "y" = 16),
			"[SOUTH]" = list("x" = 8,  "y" = 16),
			"[EAST]"  = list("x" = 0,  "y" = 16),
			"[WEST]"  = list("x" = 16, "y" = 16)
		)
	)
	. = ..()

/obj/item/mech_component/chassis/pod/prebuild()
	. = ..()
	m_armour = new /obj/item/robot_parts/robot_component/armour/exosuit/radproof(src)