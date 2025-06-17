/datum/gear/award
	sort_category = "Awards"
	category = /datum/gear/award
	slot = slot_tie

/datum/gear/award/ntaward
	display_name = "corporate award, service medal"
	description = "A silver medal awarded to employees for distinguished service in support of corporate interests."
	path = /obj/item/storage/medalbox/corp_service
	cost = 6
	flags = GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/award/ntaward/science
	display_name = "corporate award, sciences medal"
	description = "A bronze medal awarded to employees for signifigant contributions to the fields of science or engineering."
	path = /obj/item/storage/medalbox/corp_science

/datum/gear/award/ntaward/command
	display_name = "corporate award, command medal"
	description = "A gold medal awarded to employees for service as the Captain of a corporate facility, station, or vessel."
	path = /obj/item/storage/medalbox/corp_command
