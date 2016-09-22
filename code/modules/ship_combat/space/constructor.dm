/obj/machinery/space_battle/space_construction
	name = "deep space construction"
	desc = "Constructs deep space objects like ships and stations."
	icon_state = "constructor"
	var/list/designs = list()
	var/datum/space_construction/current_design
	var/list/holding = list()
	var/building = 0

/obj/machinery/space_battle/space_construction/New()
	..()
	generate_designs()

/obj/machinery/space_battle/space_construction/proc/generate_designs()
	designs.Cut()
	var/list/to_add = typesof(/datum/space_construction)
	for(var/T in to_add)
		var/datum/space_construction/blueprint = new T(src)
		if(blueprint && blueprint.name)
			designs.Add(blueprint)
		else
			qdel(blueprint)
	return designs.len

/obj/machinery/space_battle/space_construction/update_icon()
	if(stat & (BROKEN|NOPOWER)) return ..()
	else
		if(building) icon_state = "constructor_building"
		else icon_state = "constructor"

/obj/machinery/space_battle/space_construction/proc/refund_materials(var/mob/user)
	for(var/material_name in current_design.required_materials)
		var/material_amount = initial(current_design.required_materials[material_name])
		material_amount -= current_design.required_materials[material_name]
		if(material_amount <= 0) continue
		var/material/M = get_material_by_name(material_name)
		if(!istype(M))
			continue
		var/obj/item/stack/material/S = new M.stack_type(get_turf(src))
		S.amount = material_amount
		S.forceMove(get_turf(user))
	for(var/obj/item/I in holding)
		I.forceMove(get_turf(user))
	current_design.required_materials = initial(current_design.required_materials)
	current_design.required_items = initial(current_design.required_items)
	current_design = null
	holding.Cut()

/obj/machinery/space_battle/space_construction/attack_hand(var/mob/user)
	if(stat & (BROKEN|NOPOWER)) return
	if(current_design)
		if(building == 2)
			if(current_design.complete(src, user))
				user << "<span class='notice'>Construction of [current_design.name] successful!</span>"
				current_design.required_materials = initial(current_design.required_materials)
				current_design.required_items = initial(current_design.required_items)
				current_design = null
			else
				user << "<span class='warning'>Unable to create design!</span>"
				refund_materials(user)
			building = 0
			update_icon()
			return
		else if(building)
			user << "<span class='warning'>\The [src] is currently busy!</span>"
			return
		var/yes = alert(user, "\The [src] already has a design loaded. Are you sure you want to override it?", "Construction", "No", "Yes")
		if(yes == "No") return 0
	var/list/choices = list()
	for(var/datum/space_construction/blueprint in designs)
		if(blueprint.name)
			choices.Add(list("[blueprint.name]" = blueprint))
	var/input = input(user, "What would you like to build?", "Construction") in choices
	var/datum/space_construction/selected = choices[input]
	if(current_design)
		refund_materials(user)
	if(selected && istype(selected))
		current_design = selected
		user.visible_message("<span class='notice'>\The [user] sets \the [src] to construct a [current_design.name]!</span>")
	else
		user << "<span class='warning'>You've selected an invalid choice!</span>"
		return 0
	return 1

