/obj/item/robot_parts/robot_suit
	name = "standard robot frame"
	desc = "A complex metal backbone with standard limb sockets and pseudomuscle anchors."
	icon_state = "robo_suit"

	var/list/parts = list()
	var/list/required_parts = list(
		BP_L_ARM = /obj/item/robot_parts/l_arm,
		BP_R_ARM = /obj/item/robot_parts/r_arm,
		BP_CHEST = /obj/item/robot_parts/chest,
		BP_L_LEG = /obj/item/robot_parts/l_leg,
		BP_R_LEG = /obj/item/robot_parts/r_leg,
		BP_HEAD  = /obj/item/robot_parts/head
	)
	var/created_name = ""
	var/product = /mob/living/silicon/robot

/obj/item/robot_parts/robot_suit/Initialize()
	. = ..()
	update_icon()

/obj/item/robot_parts/robot_suit/on_update_icon()
	overlays.Cut()
	for(var/part in required_parts)
		if(parts[part])
			overlays += "[part]+o"

/obj/item/robot_parts/robot_suit/proc/check_completion()
	for(var/part in required_parts)
		if(!parts[part])
			return FALSE
	return TRUE

/obj/item/robot_parts/robot_suit/attackby(obj/item/W as obj, mob/user as mob)

	// Uninstall a robotic part.
	if(isCrowbar(W))
		if(!parts.len)
			to_chat(user, SPAN_WARNING("\The [src] has no parts to remove."))
			return
		var/removing = pick(parts)
		var/obj/item/robot_parts/part = parts[removing]
		part.forceMove(get_turf(src))
		user.put_in_hands(part)
		parts -= removing
		to_chat(user, SPAN_WARNING("You lever \the [part] off \the [src]."))
		update_icon()

	// Install a robotic part.
	else if (istype(W, /obj/item/robot_parts))
		var/obj/item/robot_parts/part = W
		if(!required_parts[part.bp_tag] || !istype(W, required_parts[part.bp_tag]))
			to_chat(user, SPAN_WARNING("\The [src] is not compatible with \the [W]."))
			return
		if(parts[part.bp_tag])
			to_chat(user, SPAN_WARNING("\The [src] already has \a [W] installed."))
			return
		if(part.can_install(user) && user.unEquip(W, src))
			parts[part.bp_tag] = part
			update_icon()

	// Install an MMI/brain.
	else if(istype(W, /obj/item/device/mmi) || istype(W, /obj/item/organ/internal/posibrain))

		if(!istype(loc,/turf))
			to_chat(user, SPAN_WARNING("You can't put \the [W] in without the frame being on the ground."))
			return

		if(!check_completion())
			to_chat(user, SPAN_WARNING("The frame is not ready for the central processor to be installed."))
			return

		var/mob/living/carbon/brain/B
		if(istype(W, /obj/item/device/mmi))
			var/obj/item/device/mmi/M = W
			B = M.brainmob
		else
			var/obj/item/organ/internal/posibrain/P = W
			B = P.brainmob

		if(!B)
			to_chat(user, SPAN_WARNING("Sticking an empty [W.name] into the frame would sort of defeat the purpose."))
			return

		if(jobban_isbanned(B, "Robot"))
			to_chat(user, SPAN_WARNING("\The [W] does not seem to fit."))
			return

		if(B.stat == DEAD)
			to_chat(user, SPAN_WARNING("Sticking a dead [W.name] into the frame would sort of defeat the purpose."))
			return

		var/ghost_can_reenter = 0
		if(B.mind)
			if(!B.key)
				for(var/mob/observer/ghost/G in GLOB.player_list)
					if(G.can_reenter_corpse && G.mind == B.mind)
						ghost_can_reenter = 1
						break
			else
				ghost_can_reenter = 1
		if(!ghost_can_reenter)
			to_chat(user, SPAN_WARNING("\The [W] is completely unresponsive; there's no point."))
			return

		if(!user.unEquip(W))
			return
		var/mob/living/silicon/robot/O = new product(get_turf(loc))
		if(!O)
			return

		O.mmi = W
		O.set_invisibility(0)
		O.custom_name = created_name
		O.updatename("Default")
		B.mind.transfer_to(O)
		if(O.mind && O.mind.assigned_role)
			O.job = O.mind.assigned_role
		else
			O.job = "Robot"

		var/obj/item/robot_parts/chest/chest = parts[BP_CHEST]
		if (chest && chest.cell)
			chest.cell.forceMove(O)
		W.forceMove(O) //Should fix cybros run time erroring when blown up. It got deleted before, along with the frame.

		// Since we "magically" installed a cell, we also have to update the correct component.
		if(O.cell)
			var/datum/robot_component/cell_component = O.components["power cell"]
			cell_component.wrapped = O.cell
			cell_component.installed = 1
		callHook("borgify", list(O))
		O.Namepick()
		qdel(src)

	else if(istype(W, /obj/item/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", src.name, src.created_name), MAX_NAME_LEN)
		if(t && (in_range(src, user) || loc == user))
			created_name = t
	else
		..()

/obj/item/robot_parts/robot_suit/Destroy()
	parts.Cut()
	for(var/thing in contents)
		qdel(thing)
	. = ..()

/obj/item/robot_parts/robot_suit/proc/dismantled_from(var/mob/living/silicon/robot/donor)
	for(var/thing in required_parts - list(BP_CHEST, BP_HEAD))
		var/part_type = required_parts[thing]
		parts[thing] = new part_type(src)
	var/obj/item/robot_parts/chest/chest = (locate() in donor.contents) || new
	if(chest)
		chest.forceMove(src)
		parts[BP_CHEST] = chest
	update_icon()

/obj/item/robot_parts/robot_suit/SetDefaultName()
	SetName(initial(name))

/obj/item/robot_parts/robot_suit/flyer
	name = "flying robot frame"
	icon = 'icons/obj/robot_parts_flying.dmi'
	product = /mob/living/silicon/robot/flying
	required_parts = list(
		BP_L_ARM = /obj/item/robot_parts/l_arm,
		BP_R_ARM = /obj/item/robot_parts/r_arm,
		BP_CHEST = /obj/item/robot_parts/chest,
		BP_HEAD  = /obj/item/robot_parts/head
	)
