#define WEBHOOK_SUBMAP_LOADED_LIBERIA "webhook_submap_liberia"

// Map template data
/datum/map_template/ruin/away_site/liberia
	name = "Liberia"
	id = "awaysite_liberia"
	description = "A Merchant ship."
	prefix = "mods/_maps/liberia/maps/"
	suffixes = list("liberia.dmm")
	spawn_cost = 0
	player_cost = 0
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	spawn_weight = 50 // Нельзя ставить 0, иначе подбор авеек сломается
	shuttles_to_initialise = list(
		/datum/shuttle/autodock/overmap/mule
	)
	apc_test_exempt_areas = list(
		/area/liberia/solar1 = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/liberia/solar2 = NO_SCRUBBER|NO_VENT|NO_APC
	)
	area_usage_test_exempted_root_areas = list(/area/liberia)

// Overmap objects
/obj/overmap/visitable/ship/liberia
	name = "Liberia"
	desc = "Vessel with Free Trade Union registration"
	color = "#8a6642"
	vessel_mass = 3000
	fore_dir = WEST
	max_speed = 1/(1 SECOND)
	initial_restricted_waypoints = list(
		"Mule" = list("nav_mule_start")
	)
	initial_generic_waypoints = list(
		"nav_liberia_north",
		"nav_liberia_east",
		"nav_liberia_south",
		"nav_liberia_west"
	)

/obj/submap_landmark/joinable_submap/liberia
	name = "Liberia"
	archetype = /singleton/submap_archetype/liberia

/singleton/webhook/submap_loaded/liberia
	id = WEBHOOK_SUBMAP_LOADED_LIBERIA

/singleton/submap_archetype/liberia
	descriptor = "Free Trade Union merchant ship"
	map = "Liberia - merchant ship"
	crew_jobs = list(
		/datum/job/submap/merchant_leader,
		/datum/job/submap/merchant
	)
	whitelisted_species = null
	blacklisted_species = null
	call_webhook = WEBHOOK_SUBMAP_LOADED_LIBERIA

/decl/submap_archetype/liberia/New()
	. = ..()
	GLOB.using_map.map_admin_faxes.Add("FTU Agency")
	for(var/obj/machinery/photocopier/faxmachine/fax as anything in SSmachines.get_machinery_of_type(/obj/machinery/photocopier/faxmachine))
		GLOB.admin_departments += "FTU Agency"

/obj/machinery/power/apc/liberia
	req_access = list(access_merchant)

/obj/machinery/power/smes/buildable/preset/liberia
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

#undef WEBHOOK_SUBMAP_LOADED_LIBERIA
