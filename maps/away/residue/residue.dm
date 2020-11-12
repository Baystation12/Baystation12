
/obj/effect/overmap/visitable/sector/residue
	name = "Bluespace Residue"
	desc = "Scans show low levels of radiation consistent with the aftermath of a bluespace jump."
	in_space = 0
	icon_state = "event"
	initial_generic_waypoints = list(
		"nav_residue_1",
		"nav_residue_2",
	)
	known = 1
	start_x = 12
	start_y = 13

/obj/effect/residue/irradiate
	var/radiation_power = 10
	var/datum/radiation_source/S
	var/req_range = 100//to cover whole level

/obj/effect/residue/irradiate/Initialize()
	. = ..()
	S = new()
	S.flat = TRUE
	S.range = req_range
	S.respect_maint = FALSE
	S.decay = FALSE
	S.source_turf = get_turf(src)
	S.update_rad_power(radiation_power)
	SSradiation.add_source(S)

/obj/effect/residue/irradiate/Destroy()
	. = ..()
	QDEL_NULL(S)

/obj/effect/shuttle_landmark/nav_residue/nav1
	name = "Irradiated Space #1"
	landmark_tag = "nav_residue_1"
	flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/nav_residue/nav2
	name = "Irradiated Space #2"
	landmark_tag = "nav_residue_2"
	flags = SLANDMARK_FLAG_AUTOSET


/datum/map_template/ruin/away_site/residue
	name = "Jump Residue"
	id = "awaysite_residue"
	description = "Bluespace Jump Residue."
	suffixes = list("residue/residue.dmm")
	cost = 0
	spawn_weight = 1
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED