
// EPIC GRAPPLE ARM! NINJA!
/obj/item/robot_parts/grapple
	name = "Grapple Tool"
	desc = "That looks damn awesome!"
	icon_state = "grapplehand"
	construction_time = 100
	construction_cost = list("metal"=18000)
	part = list()
	var/obj/item/weapon/grapplehand/grapple
	var/slotheld

	OnInstall()
		..()
		//var/mob/living/carbon/human/H = instin
		//H.verbs += /obj/item/robot_parts/grapple/proc/SummonGrapple

	OnUninstall()
		//var/mob/living/carbon/human/H = instin
		//H.verbs -= /obj/item/robot_parts/grapple/proc/SummonGrapple
		..()

	verb/SummonGrapple()
		set name = "Prepare Grapple"
		set category = "Abilities"
		if(!istype(grapple)&&istype(instin,/mob/living/carbon/human))
			grapple = new/obj/item/weapon/grapplehand(get_turf(src))
			if(istype(grapple))
				var/mob/living/carbon/human/H = instin
				grapple.holder = H
				grapple.slotheld = slotheld
				H.equip_to_slot_if_possible(grapple, slotheld, 0)
				H.throw_mode_on()

/obj/item/robot_parts/grapple/l_hand
	name = "left grapple hand"
	part = list("l_hand")
	w_class = 2.0
	slotheld = slot_l_hand

/obj/item/robot_parts/grapple/r_hand
	name = "right grapple hand"
	part = list("r_hand")
	w_class = 2.0
	slotheld = slot_r_hand

/obj/item/weapon/grapplehand
	name = "grapple hand"
	desc = "A claw looking thing. Throw it for long range touching of things."
	icon_state = "grapplehand"
	icon = 'icons/obj/robot_parts.dmi'
	var/holder
	var/slotheld
	throw_speed = 10

	dropped(var/override = 1)
		spawn(20)
			if(override && istype(src))
				spawn(1)
					del(src)
	equipped(var/mob/living/carbon/human/H, var/slot)
		if(slot!=slotheld)
			del(src)

	Del()
		visible_message("\blue The [src] retracts back into [holder]")
		..()

	throw_at(var/target)
		..()
		spawn(10)
			var/turf/T = get_turf(src)
			if((T==get_turf(target))||T.Adjacent(get_turf(target))) // Make sure we're in the same place, easy obsticle checking, basically.
				visible_message("\blue The [src] grasps [target]")
				if(istype(target,/obj/item))
					var/obj/item/I = target
					I.attack_hand(holder)
				else if(istype(target,/atom/movable))
					var/atom/movable/M = target
					if(!M.anchored)
						M.throw_at(get_turf(holder), 10, 1)
					else
						M.attack_hand(holder)
				else if(istype(target,/obj))
					var/obj/O = target
					O.attack_hand(holder)
				else if(istype(target,/turf))
					var/mob/living/carbon/human/H = holder
					H.throw_at(target, 10, 1)
			del(src)