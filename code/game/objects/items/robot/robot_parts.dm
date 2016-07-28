/obj/item/robot_parts
	name = "robot parts"
	icon = 'icons/obj/robot_parts.dmi'
	item_state = "buildpipe"
	icon_state = "blank"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	var/list/part = null // Order of args is important for installing robolimbs.
	var/sabotaged = 0 //Emagging limbs can have repercussions when installed as prosthetics.
	var/model_info
	dir = SOUTH

/obj/item/robot_parts/set_dir()
	return

/obj/item/robot_parts/New(var/newloc, var/model)
	..(newloc)
	if(model_info && model)
		model_info = model
		var/datum/robolimb/R = all_robolimbs[model]
		if(R)
			name = "[R.company] [initial(name)]"
			desc = "[R.desc]"
			if(icon_state in icon_states(R.icon))
				icon = R.icon
	else
		name = "robot [initial(name)]"

/obj/item/robot_parts/l_arm
	name = "left arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "l_arm"
	part = list(BP_L_ARM, BP_L_HAND)
	model_info = 1

/obj/item/robot_parts/r_arm
	name = "right arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "r_arm"
	part = list(BP_R_ARM, BP_R_HAND)
	model_info = 1

/obj/item/robot_parts/l_leg
	name = "left leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "l_leg"
	part = list(BP_L_LEG, BP_L_FOOT)
	model_info = 1

/obj/item/robot_parts/r_leg
	name = "right leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "r_leg"
	part = list(BP_R_LEG, BP_R_FOOT)
	model_info = 1

/obj/item/robot_parts/chest
	name = "torso"
	desc = "A heavily reinforced case containing cyborg logic boards, with space for a standard power cell."
	icon_state = "chest"
	part = list(BP_GROIN,BP_CHEST)
	var/wires = 0.0
	var/obj/item/weapon/cell/cell = null

/obj/item/robot_parts/head
	name = "head"
	desc = "A standard reinforced braincase, with spine-plugged neural socket and sensor gimbals."
	icon_state = "head"
	part = list(BP_HEAD)
	var/obj/item/device/flash/flash1 = null
	var/obj/item/device/flash/flash2 = null

/obj/item/robot_parts/robot_suit
	name = "endoskeleton"
	desc = "A complex metal backbone with standard limb sockets and pseudomuscle anchors."
	icon_state = "robo_suit"
	var/obj/item/robot_parts/l_arm/l_arm = null
	var/obj/item/robot_parts/r_arm/r_arm = null
	var/obj/item/robot_parts/l_leg/l_leg = null
	var/obj/item/robot_parts/r_leg/r_leg = null
	var/obj/item/robot_parts/chest/chest = null
	var/obj/item/robot_parts/head/head = null
	var/created_name = ""

/obj/item/robot_parts/robot_suit/New()
	..()
	src.updateicon()

/obj/item/robot_parts/robot_suit/proc/updateicon()
	src.overlays.Cut()
	if(src.l_arm)
		src.overlays += "l_arm+o"
	if(src.r_arm)
		src.overlays += "r_arm+o"
	if(src.chest)
		src.overlays += "chest+o"
	if(src.l_leg)
		src.overlays += "l_leg+o"
	if(src.r_leg)
		src.overlays += "r_leg+o"
	if(src.head)
		src.overlays += "head+o"

/obj/item/robot_parts/robot_suit/proc/check_completion()
	if(src.l_arm && src.r_arm)
		if(src.l_leg && src.r_leg)
			if(src.chest && src.head)
				feedback_inc("cyborg_frames_built",1)
				return 1
	return 0

