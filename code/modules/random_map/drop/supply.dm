#define SD_FLOOR_TILE 0
#define SD_WALL_TILE 1
#define SD_DOOR_TILE 2
#define SD_EMPTY_TILE 3
#define SD_SUPPLY_TILE 7
var/global/list/supply_drop_random_loot_types = list(
	"guns",
	"seeds",
	"materials",
	"food",
	"armour",
	"medical",
	"power",
	"hydroponics",
	"lasers",
	"ballistics"
	)

/datum/random_map/supplydrop
	descriptor = "small supply drop"
	initial_wall_cell = 0
	limit_x = 5
	limit_y = 5

	var/list/custom_loot_types = list()
	var/loot_type
	var/placement_explosion_dev =   3
	var/placement_explosion_heavy = 5
	var/placement_explosion_light = 7
	var/placement_explosion_flash = 5

/datum/random_map/supplydrop/New(var/seed, var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/list/supplied_drops, var/supplied_loot_type)
	if(islist(supplied_drops) && supplied_drops.len)
		custom_loot_types = supplied_drops
		loot_type = "custom"
	else if(supplied_loot_type)
		loot_type = supplied_loot_type
	..(seed, tx, ty, tz, tlx, tly, do_not_apply, do_not_announce)

/datum/random_map/supplydrop/generate_map()

	// No point calculating these 200 times.
	var/x_midpoint = n_ceil(limit_x / 2)
	var/y_midpoint = n_ceil(limit_y / 2)

	// Draw walls/floors/doors.
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if(!current_cell)
				continue

			var/on_x_bound = (x == 1 || x == limit_x)
			var/on_y_bound = (y == 1 || y == limit_x)

			if(on_x_bound || on_y_bound)
				// Draw access points in midpoint of each wall.
				if(x == x_midpoint || y == y_midpoint)
					map[current_cell] = SD_DOOR_TILE
				// Draw the actual walls.
				else if(!on_x_bound || !on_y_bound)
					map[current_cell] = SD_WALL_TILE
				//Don't draw the far corners.
				else
					map[current_cell] = SD_EMPTY_TILE
			else
				// Fill in the corners.
				if((x == 2 || x == (limit_x-1)) && (y == 2 || y == (limit_y-1)))
					map[current_cell] = SD_WALL_TILE
				// Fill in EVERYTHING ELSE.
				else
					map[current_cell] = SD_FLOOR_TILE

	// Draw the drop contents.
	var/current_cell = get_map_cell(x_midpoint,y_midpoint)
	if(current_cell)
		map[current_cell] = SD_SUPPLY_TILE
	return 1

/datum/random_map/supplydrop/apply_to_map()
	if(placement_explosion_dev || placement_explosion_heavy || placement_explosion_light || placement_explosion_flash)
		var/turf/T = locate((origin_x + n_ceil(limit_x / 2)-1), (origin_y + n_ceil(limit_y / 2)-1), origin_z)
		if(istype(T))
			explosion(T, placement_explosion_dev, placement_explosion_heavy, placement_explosion_light, placement_explosion_flash)
			sleep(15) // Let the explosion finish proccing before we ChangeTurf(), otherwise it might destroy our spawned objects.
	return ..()

/datum/random_map/supplydrop/get_appropriate_path(var/value)
	if(value == SD_FLOOR_TILE || value == SD_SUPPLY_TILE|| value == SD_DOOR_TILE)
		return floor_type
	else if(value == SD_WALL_TILE)
		return wall_type
	return null

/datum/random_map/supplydrop/get_additional_spawns(var/value, var/turf/T)

	// Splatter anything under us that survived the explosion.
	if(value != SD_EMPTY_TILE && T.contents.len)
		for(var/atom/A in T)
			if(!A.simulated || istype(A, /mob/dead))
				continue
			if(istype(A, /mob/living))
				var/mob/living/M = A
				M.gib()
			else
				qdel(A)

	// Also spawn doors and loot.
	if(value == SD_DOOR_TILE)
		var/obj/machinery/door/airlock/A = new(T)
		A.id_tag = name
	else if(value == SD_SUPPLY_TILE)
		get_spawned_loot(T)

/datum/random_map/supplydrop/proc/get_spawned_loot(var/turf/T)

	if(!loot_type) loot_type = pick(supply_drop_random_loot_types)

	if(loot_type == "custom")
		if(custom_loot_types.len)
			var/obj/structure/largecrate/C = locate() in T
			for(var/drop_type in custom_loot_types)
				var/atom/movable/A = new drop_type(T)
				if(!istype(A, /mob))
					if(!C) C = new(T)
					C.contents |= A
			return
		else
			loot_type = pick(supply_drop_random_loot_types)

	switch(loot_type)
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
	new /datum/random_map/supplydrop(null, usr.x-2, usr.y-2, usr.z, supplied_drops = chosen_loot_types, supplied_loot_type = chosen_loot_type)