
// EPIC GRAPPLE ARM! NINJA!
/obj/item/robot_parts/grapple
	name = "Grapple Tool"
	desc = "That looks damn awesome!"
	icon_state = "grapplehand0"
	construction_time = 100
	construction_cost = list("metal"=18000)
	part = list()
	var/obj/item/weapon/grapplehand/grapple
	var/slotheld
	var/itemslot
	var/obj/item/weapon/grapplehand/hook

	New()
		..()
		processing_objects += src

	process()
		// Here, we make sure that the player has a grappling hand.
		if (istype(instin, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = instin
			var/obj/item/I = H.l_hand
			if (itemslot == "r_hand")
				I = H.r_hand // Fucky way, but the only working way.
			if (!istype(I, /obj/item/weapon/grapplehand))
				if (istype(I))
					H.u_equip(I, get_turf(H))
				if (!istype(hook))
					hook = new/obj/item/weapon/grapplehand(get_turf(H))
					hook.holder = instin
					hook.slotheld = slotheld
				else
					if (!hook.loaded)
						return
					if (istype(hook.loc, /mob))
						var/mob/M = hook.loc
						M.u_equip(hook, get_turf(H))
				hook.overlays = list()
				if (istype(hook.loadedItem))
					hook.loadedItem.loc = get_turf(hook.loadedItem)
				hook.loadedItem = null
				hook.icon_state = "grapplehand1"
				H.equip_to_slot_if_possible(hook, slotheld, 0)

	OnUninstall()
		..()
		if (istype(hook))
			del(hook) // Bye bye!

/obj/item/robot_parts/grapple/l_hand
	name = "left grapple hand"
	part = list("l_hand")
	w_class = 2.0
	slotheld = slot_l_hand
	itemslot = "l_hand"

/obj/item/robot_parts/grapple/r_hand
	name = "right grapple hand"
	part = list("r_hand")
	w_class = 2.0
	slotheld = slot_r_hand
	itemslot = "r_hand"

/obj/item/weapon/grapplehand
	name = "grapple hand"
	desc = "A powerful-ish grappling hand."
	icon_state = "grapplehand1"
	icon = 'icons/obj/robot_parts.dmi'
	var/mob/living/carbon/holder
	var/slotheld
	var/loaded = 1 // Indicate that we want to fire the grapple.
	var/obj/item/loadedItem
	throw_speed = 10

	throw_at(var/target)
		if (istype(loadedItem))
			loadedItem.loc = get_turf(src)
			loadedItem = null
			overlays = list()
		if (loaded)
			loaded = 0 // We've fired. No more firing.
			icon_state = "grapplehand0"
			var/obj/item/weapon/grapplehook/hook = new/obj/item/weapon/grapplehook(holder.loc, src)
			if (istype(hook)) // That prevents some errors.
				hook.throw_at(target, 10, 1)
				hook.GraspTarget = target
				hook.hand = src
		return 0

	proc/Pickup(var/obj/item/I)
		loadedItem = I
		I.loc = src
		overlays += image(I.icon, I.icon_state)
		for(var/image in I.overlays)
			overlays += image
		icon_state = "grapplehand2"

	attack_hand(var/mob)
		if (istype(loadedItem))
			holder.put_in_active_hand(loadedItem)
			overlays = list()
			loadedItem = null
			icon_state = "grapplehand1"

/obj/item/weapon/grapplehook
	name = "grapple hook"
	desc = "A claw looking thing."
	icon_state = "grapplehook"
	icon = 'icons/obj/robot_parts.dmi'
	var/GraspTarget
	var/obj/item/weapon/grapplehand/hand
	Del()
		hand.loaded = 1
		hand.icon_state = "grapplehand1"
		if (istype(hand.loadedItem))
			hand.icon_state = "grapplehand2"
		visible_message("\blue The [src] retracts back into [hand.holder]")
		..()

	New(var/loc, var/handy)
		hand = handy
		..()
		spawn(0)
			var/mob/living/carbon/human/H = hand.holder
			H.equip_to_slot_if_possible(hand, hand.slotheld, 0)
		spawn(10)
			var/turf/T = get_turf(src)
			if((T==get_turf(GraspTarget))||T.Adjacent(get_turf(GraspTarget))) // Make sure we're in the same place, easy obsticle checking, basically.
				visible_message("\blue The [src] grasps [GraspTarget]")
				if(istype(GraspTarget,/obj/item))
					var/obj/item/I = GraspTarget
					if (!I.anchored)
						hand.Pickup(I)
					else
						I.attack_hand(hand.holder)
				else if(istype(GraspTarget,/mob))
					var/mob/M = GraspTarget
					M.throw_at(hand.holder, 10, 1)
				else if(istype(GraspTarget,/atom/movable))
					var/atom/movable/M = GraspTarget
					M.attack_hand(hand.holder)
				else if(istype(GraspTarget,/obj))
					var/obj/O = GraspTarget
					O.attack_hand(hand.holder)
				else if(istype(GraspTarget,/turf))
					var/mob/living/carbon/human/H = hand.holder
					H.throw_at(GraspTarget, 10, 1)
			del(src)