/obj/machinery/space_battle/space_construction/attackby(var/obj/item/I, var/mob/user)
	if(!current_design)
		user << "<span class='warning'>You must select a design first!</span>"
	else if(istype(I, /obj/item/stack/material))
		var/obj/item/stack/material/S = I
		if(!(S.material.name in current_design.required_materials))
			user << "<span class='warning'>\The [src] buzzes; Wrong material.</span>"
		else
			if(current_design.required_materials["[S.material.name]"] <= 0)
				user << "<span class='notice'>\The [src] does not need anymore [S.material.display_name]!</span>"
			else if(S.get_amount() > 1)
				var/amount_to_take = min(S.amount, current_design.required_materials["[S.material.name]"]) // amount of cable to take, idealy amount required, but limited by amount provided
				S.use(amount_to_take)
				user.visible_message("<span class='notice'>\The [user] places [amount_to_take] [S.material.sheet_plural_name] of [S.material.display_name]  into \the [src]!</span>")
				current_design.required_materials["[S.material.name]"] -= amount_to_take
				if(current_design.check_complete())
					src.visible_message("<span class='warning'>\The [src] begins assembling \the [current_design.name]!</span>")
					building = 1
					update_icon()
					spawn(current_design.required_time*10)
						building = 2
	else if(is_type_in_list(I, current_design.required_items))
		if(!(I.type in current_design.required_items))
			user << "<span class='notice'>\The [src] does not need anymore [I.name]!</span>"
		else
			current_design.required_items[I.type] -= 1
			user.drop_item()
			holding += I
			I.forceMove(src)

	..()

/obj/machinery/space_battle/space_construction/examine(var/mob/user)
	..()
	if(current_design)
		user << "<span class='notice'>\The [src] is currently building a [current_design]!</span>"
		for(var/i=1 to current_design.required_materials.len)
			var/material_name = current_design.required_materials[i]
			var/material_amount = current_design.required_materials[material_name]
			if(material_amount)
				var/material/M = get_material_by_name(material_name)
				user << "<span class='notice'>\The [src] needs [material_amount] sheets of [M.display_name]!</span>"
		for(var/i=1 to current_design.required_items.len)
			var/item_type = current_design.required_items[i]
			var/item_amount = current_design.required_items[item_type]
			var/item_name = current_design.item_names[i]
			if(item_amount && item_name)
				user << "<span class='notice'>\The [src] needs [item_amount] more [item_name]!</span>"
	else
		user << "<span class='notice'>\The [src] currently has no design loaded!</span>"


/*******
DESIGNS*
********/

/datum/space_construction
	var/name
	var/list/required_materials = list("plasteel" = 150) // Sheets
	var/required_time = 60 // Seconds
	var/list/required_items = list(/obj/item/weapon/crowbar = 1)
	var/list/item_names = list()

/datum/space_construction/New()
	..()
	for(var/i=1 to required_items.len)
		var/item_type = required_items[i]
		var/obj/item/I = new item_type
		item_names += I.name
		qdel(I)

/datum/space_construction/proc/complete(var/obj/machinery/space_battle/space_construction/creator)
	return 1

/datum/space_construction/proc/check_complete()
	for(var/i=1 to required_materials.len)
		var/N = required_materials[i]
		if(required_materials[N] > 0)
			return 0
	for(var/i=1 to required_items.len)
		var/O = required_items[i]
		if(required_items[O] > 0)
			return 0
	return 1

/*******
*JAMMER*
*******/

/datum/space_construction/ftl_jammer
	name = "FTL Jammer"
	required_materials = list("plasteel" = 150, "rglass" = 50, "plastic" = 10)
	required_time = 600
	required_items = list(/obj/item/weapon/circuitboard/space_battle/sensor/hub = 1, \
								   /obj/item/weapon/circuitboard/space_battle/sensor/dish = 4)

/datum/space_construction/jammer/complete(var/obj/machinery/space_battle/space_construction/creator)
	var/obj/effect/overmap/linked = map_sectors["[creator.z]"]
	if(linked)
		var/obj/effect/overmap/station/jammer/created = new(src)
		created.forceMove(get_turf(linked))
		created.team = linked.team
		return 1
	return 0

/obj/effect/overmap/station/jammer
	name = "FTL Jammer"
	desc = "A FTL Jammer. Slows down enemy ships."
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "inhibitor"
	fake = 1

	New()
		..()
		processing_objects.Add(src)
		fake_ship = new /datum/fake_ship/jammer(src)
		fake_ship.team = src.team

	process()
		if(fake_ship.health == 0) return
		for(var/obj/effect/overmap/ship/S in range(3))
			if(S.team != src.team)
				if(S.get_speed() > 1)
					S.decelerate(1)
		..()

	Destroy()
		processing_objects.Remove(src)
		..()

