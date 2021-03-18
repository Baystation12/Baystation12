/obj/structure/table
	name = "table frame"
	icon = 'icons/obj/tables.dmi'
	icon_state = "frame"
	desc = "It's a table, for putting things on. Or standing on, if you really want to."
	density = TRUE
	anchored = TRUE
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	layer = TABLE_LAYER
	throwpass = 1
	mob_offset = 12
	var/flipped = 0
	var/maxhealth = 10
	var/health = 10

	// For racks.
	var/can_reinforce = 1
	var/can_plate = 1

	var/manipulating = 0
	var/material/reinforced = null

	// Gambling tables. I'd prefer reinforced with carpet/felt/cloth/whatever, but AFAIK it's either harder or impossible to get /obj/item/stack/material of those.
	// Convert if/when you can easily get stacks of these.
	var/carpeted = 0

	connections = list("nw0", "ne0", "sw0", "se0")

/obj/structure/table/New()
	if(istext(material))
		material = SSmaterials.get_material_by_name(material)
	if(istext(reinforced))
		reinforced = SSmaterials.get_material_by_name(reinforced)
	..()

/obj/structure/table/proc/update_material()
	var/old_maxhealth = maxhealth
	if(!material)
		maxhealth = 10
	else
		maxhealth = material.integrity / 2

		if(reinforced)
			maxhealth += reinforced.integrity / 2

	health += maxhealth - old_maxhealth

/obj/structure/table/take_damage(amount)
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

/obj/structure/table/Initialize()
	. = ..()

	// One table per turf.
	for(var/obj/structure/table/T in loc)
		if(T != src)
			// There's another table here that's not us, break to metal.
			// break_to_parts calls qdel(src)
			break_to_parts(full_return = 1)
			return

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
	. = ..()

/obj/structure/table/examine(mob/user)
	. = ..()
	if(health < maxhealth)
		switch(health / maxhealth)
			if(0.0 to 0.5)
				to_chat(user, "<span class='warning'>It looks severely damaged!</span>")
			if(0.25 to 0.5)
				to_chat(user, "<span class='warning'>It looks damaged!</span>")
			if(0.5 to 1.0)
				to_chat(user, "<span class='notice'>It has a few scrapes and dents.</span>")

/obj/structure/table/attackby(obj/item/W, mob/user)
	if(reinforced && isScrewdriver(W))
		remove_reinforced(W, user)
		if(!reinforced)
			update_desc()
			update_icon()
			update_material()
		return 1

	if(carpeted && isCrowbar(W))
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
			to_chat(user, "<span class='warning'>You don't have enough carpet!</span>")
	if(!reinforced && !carpeted && material && isWrench(W) && user.a_intent == I_HURT) //robots dont have disarm so it's harm
		remove_material(W, user)
		if(!material)
			update_connections(1)
			update_icon()
			for(var/obj/structure/table/T in oview(src, 1))
				T.update_icon()
			update_desc()
			update_material()
		return 1

	if(!carpeted && !reinforced && !material && isWrench(W) && user.a_intent == I_HURT)
		dismantle(W, user)
		return 1

	if(health < maxhealth && isWelder(W))
		var/obj/item/weldingtool/F = W
		if(F.welding)
			to_chat(user, "<span class='notice'>You begin reparing damage to \the [src].</span>")
			playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
			if(!do_after(user, 20, src) || !F.remove_fuel(1, user))
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
	if(istype(W, /obj/item/hand)) //playing cards
		var/obj/item/hand/H = W
		if(H.cards && H.cards.len == 1)
			usr.visible_message("\The [user] plays \the [H.cards[1].name].")
	return ..()

/obj/structure/table/MouseDrop_T(obj/item/stack/material/what)
	if(can_reinforce && isliving(usr) && (!usr.stat) && istype(what) && usr.get_active_hand() == what && Adjacent(usr))
		reinforce_table(what, usr)
	else
		return ..()

