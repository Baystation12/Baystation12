/obj/item/stack/cable_coil

	var/const/MAX_COIL_AMOUNT = 30

	name = "multipurpose cable coil"
	icon = 'icons/obj/power.dmi'
	icon_state = "coil"
	randpixel = 2
	amount = MAX_COIL_AMOUNT
	max_amount = MAX_COIL_AMOUNT
	color = COLOR_MAROON
	desc = "A coil of wiring, used for delicate electronics and basic power transfer."
	throwforce = 0
	w_class = ITEM_SIZE_NORMAL
	throw_speed = 2
	throw_range = 5
	matter = list(
		MATERIAL_STEEL = 50,
		MATERIAL_GLASS = 20,
		MATERIAL_PLASTIC = 20
	)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	item_state = "coil"
	attack_verb = list("whipped", "lashed", "disciplined", "flogged")
	stacktype = /obj/item/stack/cable_coil
	singular_name = "length"
	plural_name = "lengths"


/obj/item/stack/cable_coil/Initialize(mapload, _amount, _color)
	. = ..()
	if (_amount)
		amount = clamp(_amount, 1, MAX_COIL_AMOUNT)
	if (_color)
		color = _color
	UpdateItemSize()
	update_icon()


/obj/item/stack/cable_coil/on_update_icon()
	if (!color)
		color = GLOB.possible_cable_colours[pick(GLOB.possible_cable_colours)]
	switch (amount)
		if (1)
			icon_state = "coil1"
			SetName("cable piece")
		if (2)
			icon_state = "coil2"
			SetName("cable piece")
		if (MAX_COIL_AMOUNT)
			icon_state = "coil-max"
			SetName(initial(name))
		else
			icon_state = "coil"
			SetName(initial(name))


/obj/item/stack/cable_coil/attack(mob/living/carbon/human/target, mob/living/user, def_zone)
	if (user.a_intent != I_HELP)
		return ..()
	if (!istype(target))
		return ..()
	var/obj/item/organ/external/organ = target.organs_by_name[user.zone_sel.selecting]
	if (!organ)
		to_chat(user, SPAN_WARNING("\The [target] is missing that organ."))
		return TRUE
	if (!BP_IS_ROBOTIC(organ))
		return ..()
	if (BP_IS_BRITTLE(organ))
		to_chat(user, SPAN_WARNING("\The [target]'s [organ.name] is hard and brittle - \the [src] cannot repair it."))
		return TRUE
	var/use_amount = min(amount, Ceil(organ.burn_dam / 3), 5)
	if (!can_use(use_amount))
		to_chat(user, SPAN_WARNING("You don't have enough of \the [src] left to repair \the [target]'s [organ.name]."))
		return TRUE
	if (organ.robo_repair(3 * use_amount, DAMAGE_BURN, "some damaged wiring", src, user))
		use(use_amount)
	return TRUE


/obj/item/stack/cable_coil/transfer_to(obj/item/stack/cable_coil/coil)
	if (!istype(coil))
		return FALSE
	if (!can_merge(coil) && !coil.can_merge(src))
		return FALSE
	. = ..()
	coil.UpdateItemSize()
	UpdateItemSize()


/obj/item/stack/cable_coil/proc/SetCableColor(_color, mob/living/user)
	if (!_color)
		return
	var/final_color = GLOB.possible_cable_colours[_color]
	if (!final_color)
		return
	color = final_color
	to_chat(user, SPAN_NOTICE("You change \the [src]'s color to [lowertext(_color)]."))


/obj/item/stack/cable_coil/proc/can_merge(obj/item/stack/cable_coil/coil)
	return color == coil.color


/obj/item/stack/cable_coil/proc/UpdateItemSize()
	switch (amount)
		if (1 to 10)
			w_class = ITEM_SIZE_TINY
		if (11 to 20)
			w_class = ITEM_SIZE_SMALL
		else
			w_class = ITEM_SIZE_NORMAL


