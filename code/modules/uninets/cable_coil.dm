// =
// = The Unified(-Type-Tree) Cable Network System
// = Written by Sukasa with assistance from Googolplexed
// =
// = Cleans up the type tree and reduces future code maintenance
// = Also makes it easy to add new cable & network types
// =

// Unified Cable Network System - Generic Cable Coil Class

/obj/item/cable_coil
	name = "cable coil"
	icon_state = "whitecoil3"
	icon = 'icons/obj/Coils.dmi'
	flags = TABLEPASS | USEDELAY | FPRINT | CONDUCT
	throwforce = 10
	w_class = 2
	throw_speed = 2
	throw_range = 5
	item_state = ""

	var/amount = 30

	var/coil_colour = "generic"
	var/base_name = "generic"
	var/short_desc = "A piece of generic cable"
	var/long_desc = "A long piece of generic cable"
	var/coil_desc = "A spool of generic cable"
	var/max_amount = 30
	var/cable_type = /obj/structure/uninet_link/cable
	var/can_lay_diagonally = 1

/obj/item/cable_coil/New(location, new_length)
	if(!new_length)
		new_length = max_amount

	amount = new_length
	item_state = "[coil_colour]coil"
	icon_state = "[coil_colour]coil"
	pixel_x = rand(-4,4)
	pixel_y = rand(-4,4)
	update_icon()
	name = "[base_name] cable"
	return ..(location)


/obj/item/cable_coil/update_icon()
	if(amount == 1)
		icon_state = "[coil_colour]coil1"
		item_state = "[coil_colour]coil1"
	else if(amount == 2)
		icon_state = "[coil_colour]coil2"
		item_state = "[coil_colour]coil2"
	else
		icon_state = "[coil_colour]coil3"
		item_state = "[coil_colour]coil3"
	return

/obj/item/cable_coil/examine()
	..()
	if(amount == 1)
		usr << short_desc
	else if(amount == 2)
		usr << long_desc
	else
		usr << coil_desc
		usr << "There are [amount] usable lengths on the spool"
	return

/obj/item/cable_coil/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/wirecutters) && amount > 2)
		amount--
		new /obj/item/cable_coil(user.loc, 1)
		user << "You cut a length off the [name]."
		update_icon()
		return

	else if(istype(W, /obj/item/cable_coil))
		var/obj/item/cable_coil/C = W
		if(C.cable_type != cable_type)
			user << "\red You can't combine different kinds of cabling!"
			return

		if(C.amount == max_amount)
			user << "\red The coil is too long, you cannot add any more cable to it."
			return

		if((C.amount + amount <= max_amount))
			C.amount += amount
			user << "You join the [name]s together."
			C.update_icon()
			del src
			return

		else
			user << "You transfer [max_amount - amount] lengths of cable from one coil to the other."
			amount -= (max_amount - C.amount)
			update_icon()
			C.amount = max_amount
			C.update_icon()
			return

	return 1

/obj/item/cable_coil/proc/useCable(var/used)
	if(amount < used)
		return 0
	else if(amount == used)
		del src
		return 1
	else
		amount -= used
		update_icon()
		return 1

/obj/item/cable_coil/proc/layCable(var/mob/user, var/turf/simulated/floor/floor, var/new_dir, var/obj/structure/uninet_link/cable/join_cable = null)
	if(get_dist(floor, user) > 1)
		user << "\red You can't lay [name] that far away."
		return

	if(!floor.is_plating())
		user << "\red You must remove the plating first."
		return

	if(!can_lay_diagonally && (new_dir & new_dir - 1))
		user << "\red You can't lay [name] diagonally."
		return

	if(join_cable && (join_cable.dir1 != 0 || join_cable.dir2 == new_dir))
		return

	var/new_cable_type = equiv_cable_type_lookup[cable_type]

	if(join_cable && join_cable.equivalent_cable_type != new_cable_type)
		user << "\red You can't connect [name] to that."

	var/new_dir1
	var/new_dir2

	if(join_cable)
		if(new_dir < join_cable.dir2)
			new_dir1 = new_dir
			new_dir2 = join_cable.dir2
		else
			new_dir1 = join_cable.dir2
			new_dir2 = new_dir
	else
		new_dir1 = 0
		new_dir2 = new_dir

	for(var/obj/structure/uninet_link/cable/existing_cable in floor)
		if(existing_cable.dir1 == new_dir1 && existing_cable.dir2 == new_dir2)
			if(existing_cable.equivalent_cable_type == new_cable_type)
				user << "\red There's already [existing_cable.name] at that position."
				return

	var/obj/structure/uninet_link/cable/new_cable = new cable_type(floor, new_dir1, new_dir2)

	if(join_cable)
		join_cable.transfer_fingerprints_to(new_cable)
		del join_cable

	transfer_fingerprints_to(new_cable)
	new_cable.userTouched(user)
	new_cable.update_icon()
	useCable(1)

	return

/obj/item/cable_coil/afterattack(var/atom/target, var/mob/user, var/prox)
	if(!prox)
		return

	if(istype(target, /turf/simulated/floor))
		layCable(user, target, get_dir(target, user))
		return

	if(istype(target, /obj/structure/uninet_link/cable))
		var/turf/simulated/floor/target_loc = target.loc

		if(istype(target_loc))
			layCable(user, target_loc, get_dir(target, user), target)
		return

	if(target && target.type in cable_connectables_lookup[cable_type])
		var/turf/simulated/floor/target_loc = target.loc

		if(istype(target_loc))
			layCable(user, target_loc, get_dir(target, user))
		return

	..()
	return
