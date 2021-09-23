GLOBAL_LIST_INIT(crashed_pod_areas, new)

/datum/map_template/ruin/exoplanet/crashed_pod
	name = "crashed survival pod"
	id = "crashed_pod"
	description = "A crashed survival pod from a destroyed ship."
	suffixes = list("crashed_pod/crashed_pod.dmm")
	spawn_cost = 1.5
	player_cost = 4
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS | TEMPLATE_FLAG_NO_RADS
	ruin_tags = RUIN_HUMAN|RUIN_WRECK
	spawn_weight = 0.33

/area/map_template/crashed_pod
	name = "\improper Crashed Survival Pod"
	icon_state = "blue"

/decl/submap_archetype/crashed_pod
	descriptor = "crashed survival pod"
	crew_jobs = list(/datum/job/submap/pod)

/datum/submap/crashed_pod/sync_cell(var/obj/effect/overmap/visitable/cell)
	cell.has_distress_beacon = name

/datum/job/submap/pod
	title = "Stranded Survivor"
	info = "Your ship has been destroyed by a terrible disaster."
	outfit_type = /decl/hierarchy/outfit/job/survivor
	total_positions = 2

/decl/hierarchy/outfit/job/survivor
	name = OUTFIT_JOB_NAME("Survivor")
	id_types = null
	pda_type = null

/datum/job/submap/pod/New(var/datum/submap/_owner, var/abstract_job = FALSE)
	..()
	if(_owner) // Might be called from admin tools, etc
		info = "Your ship, the [_owner.name], has been destroyed by a terrible disaster, \
		leaving you stranded in your survival pod on a hostile exoplanet. Your pod's distress \
		signal might draw help, but even if you should be so lucky, you must survive long \
		enough for it to arrive."

/obj/effect/submap_landmark/spawnpoint/crashed_pod_survivor
	name = "Stranded Survivor"

/obj/effect/submap_landmark/joinable_submap/crashed_pod
	name = "Crashed Survival Pod"
	archetype = /decl/submap_archetype/crashed_pod
	submap_datum_type = /datum/submap/crashed_pod

/obj/effect/submap_landmark/joinable_submap/crashed_pod/New()
	var/list/possible_ship_names = list(
		"Hornet",		"Witchmoth",	"Planthopper",
		"Mayfly",		"Locust",		"Cicada",
		"Sanddragon",	"Conehead",		"Whitetail",
		"Amberwing",	"Swallowtail",	"Hawkmoth",
		"Katydid",		"Longhorn",		"Luna Moth",
		"Monarch",		"Mydas",		"Paperwasp",
		"Treehopper",	"Sphinxmoth",	"Leatherwing",
		"Scarab",		"Ash Borer",	"Admiral",
		"Emperor",		"Skipper",		"Tarantula Hawk",
		"Adder",		"Bumblebee")
	name = "[pick("SEV", "SIC", "FTUV", "ICV", "HMS")] [pick(possible_ship_names)]"
	..()