/obj/item/stack/cable_coil/proc/CreateCable(turf/target, mob/living/user, from_dir, to_dir)
	if(!isturf(target))
		return
	var/obj/structure/cable/cable = new (target)
	cable.cableColor(color)
	cable.d1 = from_dir
	cable.d2 = to_dir
	cable.add_fingerprint(user)
	cable.update_icon()
	var/datum/powernet/powernet = new
	powernet.add_cable(cable)
	cable.mergeConnectedNetworks(cable.d1)
	cable.mergeConnectedNetworks(cable.d2)
	cable.mergeConnectedNetworksOnTurf()
	if(cable.d1 & (cable.d1 - 1))
		cable.mergeDiagonalsNetworks(cable.d1)
	if(cable.d2 & (cable.d2 - 1))
		cable.mergeDiagonalsNetworks(cable.d2)
	use(1)
	if (!cable.shock(user, 50))
		return
	if (prob(50))
		return
	new /obj/item/stack/cable_coil (target, 1, cable.color)
	qdel(cable)


/obj/item/stack/cable_coil/proc/PlaceCableOnTurf(turf/target, mob/living/user)
	if (!isturf(user.loc))
		return
	if (get_amount() < 1)
		to_chat(user, SPAN_WARNING("There is no cable left."))
		return
	if (!user.Adjacent(target))
		to_chat(user, SPAN_WARNING("You can't lay cable at a place that far away."))
		return
	if (istype(target, /turf/simulated/floor) && !target.is_plating()) // Making sure it's not a floor tile
		to_chat(user, SPAN_WARNING("Remove the tiling first."))
		return
	var/obj/structure/catwalk/catwalk = locate(/obj/structure/catwalk, target)
	if (catwalk)
		if (catwalk.plated_tile && !catwalk.hatch_open)
			to_chat(user, SPAN_WARNING("Open the catwalk hatch first."))
			return
		else if (!catwalk.plated_tile)
			to_chat(user, SPAN_WARNING("You can't reach underneath the catwalk."))
			return
	var/to_dir = 0
	if (istype(target, /turf/simulated/open) && !locate(/obj/structure/lattice, target))
		if (!can_use(2))
			to_chat(user, SPAN_WARNING("You don't have enough cable to hang a wire down."))
			return
		to_dir = DOWN
	var/from_dir = user.dir
	if (user.loc != target)
		from_dir = get_dir(target, user)
	for (var/obj/structure/cable/cable in target)
		if ((cable.d1 == from_dir && cable.d2 == to_dir) || (cable.d2 == from_dir && cable.d1 == to_dir))
			to_chat(user, SPAN_WARNING("There's already a cable at that position."))
			return
	CreateCable(target, user, to_dir, from_dir)
	if (to_dir != DOWN)
		return
	CreateCable(GetBelow(target), user, UP, 0)


/obj/item/stack/cable_coil/proc/JoinCable(obj/structure/cable/cable, mob/living/user)
	var/turf/user_turf = user.loc
	if (!isturf(user_turf))
		return
	var/turf/cable_turf = cable.loc
	if (user_turf == cable_turf)
		PlaceCableOnTurf(cable_turf, user)
		return
	var/from_dir = get_dir(cable, user)
	if (cable.d1 == from_dir || cable.d2 == from_dir)
		if (istype(user_turf, /turf/simulated/floor) && !user_turf.is_plating())
			to_chat(user, SPAN_WARNING("Remove the tiling first."))
			return
		else if ((istype(user_turf, /turf/space) || istype(user_turf, /turf/simulated/open)) && !locate(/obj/structure/lattice, user_turf))
			to_chat(user, SPAN_WARNING("The cable connection needs something to be secured to."))
			return
		else
			var/opposite_dir = turn(from_dir, 180)
			for (var/obj/structure/cable/other_cable in user_turf)
				if (other_cable.d1 == opposite_dir || other_cable.d2 == opposite_dir)
					to_chat(user, SPAN_WARNING("There's already a cable at that position."))
					return
			CreateCable(user_turf, user, 0, opposite_dir)
			return
	else if (cable.d1 == 0)
		var/new_from_dir = cable.d2
		var/new_to_dir = from_dir
		if(new_from_dir > new_to_dir)
			new_from_dir = from_dir
			new_to_dir = cable.d2
		for (var/obj/structure/cable/other_cable in cable_turf)
			if (other_cable == cable)
				continue
			if ((other_cable.d1 == new_from_dir && other_cable.d2 == new_to_dir) || (other_cable.d1 == new_to_dir && other_cable.d2 == new_from_dir))
				to_chat(user, SPAN_WARNING("There's already a cable at that position."))
				return
		cable.cableColor(color)
		cable.d1 = new_from_dir
		cable.d2 = new_to_dir
		cable.add_fingerprint()
		cable.update_icon()
		cable.mergeConnectedNetworks(cable.d1)
		cable.mergeConnectedNetworks(cable.d2)
		cable.mergeConnectedNetworksOnTurf()
		if (cable.d1 & (cable.d1 - 1))
			cable.mergeDiagonalsNetworks(cable.d1)
		if (cable.d2 & (cable.d2 - 1))
			cable.mergeDiagonalsNetworks(cable.d2)
		use(1)
		if (!cable.shock(user, 50))
			cable.denode()
			return
		if (prob(50))
			return
		new /obj/item/stack/cable_coil (cable_turf, 2, cable.color)
		cable.denode()
		qdel(cable)


