/datum/random_map/droppod/supply
	descriptor = "supply drop"
	limit_x = 5
	limit_y = 5

	placement_explosion_dev =   3
	placement_explosion_heavy = 5
	placement_explosion_light = 7
	placement_explosion_flash = 5

// UNLIKE THE DROP POD, this map deals ENTIRELY with strings and types.
// Drop type is a string representing a mode rather than an atom or path.
// supplied_drop_types is a list of types to spawn in the pod.
/datum/random_map/droppod/supply/get_spawned_drop(var/turf/T)

	if(!drop_type) drop_type = pick(supply_drop_random_loot_types)

	if(drop_type == "custom")
		if(supplied_drop_types.len)
			var/obj/structure/largecrate/C = locate() in T
			for(var/drop_type in supplied_drop_types)
				var/atom/movable/A = new drop_type(T)
				if(!istype(A, /mob))
					if(!C) C = new(T)
					C.contents |= A
			return
		else
			drop_type = pick(supply_drop_random_loot_types)

	switch(drop_type)
		if("lasers")
			var/obj/structure/largecrate/C = new(T)
			new /obj/item/weapon/gun/energy/laser(C)
			new /obj/item/weapon/gun/energy/laser(C)
			new /obj/item/weapon/gun/energy/sniperrifle(C)
			new /obj/item/weapon/gun/energy/ionrifle(C)

		if("ballistics")
			var/obj/structure/largecrate/C = new(T)
			new /obj/item/weapon/gun/projectile/sec(C)
			new /obj/item/weapon/gun/projectile/shotgun/doublebarrel(C)
			new /obj/item/weapon/gun/projectile/shotgun/pump/combat(C)
			new /obj/item/weapon/gun/projectile/automatic/wt550(C)
			new /obj/item/weapon/gun/projectile/automatic/z8(C)

		if("seeds")
			var/obj/structure/closet/crate/C = new(T)
			new /obj/item/seeds/chiliseed(C)
			new /obj/item/seeds/berryseed(C)
			new /obj/item/seeds/cornseed(C)
			new /obj/item/seeds/eggplantseed(C)
			new /obj/item/seeds/tomatoseed(C)
			new /obj/item/seeds/appleseed(C)
			new /obj/item/seeds/soyaseed(C)
			new /obj/item/seeds/wheatseed(C)
			new /obj/item/seeds/carrotseed(C)
			new /obj/item/seeds/lemonseed(C)
			new /obj/item/seeds/orangeseed(C)
			new /obj/item/seeds/grassseed(C)
			new /obj/item/seeds/sunflowerseed(C)
			new /obj/item/seeds/chantermycelium(C)
			new /obj/item/seeds/potatoseed(C)
			new /obj/item/seeds/sugarcaneseed(C)

		if("food")
			var/obj/structure/largecrate/C = new(T)
			new /obj/item/weapon/reagent_containers/food/condiment/flour(C)
			new /obj/item/weapon/reagent_containers/food/condiment/flour(C)
			new /obj/item/weapon/reagent_containers/food/condiment/flour(C)
			new /obj/item/weapon/reagent_containers/food/drinks/milk(C)
			new /obj/item/weapon/reagent_containers/food/drinks/milk(C)
			new /obj/item/weapon/storage/fancy/egg_box(C)
			new /obj/item/weapon/reagent_containers/food/snacks/tofu(C)
			new /obj/item/weapon/reagent_containers/food/snacks/tofu(C)
			new /obj/item/weapon/reagent_containers/food/snacks/meat(C)
			new /obj/item/weapon/reagent_containers/food/snacks/meat(C)

		if("armour")
			var/obj/structure/largecrate/C = new(T)
			new /obj/item/clothing/head/helmet/riot(C)
			new /obj/item/clothing/suit/armor/riot(C)
			new /obj/item/clothing/head/helmet/riot(C)
			new /obj/item/clothing/suit/armor/riot(C)
			new /obj/item/clothing/head/helmet/riot(C)
			new /obj/item/clothing/suit/armor/riot(C)
			new /obj/item/clothing/suit/storage/vest(C)
			new /obj/item/clothing/suit/storage/vest(C)
			new /obj/item/clothing/suit/storage/vest/heavy(C)
			new /obj/item/clothing/suit/storage/vest/heavy(C)
			new /obj/item/clothing/suit/armor/laserproof(C)
			new /obj/item/clothing/suit/armor/bulletproof(C)

		if("materials")
			var/obj/structure/largecrate/C = new(T)
			new /obj/item/stack/material/steel(C)
			new /obj/item/stack/material/steel(C)
			new /obj/item/stack/material/steel(C)
			new /obj/item/stack/material/glass(C)
			new /obj/item/stack/material/glass(C)
			new /obj/item/stack/material/wood(C)
			new /obj/item/stack/material/plastic(C)
			new /obj/item/stack/material/glass/reinforced(C)
			new /obj/item/stack/material/plasteel(C)

		if("medical")
			var/obj/structure/closet/crate/medical/M = new(T)
			new /obj/item/weapon/storage/firstaid/regular(M)
			new /obj/item/weapon/storage/firstaid/fire(M)
			new /obj/item/weapon/storage/firstaid/toxin(M)
			new /obj/item/weapon/storage/firstaid/o2(M)
			new /obj/item/weapon/storage/firstaid/adv(M)
			new /obj/item/weapon/reagent_containers/glass/bottle/antitoxin(M)
			new /obj/item/weapon/reagent_containers/glass/bottle/inaprovaline(M)
			new /obj/item/weapon/reagent_containers/glass/bottle/stoxin(M)
			new /obj/item/weapon/storage/box/syringes(M)
			new /obj/item/weapon/storage/box/autoinjectors(M)

		if("power")
			var/obj/structure/largecrate/C = new(T)
			var/gen_type = pick(list(/obj/machinery/power/port_gen/pacman,/obj/machinery/power/port_gen/pacman/super,/obj/machinery/power/port_gen/pacman/mrs))
			new gen_type(C)

		if("hydroponics")
			var/obj/structure/largecrate/C = new(T)
			new /obj/machinery/portable_atmospherics/hydroponics(C)
			new /obj/machinery/portable_atmospherics/hydroponics(C)
			new /obj/machinery/portable_atmospherics/hydroponics(C)

