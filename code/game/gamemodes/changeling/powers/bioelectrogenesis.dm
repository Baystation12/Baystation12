/datum/power/changeling/bioelectrogenesis
	name = "Bioelectrogenesis"
	desc = "We reconfigure a large number of cells in our body to generate an electric charge.  \
	On demand, we can attempt to recharge anything in our active hand, or we can touch someone with an electrified hand, shocking them."
	helptext = "We can shock someone by grabbing them and using this ability, or using the ability with an empty hand and touching them.  \
	Shocking someone costs ten chemicals per use."
	enhancedtext = "Shocking biologicals without grabbing only requires five chemicals, and has more disabling power."
	ability_icon_state = "ling_bioelectrogenesis"
	genomecost = 2
	verbpath = /mob/living/carbon/human/proc/changeling_bioelectrogenesis

//Recharge whatever's in our hand, or shock people.
/mob/living/carbon/human/proc/changeling_bioelectrogenesis()
	set category = "Changeling"
	set name = "Bioelectrogenesis (15 + 10/shock)"
	set desc = "Recharges anything in your hand, or shocks people."
	var/obj/held_item = get_active_hand()
	if (istype(held_item, /obj/item/weapon/electric_hand))
		qdel(held_item)
		return 0
	var/datum/changeling/changeling = changeling_power(20,0,100,CONSCIOUS)


	var/last_shock = null
	var/cooldown = 3 SECONDS
	if(!changeling)
		return FALSE

	if(!held_item)
		if(src.mind.changeling.recursive_enhancement)
			if(changeling_generic_weapon(/obj/item/weapon/electric_hand/efficent,0))
				to_chat(src, "<span class='notice'>We will shock others more efficently.</span>")
				return TRUE
		else
			if(changeling_generic_weapon(/obj/item/weapon/electric_hand,0))  //Chemical cost is handled in the equip proc.
				return TRUE
		return FALSE
	else
		// Handle glove conductivity.
		var/obj/item/clothing/gloves/gloves = src.gloves
		var/siemens = 1
		if(gloves)
			siemens = gloves.siemens_coefficient
		if((last_shock + cooldown > world.time))
			to_chat(src,SPAN_DANGER("Our bioelectric hand is still recharging a voltage powerful enough to shock someone!"))
			return FALSE
		//If we're grabbing someone, electrocute them.
		var/obj/item/grab/G = src.get_active_hand()
		if(istype(G))
			if(G.affecting)
				G.affecting.electrocute_act(10 * siemens, src, 1.0, BP_CHEST, 0)
				var/agony = 80 * siemens //Does more than if hit with an electric hand, since grabbing is slower.
				G.affecting.stun_effect_act(0, agony, BP_CHEST, src)

				admin_attack_log(src,G.affecting,"Changeling shocked")

				if(siemens)
					visible_message("<span class='warning'>Arcs of electricity strike [G.affecting]!</span>",
					"<span class='warning'>Our hand channels raw electricity into [G.affecting].</span>",
					"<span class='italics'>You hear sparks!</span>")
					last_shock = world.time
				else
					to_chat(src, "<span class='warning'>Our gloves block us from shocking \the [G.affecting].</span>")
				src.mind.changeling.chem_charges -= 10
				return 1

		//Otherwise, charge up whatever's in their hand.
		else
			//This checks both the active hand, and the contents of the active hand's held item.
			var/success = 0
			var/list/L = new() //We make a new list to avoid copypasta.

			//Check our hand.
			if(istype(held_item,/obj/item/cell))
				L.Add(held_item)

			//Now check our hand's item's contents, so we can recharge guns and other stuff.
			for(var/obj/item/cell/cell in held_item.contents)
				L.Add(cell)

			//Now for the actual recharging.
			for(var/obj/item/cell/cell in L)
				visible_message("<span class='warning'>Some sparks fall out from \the [src.name]\'s [held_item]!</span>",
				"<span class='warning'>Our hand channels raw electricity into \the [held_item].</span>",
				"<span class='italics'>You hear sparks!</span>")
				var/i = 10
				if(siemens)
					while(i)
						cell.charge += 100 * siemens //This should be a nice compromise between recharging guns and other batteries.
						if(cell.charge > cell.maxcharge)
							cell.charge = cell.maxcharge
							break
						if(siemens)
							var/T = get_turf(src)
							new /obj/sparks(T)
							held_item.update_icon()
						i--
						sleep(1 SECOND)
					success = 1
			if(success == 0) //If we couldn't do anything with the ability, don't deduct the chemicals.
				to_chat(src, "<span class='warning'>We are unable to affect \the [held_item].</span>")
			else
				src.mind.changeling.chem_charges -= 10
			return success