/obj/item/stack/cable_coil/proc/MakeCuffs(mob/living/carbon/human/user)
	if (!istype(user))
		to_chat(user, SPAN_WARNING("You cannot do that."))
		return
	if (user.incapacitated())
		to_chat(user, SPAN_WARNING("You're in no condition to do that."))
		return
	if (!isturf(user.loc))
		to_chat(user, SPAN_WARNING("You don't have enough free space to do that."))
		return
	if (!can_use(15))
		to_chat(user, SPAN_WARNING("You need at least 15 cable to make restraints."))
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] begins winding some cable together."),
		SPAN_ITALIC("You begin to wind the cable into crude restraints.")
	)
	if (!do_after(user, 10 SECONDS, null, DO_DEFAULT | DO_PUBLIC_PROGRESS))
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] makes some crude cable restraints."),
		SPAN_NOTICE("You finish making the restraints.")
	)
	use(15)
	var/obj/item/handcuffs/cable/cuffs = new (user.loc)
	cuffs.color = color


/obj/item/stack/cable_coil/verb/MakeCuffsVerb()
	set name = "Make Cable Restraints"
	set category = "Object"
	MakeCuffs(usr)


/obj/item/stack/cable_coil/single/Initialize(mapload, _color)
	return ..(mapload, 1, _color)


/obj/item/stack/cable_coil/cut
	item_state = "coil2"


/obj/item/stack/cable_coil/cut/Initialize(mapload, _color)
	return ..(mapload, rand(1, 2), _color)


/obj/item/stack/cable_coil/random/Initialize(mapload, _amount)
	var/_color = GLOB.possible_cable_colours[pick(GLOB.possible_cable_colours)]
	return ..(mapload, _amount, _color)


/obj/item/stack/cable_coil/cyborg
	name = "cable coil synthesizer"
	desc = "A device that makes cable."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(1)


/obj/item/stack/cable_coil/cyborg/can_merge(obj/item/stack/cable_coil/coil)
	return TRUE


/obj/item/stack/cable_coil/cyborg/verb/SetCableColorVerb()
	set name = "Change Colour"
	set category = "Object"
	var/response = input("Pick new colour:", "Cable Colour", null, null) as null | anything in GLOB.possible_cable_colours
	if (isnull(response))
		return
	SetCableColor(response, usr)


/obj/item/stack/cable_coil/fabricator
	name = "cable fabricator"
	var/cost_per_cable = 10


/obj/item/stack/cable_coil/fabricator/split(transfer_amount, force)
	return


/obj/item/stack/cable_coil/fabricator/get_cell()
	if (istype(loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = loc
		return module.get_cell()
	if (istype(loc, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/robot = loc
		return robot.get_cell()


/obj/item/stack/cable_coil/fabricator/use(used)
	var/obj/item/cell/cell = get_cell()
	if (!cell)
		return
	cell.use(used * cost_per_cable)


/obj/item/stack/cable_coil/fabricator/get_amount()
	var/obj/item/cell/cell = get_cell()
	if (!cell)
		return 0
	return Floor(cell.charge / cost_per_cable)


/obj/item/stack/cable_coil/fabricator/get_max_amount()
	var/obj/item/cell/cell = get_cell()
	if (!cell)
		return 0
	return Floor(cell.maxcharge / cost_per_cable)


/obj/item/stack/cable_coil/yellow
	color = COLOR_AMBER


/obj/item/stack/cable_coil/blue
	color = COLOR_CYAN_BLUE


/obj/item/stack/cable_coil/green
	color = COLOR_GREEN


/obj/item/stack/cable_coil/pink
	color = COLOR_PURPLE


/obj/item/stack/cable_coil/orange
	color = COLOR_ORANGE


/obj/item/stack/cable_coil/cyan
	color = COLOR_SKY_BLUE


/obj/item/stack/cable_coil/white
	color = COLOR_SILVER
