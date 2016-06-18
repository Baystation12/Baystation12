/datum/power/changeling/bioelectrogenesis
	name = "Bioelectrogenesis"
	desc = "We reconfigure a large number of cells in our body to generate an electric charge.  \
	On demand, we can attempt to recharge anything in our active hand, or we can touch someone with an electrified hand, shocking them."
	helptext = "We can shock someone by grabbing them and using this ability, or using the ability with an empty hand and touching them.  \
	Shocking someone costs ten chemicals per use."
	enhancedtext = "Shocking biologicals without grabbing only requires five chemicals, and has more disabling power."
	genomecost = 2
	verbpath = /mob/living/carbon/human/proc/changeling_bioelectrogenesis

/obj/proc/changeling_recharge(mob/living/user)
	. = 0
	for(var/obj/item/weapon/cell/cell in src.contents)
		. += cell.changeling_recharge(user, src)
	update_icon()

/obj/item/weapon/cell/changeling_recharge(mob/living/user, var/obj/affected = null)
	. = 0

	if(!affected) affected = src

	// Handle glove conductivity.
	var/siemens = 1
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/gloves/gloves = user.gloves
		if(gloves)
			siemens = gloves.siemens_coefficient

	for(var/i in 1 to 10)
		var/given = src.give(100 * siemens) //This should be a nice compromise between recharging guns and other batteries. TODO update this once gun cell capacities have been reworked
		if(!given)
			break //well, it didn't work
		
		var/T = get_turf(src)
		new /obj/effect/effect/sparks(T)
		playsound(T, "sparks", 50, 1)

		if(show_message)
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

	var/datum/changeling/changeling = changeling_power(20,0,100,CONSCIOUS)

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

	//If we're grabbing someone, electrocute them.
	if(istype(held_item,/obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = held_item
		if(G.affecting)
			var/obj/item/weapon/electric_hand/grab/direct = new(src)
			direct.shock_mob(G.affecting, src)
			qdel(direct)
		return 1

	//Otherwise, charge up whatever's in their hand.
	if(isobj(held_item))
		var/obj/item/weapon/electric_hand/grab/direct = new(src)
		var/success = direct.charge_obj(held_item, src)
		qdel(direct)
		return success


/obj/item/weapon/electric_hand
	name = "electrified hand"
	desc = "You could probably shock someone badly if you touched them, or recharge something."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "electric_hand"
	var/shock_cost = 10
	var/agony_amount = 60
	var/electrocute_amount = 10

/obj/item/weapon/electric_hand/grab
	agony_amount = 80 //Does more than if hit with an electric hand, since grabbing is slower.

/obj/item/weapon/electric_hand/efficent
	shock_cost = 5
	agony_amount = 80
	electrocute_amount = 20

/obj/item/weapon/electric_hand/New()
	if(ismob(loc))
		visible_message("<span class='warning'>Electrical arcs form around [loc.name]\'s hand!</span>",
		"<span class='warning'>We store a charge of electricity in our hand.</span>",
		"<span class='italics'>You hear crackling electricity!</span>")
		var/T = get_turf(src)
		new /obj/effect/sparks(T)
		playsound(T, "sparks", 50, 1)

/obj/item/weapon/electric_hand/dropped(mob/user)
	spawn(1)
		if(src)
			qdel(src)

/obj/item/weapon/electric_hand/afterattack(var/atom/target, var/mob/living/carbon/human/user, proximity)
	if(!target)
		return
	if(!proximity)
		return

	// Handle glove conductivity.
	var/obj/item/clothing/gloves/gloves = user.gloves
	var/siemens = 1
	if(gloves)
		siemens = gloves.siemens_coefficient

	//Excuse the copypasta.
	if(istype(target,/mob/living))
		if(user.mind.changeling.chem_charges < shock_cost)
			src << "<span class='warning'>We require more chemicals to electrocute [C]!</span>"
			return 0

		shock_mob(target, user)
		return 1

	if(isobj(target))
		recharge_obj(target, user)
		return 1

/obj/item/weapon/electric_hand/proc/shock_mob(mob/living/target, mob/living/user)
	// Handle glove conductivity.
	var/siemens = 1
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/gloves/gloves = user.gloves
		if(gloves)
			siemens = gloves.siemens_coefficient

	target.electrocute_act(electrocute_amount * siemens,src,1.0,BP_TORSO)
	target.stun_effect_act(0, agony_amount * siemens, BP_TORSO, src)

	msg_admin_attack("[key_name(user)] shocked [key_name(target)] with [src].")

	if(siemens)
		var/T = get_turf(target)
		new /obj/effect/effect/sparks(T)
		playsound(T, "sparks", 50, 1)
		visible_message("<span class='warning'>Arcs of electricity strike [target]!</span>",
		"<span class='warning'>Our hand channels raw electricity into [target]</span>",
		"<span class='italics'>You hear sparks!</span>")
		user.mind.changeling.chem_charges -= shock_cost
	else
		src << "<span class='warning'>Our gloves block us from shocking \the [target].</span>"

/obj/item/weapon/electric_hand/proc/recharge_obj(obj/target, mob/living/user)
	var/success = O.changeling_recharge(user)
	if(success) //If we couldn't do anything with the ability, don't deduct the chemicals.
		user.mind.changeling.chem_charges -= shock_cost
		qdel(src)
	else
		src << "<span class='warning'>We are unable to affect \the [O].</span>"
	return success