/obj/structure/table/proc/reinforce_table(obj/item/stack/material/S, mob/user)
	if(reinforced)
		to_chat(user, "<span class='warning'>\The [src] is already reinforced!</span>")
		return

	if(!can_reinforce)
		to_chat(user, "<span class='warning'>\The [src] cannot be reinforced!</span>")
		return

	if(!material)
		to_chat(user, "<span class='warning'>Plate \the [src] before reinforcing it!</span>")
		return

	if(flipped)
		to_chat(user, "<span class='warning'>Put \the [src] back in place before reinforcing it!</span>")
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
	var/material/M = S.get_material()
	if(!istype(M))
		to_chat(user, "<span class='warning'>You cannot [verb]e \the [src] with \the [S].</span>")
		return null

	if(manipulating) return M
	manipulating = 1
	to_chat(user, "<span class='notice'>You begin [verb]ing \the [src] with [M.display_name].</span>")
	if(!do_after(user, 20, src) || !S.use(1))
		manipulating = 0
		return null
	user.visible_message("<span class='notice'>\The [user] [verb]es \the [src] with [M.display_name].</span>", "<span class='notice'>You finish [verb]ing \the [src].</span>")
	manipulating = 0
	return M

// Returns the material to set the table to.
/obj/structure/table/proc/common_material_remove(mob/user, material/M, delay, what, type_holding, sound)
	if(!M.stack_type)
		to_chat(user, "<span class='warning'>You are unable to remove the [what] from this table!</span>")
		return M

	if(manipulating) return M
	manipulating = 1
	user.visible_message("<span class='notice'>\The [user] begins removing the [type_holding] holding \the [src]'s [M.display_name] [what] in place.</span>",
	                              "<span class='notice'>You begin removing the [type_holding] holding \the [src]'s [M.display_name] [what] in place.</span>")
	if(sound)
		playsound(src.loc, sound, 50, 1)
	if(!do_after(user, 40, src))
		manipulating = 0
		return M
	user.visible_message("<span class='notice'>\The [user] removes the [M.display_name] [what] from \the [src].</span>",
	                              "<span class='notice'>You remove the [M.display_name] [what] from \the [src].</span>")
	M.place_sheet(src.loc)
	manipulating = 0
	return null

/obj/structure/table/proc/remove_reinforced(obj/item/screwdriver/S, mob/user)
	reinforced = common_material_remove(user, reinforced, 40, "reinforcements", "screws", 'sound/items/Screwdriver.ogg')

/obj/structure/table/proc/remove_material(obj/item/wrench/W, mob/user)
	material = common_material_remove(user, material, 20, "plating", "bolts", 'sound/items/Ratchet.ogg')

/obj/structure/table/proc/dismantle(obj/item/wrench/W, mob/user)
	reset_mobs_offset()
	if(manipulating) return
	manipulating = 1
	user.visible_message("<span class='notice'>\The [user] begins dismantling \the [src].</span>",
	                              "<span class='notice'>You begin dismantling \the [src].</span>")
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	if(!do_after(user, 20, src))
		manipulating = 0
		return
	user.visible_message("<span class='notice'>\The [user] dismantles \the [src].</span>",
	                              "<span class='notice'>You dismantle \the [src].</span>")
	new /obj/item/stack/material/steel(src.loc)
	qdel(src)
	return

// Returns a list of /obj/item/material/shard objects that were created as a result of this table's breakage.
// Used for !fun! things such as embedding shards in the faces of tableslammed people.

// The repeated
//     S = [x].place_shard(loc)
//     if(S) shards += S
// is to avoid filling the list with nulls, as place_shard won't place shards of certain materials (holo-wood, holo-steel)

/obj/structure/table/proc/break_to_parts(full_return = 0)
	reset_mobs_offset()
	var/list/shards = list()
	var/obj/item/material/shard/S = null
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
		var/material/M = SSmaterials.get_material_by_name(MATERIAL_STEEL)
		S = M.place_shard(loc)
		if(S) shards += S
	qdel(src)
	return shards

