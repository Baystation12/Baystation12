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
	var/cable_type = /obj/structure/cabling
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

/obj/item/cable_coil/proc/destroy()
	loc = null
	return

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
			user << "The coil is too long, you cannot add any more cable to it."
			return

		if((C.amount + amount <= max_amount))
			C.amount += amount
			user << "You join the [name]s together."
			C.update_icon()
			destroy()
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
		destroy()
		return 1
	else
		amount -= used
		update_icon()
		return 1

/obj/item/cable_coil/proc/layOnTurf(turf/simulated/floor/target, mob/user)
	if(!isturf(user.loc))
		return

	if(get_dist(target, user) > 1)
		user << "\red You can't lay cable at a place that far away."
		return

	if(!target.is_plating())
		user << "\red You can't lay cable there unless the floor tiles are removed."
		return

	else
		var/new_dir

		if(user.loc == target)
			new_dir = user.dir
		else
			new_dir = get_dir(target, user)

		if(!can_lay_diagonally && (new_dir & new_dir - 1))
			user << "\red This type of cable cannot be laid diagonally."
			return

		var/new_cable_type = equiv_cable_type_lookup[cable_type]

		for(var/obj/structure/cabling/existing_cable in target)
			if((existing_cable.dir1 == new_dir || existing_cable.dir2 == new_dir) && existing_cable.equivalent_cable_type == new_cable_type)
				user << "\red There's already a cable at that position."
				return

		var/obj/structure/cabling/new_cable = new cable_type(target, 0, new_dir)
		transfer_fingerprints_to(new_cable)
		new_cable.update_icon()
		useCable(1)

/obj/item/cable_coil/proc/joinCable(obj/structure/cabling/cable, mob/user)
	var/turf/user_loc = user.loc

	if(!isturf(user_loc))
		return

	var/turf/cable_loc = cable.loc

	if(!isturf(cable_loc) || !cable_loc.is_plating())
		return

	if(get_dist(cable, user) > 1)
		user << "\red You can't lay cable at a place that far away."
		return

	if(user_loc == cable_loc)
		return

	var/user_dir = get_dir(cable, user)

	if(!can_lay_diagonally && (user_dir & user_dir - 1))
		user << "\red This type of cable cannot be laid diagonally."
		return

	if(cable.dir1 == user_dir || cable.dir2 == user_dir)
		if(user_loc.intact)
			user << "\red You can't lay cable there unless the floor tiles are removed."
			return

		var/cable_dir = reverse_dir_3d(user_dir)

		for(var/obj/structure/cabling/existing_cable in user_loc)
			if((existing_cable.dir1 == cable_dir || existing_cable.dir2 == cable_dir) && existing_cable.equivalent_cable_type == cable.equivalent_cable_type)
				user << "There's already a [cable.name] at that position."
				return

		var/obj/structure/cabling/new_cable = new cable_type(cable_loc, 0, cable_dir)
		transfer_fingerprints_to(new_cable)
		new_cable.userTouched(user)
		new_cable.update_icon()
		useCable(1)

	else if(cable.dir1 == 0)
		var/new_dir_1 = cable.dir2
		var/new_dir_2 = user_dir

		if(new_dir_1 > new_dir_2)
			new_dir_1 = user_dir
			new_dir_2 = cable.dir2

		for(var/obj/structure/cabling/existing_cable in cable_loc)
			if(existing_cable == cable || existing_cable.equivalent_cable_type != cable.equivalent_cable_type)
				continue
			if((existing_cable.dir1 == new_dir_1 && existing_cable.dir2 == new_dir_2) || (existing_cable.dir1 == new_dir_2 && existing_cable.dir2 == new_dir_1) )	// make sure no cable matches either direction
				user << "There's already a [cable.name] at that position."
				return

		var/obj/structure/cabling/new_cable = new cable_type(cable_loc, new_dir_1, new_dir_2)
		transfer_fingerprints_to(new_cable)
		new_cable.userTouched(user)
		new_cable.update_icon()

		del cable

		useCable(1)

	return

/obj/item/cable_coil/afterattack(var/atom/target, var/mob/user, var/prox)
	if(!prox)
		return

	if(istype(target, /turf/simulated/floor))
		var/turf/simulated/floor = target
		if(floor.is_plating())
			layOnTurf(floor, user)
		else
			user << "\red You must remove the plating first."
		return

	if(!(target.type in cable_connectables_lookup[cable_type]))
		return

	var/turf/cable_loc = get_turf(target)

	if(cable_loc.intact || !istype(cable_loc, /turf/simulated/floor))
		return

	if(get_dist(target, user) > 1)
		return

	var/DirectionTouser = get_dir(target, user)

	var/new_cable_type = equiv_cable_type_lookup[cable_type]

	for(var/obj/structure/cabling/existing_cable in cable_loc)
		if((existing_cable.dir1 == DirectionTouser || existing_cable.dir2 == DirectionTouser) && existing_cable.equivalent_cable_type == new_cable_type)
			user << "There's already a cable at that position."
			return

	var/obj/structure/cabling/cable = new cable_type(cable_loc, 0, DirectionTouser)
	transfer_fingerprints_to(cable)
	cable.userTouched(user)
	cable.update_icon()
	useCable(1)

	..()
	return
