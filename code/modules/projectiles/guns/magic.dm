/obj/item/weapon/gun/magic
	name = "magic gun of nothing"
	desc = "It does absolutely nothing"
	icon = 'icons/obj/gun.dmi'
	icon_state = "staffofchange"
	item_state = "staffofchange"
	fire_sound = 'sound/weapons/emitter.ogg'
	flags = CONDUCT
	slot_flags = SLOT_BACK
	w_class = 4
	var/charge = 5
	var/maxcharge = 5
	var/recharge_rate = 5 // Set to 0 to never recharge
	var/recharge_tick = 0
	var/projectile_type = null
	origin_tech = null
	clumsy_check = 0

/obj/item/weapon/gun/magic/New()
	..()
	if(recharge_rate)
		processing_objects.Add(src)

/obj/item/weapon/gun/magic/Del()
	..()
	if(recharge_rate)
		processing_objects.Remove(src)

/obj/item/weapon/gun/magic/load_into_chamber()
	if(in_chamber)
		return 1
	if(!charge)
		return 0
	if(!projectile_type)
		return 0
	--charge
	in_chamber = new projectile_type(src)
	return 1

/obj/item/weapon/gun/magic/process()
	if(charge >= maxcharge)
		return
	++recharge_tick
	if(recharge_tick >= recharge_rate)
		recharge_tick =0
		++charge
	return 1

/obj/item/weapon/gun/magic/click_empty(mob/user = null)
	if (user)
		user.visible_message("*fizzle*", "<span class='danger'>*fizzle*</span>")
	else
		src.visible_message("*fizzle*")
	playsound(src.loc, 'sound/effects/sparks1.ogg', 100, 1)

/obj/item/weapon/gun/magic/change
	name = "staff of change"
	desc = "An artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself"
	icon = 'icons/obj/gun.dmi'
	icon_state = "staffofchange"
	item_state = "staffofchange"
	fire_sound = 'sound/weapons/emitter.ogg'
	projectile_type = /obj/item/projectile/change

/obj/item/weapon/gun/magic/animate
	name = "staff of animation"
	desc = "An artefact that spits bolts of life-force which causes objects which are hit by it to animate and come to life! This magic doesn't affect machines."
	projectile_type = /obj/item/projectile/animate

/obj/item/weapon/storage/belt/wands
	name = "Magic wands belt"
	desc = "Used by wizards who like their wands in order."
	icon_state = "soulstonebelt"
	item_state = "soulstonebelt"
	can_hold = list(
		"/obj/item/weapon/gun/magic/wand"
		)

/obj/item/weapon/storage/belt/wands/full/New()
	..()
	new /obj/item/weapon/gun/magic/wand/opening(src)
	new /obj/item/weapon/gun/magic/wand/sleeping(src)
	new /obj/item/weapon/gun/magic/wand/lightning(src)
	new /obj/item/weapon/gun/magic/wand/healing(src)

/obj/item/weapon/gun/magic/wand
	name = "wand of nothing"
	desc = "It zaps beams of nothing"
	charge = 20
	maxcharge = 20
	w_class = 2
	recharge_rate = 0
	slot_flags = 0

/obj/item/weapon/gun/magic/wand/attack(mob/living/M as mob, mob/living/user as mob, def_zone)
	if(load_into_chamber())
		if(user.a_intent == "hurt")
			user.visible_message("<span class='warning'>[user] has zapped [M] with \the [src]!")
			Fire(M, user)

/obj/item/projectile/beam/wand
	pass_flags = 0
	damage = 0
	nodamage = 1
	flag = "energy"

/obj/item/projectile/beam/wand/on_hit(var/atom/target, var/blocked = 0)
	affect(target)

/obj/item/projectile/beam/wand/proc/affect(var/atom/target)
	return

/obj/item/weapon/gun/magic/wand/opening
	name = "wand of opening"
	desc = "It opens doors when zapped at them"
	projectile_type = /obj/item/projectile/beam/wand/opening

/obj/item/weapon/gun/magic/wand/sleeping
	name = "wand of sleep"
	desc = "It puts people to sleep"
	projectile_type = /obj/item/projectile/beam/wand/sleeping

/obj/item/weapon/gun/magic/wand/lightning
	name = "wand of lightning"
	desc = "It zaps the target with a powerful lightning strike"
	projectile_type = /obj/item/projectile/beam/wand/lightning

/obj/item/weapon/gun/magic/wand/healing
	name = "wand of healing"
	desc = "It mends wounds and heals other types of damage, but does nothing for the dead."
	projectile_type = /obj/item/projectile/beam/wand/healing

/obj/item/projectile/beam/wand/opening/affect(var/atom/target)
	if(istype(target, /obj/machinery/door))
		var/obj/machinery/door/D = target
		if(istype(D, /obj/machinery/door/airlock))
			D:unlock(1)	//forced because it's magic!
		D.open()
	else if(istype(target, /obj/structure/closet/crate/secure))
		var/obj/structure/closet/crate/secure/C = target
		if(C.locked) // Why isn't there a proc for this?
			C.locked = 0
			C.overlays.Cut()
			C.overlays += C.greenlight
	else if(istype(target, /obj/structure/closet/secure_closet))
		var/obj/structure/closet/secure_closet/C = target
		if(C.locked)
			C.locked = 0
			C.update_icon()

/obj/item/projectile/beam/wand/sleeping/affect(var/atom/target)
	if(istype(target, /mob/living/carbon))
		var/mob/living/carbon/C = target
		C << "<span class='warning'>You suddenly feel very tired.</span>"
		C.sleeping = max(C.sleeping, 10)

/obj/item/projectile/beam/wand/lightning/affect(var/atom/target)
	if(istype(target, /mob/living/carbon))
		var/mob/living/carbon/C = target
		C.electrocute_act(15, src)

/obj/item/projectile/beam/wand/healing/affect(var/atom/target)
	if(istype(target, /mob/living/carbon))
		var/mob/living/carbon/C = target
		C.adjustOxyLoss(-30)
		C.heal_organ_damage(15, 15)
		C.adjustToxLoss(-15)
		C.adjustCloneLoss(-5)
		for(var/datum/organ/internal/I in C.internal_organs)
			if(I.damage > 0)
				I.damage = max(I.damage - 3, 0)
		C.visible_message("<span class='info'>[C] looks better.</span>")