/datum/fake_ship/jammer
	health = 50
	maxhealth = 50
	totally_destroyed = 0

/*********
*BLOCKADE*
*********/

/datum/space_construction/blockade
	name = "Blockade"
	required_materials = list("plasteel" = 100)
	required_time = 500
	required_items = list()

/datum/space_construction/blockade/complete(var/obj/machinery/space_battle/space_construction/creator)
	var/obj/effect/overmap/linked = map_sectors["[creator.z]"]
	if(linked)
		var/obj/effect/overmap/station/blockade/created = new
		created.forceMove(get_turf(linked))
		created.team = 0
		return 1
	return 0

/obj/effect/overmap/station/blockade
	name = "blockade"
	desc = "A solid chunk of metal. You shall not pass!"
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "asteroid_large"
	density = 1

/obj/effect/overmap/station/blockade/New()
	..()
	processing_objects.Add(src)
	fake_ship = new /datum/fake_ship/blockade(src)
	fake_ship.team = 0

/datum/fake_ship/blockade
	health = 200
	maxhealth = 200

/*****
*SHIP*
*****/

/datum/space_construction/ship
	name = "New Ship"
	required_materials = list("plasteel" = 200, "rglass" = 100,)
	required_time = 500
	required_items = list()

/datum/space_construction/ship/complete(var/obj/machinery/space_battle/space_construction/creator, var/mob/user)
	var/N = input(user, "What name would you like the new ship to have?(<25 chars)", "Construction")
	var/area/ship_battle/A = get_area(creator)
	var/obj/effect/overmap/linked = map_sectors["[creator.z]"]
	if(!linked || !A)
		return 0
	if(!N || length(N) > 25)
		user << "<span class='warning'>Invalid name!</span>"
		return 0
	var/I = input(user, "Enter desired warp ID(<25 chars)", "Construction")
	if(!I || length(I) > 25)
		user << "<span class='warning'>Invalid name!</span>"
		return 0
	build_ship(50, 50, N, A.team, I, linked)
	return 1


/**********
*WARP GATE*
**********/

/datum/space_construction/warp_gate
	name = "Warp Gate"
	required_materials = list("plasteel" = 80,
							  "rglass" = 40,
							  "phoron" = 20)
	required_time = 500
	required_items = list(/obj/item/weapon/circuitboard/space_battle/warp_pad = 1)

/datum/space_construction/warp_gate/complete(var/obj/machinery/space_battle/space_construction/creator, var/mob/user)
	var/warp_id = input(user, "What would you like the warp gate's ID to be?", "Construction")
	var/obj/effect/overmap/linked = map_sectors["[creator.z]"]
	if(linked && warp_id && length(warp_id) <= 25)
		new /obj/effect/overmap/station/warp_gate(get_turf(linked), warp_id, linked.team)
		return 1
	return 0

/obj/effect/overmap/station/warp_gate
	name = "blockade"
	desc = "A solid chunk of metal. You shall not pass!"
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "warp_pad"
	density = 1
	var/obj/effect/overmap/station/warp_gate/destination
	var/warp_id
	var/teleporting = 0

/obj/effect/overmap/station/warp_gate/New(var/new_team, var/id_tag)
	..()
	warp_id = id_tag
	team = new_team
	for(var/obj/effect/overmap/station/warp_gate/G in world)
		if(G.warp_id == src.warp_id && G.team == src.team)
			destination = G
			break

/obj/effect/overmap/station/warp_gate/Crossed(var/atom/A)
	..()
	if(istype(A, /obj/effect/overmap/ship) && !teleporting)
		var/obj/effect/overmap/ship/S = A
		if(S.team == src.team)
			destination.teleporting = 1
			S.forceMove(get_turf(destination))
			spawn(0) destination.teleporting = 0
