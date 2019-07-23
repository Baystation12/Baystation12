GLOBAL_LIST_INIT(DEMOLITION_MANAGER_LIST, new)

/datum/demolition_manager
	var/list/linked_targets = list()
	var/demolished = FALSE
	var/z = -1

/datum/demolition_manager/proc/check_demolition()
	if(demolished)
		return 1

	for(var/obj/effect/landmark/demolition_point/D in linked_targets)
		if(!D.demolished)
			return 0

	demolished = TRUE
	return 1

/datum/demolition_manager/ship
/datum/demolition_manager/ship/check_demolition()
	if(..())
		map_sectors["[z]"].pre_superstructure_failing()

/obj/effect/landmark/demolition_point
	name = "demolition charge target type"
	var/demolished = FALSE
	var/datum/demolition_manager/manager
	var/ship = FALSE

/obj/effect/landmark/demolition_point/New()
	..()

	if(!GLOB.DEMOLITION_MANAGER_LIST["[map_sectors["[z]"]]"])
		if(ship)
			GLOB.DEMOLITION_MANAGER_LIST["[map_sectors["[z]"]]"] = new/datum/demolition_manager/ship
		else
			GLOB.DEMOLITION_MANAGER_LIST["[map_sectors["[z]"]]"] = new/datum/demolition_manager

	manager = GLOB.DEMOLITION_MANAGER_LIST["[map_sectors["[z]"]]"]
	manager.z = z
	manager.linked_targets += src

/obj/effect/landmark/demolition_point/proc/demolish()
	demolished = TRUE
	manager.check_demolition()