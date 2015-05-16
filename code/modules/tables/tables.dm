/obj/structure/table
	name = "table frame"
	icon = 'icons/obj/tables.dmi'
	icon_state = "frame"
	desc = "It's a table, for putting things on. Or standing on, if you really want to."
	density = 1
	anchored = 1
	climbable = 1
	layer = 2.8
	throwpass = 1
	var/flipped = 0
	var/maxhealth = 10
	var/health = 10

	// For racks.
	var/can_reinforce = 1
	var/can_plate = 1

	var/manipulating = 0
	var/material/material = null
	var/material/reinforced = null

	// Gambling tables. I'd prefer reinforced with carpet/felt/cloth/whatever, but AFAIK it's either harder or impossible to get /obj/item/stack/material of those.
	// Convert if/when you can easily get stacks of these.
	var/carpeted = 0

	var/list/connections = list("nw0", "ne0", "sw0", "se0")

/obj/structure/table/proc/update_material()
	var/old_maxhealth = maxhealth
	if(!material)
		maxhealth = 10
	else
		maxhealth = material.integrity / 2

		if(reinforced)
			maxhealth += reinforced.integrity / 2

	health += maxhealth - old_maxhealth

/obj/structure/table/proc/take_damage(amount)
	// If the table is made of a brittle material, and is *not* reinforced with a non-brittle material, damage is multiplied by TABLE_BRITTLE_MATERIAL_MULTIPLIER
	if(material && material.is_brittle())
		if(reinforced)
			if(reinforced.is_brittle())
				amount *= TABLE_BRITTLE_MATERIAL_MULTIPLIER
		else
			amount *= TABLE_BRITTLE_MATERIAL_MULTIPLIER
	health -= amount
	if(health <= 0)
		visible_message("<span class='warning'>\The [src] breaks down!</span>")
		return break_to_parts() // if we break and form shards, return them to the caller to do !FUN! things with

/obj/structure/table/New()
	..()
	// One table per turf.
	for(var/obj/structure/table/T in loc)
		if(T != src)
			// There's another table here that's not us, break to metal.
			// break_to_parts calls qdel(src)
			break_to_parts(full_return = 1)
			return

/obj/structure/table/initialize()
	..()
	// reset color/alpha, since they're set for nice map previews
	color = "#ffffff"
	alpha = 255
	update_connections(1)
	update_icon()
	update_desc()
	update_material()

/obj/structure/table/Destroy()
	material = null
	reinforced = null
	update_connections(1) // Update tables around us to ignore us (material=null forces no connections)
	for(var/obj/structure/table/T in oview(src, 1))
		T.update_icon()
	..()

/obj/structure/table/examine(mob/user)
	. = ..()
	if(health < maxhealth)
		switch(health / maxhealth)
			if(0.0 to 0.5)
				user << "<span class='warning'>It looks severely damaged!</span>"
			if(0.25 to 0.5)
				user << "<span class='warning'>It looks damaged!</span>"
			if(0.5 to 1.0)
				user << "<span class='notice'>It has a few scrapes and dents.</span>"

