/// Associative list of colors. Default colors that a cable coil or length of cable can be. Used for multitool interactions.
GLOBAL_LIST_INIT(cable_default_colors, list(
	"Black"  = CABLE_COLOR_BLACK,
	"Blue"   = CABLE_COLOR_BLUE,
	"Cyan"   = CABLE_COLOR_CYAN,
	"Green"  = CABLE_COLOR_GREEN,
	"Orange" = CABLE_COLOR_ORANGE,
	"Purple" = CABLE_COLOR_PINK,
	"Red"    = CABLE_COLOR_RED,
	"Yellow" = CABLE_COLOR_YELLOW,
	"White"  = CABLE_COLOR_WHITE
))


/obj/item/stack/cable_coil

	var/const/MAX_COIL_AMOUNT = 30

	name = "multipurpose cable coil"
	icon = 'icons/obj/machines/power/power_cond_white.dmi'
	icon_state = "coil"
	randpixel = 2
	amount = MAX_COIL_AMOUNT
	max_amount = MAX_COIL_AMOUNT
	color = CABLE_COLOR_RED
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
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CAN_BE_PAINTED
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


/obj/item/stack/cable_coil/get_mechanics_info()
	. = ..()
	. += {"
		<h5>Placing Cables</h5>
		<p>Cable coils can be used to place cables on the ground. To do this, click an adjacent plating turf with a cable coil while on help intent. Placing cables requires 1 unit of cable.</p>
		<p>You can create continuous cables without cable knots by clicking on an existing cable knot instead of the turf.</p>
		<p>You can wire across z-levels with cables by clicking on an open space turf with the cable coil. This creates a cable that descends down to the lower z-level's turf. If the open space turf has a lattice on it, this behaviour is overridden to allow placing normal cables in space. You can get around this by removing the lattice, placing the cable, then re-placing the lattice. Creating multi-z cables requires 2 lengths of cable.</p>

		<h5>Robotics Repairs</h5>
		<p>Using cable coil on a mob while targeting a body part that is robotic allows you to perform rudimentary burn damage repair. This uses up to 5 lengths of cable at a time depending on the amount of damage, and may require multiple uses. You must be on help intent to perform this interaction.</p>

		<h5>Other Uses</h5>
		<p>Multiple cable coils can be merged together like other material stacks by clicking on one coil with another coil. If the two coils are of different colors, the new stack will use the color of the coil that was in your active hand.</p>
		<p>You can create cable ties, which are a weaker form of handcuffs, by right-clicking on a cable coil in your hand and selecting 'Make Cable Restraints' or selecting the verb from the 'Object' tab. This requires 15 lengths of cables to create and requires you to remain still for 10 seconds.</p>
		<p>You can change the color of the cable coil by using a multitool or a paint sprayer on it. Cyborg cable coils can be recolored by right clicking the coil or going to the Object tab and selecting 'Change Cable Colour' while it is an active module.</p>
	"}


/obj/item/stack/cable_coil/on_update_icon()
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


/obj/item/stack/cable_coil/use_after(mob/living/carbon/human/target, mob/living/user)
	if (!istype(target))
		return FALSE
	var/obj/item/organ/external/organ = target.organs_by_name[user.zone_sel.selecting]
	if (!organ)
		to_chat(user, SPAN_WARNING("\The [target] is missing that organ."))
		return TRUE
	if (!BP_IS_ROBOTIC(organ))
		to_chat(user, SPAN_WARNING("\The [target]'s [organ.name] is not robotic. \The [src] is useless."))
		return TRUE
	if (BP_IS_BRITTLE(organ))
		to_chat(user, SPAN_WARNING("\The [target]'s [organ.name] is hard and brittle - \the [src] cannot repair it."))
		return TRUE
	var/use_amount = min(amount, ceil(organ.burn_dam / 3), 5)
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


/obj/item/stack/cable_coil/use_tool(obj/item/tool, mob/user, list/click_params)
	// Multitool - Recolor cable coil
	if (isMultitool(tool))
		var/new_color = input(user, "Select a color to change to:", "\The [src] - Color Change", null) as null|anything in GLOB.cable_default_colors
		if (!new_color || !user.use_sanity_check(src, tool))
			return TRUE
		var/new_color_code = GLOB.cable_default_colors["[new_color]"]
		if (get_color() == new_color_code)
			return TRUE
		set_color(new_color_code)
		user.visible_message(
			SPAN_NOTICE("\The [user] changes \the [src]'s color with \a [tool]."),
			SPAN_NOTICE("You set \the [src]'s color to '[new_color]' with \the [tool].")
		)
		return TRUE

	return ..()


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
	var/obj/structure/cable/cable = new (target, color)
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
		cable.set_color(color)
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


/obj/random/single/color/cable_coil
	icon = 'icons/obj/machines/power/power_cond_white.dmi'
	icon_state = "coil"
	spawn_object = /obj/item/stack/cable_coil


/obj/random/single/color/cable_coil/color_choices()
	return list(
		CABLE_COLOR_YELLOW,
		CABLE_COLOR_GREEN,
		CABLE_COLOR_BLUE,
		CABLE_COLOR_PINK,
		CABLE_COLOR_ORANGE,
		CABLE_COLOR_CYAN,
		CABLE_COLOR_WHITE,
		CABLE_COLOR_BLACK
	)


/obj/item/stack/cable_coil/cyborg
	name = "cable coil synthesizer"
	desc = "A device that makes cable."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(1)
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE


/obj/item/stack/cable_coil/cyborg/can_merge(obj/item/stack/cable_coil/coil)
	return TRUE


/obj/item/stack/cable_coil/cyborg/verb/SetCableColorVerb()
	set name = "Change Cable Colour"
	set category = "Object"
	var/response = lowertext(input(usr, "Pick new colour:", "Cable Colour", color) as null | color)
	if (isnull(response) || color == response)
		return
	set_color(response)
	to_chat(usr, SPAN_NOTICE("You change \the [src]'s color to [lowertext(color)]."))


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
	return floor(cell.charge / cost_per_cable)


/obj/item/stack/cable_coil/fabricator/get_max_amount()
	var/obj/item/cell/cell = get_cell()
	if (!cell)
		return 0
	return floor(cell.maxcharge / cost_per_cable)


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
