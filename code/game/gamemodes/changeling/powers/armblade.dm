/datum/power/changeling/arm_blade
	name = "Arm Blade"
	desc = "We reform one of our arms into a deadly blade."
	helptext = "We may retract our armblade by dropping it.  It can deflect projectiles."
	enhancedtext = "The blade will have armor peneratration."
	ability_icon_state = "ling_blade"
	genomecost = 2
	power_category = CHANGELING_POWER_WEAPONS
	verbpath = /mob/proc/changeling_arm_blade

//Grows a scary, and powerful arm blade.
/mob/proc/changeling_arm_blade()
	set category = "Changeling"
	set name = "Arm Blade (20)"

	if(src.mind.changeling.recursive_enhancement)
		if(changeling_generic_weapon(/obj/item/melee/changeling/arm_blade/greater))
			to_chat(src, "<span class='notice'>We prepare an extra sharp blade.</span>")
			return 1

	else
		if(changeling_generic_weapon(/obj/item/melee/changeling/arm_blade))
			return 1
		return 0

//Claws
/datum/power/changeling/claw
	name = "Claw"
	desc = "We reform one of our arms into a deadly claw."
	helptext = "We may retract our claw by dropping it."
	enhancedtext = "The claw will have armor peneratration."
	ability_icon_state = "ling_claw"
	genomecost = 1
	power_category = CHANGELING_POWER_WEAPONS
	verbpath = /mob/proc/changeling_claw

//Grows a scary, and powerful claw.
/mob/proc/changeling_claw()
	set category = "Changeling"
	set name = "Claw (15)"

	if(src.mind.changeling.recursive_enhancement)
		if(changeling_generic_weapon(/obj/item/melee/changeling/claw/greater, 1, 15))
			to_chat(src, "<span class='notice'>We prepare an extra sharp claw.</span>")
			return 1

	else
		if(changeling_generic_weapon(/obj/item/melee/changeling/claw, 1, 15))
			return 1
		return 0

/obj/item/melee/changeling
	name = "arm weapon"
	desc = "A grotesque weapon made out of bone and flesh that cleaves through people as a hot knife through butter."
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "ling_blade"
	w_class = ITEM_SIZE_HUGE
	force = 5
	anchored = TRUE
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	var/mob/living/creator //This is just like ninja swords, needed to make sure dumb shit that removes the sword doesn't make it stay around.
	var/weapType = "weapon"
	var/weapLocation = "arm"

	base_parry_chance = 40	// The base chance for the weapon to parry.

/obj/item/melee/changeling/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	if(ismob(loc))
		visible_message(
			SPAN_WARNING("A grotesque weapon forms around [loc.name]\'s arm!"),
			SPAN_WARNING("Our arm twists and mutates, transforming it into a deadly weapon."),
			SPAN_ITALIC("You hear organic matter ripping and tearing!")
		)
		src.creator = loc

/obj/item/melee/changeling/dropped(mob/user)
	visible_message(
		SPAN_WARNING("With a sickening crunch, [creator] reforms their arm!"),
		SPAN_NOTICE("We assimilate the weapon back into our body."),
		SPAN_ITALIC("You hear organic matter ripping and tearing!")
	)
	playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
	qdel(src)

/obj/item/melee/changeling/Destroy()
	STOP_PROCESSING(SSobj, src)
	creator = null
	return ..()

/obj/item/melee/changeling/Process()
	if(!creator || loc != creator || (creator.l_hand != src && creator.r_hand != src))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		QDEL_IN(src, 0)


/obj/item/melee/changeling/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(default_parry_check(user, attacker, damage_source) && prob(base_parry_chance))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(src, 'sound/weapons/slash.ogg', 50, 1)
		return TRUE

	return FALSE

/obj/item/melee/changeling/arm_blade
	name = "arm blade"
	desc = "A grotesque blade made out of bone and flesh that cleaves through people as a hot knife through butter."
	icon_state = "ling_blade"
	force = 40
	armor_penetration = 15
	sharp = TRUE
	edge = TRUE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	base_parry_chance = 60

/obj/item/melee/changeling/arm_blade/greater
	name = "arm greatblade"
	desc = "A grotesque blade made out of bone and flesh that cleaves through people and armor as a hot knife through butter."
	armor_penetration = 30
	base_parry_chance = 70

/obj/item/melee/changeling/claw
	name = "hand claw"
	desc = "A grotesque claw made out of bone and flesh that cleaves through people as a hot knife through butter."
	icon_state = "ling_claw"
	force = 15
	sharp = TRUE
	edge = TRUE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	base_parry_chance = 50

/obj/item/melee/changeling/claw/greater
	name = "hand greatclaw"
	force = 20
	armor_penetration = 20
	base_parry_chance = 60
