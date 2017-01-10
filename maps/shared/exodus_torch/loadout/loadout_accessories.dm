/datum/gear/accessory/flannel
	display_name = "flannel (colorable)"
	path = /obj/item/clothing/accessory/toggleable/flannel
	slot = slot_tie
	flags = GEAR_HAS_COLOR_SELECTION
	sort_category = "Accessories"

/datum/gear/accessory/flannel/selection
	display_name = "flannel selection"
	path = /obj/item/clothing/accessory/toggleable/flannel/red

/datum/gear/accessory/flannel/selection/New()
	..()
	var/flannels = list()
	flannels["red and green flannel"] = /obj/item/clothing/accessory/toggleable/flannel/red
	flannels["green and blue flannel"] = /obj/item/clothing/accessory/toggleable/flannel/green
	flannels["purple and yellow flannel"] = /obj/item/clothing/accessory/toggleable/flannel/purple
	gear_tweaks += new/datum/gear_tweak/path(flannels)