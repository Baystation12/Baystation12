var/list/name_to_mineral

proc/SetupMinerals()
	name_to_mineral = list()
	for(var/type in typesof(/mineral) - /mineral)
		var/mineral/new_mineral = new type
		if(!new_mineral.name)
			continue
		name_to_mineral[new_mineral.name] = new_mineral
	return 1

mineral
	///What am I called?
	var/name
	var/display_name
	///How much ore?
	var/result_amount
	///Does this type of deposit spread?
	var/spread = 1
	///Chance of spreading in any direction
	var/spread_chance

	///Path to the resultant ore.
	var/ore

	New()
		. = ..()
		if(!display_name)
			display_name = name

mineral/uranium
	name = "Uranium"
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/weapon/ore/uranium

mineral/iron
	name = "Iron"
	result_amount = 5
	spread_chance = 25
	ore = /obj/item/weapon/ore/iron

mineral/diamond
	name = "Diamond"
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/weapon/ore/diamond

mineral/gold
	name = "Gold"
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/weapon/ore/gold

mineral/silver
	name = "Silver"
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/weapon/ore/silver

mineral/plasma
	name = "Plasma"
	result_amount = 5
	spread_chance = 25
	ore = /obj/item/weapon/ore/plasma

mineral/clown
	display_name = "Bananium"
	name = "Clown"
	result_amount = 3
	spread = 0
	ore = /obj/item/weapon/ore/clown