
/datum/power/changeling/arm_hammer
	name = "Arm Hammer"
	desc = "We reform one of our arms into a weighty hammer capable of smashing quickly through obstacles or victims alike. We can slam enemies aside with it on disarm intent, sending them flying."
	helptext = "We may retract our armhammer by using the ability again with the hammer in our active hand."
	ability_icon_state = "ling_hammer"
	enhancedtext = "The hammer will have further armor peneratration."
	genomecost = 2
	power_category = CHANGELING_POWER_WEAPONS
	verbpath = /mob/proc/changeling_arm_hammer
/datum/power/changeling/arm_blade
	name = "Arm Blade"
	desc = "We reform one of our arms into a deadly blade capable of slicing through armor. It can pry open airlocks, breaking them in the process."
	helptext = "We may retract our armblade by using the ability again with the blade in our active hand."
	enhancedtext = "The blade will have greater armor peneratration and parry more effectively."
	ability_icon_state = "ling_blade"
	genomecost = 2
	power_category = CHANGELING_POWER_WEAPONS
	verbpath = /mob/proc/changeling_arm_blade

//HAMMERTIME
/mob/proc/changeling_arm_hammer()
	set category = "Changeling"
	set name = "Arm Hammer (15)"
	var/holding = src.get_active_hand()
	if (istype(holding, /obj/item/melee/changeling/arm_hammer))
		to_chat(src,SPAN_WARNING("We shrink our arm back to its normal size."))
		playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
		qdel(holding)
		return 0
	if(src.mind.changeling.recursive_enhancement)
		src.mind.changeling.recursive_enhancement = FALSE
		if(changeling_generic_weapon(/obj/item/melee/changeling/arm_hammer/greater, cost = 15))
			//to_chat(src, "<span class='notice'>We prepare an extra sharp blade.</span>")
			return 1
	else
		if(changeling_generic_weapon(/obj/item/melee/changeling/arm_hammer, cost = 15))
			return 1
		return 0

//Grows a scary, and powerful arm blade.
/mob/proc/changeling_arm_blade()
	set category = "Changeling"
	set name = "Arm Blade (20)"
	var/holding = src.get_active_hand()
	if (istype(holding, /obj/item/melee/changeling/arm_blade))
		to_chat(src,SPAN_WARNING("We retract our blade back into our body."))
		playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
		qdel(holding)
		return 0
	if(src.mind.changeling.recursive_enhancement)
		src.mind.changeling.recursive_enhancement = FALSE
		if(changeling_generic_weapon(/obj/item/melee/changeling/arm_blade/greater, cost = 20))
			//to_chat(src, "<span class='notice'>We prepare an extra sharp blade.</span>")
			return 1

	else
		if(changeling_generic_weapon(/obj/item/melee/changeling/arm_blade, cost = 20))
			return 1
		return 0

//Claws
/datum/power/changeling/claw
	name = "Claw"
	desc = "We reform one of our arms into a deadly claw. We can instantly aggressively grab enemies with it on grab intent."
	helptext = "We may retract our claw by using the ability again with the claw in our active hand."
	enhancedtext = "The claw will have armor peneratration."
	ability_icon_state = "ling_claw"
	genomecost = 1
	power_category = CHANGELING_POWER_WEAPONS
	verbpath = /mob/proc/changeling_claw

//Grows a scary, and powerful claw.
/mob/proc/changeling_claw()
	set category = "Changeling"
	set name = "Claw (15)"
	var/holding = src.get_active_hand()
	if (istype(holding, /obj/item/melee/changeling/claw))
		to_chat(src,SPAN_WARNING("We reform our claw back into an ordinary appendage."))
		playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
		qdel(holding)
		return 0
	if(src.mind.changeling.recursive_enhancement)
		src.mind.changeling.recursive_enhancement = FALSE
		if(changeling_generic_weapon(/obj/item/melee/changeling/claw/greater, 1, cost = 15))
			to_chat(src, SPAN_NOTICE("We prepare an extra sharp claw."))
			return 1

	else
		if(changeling_generic_weapon(/obj/item/melee/changeling/claw, 1, cost = 15))
			return 1
		return 0

/obj/item/melee/changeling
	name = "arm weapon"
	desc = "A grotesque weapon made out of bone and flesh that cleaves through people as a hot knife through butter."
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "ling_blade"
	item_icons = list(
		icon_l_hand = 'icons/mob/onmob/items/lefthand.dmi',
		icon_r_hand = 'icons/mob/onmob/items/righthand.dmi',
		)
	item_state = "arm_blade"
	w_class = ITEM_SIZE_HUGE
	force = 5
	hitsound = 'sound/weapons/bladeslice.ogg'
	anchored = TRUE
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	var/mob/living/creator //This is just like ninja swords, needed to make sure dumb shit that removes the sword doesn't make it stay around.
	var/weapType = "weapon"
	var/weapLocation = "arm"
	canremove = FALSE
	base_parry_chance = 40	// The base chance for the weapon to parry.

