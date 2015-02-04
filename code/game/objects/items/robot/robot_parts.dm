/obj/item/robot_parts
	name = "robot parts"
	icon = 'icons/obj/robot_parts.dmi'
	item_state = "buildpipe"
	icon_state = "blank"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	var/construction_time = 100
	var/list/construction_cost = list("metal"=20000,"glass"=5000)

/obj/item/robot_parts/robot_suit
	name = "robot endoskeleton"
	desc = "A complex metal backbone with standard limb sockets and pseudomuscle anchors."
	icon_state = "robo_suit"
	construction_time = 500
	construction_cost = list("metal"=50000)
	var/list/limbs = list(
		"head" = 0,
		"chest" = 0,
		"l_arm" = 0,
		"r_arm" = 0,
		"l_leg" = 0,
		"r_leg" = 0
		)
	var/created_name = ""

/obj/item/robot_parts/robot_suit/New()
	..()
	src.updateicon()

/obj/item/robot_parts/robot_suit/proc/updateicon()
	src.overlays.Cut()
	for(var/limb in limbs)
		if(limbs[limbs] != 0)
			src.overlays += "[limb]+o"

/obj/item/robot_parts/robot_suit/proc/check_completion()
	for(var/limb in limbs)
		if(!limbs[limbs])
			return 0
	feedback_inc("cyborg_frames_built",1)
	return 1

/obj/item/robot_parts/robot_suit/attackby(obj/item/W as obj, mob/user as mob)

	// Security bot construction.
	if(istype(W, /obj/item/stack/sheet/metal) && !limbs.len)
		var/obj/item/stack/sheet/metal/M = W
		if (M.use(1))
			var/obj/item/weapon/secbot_assembly/ed209_assembly/B = new /obj/item/weapon/secbot_assembly/ed209_assembly
			B.loc = get_turf(src)
			user << "<span class='notice'>You armed the robot frame.</span>"
			if (user.get_inactive_hand()==src)
				user.before_take_item(src)
				user.put_in_inactive_hand(B)
			del(src)
		else
			user << "<span class='warning'>You need one sheet of metal to arm the robot frame.</span>"

	// Robot chassis construction.
	if(istype(W, /obj/item/organ))
		var/obj/item/organ/new_limb = W
		if(!(new_limb.status & ORGAN_ROBOT))
			user << "That would be a bit ghoulish, wouldn't it? Use a robotic limb."
			return
		if(limbs[new_limb.body_part] != 0)
			user << "The chassis already has a limb of that type installed."
			return
		user.drop_item()
		W.loc = src
		limbs[new_limb.body_part] = W
		src.updateicon()

	// MMI installation.
	if(istype(W, /obj/item/device/mmi))
		var/obj/item/device/mmi/M = W
		if(check_completion())
			if(!istype(loc,/turf))
				user << "\red You can't put \the [W] in, the frame has to be standing on the ground to be perfectly precise."
				return
			if(!M.brainmob)
				user << "\red Sticking an empty [W] into the frame would sort of defeat the purpose."
				return
			if(!M.brainmob.key)
				var/ghost_can_reenter = 0
				if(M.brainmob.mind)
					for(var/mob/dead/observer/G in player_list)
						if(G.can_reenter_corpse && G.mind == M.brainmob.mind)
							ghost_can_reenter = 1
							break
				if(!ghost_can_reenter)
					user << "<span class='notice'>\The [W] is completely unresponsive; there's no point.</span>"
					return

			if(M.brainmob.stat == DEAD)
				user << "\red Sticking a dead [W] into the frame would sort of defeat the purpose."
				return

			if(M.brainmob.mind in ticker.mode.head_revolutionaries)
				user << "\red The frame's firmware lets out a shrill sound, and flashes 'Abnormal Memory Engram'. It refuses to accept the [W]."
				return

			if(jobban_isbanned(M.brainmob, "Cyborg"))
				user << "\red This [W] does not seem to fit."
				return

			var/mob/living/silicon/robot/O = new /mob/living/silicon/robot(get_turf(loc), unfinished = 1)
			if(!O)	return

			user.drop_item()

			O.mmi = W
			O.invisibility = 0
			O.custom_name = created_name
			O.updatename("Default")
			M.brainmob.mind.transfer_to(O)
			O.job = "Cyborg"
			//O.cell = chest.cell
			//O.cell.loc = O
			W.loc = O //Should fix cybros run time erroring when blown up. It got deleted before, along with the frame.

			// Since we "magically" installed a cell, we also have to update the correct component.
			if(O.cell)
				var/datum/robot_component/cell_component = O.components["power cell"]
				cell_component.wrapped = O.cell
				cell_component.installed = 1

			feedback_inc("cyborg_birth",1)
			callHook("borgify", list(O))
			O.notify_ai(1)
			O.Namepick()

			del(src)
		else
			user << "\blue The MMI must go in after everything else!"

	if (istype(W, /obj/item/weapon/pen))
		var/t = stripped_input(user, "Enter new robot name:", src.name, src.created_name, MAX_NAME_LEN)
		if (!t)
			return
		if (!in_range(src, usr) && src.loc != usr)
			return

		src.created_name = t

	return