/obj/structure/table/attackby(obj/item/weapon/W, mob/user)

	if(reinforced && istype(W, /obj/item/weapon/screwdriver))
		remove_reinforced(W, user)
		if(!reinforced)
			update_desc()
			update_icon()
			update_material()
		return 1

	if(carpeted && istype(W, /obj/item/weapon/crowbar))
		user.visible_message("<span class='notice'>\The [user] removes the carpet from \the [src].</span>",
		                              "<span class='notice'>You remove the carpet from \the [src].</span>")
		new /obj/item/stack/tile/carpet(loc)
		carpeted = 0
		update_icon()
		return 1

	if(!carpeted && material && istype(W, /obj/item/stack/tile/carpet))
		var/obj/item/stack/tile/carpet/C = W
		if(C.use(1))
			user.visible_message("<span class='notice'>\The [user] adds \the [C] to \the [src].</span>",
			                              "<span class='notice'>You add \the [C] to \the [src].</span>")
			carpeted = 1
			update_icon()
			return 1
		else
			user << "<span class='warning'>You don't have enough carpet!</span>"

	if(!reinforced && !carpeted && material && istype(W, /obj/item/weapon/wrench))
		remove_material(W, user)
		if(!material)
			update_connections(1)
			update_icon()
			for(var/obj/structure/table/T in oview(src, 1))
				T.update_icon()
			update_desc()
			update_material()
		return 1

	if(!carpeted && !reinforced && !material && istype(W, /obj/item/weapon/wrench))
		dismantle(W, user)
		return 1

	if(health < maxhealth && istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/F = W
		if(F.welding)
			user << "<span class='notice'>You begin reparing damage to \the [src].</span>"
			playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
			if(!do_after(user, 20) || !F.remove_fuel(1, user))
				return
			user.visible_message("<span class='notice'>\The [user] repairs some damage to \the [src].</span>",
			                              "<span class='notice'>You repair some damage to \the [src].</span>")
			health = max(health+(maxhealth/5), maxhealth) // 20% repair per application
			return 1

	if(!material && can_plate && istype(W, /obj/item/stack/material))
		material = common_material_add(W, user, "plat")
		if(material)
			update_connections(1)
			update_icon()
			update_desc()
			update_material()
		return 1

	return ..()

/obj/structure/table/MouseDrop_T(obj/item/stack/material/what)
	if(can_reinforce && isliving(usr) && (!usr.stat) && istype(what) && usr.get_active_hand() == what && Adjacent(usr))
		reinforce_table(what, usr)
	else
		return ..()

/obj/structure/table/proc/reinforce_table(obj/item/stack/material/S, mob/user)
	if(reinforced)
		user << "<span class='warning'>\The [src] is already reinforced!</span>"
		return

	if(!can_reinforce)
		user << "<span class='warning'>\The [src] cannot be reinforced!</span>"
		return

	if(!material)
		user << "<span class='warning'>Plate \the [src] before reinforcing it!</span>"
		return

	reinforced = common_material_add(S, user, "reinforc")
	if(reinforced)
		update_desc()
		update_icon()
		update_material()

/obj/structure/table/proc/update_desc()
	if(material)
		name = "[material.display_name] table"
	else
		name = "table frame"

	if(reinforced)
		name = "reinforced [name]"
		desc = "[initial(desc)] This one seems to be reinforced with [reinforced.display_name]."
	else
		desc = initial(desc)

// Returns the material to set the table to.
/obj/structure/table/proc/common_material_add(obj/item/stack/material/S, mob/user, verb) // Verb is actually verb without 'e' or 'ing', which is added. Works for 'plate'/'plating' and 'reinforce'/'reinforcing'.
	var/material/M = name_to_material[S.default_type]
	if(!istype(M))
		user << "<span class='warning'>You cannot [verb]e \the [src] with \the [S].</span>"
		return null

	if(manipulating) return M
	manipulating = 1
	user << "<span class='notice'>You begin [verb]ing \the [src] with [M.display_name].</span>"
	if(!do_after(user, 20) || !S.use(1))
		manipulating = 0
		return null
	user.visible_message("<span class='notice'>\The [user] [verb]es \the [src] with [M.display_name].</span>", "<span class='notice'>You finish [verb]ing \the [src].</span>")
	manipulating = 0
	return M

// Returns the material to set the table to.
/obj/structure/table/proc/common_material_remove(mob/user, material/M, delay, what, type_holding, sound)
	if(!M.stack_type)
		user << "<span class='warning'>You are unable to remove the [what] from this table!</span>"
		return M

	if(manipulating) return M
	manipulating = 1
	user.visible_message("<span class='notice'>\The [user] begins removing the [type_holding] holding \the [src]'s [M.display_name] [what] in place.</span>",
	                              "<span class='notice'>You begin removing the [type_holding] holding \the [src]'s [M.display_name] [what] in place.</span>")
	if(sound)
		playsound(src.loc, sound, 50, 1)
	if(!do_after(user, 40))
		manipulating = 0
		return M
	user.visible_message("<span class='notice'>\The [user] removes the [M.display_name] [what] from \the [src].</span>",
	                              "<span class='notice'>You remove the [M.display_name] [what] from \the [src].</span>")
	new M.stack_type(src.loc)
	manipulating = 0
	return null

/obj/structure/table/proc/remove_reinforced(obj/item/weapon/screwdriver/S, mob/user)
	reinforced = common_material_remove(user, reinforced, 40, "reinforcements", "screws", 'sound/items/Screwdriver.ogg')

/obj/structure/table/proc/remove_material(obj/item/weapon/wrench/W, mob/user)
	material = common_material_remove(user, material, 20, "plating", "bolts", 'sound/items/Ratchet.ogg')

/obj/structure/table/proc/dismantle(obj/item/weapon/wrench/W, mob/user)
	if(manipulating) return
	manipulating = 1
	user.visible_message("<span class='notice'>\The [user] begins dismantling \the [src].</span>",
	                              "<span class='notice'>You begin dismantling \the [src].</span>")
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	if(!do_after(user, 20))
		manipulating = 0
		return
	user.visible_message("<span class='notice'>\The [user] dismantles \the [src].</span>",
	                              "<span class='notice'>You dismantle \the [src].</span>")
	new /obj/item/stack/material/steel(src.loc)
	qdel(src)
	return

// Returns a list of /obj/item/weapon/material/shard objects that were created as a result of this table's breakage.
// Used for !fun! things such as embedding shards in the faces of tableslammed people.

// The repeated
//     S = [x].place_shard(loc)
//     if(S) shards += S
// is to avoid filling the list with nulls, as place_shard won't place shards of certain materials (holo-wood, holo-steel)

/obj/structure/table/proc/break_to_parts(full_return = 0)
	var/list/shards = list()
	var/obj/item/weapon/material/shard/S = null
	if(reinforced)
		if(reinforced.stack_type && (full_return || prob(20)))
			reinforced.place_sheet(loc)
		else
			S = reinforced.place_shard(loc)
			if(S) shards += S
	if(material)
		if(material.stack_type && (full_return || prob(20)))
			material.place_sheet(loc)
		else
			S = material.place_shard(loc)
			if(S) shards += S
	if(carpeted && (full_return || prob(50))) // Higher chance to get the carpet back intact, since there's no non-intact option
		new /obj/item/stack/tile/carpet(src.loc)
	if(full_return || prob(20))
		new /obj/item/stack/material/steel(src.loc)
	else
		var/material/M = get_material_by_name(DEFAULT_WALL_MATERIAL)
		S = M.place_shard(loc)
		if(S) shards += S
	qdel(src)
	return shards

/obj/structure/table/update_icon()
	if(flipped != 1)
		icon_state = "blank"
		overlays.Cut()

		// Base frame shape. Mostly done for glass/diamond tables, where this is visible.
		for(var/n in connections)
			overlays += n

		// Standard table image
		if(material)
			for(var/n in connections)
				var/image/I = image(icon, "[material.icon_base]_[n]")
				I.color = material.icon_colour
				I.alpha = 255 * material.opacity
				overlays += I

		// Reinforcements
		if(reinforced)
			for(var/n in connections)
				var/image/I = image(icon, "[reinforced.icon_reinf]_[n]")
				I.color = reinforced.icon_colour
				I.alpha = 255 * reinforced.opacity
				overlays += I

		if(carpeted)
			for(var/n in connections)
				overlays += "carpet_[n]"
	else
		overlays.Cut()
		var/type = 0
		var/tabledirs = 0
		for(var/direction in list(turn(dir,90), turn(dir,-90)) )
			var/obj/structure/table/T = locate(/obj/structure/table ,get_step(src,direction))
			if (T && T.flipped == 1 && T.dir == src.dir && material && T.material && T.material.name == material.name)
				type++
				tabledirs |= direction

		type = "[type]"
		if (type=="1")
			if (tabledirs & turn(dir,90))
				type += "-"
			if (tabledirs & turn(dir,-90))
				type += "+"

		icon_state = "flip[type]"
		if(material)
			var/image/I = image(icon, "[material.icon_base]_flip[type]")
			I.color = material.icon_colour
			I.alpha = 255 * material.opacity
			overlays += I
			name = "[material.display_name] table"
		else
			name = "table frame"

		if(reinforced)
			var/image/I = image(icon, "[reinforced.icon_reinf]_flip[type]")
			I.color = reinforced.icon_colour
			I.alpha = 255 * reinforced.opacity
			overlays += I

		if(carpeted)
			for(var/n in connections)
				overlays += "carpet_flip[type]"

// set propagate if you're updating a table that should update tables around it too, for example if it's a new table or something important has changed (like material).
/obj/structure/table/proc/update_connections(propagate=0)
	if(!material)
		connections = list("nw0", "ne0", "sw0", "se0")

		if(propagate)
			for(var/obj/structure/table/T in oview(src, 1))
				T.update_connections()
		return

	var/list/blocked_dirs = list()
	for(var/obj/structure/window/W in get_turf(src))
		if(W.is_fulltile())
			connections = list("nw0", "ne0", "sw0", "se0")
			return
		blocked_dirs |= W.dir

	for(var/D in list(NORTH, SOUTH, EAST, WEST) - blocked_dirs)
		var/turf/T = get_step(src, D)
		for(var/obj/structure/window/W in T)
			if(W.is_fulltile() || W.dir == reverse_dir[D])
				blocked_dirs |= D
				break
			else
				if(W.dir != D) // it's off to the side
					blocked_dirs |= W.dir|D // blocks the diagonal

	for(var/D in list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST) - blocked_dirs)
		var/turf/T = get_step(src, D)

		for(var/obj/structure/window/W in T)
			if(W.is_fulltile() || W.dir & reverse_dir[D])
				blocked_dirs |= D
				break

	// Blocked cardinals block the adjacent diagonals too. Prevents weirdness with tables.
	for(var/x in list(NORTH, SOUTH))
		for(var/y in list(EAST, WEST))
			if((x in blocked_dirs) || (y in blocked_dirs))
				blocked_dirs |= x|y

	var/list/connection_dirs = list()

	for(var/obj/structure/table/T in oview(src, 1))
		var/T_dir = get_dir(src, T)
		if(T_dir in blocked_dirs) continue
		if(material && T.material && material.name == T.material.name && flipped == T.flipped)
			connection_dirs |= T_dir
		if(propagate)
			spawn(0)
				T.update_connections()
				T.update_icon()

	connections = dirs_to_corner_states(connection_dirs)