/obj/item/melee/changeling/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	if(ismob(loc))
		/*
		visible_message(
			SPAN_WARNING("A grotesque weapon forms around [loc.name]\'s arm!"),
			SPAN_WARNING("Our arm twists and mutates, transforming it into a deadly weapon."),
			SPAN_ITALIC("You hear organic matter ripping and tearing!")
		)
		*/
		src.creator = loc


/obj/item/melee/changeling/Destroy()
	STOP_PROCESSING(SSobj, src)
	creator = null
	return ..()
/obj/item/melee/changeling/Process()
	var/mob/living/carbon/human/H = creator
	if ( H.handcuffed || (H.stat != CONSCIOUS))
		qdel(src)
	if(!istype(loc,/mob))
		src.visible_message(SPAN_DANGER("\The [src] rapidly decays and melts into a puddle of slime!"))
		new /obj/decal/cleanable/ling_vomit(src.loc)
		qdel(src)
		..()
/obj/item/melee/changeling/arm_hammer
	name = "arm hammer"
	desc = "A hammer made out of flesh and bone, heavy enough to smash through armor and people alike."
	icon_state = "ling_hammer"
	item_state = "ling_hammer"
	force = 25
	hitsound = 'sound/weapons/genhit3.ogg'
	armor_penetration = 30
	sharp = FALSE
	edge = FALSE
	attack_verb = list("attacked", "struck", "smashed", "clubbed", "beaten", "hit", "battered", "smacked")
	base_parry_chance = 50
	var/last_slam = null
	var/cooldown = 7 SECONDS
/obj/item/melee/changeling/arm_hammer/greater
	name = "arm greathammer"
	desc = "A massive hammer made out of flesh and bone, heavy enough to smash through armor and people alike."
	armor_penetration = 50

/obj/item/melee/changeling/arm_hammer/use_before(atom/target,mob/user)
	if (user.a_intent == I_DISARM)
		if ((last_slam + cooldown > world.time))
			to_chat(user, SPAN_WARNING("We are still recovering from our last slam attack."))
			return
		if(istype(target,/mob/living/carbon))
			var/mob/living/carbon/M = target
			user.do_attack_animation(M)
			var/target_zone = check_zone(user.zone_sel.selecting)
			M.apply_damage(force, DAMAGE_BRUTE, target_zone)
			user.visible_message(SPAN_DANGER("\the [user] slams their arm hammer into \the [M] in a furious blow, sending them flying!"))
			M.throw_at(get_edge_target_turf(user, user.dir), 5, 5)
			playsound(src, 'sound/weapons/punch1.ogg', 30, 1)
			last_slam = world.time

	if(istype(target,/turf/simulated/wall) || istype(target,/obj/structure) && (user.a_intent != I_HELP))
		target.damage_health(rand(25, 75), DAMAGE_BRUTE)

/obj/item/melee/changeling/arm_blade
	name = "arm blade"
	desc = "A grotesque blade made out of bone and flesh that cleaves through people as a hot knife through butter."
	icon_state = "ling_blade"
	item_state = "arm_blade"
	force = 35
	armor_penetration = 15
	sharp = TRUE
	edge = TRUE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "ripped", "diced", "cut")
	base_parry_chance = 60

