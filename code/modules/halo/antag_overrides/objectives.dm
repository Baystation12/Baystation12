

datum/objective/assassinate
	find_target()
		..()
		if(target && target.current)
			explanation_text = "Assassinate [target.current.real_name], the [target.assigned_role]."
		else
			explanation_text = "Free Objective"
		return target


	find_target_by_role(role, role_type=0)
		..(role, role_type)
		if(target && target.current)
			explanation_text = "Assassinate [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role]."
		else
			explanation_text = "Free Objective"
		return target


	check_completion()
		if(target && target.current)
			if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current) || target.current.z > 6 || !target.current.ckey) //Borgs/brains/AIs count as dead for traitor objectives. --NeoFite
				return 1
			return 0
		return 1

datum/objective/debrain//I want braaaainssss
	find_target()
		..()
		if(target && target.current)
			explanation_text = "Steal the brain of [target.current.real_name]."
		else
			explanation_text = "Free Objective"
		return target


	find_target_by_role(role, role_type=0)
		..(role, role_type)
		if(target && target.current)
			explanation_text = "Steal the brain of [target.current.real_name] the [!role_type ? target.assigned_role : target.special_role]."
		else
			explanation_text = "Free Objective"
		return target

	check_completion()
		if(!target)//If it's a free objective.
			return 1
		if( !owner.current || owner.current.stat==DEAD )//If you're otherwise dead.
			return 0
		if( !target.current || !isbrain(target.current) )
			return 0
		var/atom/A = target.current
		while(A.loc)			//check to see if the brainmob is on our person
			A = A.loc
			if(A == owner.current)
				return 1
		return 0

datum/objective/protect//The opposite of killing a dude.
	find_target()
		..()
		if(target && target.current)
			explanation_text = "Protect [target.current.real_name], the [target.assigned_role]."
		else
			explanation_text = "Free Objective"
		return target


	find_target_by_role(role, role_type=0)
		..(role, role_type)
		if(target && target.current)
			explanation_text = "Protect [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role]."
		else
			explanation_text = "Free Objective"
		return target

	check_completion()
		if(!target)			//If it's a free objective.
			return 1
		if(target.current)
			if(target.current.stat == DEAD || issilicon(target.current) || isbrain(target.current))
				return 0
			return 1
		return 0

datum/objective/survive
	explanation_text = "Stay alive; Don't die."

	check_completion()
		if(!owner.current || owner.current.stat == DEAD || isbrain(owner.current))
			return 0		//Brains no longer win survive objectives. --NEO
		if(issilicon(owner.current) && owner.current != owner.original)
			return 0
		return 1


// Harm a crew member, making an example of them
datum/objective/harm
	var/already_completed = 0

	find_target()
		..()
		if(target && target.current)
			explanation_text = "Make an example of [target.current.real_name], the [target.assigned_role]. Break one of their bones, detach one of their limbs or disfigure their face. Make sure they're alive when you do it."
		else
			explanation_text = "Free Objective"
		return target


	find_target_by_role(role, role_type=0)
		..(role, role_type)
		if(target && target.current)
			explanation_text = "Make an example of [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role]. Break one of their bones, detach one of their limbs or disfigure their face. Make sure they're alive when you do it."
		else
			explanation_text = "Free Objective"
		return target

	check_completion()
		if(already_completed)
			return 1

		if(target && target.current && istype(target.current, /mob/living/carbon/human))
			if(target.current.stat == DEAD)
				return 0

			var/mob/living/carbon/human/H = target.current
			for(var/obj/item/organ/external/E in H.organs)
				if(E.status & ORGAN_BROKEN)
					return 1
			for(var/limb_tag in H.species.has_limbs) //todo check prefs for robotic limbs and amputations.
				var/list/organ_data = H.species.has_limbs[limb_tag]
				var/limb_type = organ_data["path"]
				var/found
				for(var/obj/item/organ/external/E in H.organs)
					if(limb_type == E.type)
						found = 1
						break
				if(!found)
					return 1

			var/obj/item/organ/external/head/head = H.get_organ(BP_HEAD)
			if(!head || head.disfigured)
				return 1
		return 0

