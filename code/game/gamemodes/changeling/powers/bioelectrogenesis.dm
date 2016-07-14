/datum/power/changeling/bioelectrogenesis
	name = "Bioelectrogenesis"
	desc = "We reconfigure a large number of cells in our body to generate an electric charge.  \
	On demand, we can attempt to recharge anything in our active hand, or we can touch someone with an electrified hand, shocking them."
	helptext = "We can shock someone by grabbing them and using this ability, or using the ability with an empty hand and touching them.  \
	Shocking someone costs ten chemicals per use."
	enhancedtext = "Shocking biologicals only requires five chemicals, and has more disabling power."
	genomecost = 2
	verbpath = /mob/living/carbon/human/proc/changeling_bioelectrogenesis

/obj/proc/changeling_recharge(mob/living/user, var/siemens)
	. = 0
	for(var/obj/item/weapon/cell/cell in src.contents)
		. += cell.changeling_recharge(user, siemens, src)
	update_icon()

/obj/item/weapon/cell/changeling_recharge(mob/living/user, var/siemens, var/obj/affected = null)
	. = 0

	if(!affected) affected = src

	for(var/i in 1 to 10)
		var/given = src.give(100 * siemens) //This should be a nice compromise between recharging guns and other batteries. TODO update this once gun cell capacities have been reworked
		if(!given)
			break //well, it didn't work
		
		var/T = get_turf(src)
		var/datum/effect/effect/system/spark_spread/spark_system = new () //this should really have a helper
		spark_system.set_up(5, 0, T)
		spark_system.start()
		playsound(T, "sparks", 50, 1)

		user.visible_message(
			"<span class='warning'>A shower of sparks erupts from [affected]!</span>",
			"<span class='warning'>Our hand channels raw electricity into [affected].</span>",
			"<span class='italics'>You hear electrical arcing!</span>"
			)

		update_icon()
		. += given
		sleep(1 SECOND)


//Recharge whatever's in our hand, or shock people.
/mob/living/carbon/human/proc/changeling_bioelectrogenesis()
	set category = "Changeling"
	set name = "Bioelectrogenesis (20 + 10/shock)"
	set desc = "Recharges anything in your hand, or shocks people."

	var/datum/changeling/changeling = changeling_power(10,0,100)

	var/obj/held_item = get_active_hand()

	if(!changeling)
		return 0

	if(held_item == null)
		if(src.mind.changeling.recursive_enhancement)
			if(changeling_generic_weapon(/obj/item/weapon/electric_hand/efficent))
				src << "<span class='notice'>We will shock others more efficently.</span>"
				src.mind.changeling.recursive_enhancement = 0
				return 1
		else
			if(changeling_generic_weapon(/obj/item/weapon/electric_hand,0))  //Chemical cost is handled in the equip proc.
				return 1
		return 0

	var/obj/item/weapon/electric_hand/direct
	if(src.mind.changeling.recursive_enhancement)
		direct = new /obj/item/weapon/electric_hand/efficent(src)
		src.mind.changeling.recursive_enhancement = 0
	else
		direct = new (src)
	direct.agony_amount += 20 //Does more than if hit with an electric hand, since grabbing is slower.

	//If we're grabbing someone, electrocute them.
	if(istype(held_item,/obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = held_item
		if(G.affecting)
			direct.shock_mob(G.affecting, src)
		. = 1

	//Otherwise, charge up whatever's in their hand.
	if(isobj(held_item))
		var/success = direct.recharge_obj(held_item, src)
		. = success

	qdel(direct)


/obj/item/weapon/electric_hand
	name = "electrified hand"
	desc = "You could probably shock someone badly if you touched them, or recharge something."
	icon = 'icons/mob/items/changeling.dmi'
	icon_state = "electric_hand"
	var/shock_cost = 10
	var/agony_amount = 60
	var/electrocute_amount = 10

/obj/item/weapon/electric_hand/efficent
	shock_cost = 5
	agony_amount = 80
	electrocute_amount = 20

/obj/item/weapon/electric_hand/New()
	if(ismob(loc))
		var/mob/M = loc
		M.visible_message(
			"<span class='warning'>Electrical arcs form around [loc]\'s hand!</span>",
			"<span class='warning'>We store a charge of electricity in our hand.</span>",
			"<span class='italics'>You hear crackling electricity!</span>"
			)
		var/T = get_turf(src)
		var/datum/effect/effect/system/spark_spread/spark_system = new () //this should really have a helper
		spark_system.set_up(5, 0, T)
		spark_system.start()
		playsound(T, "sparks", 50, 1)

/obj/item/weapon/electric_hand/dropped(mob/user)
	spawn(1)
		if(src)
			qdel(src)

/obj/item/weapon/electric_hand/resolve_attackby(var/atom/target, var/mob/living/carbon/human/user)
	if(!target)
		return

	//Excuse the copypasta.
	if(istype(target,/mob/living))
		if(user.mind.changeling.chem_charges < shock_cost)
			src << "<span class='warning'>We require more chemicals to electrocute [target]!</span>"
			return 0

		shock_mob(target, user)
		return 1

	if(isobj(target))
		recharge_obj(target, user)
		return 1

/obj/item/weapon/electric_hand/proc/shock_mob(mob/living/target, mob/living/user)
	// Handle glove conductivity.
	var/hand = user.get_held_zone(src)
	if(!hand)
		hand = pick("l_hand", "r_hand")

	var/siemens = user.get_siemens_coefficient_organ(hand)
	target.electrocute_act(electrocute_amount * siemens,src,1.0,BP_TORSO)
	target.stun_effect_act(0, agony_amount * siemens, BP_TORSO, src)

	msg_admin_attack("[key_name(user)] shocked [key_name(target)] with [src].")

	if(siemens)
		var/T = get_turf(target)
		var/datum/effect/effect/system/spark_spread/spark_system = new () //this should really have a helper
		spark_system.set_up(5, 0, T)
		spark_system.start()
		playsound(T, "sparks", 50, 1)
		user.visible_message(
			"<span class='warning'>Arcs of electricity strike [target]!</span>",
			"<span class='warning'>Our hand channels raw electricity into [target]</span>",
			"<span class='italics'>You hear sparks!</span>"
			)
		user.mind.changeling.chem_charges -= shock_cost
	else
		src << "<span class='warning'>Our gloves block us from shocking \the [target].</span>"

/obj/item/weapon/electric_hand/proc/recharge_obj(obj/target, mob/living/user)
	// Handle glove conductivity.
	var/hand = user.get_held_zone(src)
	if(!hand)
		hand = pick("l_hand", "r_hand")

	var/siemens = user.get_siemens_coefficient_organ(hand)
	var/success = target.changeling_recharge(user, siemens)
	if(success) //If we couldn't do anything with the ability, don't deduct the chemicals.
		user.mind.changeling.chem_charges -= shock_cost
	else
		src << "<span class='warning'>We are unable to affect \the [target].</span>"
	return success