GLOBAL_LIST_INIT(crashed_pod_areas, new)

/singleton/map_template/ruin/exoplanet/crashed_pod
	name = "crashed survival pod"
	id = "crashed_pod"
	description = "A crashed survival pod from a destroyed ship."
	suffixes = list("crashed_pod/crashed_pod.dmm")
	spawn_cost = 1.5
	player_cost = 4
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS | TEMPLATE_FLAG_NO_RADS
	ruin_tags = RUIN_HUMAN|RUIN_WRECK
	spawn_weight = 0.25

/area/map_template/crashed_pod
	name = "\improper Crashed Survival Pod"
	icon_state = "blue"

/singleton/submap_archetype/crashed_pod
	descriptor = "crashed survival pod"
	crew_jobs = list(/datum/job/submap/pod)

/datum/submap/crashed_pod/sync_cell(obj/overmap/visitable/cell)
	return

/datum/job/submap/pod
	title = "Stranded Survivor"
	info = "Your ship has been destroyed by a terrible disaster."
	outfit_type = /singleton/hierarchy/outfit/job/survivor
	total_positions = 2

/singleton/hierarchy/outfit/job/survivor
	name = OUTFIT_JOB_NAME("Survivor")
	id_types = null
	pda_type = null

/datum/job/submap/pod/New(datum/submap/_owner, abstract_job = FALSE)
	..()
	if(_owner) // Might be called from admin tools, etc
		info = "Your ship, the [_owner.name], has been destroyed by a terrible disaster, \
		leaving you stranded in your survival pod on a hostile exoplanet. Your pod's distress \
		signal appear to be malfunctioning. All you can do now is survive, and hope for a passing ship..."

/obj/submap_landmark/spawnpoint/crashed_pod_survivor
	name = "Stranded Survivor"

/obj/submap_landmark/joinable_submap/crashed_pod
	name = "Crashed Survival Pod"
	archetype = /singleton/submap_archetype/crashed_pod
	submap_datum_type = /datum/submap/crashed_pod

/obj/submap_landmark/joinable_submap/crashed_pod/New()
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
