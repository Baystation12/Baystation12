/obj/item/robot_parts
	name = "robot parts"
	icon = 'icons/obj/robot_parts.dmi'
	item_state = "buildpipe"
	icon_state = "blank"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	var/list/part = null // Order of args is important for installing robolimbs.
	var/sabotaged = 0 //Emagging limbs can have repercussions when installed as prosthetics.
	var/model_info
	var/bp_tag = null // What part is this?
	dir = SOUTH

/obj/item/robot_parts/set_dir()
	return

/obj/item/robot_parts/New(var/newloc, var/model)
	..(newloc)
	if(model_info && model)
		model_info = model
		var/datum/robolimb/R = all_robolimbs[model]
		if(R)
			SetName("[R.company] [initial(name)]")
			desc = "[R.desc]"
			if(icon_state in icon_states(R.icon))
				icon = R.icon
	else
		SetDefaultName()

/obj/item/robot_parts/proc/SetDefaultName()
	SetName("robot [initial(name)]")

/obj/item/robot_parts/proc/can_install(mob/user)
	return TRUE

/obj/item/robot_parts/l_arm
	name = "left arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "l_arm"
	part = list(BP_L_ARM, BP_L_HAND)
	model_info = 1
	bp_tag = BP_L_ARM

/obj/item/robot_parts/r_arm
	name = "right arm"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "r_arm"
	part = list(BP_R_ARM, BP_R_HAND)
	model_info = 1
	bp_tag = BP_R_ARM

/obj/item/robot_parts/l_leg
	name = "left leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "l_leg"
	part = list(BP_L_LEG, BP_L_FOOT)
	model_info = 1
	bp_tag = BP_L_LEG

/obj/item/robot_parts/r_leg
	name = "right leg"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon_state = "r_leg"
	part = list(BP_R_LEG, BP_R_FOOT)
	model_info = 1
	bp_tag = BP_R_LEG

/obj/item/robot_parts/head
	name = "head"
	desc = "A standard reinforced braincase, with spine-plugged neural socket and sensor gimbals."
	icon_state = "head"
	part = list(BP_HEAD)
	model_info = 1
	bp_tag = BP_HEAD
	var/obj/item/device/flash/flash1 = null
	var/obj/item/device/flash/flash2 = null

/obj/item/robot_parts/head/can_install(mob/user)
	var/success = TRUE
	if(!flash1 || !flash2)
		to_chat(user, "<span class='warning'>You need to attach a flash to it first!</span>")
		success = FALSE
	return success && ..()

/obj/item/robot_parts/chest
	name = "torso"
	desc = "A heavily reinforced case containing cyborg logic boards, with space for a standard power cell."
	icon_state = "chest"
	part = list(BP_GROIN,BP_CHEST)
	model_info = 1
	bp_tag = BP_CHEST
	var/wires = 0.0
	var/obj/item/weapon/cell/cell = null

/obj/item/robot_parts/chest/can_install(mob/user)
	var/success = TRUE
	if(!wires)
		to_chat(user, "<span class='warning'>You need to attach wires to it first!</span>")
		success = FALSE
	if(!cell)
		to_chat(user, "<span class='warning'>You need to attach a cell to it first!</span>")
		success = FALSE
	return success && ..()

/obj/item/robot_parts/chest/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/cell))
		if(src.cell)
			to_chat(user, "<span class='warning'>You have already inserted a cell!</span>")
			return
		else
			if(!user.unEquip(W, src))
				return
			src.cell = W
			to_chat(user, "<span class='notice'>You insert the cell!</span>")
	if(isCoil(W))
		if(src.wires)
			to_chat(user, "<span class='warning'>You have already inserted wire!</span>")
			return
		else
			var/obj/item/stack/cable_coil/coil = W
			if(coil.use(1))
				src.wires = 1.0
				to_chat(user, "<span class='notice'>You insert the wire!</span>")
	if(istype(W, /obj/item/robot_parts/head))
		var/obj/item/robot_parts/head/head_part = W
		// Attempt to create full-body prosthesis.
		var/success = TRUE
		success &= can_install(user)
		success &= head_part.can_install(user)
		if (success)

			// Species selection.
			var/species = input(user, "Select a species for the prosthetic.") as null|anything in GetCyborgSpecies()
			if(!species)
				return
			var/name = sanitizeSafe(input(user,"Set a name for the new prosthetic."), MAX_NAME_LEN)
			if(!name)
				SetName("prosthetic ([random_id("prosthetic_id", 1, 999)])")

			// Create a new, nonliving human.
			var/mob/living/carbon/human/H = new /mob/living/carbon/human(get_turf(loc))
			H.death(0, "no message")
			H.set_species(species)
			H.fully_replace_character_name(name)

			// Remove all external organs other than chest and head..
			for (var/O in list(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG))
				var/obj/item/organ/external/organ = H.organs_by_name[O]
				H.organs -= organ
				H.organs_by_name[organ.organ_tag] = null
				qdel(organ)

			// Remove brain (we want to put one in).
			var/obj/item/organ/internal/brain = H.internal_organs_by_name[BP_BRAIN]
			H.organs -= brain
			H.organs_by_name[brain.organ_tag] = null
			qdel(brain)

			// Robotize remaining organs: Eyes, head, and chest.
			// Respect brand used.
			var/obj/item/organ/internal/eyes = H.internal_organs_by_name[BP_EYES]
			eyes.robotize()

			var/obj/item/organ/external/head = H.organs_by_name[BP_HEAD]
			var/head_company = head_part.model_info
			head.robotize(head_company)

			var/obj/item/organ/external/chest = H.organs_by_name[BP_CHEST]
			var/chest_company = model_info
			chest.robotize(chest_company)

			// Cleanup
			qdel(W)
			qdel(src)

/obj/item/robot_parts/chest/proc/GetCyborgSpecies()
	. = list()
	for(var/N in playable_species)
		var/datum/species/S = all_species[N]
		if(S.spawn_flags & SPECIES_NO_FBP_CONSTRUCTION)
			continue
		. += N

/obj/item/robot_parts/head/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/device/flash))
		if(istype(user,/mob/living/silicon/robot))
			var/current_module = user.get_active_hand()
			if(current_module == W)
				to_chat(user, "<span class='warning'>How do you propose to do that?</span>")
				return
			else
				add_flashes(W,user)
		else
			add_flashes(W,user)

/obj/item/robot_parts/head/proc/add_flashes(obj/item/W as obj, mob/user as mob) //Made into a seperate proc to avoid copypasta
	if(src.flash1 && src.flash2)
		to_chat(user, "<span class='notice'>You have already inserted the eyes!</span>")
		return
	else if(src.flash1)
		if(!user.unEquip(W, src))
			return
		src.flash2 = W
		to_chat(user, "<span class='notice'>You insert the flash into the eye socket!</span>")
	else
		if(!user.unEquip(W, src))
			return
		src.flash1 = W
		to_chat(user, "<span class='notice'>You insert the flash into the eye socket!</span>")


/obj/item/robot_parts/emag_act(var/remaining_charges, var/mob/user)
	if(sabotaged)
		to_chat(user, "<span class='warning'>[src] is already sabotaged!</span>")
	else
		to_chat(user, "<span class='warning'>You short out the safeties.</span>")
		sabotaged = 1
		return 1
