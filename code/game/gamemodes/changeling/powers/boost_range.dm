/datum/power/changeling/boost_range
	name = "Boost Range"
	desc = "We evolve the ability to fire biological darts from our hand to deliver our sting."
	helptext = "Allows us to use the effects of our stings at a distance"
	enhancedtext = "The range is extended to five tiles."
	ability_icon_state = "ling_sting_boost_range"
	genomecost = 1
	allowduringlesserform = 1
	verbpath = /mob/proc/changeling_boost_range

//Boosts the range of your next sting attack by 1

/obj/item/ammo_casing/chemdart/changeling
	name = "organic dart"
	desc = "A needle thin dart formed of bone."
	icon_state = "ling_dart"
	icon = 'icons/obj/projectiles.dmi'
	caliber = CALIBER_DART
	projectile_type = /obj/item/projectile/bullet/chemdart/changeling
	leaves_residue = FALSE
/obj/item/projectile/bullet/chemdart/changeling
	name = "organic dart"
	fire_sound = 'sound/weapons/Genhit.ogg'
	icon_state = "ling_dart"
	life_span = 3
	icon = 'icons/obj/projectiles.dmi'
/obj/item/projectile/bullet/chemdart/changeling/on_hit(atom/target, blocked = 0, def_zone)
	if(blocked < 100 && isliving(target))
		var/mob/living/L = target
		if (src.firer == target)
			return
		var/datum/power/changeling/sting = src.firer.mind.changeling.selected_ranged_sting
		//use firer ling mind to set ling selected ranged sting
		if(L.can_inject(null, def_zone) == CAN_INJECT)
			call(sting.sting_effect)(target,sting.sting_duration)


/obj/item/gun/projectile/changeling
	name = "thin mass"
	desc = "A thin, narrow and hollow mass of flesh protruding from the palm. It twitches and pulses, eager to strike."
	can_reload = FALSE
	screen_shake = FALSE
	space_recoil = FALSE
	has_safety = FALSE
	silenced = TRUE
	auto_eject = FALSE
	handle_casings = CLEAR_CASINGS
	max_shells = 1
	starts_loaded = TRUE
	has_safety = FALSE
	silenced = TRUE
	icon = 'icons/obj/guns/dartgun.dmi'
	item_state = null
	icon_state = "ling_dart"
	fire_sound = 'sound/weapons/Genhit.ogg'
	anchored = TRUE
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	screen_shake = FALSE
	space_recoil = FALSE
	var/mob/living/creator //This is just like ninja swords, needed to make sure dumb shit that removes the sword doesn't make it stay around.
	var/weapType = "weapon"
	var/weapLocation = "arm"
	canremove = FALSE
	jam_chance = 0
	ammo_type = /obj/item/ammo_casing/chemdart/changeling
	var/list/available_stings = list()
	var/selected_sting = null

/obj/item/gun/projectile/changeling/Initialize()
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

/obj/item/gun/projectile/changeling/Destroy()
	STOP_PROCESSING(SSobj, src)
	creator = null
	return ..()

/obj/item/gun/projectile/changeling/Process()
	var/mob/living/carbon/human/H = creator

	if ( H.handcuffed || (H.stat != CONSCIOUS) || (length(loaded) == 0))
		//playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
		to_chat(creator,SPAN_WARNING("We retract our ranged stinger back into our body."))
		qdel(src)

/mob/proc/changeling_boost_range()
	set category = "Changeling"
	set name = "Ranged Stinger (20)"
	set desc="We transform one of our hands so that it can fire organic darts at targets."

	var/list/available_stings = list()
	var/datum/changeling/changeling = changeling_power(10,0,100)
	if(!changeling)
		return TRUE
	//changeling.chem_charges -= 10
	var/holding = src.get_active_hand()
	if (istype(holding, /obj/item/gun/projectile/changeling))
		to_chat(src,SPAN_WARNING("We retract our ranged stinger back into our body."))
		//playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
		qdel(holding)
		return 0
	for (var/datum/power/changeling/power in src.mind.changeling.purchased_powers)
		if (power.is_sting)
			available_stings.Add(power)
	if(length(available_stings) == 0)
		to_chat(src,SPAN_WARNING("We do not have any stings that we can fire at range!"))
		return FALSE
	var/datum/power/changeling/sting= input(src,"Select a sting.", "Select") as null|anything in available_stings
	if(sting)
		var/sting_name = sting.name
		to_chat(src,SPAN_WARNING("We prepare to fire a [sting_name]"))
	if(src.mind.changeling.recursive_enhancement)
		if(changeling_equip_ranged(/obj/item/gun/projectile/changeling, sting_type = sting))
			return 1

	else
		if(changeling_equip_ranged(/obj/item/gun/projectile/changeling, sting_type = sting))
			return 1
		return 0