/obj/item/robot_parts/robot_suit/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/stack/material) && W.get_material_name() == DEFAULT_WALL_MATERIAL && !l_arm && !r_arm && !l_leg && !r_leg && !chest && !head)
		var/obj/item/stack/material/M = W
		if (M.use(1))
			var/obj/item/weapon/secbot_assembly/ed209_assembly/B = new /obj/item/weapon/secbot_assembly/ed209_assembly
			B.loc = get_turf(src)
			user << "<span class='notice'>You armed the robot frame.</span>"
			if (user.get_inactive_hand()==src)
				user.remove_from_mob(src)
				user.put_in_inactive_hand(B)
			qdel(src)
		else
			user << "<span class='warning'>You need one sheet of metal to arm the robot frame.</span>"
	if(istype(W, /obj/item/robot_parts/l_leg))
		if(src.l_leg)	return
		user.drop_item()
		W.loc = src
		src.l_leg = W
		src.updateicon()

	if(istype(W, /obj/item/robot_parts/r_leg))
		if(src.r_leg)	return
		user.drop_item()
		W.loc = src
		src.r_leg = W
		src.updateicon()

	if(istype(W, /obj/item/robot_parts/l_arm))
		if(src.l_arm)	return
		user.drop_item()
		W.loc = src
		src.l_arm = W
		src.updateicon()

	if(istype(W, /obj/item/robot_parts/r_arm))
		if(src.r_arm)	return
		user.drop_item()
		W.loc = src
		src.r_arm = W
		src.updateicon()

	if(istype(W, /obj/item/robot_parts/chest))
		if(src.chest)	return
		if(W:wires && W:cell)
			user.drop_item()
			W.loc = src
			src.chest = W
			src.updateicon()
		else if(!W:wires)
			user << "<span class='warning'>You need to attach wires to it first!</span>"
		else
			user << "<span class='warning'>You need to attach a cell to it first!</span>"

	if(istype(W, /obj/item/robot_parts/head))
		if(src.head)	return
		if(W:flash2 && W:flash1)
			user.drop_item()
			W.loc = src
			src.head = W
			src.updateicon()
		else
			user << "<span class='warning'>You need to attach a flash to it first!</span>"

	if(istype(W, /obj/item/device/mmi))
		var/obj/item/device/mmi/M = W
		if(check_completion())
			if(!istype(loc,/turf))
				user << "<span class='warning'>You can't put \the [W] in, the frame has to be standing on the ground to be perfectly precise.</span>"
				return
			if(!M.brainmob)
				user << "<span class='warning'>Sticking an empty [W] into the frame would sort of defeat the purpose.</span>"
				return
			if(!M.brainmob.key)
				var/ghost_can_reenter = 0
				if(M.brainmob.mind)
					for(var/mob/observer/ghost/G in player_list)
						if(G.can_reenter_corpse && G.mind == M.brainmob.mind)
							ghost_can_reenter = 1
							break
				if(!ghost_can_reenter)
					user << "<span class='notice'>\The [W] is completely unresponsive; there's no point.</span>"
					return

			if(M.brainmob.stat == DEAD)
				user << "<span class='warning'>Sticking a dead [W] into the frame would sort of defeat the purpose.</span>"
				return

			if(jobban_isbanned(M.brainmob, "Cyborg"))
				user << "<span class='warning'>This [W] does not seem to fit.</span>"
				return

			var/mob/living/silicon/robot/O = new /mob/living/silicon/robot(get_turf(loc), unfinished = 1)
			if(!O)	return

			user.drop_item()

			O.mmi = W
			O.invisibility = 0
			O.custom_name = created_name
			O.updatename("Default")

			M.brainmob.mind.transfer_to(O)

			if(O.mind && O.mind.special_role)
				O.mind.store_memory("In case you look at this after being borged, the objectives are only here until I find a way to make them not show up for you, as I can't simply delete them without screwing up round-end reporting. --NeoFite")

			O.job = "Cyborg"

			O.cell = chest.cell
			O.cell.loc = O
			W.loc = O//Should fix cybros run time erroring when blown up. It got deleted before, along with the frame.

			// Since we "magically" installed a cell, we also have to update the correct component.
			if(O.cell)
				var/datum/robot_component/cell_component = O.components["power cell"]
				cell_component.wrapped = O.cell
				cell_component.installed = 1

			feedback_inc("cyborg_birth",1)
			callHook("borgify", list(O))
			O.Namepick()

			qdel(src)
		else
			user << "<span class='warning'>The MMI must go in after everything else!</span>"

	if (istype(W, /obj/item/weapon/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", src.name, src.created_name), MAX_NAME_LEN)
		if (!t)
			return
		if (!in_range(src, usr) && src.loc != usr)
			return

		src.created_name = t

	return

/obj/item/robot_parts/chest/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/cell))
		if(src.cell)
			user << "<span class='warning'>You have already inserted a cell!</span>"
			return
		else
			user.drop_item()
			W.loc = src
			src.cell = W
			user << "<span class='notice'>You insert the cell!</span>"
	if(istype(W, /obj/item/stack/cable_coil))
		if(src.wires)
			user << "<span class='warning'>You have already inserted wire!</span>"
			return
		else
			var/obj/item/stack/cable_coil/coil = W
			coil.use(1)
			src.wires = 1.0
			user << "<span class='notice'>You insert the wire!</span>"
	return

/obj/item/robot_parts/head/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/device/flash))
		if(istype(user,/mob/living/silicon/robot))
			var/current_module = user.get_active_hand()
			if(current_module == W)
				user << "<span class='warning'>How do you propose to do that?</span>"
				return
			else
				add_flashes(W,user)
		else
			add_flashes(W,user)
	else if(istype(W, /obj/item/weapon/stock_parts/manipulator))
		user << "<span class='notice'>You install some manipulators and modify the head, creating a functional spider-bot!</span>"
		new /mob/living/simple_animal/spiderbot(get_turf(loc))
		user.drop_item()
		qdel(W)
		qdel(src)
		return
	return

/obj/item/robot_parts/head/proc/add_flashes(obj/item/W as obj, mob/user as mob) //Made into a seperate proc to avoid copypasta
	if(src.flash1 && src.flash2)
		user << "<span class='notice'>You have already inserted the eyes!</span>"
		return
	else if(src.flash1)
		user.drop_item()
		W.loc = src
		src.flash2 = W
		user << "<span class='notice'>You insert the flash into the eye socket!</span>"
	else
		user.drop_item()
		W.loc = src
		src.flash1 = W
		user << "<span class='notice'>You insert the flash into the eye socket!</span>"


/obj/item/robot_parts/emag_act(var/remaining_charges, var/mob/user)
	if(sabotaged)
		user << "<span class='warning'>[src] is already sabotaged!</span>"
	else
		user << "<span class='warning'>You short out the safeties.</span>"
		sabotaged = 1
		return 1
