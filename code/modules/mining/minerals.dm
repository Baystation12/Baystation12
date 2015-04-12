var/list/name_to_mineral

/proc/SetupMinerals()
	name_to_mineral = list()
	for(var/type in typesof(/mineral) - /mineral)
		var/mineral/new_mineral = new type
		if(!new_mineral.name)
			continue
		name_to_mineral[new_mineral.name] = new_mineral
	return 1

/mineral
	var/name	      // Tag for use in overlay generation/list population	.
	var/display_name  // What am I called?
	var/result_amount // How much ore?
	var/spread = 1	  // Does this type of deposit spread?
	var/spread_chance // Chance of spreading in any direction
	var/ore	          // Path to the ore produced when tile is mined.


/mineral/New()
	. = ..()
	if(!display_name)
		display_name = name

/mineral/uranium
	name = "Uranium"
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/weapon/ore/uranium

/mineral/platinum
	name = "Platinum"
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/weapon/ore/osmium

/mineral/iron
	name = "Iron"
	result_amount = 5
	spread_chance = 25
	ore = /obj/item/weapon/ore/iron

/mineral/coal
	name = "Coal"
	result_amount = 5
	spread_chance = 25
	ore = /obj/item/weapon/ore/coal

/mineral/diamond
	name = "Diamond"
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/weapon/ore/diamond

/mineral/gold
	name = "Gold"
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/weapon/ore/gold

/mineral/silver
	name = "Silver"
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/weapon/ore/silver

/mineral/phoron
	name = "Phoron"
	result_amount = 5
	spread_chance = 25
	ore = /obj/item/weapon/ore/phoron