/obj/item/weapon/electric_hand
	name = "electrified hand"
	desc = "You could probably shock someone badly if you touched them, or recharge something."
	icon = 'icons/obj/weapons/melee_energy.dmi'
	icon_state = "electric_hand"
	canremove = FALSE
	var/shock_cost = 10
	var/agony_amount = 60
	var/electrocute_amount = 10
	var/last_shock = null
	var/cooldown = 5 SECONDS
/obj/item/weapon/electric_hand/efficent
	name = "supercharged hand"
	desc = "Power! Unlimited Power!"
	shock_cost = 5
	agony_amount = 80
	electrocute_amount = 20

/obj/item/weapon/electric_hand/Initialize()
	. = ..()
	if(ismob(loc))
		src.visible_message(SPAN_DANGER("[src]\'s hand crackles with electricity, sparks flying about!"))
		var/T = get_turf(src)
		new /obj/sparks(T)

/obj/item/weapon/electric_hand/afterattack(atom/target, mob/living/carbon/human/user, proximity)
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
	if(istype(target,/mob/living/carbon))
		var/mob/living/carbon/C = target

		if(user.mind.changeling.chem_charges < shock_cost)
			to_chat(user, SPAN_WARNING("We require at least 10 chemicals to electrocute [C]!"))
			return FALSE
		if((last_shock + cooldown > world.time))
			to_chat(user,SPAN_DANGER("Our bioelectric hand is still recharging a voltage powerful enough to shock someone!"))
			return FALSE
		C.electrocute_act(electrocute_amount * siemens,src,1.0,BP_CHEST)
		C.stun_effect_act(0, agony_amount * siemens, BP_CHEST, src)

		admin_attack_log(user,C,"Shocked with [src]")

		if(siemens)
			to_chat(user, SPAN_NOTICE("Our hand channels raw electricity into [C]"))
			src.visible_message(SPAN_DANGER("Arcs of electricity strike [C]!"))
			last_shock = world.time
			//visible_message("<span class='warning'>Arcs of electricity strike [C]!</span>",
			//"<span class='warning'>Our hand channels raw electricity into [C]</span>",
			//"<span class='italics'>You hear sparks!</span>")
		else
			to_chat(src, SPAN_WARNING("Our gloves block us from shocking \the [C]."))
		//qdel(src)  //Since we're no longer a one hit stun, we need to stick around.
		user.mind.changeling.chem_charges -= shock_cost
		return TRUE

	else if(istype(target,/mob/living/silicon))
		var/mob/living/silicon/S = target

		if(user.mind.changeling.chem_charges < 10)
			to_chat(src, "<span class='warning'>We require at least 10 chemicals to electrocute [S]!</span>")
			return FALSE

		S.electrocute_act(60,src,0.75) //If only they had surge protectors.
		if(siemens)
			visible_message("<span class='warning'>Arcs of electricity strike [S]!</span>",
			"<span class='warning'>Our hand channels raw electricity into [S]</span>",
			"<span class='italics'>You hear sparks!</span>")
			to_chat(S, "<span class='danger'>Warning: Electrical surge detected!</span>")
		//qdel(src)
		user.mind.changeling.chem_charges -= 10
		return TRUE

	else
		if(istype(target,/obj))
			var/success = 0
			var/obj/T = target
			//We can also recharge things we touch, such as APCs or hardsuits.
			for(var/obj/item/cell/cell in T.contents)
				src.visible_message(SPAN_WARNING("[src]\'s hand crackles, sparks darting from it to \the [cell]"))
				/*visible_message("<span class='warning'>Some sparks fall out from \the [target]!</span>",
				"<span class='warning'>Our hand channels raw electricity into \the [target].</span>",
				"<span class='italics'>You hear sparks!</span>")*/
				var/i = 10
				if(siemens)
					while(i)
						cell.charge += 100 * siemens //This should be a nice compromise between recharging guns and other batteries.
						if(cell.charge > cell.maxcharge)
							cell.charge = cell.maxcharge
							break //No point making sparks if the cell's full.
	//					if(!Adjacent(T))
	//						break
						if(siemens)
							var/Turf = get_turf(src)
							new /obj/sparks(Turf)
							T.update_icon()
						i--
						sleep(1 SECOND)
					success = 1
					break
			if(success == 0)
				to_chat(src, "<span class='warning'>We are unable to affect \the [target].</span>")
			else
				qdel(src)
			return TRUE