datum/objective/steal
	var/obj/item/steal_target
	var/target_name

	var/global/possible_items[] = list(
		"the captain's antique laser gun" = /obj/item/weapon/gun/energy/captain,
		"a bluespace rift generator" = /obj/item/integrated_circuit/manipulation/bluespace_rift,
		"an RCD" = /obj/item/weapon/rcd,
		"a jetpack" = /obj/item/weapon/tank/jetpack,
		"a captain's jumpsuit" = /obj/item/clothing/under/rank/captain,
		"a functional AI" = /obj/item/weapon/aicard,
		"a pair of magboots" = /obj/item/clothing/shoes/magboots,
		"the [station_name()] blueprints" = /obj/item/blueprints,
		"a nasa voidsuit" = /obj/item/clothing/suit/space/void,
		"28 moles of phoron (full tank)" = /obj/item/weapon/tank,
		"a sample of slime extract" = /obj/item/slime_extract,
		"a piece of corgi meat" = /obj/item/weapon/reagent_containers/food/snacks/meat/corgi,
		"a research director's jumpsuit" = /obj/item/clothing/under/rank/research_director,
		"a chief engineer's jumpsuit" = /obj/item/clothing/under/rank/chief_engineer,
		"a chief medical officer's jumpsuit" = /obj/item/clothing/under/rank/chief_medical_officer,
		"a head of security's jumpsuit" = /obj/item/clothing/under/rank/head_of_security,
		"a head of personnel's jumpsuit" = /obj/item/clothing/under/rank/head_of_personnel,
		"the hypospray" = /obj/item/weapon/reagent_containers/hypospray,
		"the captain's pinpointer" = /obj/item/weapon/pinpointer,
		"an ablative armor vest" = /obj/item/clothing/suit/armor/laserproof,
	)

	var/global/possible_items_special[] = list(
		/*"nuclear authentication disk" = /obj/item/weapon/disk/nuclear,*///Broken with the change to nuke disk making it respawn on z level change.
		"nuclear gun" = /obj/item/weapon/gun/energy/gun/nuclear,
		"diamond drill" = /obj/item/weapon/pickaxe/diamonddrill,
		"bag of holding" = /obj/item/weapon/storage/backpack/holding,
		"hyper-capacity cell" = /obj/item/weapon/cell/hyper,
		"10 diamonds" = /obj/item/stack/material/diamond,
		"50 gold bars" = /obj/item/stack/material/gold,
		"25 refined uranium bars" = /obj/item/stack/material/uranium,
	)


	proc/set_target(item_name)
		target_name = item_name
		steal_target = possible_items[target_name]
		if (!steal_target )
			steal_target = possible_items_special[target_name]
		explanation_text = "Steal [target_name]."
		return steal_target


	find_target()
		return set_target(pick(possible_items))


	proc/select_target()
		var/list/possible_items_all = possible_items+possible_items_special+"custom"
		var/new_target = input("Select target:", "Objective target", steal_target) as null|anything in possible_items_all
		if (!new_target) return
		if (new_target == "custom")
			var/obj/item/custom_target = input("Select type:","Type") as null|anything in typesof(/obj/item)
			if (!custom_target) return
			var/tmp_obj = new custom_target
			var/custom_name = tmp_obj:name
			qdel(tmp_obj)
			custom_name = sanitize(input("Enter target name:", "Objective target", custom_name) as text|null)
			if (!custom_name) return
			target_name = custom_name
			steal_target = custom_target
			explanation_text = "Steal [target_name]."
		else
			set_target(new_target)
		return steal_target

	check_completion()
		if(!steal_target || !owner.current)	return 0
		if(!isliving(owner.current))	return 0
		var/list/all_items = owner.current.get_contents()
		switch (target_name)
			if("28 moles of phoron (full tank)","10 diamonds","50 gold bars","25 refined uranium bars")
				var/target_amount = text2num(target_name)//Non-numbers are ignored.
				var/found_amount = 0.0//Always starts as zero.

				for(var/obj/item/I in all_items) //Check for phoron tanks
					if(istype(I, steal_target))
						found_amount += (target_name=="28 moles of phoron (full tank)" ? (I:air_contents:gas["phoron"]) : (I:amount))
				return found_amount>=target_amount

			if("a functional AI")
				for(var/mob/living/silicon/ai/ai in GLOB.mob_list)
					if(ai.stat == DEAD)
						continue
					var/turf/T = get_turf(ai)
					if(owner.current.contains(ai) || (T && is_type_in_list(T.loc, GLOB.using_map.post_round_safe_areas)))
						return 1
			else

				for(var/obj/I in all_items) //Check for items
					if(istype(I, steal_target))
						return 1
		return 0


// REV


/datum/objective/rev/find_target()
	..()
	if(target && target.current)
		explanation_text = "Assassinate, capture or convert [target.current.real_name], the [target.assigned_role]."
	else
		explanation_text = "Free Objective"
	return target


/datum/objective/rev/find_target_by_role(role, role_type=0)
	..(role, role_type)
	if(target && target.current)
		explanation_text = "Assassinate, capture or convert [target.current.real_name], the [!role_type ? target.assigned_role : target.special_role]."
	else
		explanation_text = "Free Objective"
	return target

/datum/objective/rev/check_completion()
	var/rval = 1
	if(target && target.current)
		var/mob/living/carbon/human/H = target.current
		if(!istype(H))
			return 1
		if(H.stat == DEAD || H.restrained())
			return 1
		// Check if they're converted
		if(target in revs.current_antagonists)
			return 1
		return 0
	return rval



// CHANGELING


/datum/objective/absorb
	proc/gen_amount_goal(var/lowbound = 4, var/highbound = 6)
		target_amount = rand (lowbound,highbound)
		if (ticker)
			var/n_p = 1 //autowin
			if (ticker.current_state == GAME_STATE_SETTING_UP)
				for(var/mob/new_player/P in GLOB.player_list)
					if(P.client && P.ready && P.mind!=owner)
						n_p ++
			else if (ticker.current_state == GAME_STATE_PLAYING)
				for(var/mob/living/carbon/human/P in GLOB.player_list)
					if(P.client && !(P.mind.changeling) && P.mind!=owner)
						n_p ++
			target_amount = min(target_amount, n_p)

		explanation_text = "Absorb [target_amount] compatible genomes."
		return target_amount

	check_completion()
		if(owner && owner.changeling && owner.changeling.absorbed_dna && (owner.changeling.absorbedcount >= target_amount))
			return 1
		else
			return 0
