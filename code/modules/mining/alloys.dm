//Alloys that contain subsets of each other's ingredients must be ordered in the desired sequence
//eg. steel comes after plasteel because plasteel's ingredients contain the ingredients for steel and
//it would be impossible to produce.

/datum/alloy
	var/list/requires
	var/product_mod = 1
	var/product
	var/metaltag

/datum/alloy/plasteel
	metaltag = "plasteel"
	requires = list(
		"platinum" = 1,
		"carbon" = 2,
		"iron" = 2
		)
	product_mod = 0.3
	product = /obj/item/stack/material/plasteel

/datum/alloy/ocp
	metaltag = "osmium-carbide plasteel"
	requires = list(
		"platinum" = 1,
		"carbon" = 3,
		"iron" = 2,
		"osmium" = 2
		)
	product_mod = 0.3
	product = /obj/item/stack/material/ocp

/datum/alloy/steel
	metaltag = DEFAULT_WALL_MATERIAL
	requires = list(
		"carbon" = 1,
		"iron" = 1
		)
	product = /obj/item/stack/material/steel

/datum/alloy/borosilicate
	metaltag = "phglass"
	requires = list(
		"platinum" = 1,
		"sand" = 2
		)
	product = /obj/item/stack/material/glass/phoronglass