/datum/admins/proc/call_supply_drop()
	set category = "Fun"
	set desc = "Call an immediate supply drop on your location."
	set name = "Call Supply Drop"

	if(!check_rights(R_FUN)) return

	var/chosen_loot_type
	var/list/chosen_loot_types
	var/choice = alert("Do you wish to supply a custom loot list?",,"No","Yes")
	if(choice == "Yes")
		chosen_loot_types = list()

		choice = alert("Do you wish to add mobs?",,"No","Yes")
		if(choice == "Yes")
			while(1)
				var/adding_loot_type = input("Select a new loot path. Cancel to finish.", "Loot Selection", null) as null|anything in typesof(/mob/living)
				if(!adding_loot_type)
					break
				chosen_loot_types |= adding_loot_type
		choice = alert("Do you wish to add structures or machines?",,"No","Yes")
		if(choice == "Yes")
			while(1)
				var/adding_loot_type = input("Select a new loot path. Cancel to finish.", "Loot Selection", null) as null|anything in typesof(/obj) - typesof(/obj/item)
				if(!adding_loot_type)
					break
				chosen_loot_types |= adding_loot_type
		choice = alert("Do you wish to add any non-weapon items?",,"No","Yes")
		if(choice == "Yes")
			while(1)
				var/adding_loot_type = input("Select a new loot path. Cancel to finish.", "Loot Selection", null) as null|anything in typesof(/obj/item) - typesof(/obj/item/weapon)
				if(!adding_loot_type)
					break
				chosen_loot_types |= adding_loot_type

		choice = alert("Do you wish to add weapons?",,"No","Yes")
		if(choice == "Yes")
			while(1)
				var/adding_loot_type = input("Select a new loot path. Cancel to finish.", "Loot Selection", null) as null|anything in typesof(/obj/item/weapon)
				if(!adding_loot_type)
					break
				chosen_loot_types |= adding_loot_type
		choice = alert("Do you wish to add ABSOLUTELY ANYTHING ELSE? (you really shouldn't need to)",,"No","Yes")
		if(choice == "Yes")
			while(1)
				var/adding_loot_type = input("Select a new loot path. Cancel to finish.", "Loot Selection", null) as null|anything in typesof(/atom/movable)
				if(!adding_loot_type)
					break
				chosen_loot_types |= adding_loot_type
	else
		choice = alert("Do you wish to specify a loot type?",,"No","Yes")
		if(choice == "Yes")
			chosen_loot_type = input("Select a loot type.", "Loot Selection", null) as null|anything in supply_drop_random_loot_types

	choice = alert("Are you SURE you wish to deploy this supply drop? It will cause a sizable explosion and gib anyone underneath it.",,"No","Yes")
	if(choice == "No")
		return
	log_admin("[key_name(usr)] dropped supplies at ([usr.x],[usr.y],[usr.z])")
	new /datum/random_map/droppod/supply(null, usr.x-2, usr.y-2, usr.z, supplied_drops = chosen_loot_types, supplied_drop = chosen_loot_type)