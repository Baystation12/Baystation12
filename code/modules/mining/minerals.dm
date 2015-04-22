var/list/name_to_mineral

/proc/SetupMinerals()
	name_to_mineral = list()
	for(var/type in typesof(/material) - /material)
		var/material/new_mineral = new type
		if(!new_mineral.name)
			continue
		name_to_mineral[lowertext(new_mineral.name)] = new_mineral
	return 1

/material
	var/name	          // Tag for use in overlay generation/list population	.
	var/walltype_solid
	var/walltype_false
	var/doortype
	var/stack_type
	var/unmeltable
	var/cut_delay

/material/uranium
	name = "uranium"
	walltype_solid = /turf/simulated/wall/mineral/uranium
	walltype_false = /obj/structure/falsewall/uranium
	doortype = /obj/machinery/door/airlock/uranium
	stack_type = /obj/item/stack/sheet/mineral/uranium

/material/diamond
	name = "diamond"
	walltype_solid = /turf/simulated/wall/mineral/diamond
	walltype_false = /obj/structure/falsewall/diamond
	doortype = /obj/machinery/door/airlock/diamond
	stack_type = /obj/item/stack/sheet/mineral/diamond
	unmeltable = 1
	cut_delay = 60

/material/gold
	name = "gold"
	walltype_solid = /turf/simulated/wall/mineral/gold
	walltype_false = /obj/structure/falsewall/gold
	doortype = /obj/machinery/door/airlock/gold
	stack_type = /obj/item/stack/sheet/mineral/gold

/material/silver
	name = "silver"
	walltype_solid = /turf/simulated/wall/mineral/silver
	walltype_false = /obj/structure/falsewall/silver
	doortype = /obj/machinery/door/airlock/silver
	stack_type = /obj/item/stack/sheet/mineral/silver

/material/phoron
	name = "phoron"
	walltype_solid = /turf/simulated/wall/mineral/phoron
	walltype_false = /obj/structure/falsewall/phoron
	doortype = /obj/machinery/door/airlock/phoron
	stack_type = /obj/item/stack/sheet/mineral/phoron

/material/sandstone
	name = "sandstone"
	walltype_solid = /turf/simulated/wall/mineral/sandstone
	walltype_false = /obj/structure/falsewall/sandstone
	stack_type = /obj/item/stack/sheet/mineral/sandstone

/material/steel
	name = "steel"
	stack_type = /obj/item/stack/sheet/metal
	walltype_solid = /turf/simulated/wall
	walltype_false = /obj/structure/falsewall

/material/glass
	name = "glass"
	stack_type = /obj/item/stack/sheet/glass

/material/plastic
	name = "plastic"
	stack_type = /obj/item/stack/sheet/mineral/plastic

/material/osmium
	name = "osmium"
	stack_type = /obj/item/stack/sheet/mineral/osmium

/material/tritium
	name = "tritium"
	stack_type = /obj/item/stack/sheet/mineral/tritium

/material/mhydrogen
	name = "mhydrogen"
	stack_type = /obj/item/stack/sheet/mineral/mhydrogen

/material/platinum
	name = "platinum"
	stack_type = /obj/item/stack/sheet/mineral/platinum

/material/iron
	name = "iron"
	stack_type = /obj/item/stack/sheet/mineral/iron