/obj/item/melee/changeling/arm_blade/use_before(atom/target,mob/user)
	if (istype(target, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/A = target
		if(A.locked)
			to_chat(user,SPAN_WARNING("We cannot force open an airlock held in place by bolts."))
			return
		A.visible_message(SPAN_DANGER("\The [user] forces \the [src] between \the [A], causing the metal to creak!"))
		playsound(A, 'sound/machines/airlock_creaking.ogg', 100, 1)
		if (do_after(user, 5 SECONDS, A, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS) && !A.locked)
			A.welded = FALSE
			A.update_icon()
			playsound(A, 'sound/effects/meteorimpact.ogg', 100, 1)
			A.visible_message(SPAN_DANGER("\The [user] tears \the [A] open with \a [src]!"))
			addtimer(new Callback(A, /obj/machinery/door/airlock/.proc/open, TRUE), 0)
			A.open()
			A.set_broken(TRUE)

	if (istype(target, /obj/machinery/door/firedoor))
		var/obj/machinery/door/firedoor/A = target
		playsound(A, 'sound/machines/airlock_creaking.ogg', 100, 1)
		if (do_after(user, 2 SECONDS, A, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
			A.visible_message(SPAN_DANGER("\The [user] pries \the [A] wide open effortlessly!"))
			A.open(TRUE)
	if (istype(target, /obj/machinery/door/blast))
		var/obj/machinery/door/blast/A = target
		if(!istype(user.get_inactive_hand(),/obj/item/melee/changeling/arm_blade))
			to_chat(user,SPAN_WARNING("We require an armblade in both arms to be able to exert enough force to pry a blast door open."))
			return
		A.visible_message(SPAN_DANGER("\The [user] forces both armblades between \the [A], prying with incredible strength!"))
		playsound(A, 'sound/machines/airlock_creaking.ogg', 100, 1)
		if (do_after(user, 20 SECONDS, A, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS) )
			A.update_icon()
			playsound(A, 'sound/effects/meteorimpact.ogg', 100, 1)
			A.visible_message(SPAN_DANGER("\The [user] tears \the [A] wide open!"))
			A.force_open()

/obj/item/melee/changeling/arm_blade/greater
	name = "arm greatblade"
	desc = "A grotesque blade made out of bone and flesh that cleaves through people and armor as a hot knife through butter."
	armor_penetration = 30
	base_parry_chance = 70

/obj/item/melee/changeling/claw
	name = "hand claw"
	item_state = "ling_claw"
	desc = "A grotesque claw made out of bone and flesh that cleaves through people as a hot knife through butter."
	icon_state = "ling_claw"
	force = 20
	sharp = FALSE
	edge = TRUE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	base_parry_chance = 50
	var/last_grab = null
	var/cooldown = 5 SECONDS
/obj/item/melee/changeling/claw/use_before(mob/living/M,mob/user)

	if(user.a_intent == I_GRAB)
		if ((last_grab + cooldown > world.time))
			to_chat(user, SPAN_WARNING("We are still recovering from our last grab attack."))
			return
		if(istype(M,/mob/living/carbon) && (user.mind.changeling.chem_charges > 10))
			var/mob/living/carbon/human/H = user
			if(!user.get_inactive_hand())
				user.swap_hand()
				H.species.attempt_grab(H,M)
				var/obj/item/grab/holding = H.get_active_hand()
				if(istype(holding,/obj/item/grab))
					holding.upgrade(bypass_cooldown = TRUE)
					last_grab = world.time

/obj/item/melee/changeling/claw/greater
	name = "hand greatclaw"
	force = 25
	armor_penetration = 20
	base_parry_chance = 60

/datum/power/changeling/arm_shield
	name = "Arm Shield"
	desc = "We reform one of our arms into a resilient shield to protect ourselves from harm. The shield can deflect projectiles, but not reliably."
	helptext = "We may retract our shield by using the ability again with the shield in hand."
	enhancedtext = "The shield will be more resistant to damage."
	ability_icon_state = "ling_shield"
	genomecost = 2
	power_category = CHANGELING_POWER_WEAPONS
	verbpath = /mob/proc/changeling_arm_shield

/mob/proc/changeling_arm_shield()
	set category = "Changeling"
	set name = "Arm Shield (20)"
	var/holding = src.get_active_hand()
	if (istype(holding, /obj/item/shield/riot/changeling))
		to_chat(src,SPAN_WARNING("We retract our claw back into our body."))
		playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
		qdel(holding)
		return 0
	if(src.mind.changeling.recursive_enhancement)
		src.mind.changeling.recursive_enhancement = FALSE
		if(changeling_generic_weapon(/obj/item/shield/riot/changeling/greater))
			//to_chat(src, "<span class='notice'>We prepare an extra sharp blade.</span>")
			return 1

	else
		if(changeling_generic_weapon(/obj/item/shield/riot/changeling))
			return 1
		return 0

/obj/item/shield/riot/changeling
	name = "chitin shield"
	item_state = "ling_shield"
	icon_state = "ling_shield"
	desc = "A monstrously thick and bulky mess of fleshy chitin, covered in shards of bone."
	throwforce = 0
	throw_speed = 0
	throw_range = 0
	anchored = TRUE
	var/mob/living/creator //This is just like ninja swords, needed to make sure dumb shit that removes the sword doesn't make it stay around.
	var/weapType = "weapon"
	var/weapLocation = "arm"
	canremove = FALSE
/obj/item/shield/riot/changeling/greater
	name = "chitin greatshield"
	max_block = 50
	can_block_lasers = TRUE

/obj/item/shield/riot/changeling/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	if(ismob(loc))
		/*
		visible_message(
			SPAN_WARNING("A grotesque weapon forms around [loc.name]\'s arm!"),
			SPAN_WARNING("Our arm twists and mutates, transforming it into a deadly weapon."),
			SPAN_ITALIC("You hear organic matter ripping and tearing!")
		)
		*/
		src.creator = loc

/obj/item/shield/riot/changeling/Destroy()
	STOP_PROCESSING(SSobj, src)
	creator = null
	return ..()

/obj/item/shield/riot/changeling/Process()
	var/mob/living/carbon/human/H = creator
	if ( H.handcuffed || (H.stat != CONSCIOUS))
		qdel(src)
	if(!istype(loc,/mob))
		src.visible_message(SPAN_DANGER("\The [src] rapidly decays and melts into a puddle of slime!"))
		new /obj/decal/cleanable/ling_vomit(src.loc)
		qdel(src)
		..()