#define CORNER_NONE 0
#define CORNER_EASTWEST 1
#define CORNER_DIAGONAL 2
#define CORNER_NORTHSOUTH 4

/proc/dirs_to_corner_states(list/dirs)
	if(!istype(dirs)) return

	var/NE = CORNER_NONE
	var/NW = CORNER_NONE
	var/SE = CORNER_NONE
	var/SW = CORNER_NONE

	if(NORTH in dirs)
		NE |= CORNER_NORTHSOUTH
		NW |= CORNER_NORTHSOUTH
	if(SOUTH in dirs)
		SW |= CORNER_NORTHSOUTH
		SE |= CORNER_NORTHSOUTH
	if(EAST in dirs)
		SE |= CORNER_EASTWEST
		NE |= CORNER_EASTWEST
	if(WEST in dirs)
		NW |= CORNER_EASTWEST
		SW |= CORNER_EASTWEST
	if(NORTHWEST in dirs)
		NW |= CORNER_DIAGONAL
	if(NORTHEAST in dirs)
		NE |= CORNER_DIAGONAL
	if(SOUTHEAST in dirs)
		SE |= CORNER_DIAGONAL
	if(SOUTHWEST in dirs)
		SW |= CORNER_DIAGONAL

	return list("ne[NE]", "se[SE]", "sw[SW]", "nw[NW]")

#undef CORNER_NONE
#undef CORNER_EASTWEST
#undef CORNER_DIAGONAL
#undef CORNER_NORTHSOUTH