/obj/structure/table/on_update_icon()
	if(!flipped)
		mob_offset = initial(mob_offset)
		icon_state = "blank"
		overlays.Cut()

		var/image/I

		// Base frame shape. Mostly done for glass/diamond tables, where this is visible.
		for(var/i = 1 to 4)
			I = image(icon, dir = 1<<(i-1), icon_state = connections[i])
			overlays += I

		// Standard table image
		if(material)
			for(var/i = 1 to 4)
				I = image(icon, "[material.table_icon_base]_[connections[i]]", dir = 1<<(i-1))
				if(material.icon_colour) I.color = material.icon_colour
				I.alpha = 255 * material.opacity
				overlays += I

		// Reinforcements
		if(reinforced)
			for(var/i = 1 to 4)
				I = image(icon, "[reinforced.table_reinf]_[connections[i]]", dir = 1<<(i-1))
				I.color = reinforced.icon_colour
				I.alpha = 255 * reinforced.opacity
				overlays += I

		if(carpeted)
			for(var/i = 1 to 4)
				I = image(icon, "carpet_[connections[i]]", dir = 1<<(i-1))
				overlays += I
	else
		mob_offset = 0
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
			var/image/I = image(icon, "[material.table_icon_base]_flip[type]")
			I.color = material.icon_colour
			I.alpha = 255 * material.opacity
			overlays += I
			name = "[material.display_name] table"
		else
			name = "table frame"

		if(reinforced)
			var/image/I = image(icon, "[reinforced.table_reinf]_flip[type]")
			I.color = reinforced.icon_colour
			I.alpha = 255 * reinforced.opacity
			overlays += I

		if(carpeted)
			overlays += "carpet_flip[type]"

/obj/structure/table/proc/can_connect()
	return TRUE

// set propagate if you're updating a table that should update tables around it too, for example if it's a new table or something important has changed (like material).
/obj/structure/table/update_connections(propagate=0)
	if(!material)
		connections = list("0", "0", "0", "0")

		if(propagate)
			for(var/obj/structure/table/T in oview(src, 1))
				T.update_connections()
		return

	var/list/blocked_dirs = list()
	for(var/obj/structure/window/W in get_turf(src))
		if(W.is_fulltile())
			connections = list("0", "0", "0", "0")
			return
		blocked_dirs |= W.dir

	for(var/D in list(NORTH, SOUTH, EAST, WEST) - blocked_dirs)
		var/turf/T = get_step(src, D)
		for(var/obj/structure/window/W in T)
			if(W.is_fulltile() || W.dir == GLOB.reverse_dir[D])
				blocked_dirs |= D
				break
			else
				if(W.dir != D) // it's off to the side
					blocked_dirs |= W.dir|D // blocks the diagonal

	for(var/D in list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST) - blocked_dirs)
		var/turf/T = get_step(src, D)

		for(var/obj/structure/window/W in T)
			if(W.is_fulltile() || (W.dir & GLOB.reverse_dir[D]))
				blocked_dirs |= D
				break

	// Blocked cardinals block the adjacent diagonals too. Prevents weirdness with tables.
	for(var/x in list(NORTH, SOUTH))
		for(var/y in list(EAST, WEST))
			if((x in blocked_dirs) || (y in blocked_dirs))
				blocked_dirs |= x|y

	var/list/connection_dirs = list()

	for(var/obj/structure/table/T in orange(src, 1))
		if(!T.can_connect()) continue
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
#define CORNER_COUNTERCLOCKWISE 1
#define CORNER_DIAGONAL 2
#define CORNER_CLOCKWISE 4

/*
	turn() is weird:
		turn(icon, angle) turns icon by angle degrees clockwise
		turn(matrix, angle) turns matrix by angle degrees clockwise
		turn(dir, angle) turns dir by angle degrees counter-clockwise
*/

/proc/dirs_to_corner_states(list/dirs)
	if(!istype(dirs)) return

	var/list/ret = list(NORTHWEST, SOUTHEAST, NORTHEAST, SOUTHWEST)

	for(var/i = 1 to ret.len)
		var/dir = ret[i]
		. = CORNER_NONE
		if(dir in dirs)
			. |= CORNER_DIAGONAL
		if(turn(dir,45) in dirs)
			. |= CORNER_COUNTERCLOCKWISE
		if(turn(dir,-45) in dirs)
			. |= CORNER_CLOCKWISE
		ret[i] = "[.]"

	return ret

#undef CORNER_NONE
#undef CORNER_COUNTERCLOCKWISE
#undef CORNER_DIAGONAL
#undef CORNER_CLOCKWISE
