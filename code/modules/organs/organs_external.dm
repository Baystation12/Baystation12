/****************************************************
				EXTERNAL ORGANS
****************************************************/
/obj/item/organ/external

	name = "external"
	health = 300                      // Significantly longer delay on organ death for limbs.

	var/op_stage = 0                  // Tracks state of internal organ removal.
	var/icon_name = null
	var/icon_position = 0

	var/icon/mob_icon

	var/damage_state = "00"
	var/brute_dam = 0
	var/burn_dam = 0
	var/max_damage = 0
	var/max_size = 0
	var/last_dam = -1
	var/display_name
	var/number_wounds = 0 // cache the number of wounds, which is NOT wounds.len!
	var/disfigured = 0
	var/gendered_icon = 0

	var/list/wounds = list()
	var/list/tissue_layers = list()

	var/tmp/perma_injury = 0
	var/tmp/destspawn = 0 //Has it spawned the broken limb?
	var/tmp/amputated = 0 //Whether this has been cleanly amputated, thus causing no pain

	var/obj/item/organ/external/parent
	var/list/children
	var/list/internal_organs

	var/stage = 0
	var/cavity = 0
	var/sabotaged = 0 // If a prosthetic limb is emagged, it will detonate when it fails.

	var/obj/item/hidden = null
	var/list/implants = list()

	// how often wounds should be updated, a higher number means less often
	var/wound_update_accuracy = 1

/obj/item/organ/external/New(var/mob/living/carbon/human/H, var/spawn_robotic, var/list/tissue_types)
	..()

	tissue_layers = list()
	for(var/tissue_layer in tissue_types)
		tissue_layers += new /datum/tissue_layer(src,tissue_layer)

	spawn(1)
		if(!istype(owner))
			return
		var/obj/item/organ/external/P = owner.organs_by_name[parent_organ]
		if(P)
			parent = P
			src.loc = parent
			if(!parent.children)
				parent.children = list()
			parent.children.Add(src)

// Check if organs are accessible.
/obj/item/organ/external/proc/is_open(var/organs_accessible)
	for(var/datum/tissue_layer/tissue_layer in tissue_layers)
		if(tissue_layer.is_open())
			if(!organs_accessible)
				return 1
			if(tissue_layer.tissue.flags & TISSUE_ORGAN_LAYER)
				return 1
		else
			return 0
	return 1

// Get the most immediately accessible layer.
/obj/item/organ/external/proc/get_surface_layer()
	for(var/datum/tissue_layer/tissue_layer in tissue_layers)
		if(tissue_layer.is_open())
			continue
		return tissue_layer
	return

// Checks if the tissue has an exposed tissue that can be infected.
/obj/item/organ/external/proc/can_be_infected()
	for(var/datum/tissue_layer/tissue_layer in tissue_layers)
		if(tissue_layer.is_split() && (tissue_layer.tissue.flags & TISSUE_INFECTS))
			return 1
	return 0


/****************************************************
			   DAMAGE PROCS
****************************************************/

/obj/item/organ/external/emp_act(severity)
	if(!(status & ORGAN_ROBOT))	//meatbags do not care about EMP
		return
	var/probability = 30
	var/damage = 15
	if(severity == 2)
		probability = 1
		damage = 3
	if(prob(probability))
		droplimb(1)
	else
		take_damage(damage, 0, 1, 1, used_weapon = "EMP")

/obj/item/organ/external/take_damage(brute, burn, sharp, edge, used_weapon = null, list/forbidden_limbs = list())

	if((brute <= 0) && (burn <= 0))
		return 0

	if(status & ORGAN_DESTROYED)
		return 0

	if(status & ORGAN_ROBOT )

		var/brmod = 0.66
		var/bumod = 0.66

		if(istype(owner,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = owner
			if(H.species && H.species.flags & IS_SYNTHETIC)
				brmod = H.species.brute_mod
				bumod = H.species.burn_mod

		brute *= brmod //~2/3 damage for ROBOLIMBS
		burn *= bumod //~2/3 damage for ROBOLIMBS

	// High brute damage or sharp objects may damage internal organs
	if(internal_organs && ( (sharp && brute >= 5) || brute >= 10) && prob(5))
		// Damage an internal organ
		var/obj/item/organ/internal/I = pick(internal_organs)
		I.take_damage(brute / 2)
		brute -= brute / 2

	if(status & ORGAN_BROKEN && prob(40) && brute)
		if (!(owner.species && (owner.species.flags & NO_PAIN)))
			owner.emote("scream")	//getting hit on broken hand hurts
	if(used_weapon)
		add_autopsy_data("[used_weapon]", brute + burn)

	var/can_cut = (prob(brute*2) || sharp) && !(status & ORGAN_ROBOT)
	// If the limbs can break, make sure we don't exceed the maximum damage a limb can take before breaking
	if((brute_dam + burn_dam + brute + burn) < max_damage || !config.limbs_can_break)
		if(brute)
			if(can_cut)
				createwound( CUT, brute )
			else
				createwound( BRUISE, brute )
		if(burn)
			createwound( BURN, burn )
	else
		//If we can't inflict the full amount of damage, spread the damage in other ways
		//How much damage can we actually cause?
		var/can_inflict = max_damage * config.organ_health_multiplier - (brute_dam + burn_dam)
		if(can_inflict)
			if (brute > 0)
				//Inflict all burte damage we can
				if(can_cut)
					createwound( CUT, min(brute,can_inflict) )
				else
					createwound( BRUISE, min(brute,can_inflict) )
				var/temp = can_inflict
				//How much mroe damage can we inflict
				can_inflict = max(0, can_inflict - brute)
				//How much brute damage is left to inflict
				brute = max(0, brute - temp)

			if (burn > 0 && can_inflict)
				//Inflict all burn damage we can
				createwound(BURN, min(burn,can_inflict))
				//How much burn damage is left to inflict
				burn = max(0, burn - can_inflict)
		//If there are still hurties to dispense
		if (burn || brute)
			if (status & ORGAN_ROBOT)
				droplimb(1) //Robot limbs just kinda fail at full damage.
			else
				//List organs we can pass it to
				var/list/obj/item/organ/external/possible_points = list()
				if(parent)
					possible_points += parent
				if(children)
					possible_points += children
				if(forbidden_limbs.len)
					possible_points -= forbidden_limbs
				if(possible_points.len)
					//And pass the pain around
					var/obj/item/organ/external/target = pick(possible_points)
					target.take_damage(brute, burn, sharp, edge, used_weapon, forbidden_limbs + src)

	// sync the organ's damage with its wounds
	src.update_damages()

	//If limb took enough damage, try to cut or tear it off
	if(body_part != UPPER_TORSO && body_part != LOWER_TORSO) //as hilarious as it is, getting hit on the chest too much shouldn't effectively gib you.
		if(config.limbs_can_break && brute_dam >= max_damage * config.organ_health_multiplier)
			if( (edge && prob(5 * brute)) || (brute > 20 && prob(2 * brute)) )
				droplimb(1)
				return

	owner.updatehealth()

	if (!disfigured)
		if (brute_dam > 40)
			if (prob(50))
				disfigure("brute")
		if (burn_dam > 40)
			disfigure("burn")

	var/result = update_icon()
	return result

/obj/item/organ/external/proc/heal_damage(brute, burn, internal = 0, robo_repair = 0)
	if(status & ORGAN_ROBOT && !robo_repair)
		return

	//Heal damage on the individual wounds
	for(var/datum/wound/W in wounds)
		if(brute == 0 && burn == 0)
			break

		// heal brute damage
		if(W.damage_type == CUT || W.damage_type == BRUISE)
			brute = W.heal_damage(brute)
		else if(W.damage_type == BURN)
			burn = W.heal_damage(burn)

	if(internal)
		status &= ~ORGAN_BROKEN
		perma_injury = 0

	//Sync the organ's damage with its wounds
	src.update_damages()
	owner.updatehealth()

	var/result = update_icon()
	return result

/*
This function completely restores a damaged organ to perfect condition.
*/
/obj/item/organ/external/proc/rejuvenate()
	damage_state = "00"
	if(status & ORGAN_ROBOT)
		status = ORGAN_ROBOT
	else
		status = 0
	perma_injury = 0
	brute_dam = 0
	burn_dam = 0
	germ_level = 0
	wounds.Cut()
	number_wounds = 0

	// handle internal organs
	for(var/obj/item/organ/internal/current_organ in internal_organs)
		current_organ.rejuvenate()

	// remove embedded objects and drop them on the floor
	for(var/obj/implanted_object in implants)
		if(!istype(implanted_object,/obj/item/weapon/implant))	// We don't want to remove REAL implants. Just shrapnel etc.
			implanted_object.loc = owner.loc
			implants -= implanted_object

	owner.updatehealth()


/obj/item/organ/external/proc/createwound(var/type = CUT, var/damage)
	if(damage == 0) return

	//moved this before the open_wound check so that having many small wounds for example doesn't somehow protect you from taking internal damage (because of the return)
	//Possibly trigger an internal wound, too.
	var/local_damage = brute_dam + burn_dam + damage
	if(damage > 15 && type != BURN && local_damage > 30 && prob(damage) && !(status & ORGAN_ROBOT))
		var/datum/wound/internal_bleeding/I = new (min(damage - 15, 15))
		wounds += I
		owner.custom_pain("You feel something rip in your [display_name]!", 1)

	// first check whether we can widen an existing wound
	if(wounds.len > 0 && prob(max(50+(number_wounds-1)*10,90)))
		if((type == CUT || type == BRUISE) && damage >= 5)
			//we need to make sure that the wound we are going to worsen is compatible with the type of damage...
			var/list/compatible_wounds = list()
			for (var/datum/wound/W in wounds)
				if (W.can_worsen(type, damage))
					compatible_wounds += W

			if(compatible_wounds.len)
				var/datum/wound/W = pick(compatible_wounds)
				W.open_wound(damage)
				if(prob(25))
					//maybe have a separate message for BRUISE type damage?
					owner.visible_message("\red The wound on [owner.name]'s [display_name] widens with a nasty ripping noise.",\
					"\red The wound on your [display_name] widens with a nasty ripping noise.",\
					"You hear a nasty ripping noise, as if flesh is being torn apart.")
				return

	//Creating wound
	var/wound_type = get_wound_type(type, damage)

	if(wound_type)
		var/datum/wound/W = new wound_type(damage)

		//Check whether we can add the wound to an existing wound
		for(var/datum/wound/other in wounds)
			if(other.can_merge(W))
				other.merge_wound(W)
				W = null // to signify that the wound was added
				break
		if(W)
			wounds += W

/****************************************************
			   PROCESSING & UPDATING
****************************************************/

//Determines if we even need to process this organ.

/obj/item/organ/external/proc/need_process()
	if(destspawn)	//Missing limb is missing
		return 0
	if(status && status != ORGAN_ROBOT) // If it's robotic, that's fine it will have a status.
		return 1
	if(brute_dam || burn_dam)
		return 1
	if(last_dam != brute_dam + burn_dam) // Process when we are fully healed up.
		last_dam = brute_dam + burn_dam
		return 1
	else
		last_dam = brute_dam + burn_dam
	if(germ_level)
		return 1
	return 0

/obj/item/organ/external/process_internal()

	..()
	//Dismemberment
	if(status & ORGAN_DESTROYED)
		if(!destspawn && config.limbs_can_break)
			droplimb()
		return
	if(parent)
		if(parent.status & ORGAN_DESTROYED)
			status |= ORGAN_DESTROYED
			owner.update_body(1)
			return

	// Process wounds, doing healing etc. Only do this every few ticks to save processing power
	if(owner.life_tick % wound_update_accuracy == 0)
		update_wounds()

	//Chem traces slowly vanish
	if(owner.life_tick % 10 == 0)
		for(var/chemID in trace_chemicals)
			trace_chemicals[chemID] = trace_chemicals[chemID] - 1
			if(trace_chemicals[chemID] <= 0)
				trace_chemicals.Remove(chemID)

	//Bone fracurtes
	if(config.bones_can_break && brute_dam > min_broken_damage * config.organ_health_multiplier && !(status & ORGAN_ROBOT))
		src.fracture()
	if(!(status & ORGAN_BROKEN))
		perma_injury = 0

	//Infections
	update_germs()

//Updating germ levels. Handles organ germ levels and necrosis.
/*
The INFECTION_LEVEL values defined in setup.dm control the time it takes to reach the different
infection levels. Since infection growth is exponential, you can adjust the time it takes to get
from one germ_level to another using the rough formula:

desired_germ_level = initial_germ_level*e^(desired_time_in_seconds/1000)

So if I wanted it to take an average of 15 minutes to get from level one (100) to level two
I would set INFECTION_LEVEL_TWO to 100*e^(15*60/1000) = 245. Note that this is the average time,
the actual time is dependent on RNG.

INFECTION_LEVEL_ONE		below this germ level nothing happens, and the infection doesn't grow
INFECTION_LEVEL_TWO		above this germ level the infection will start to spread to internal and adjacent organs
INFECTION_LEVEL_THREE	above this germ level the player will take additional toxin damage per second, and will die in minutes without
						antitox. also, above this germ level you will need to overdose on spaceacillin to reduce the germ_level.

Note that amputating the affected organ does in fact remove the infection from the player's body.
*/
/obj/item/organ/external/proc/update_germs()
	//Robotic limbs shouldn't be infected, nor should nonexistant limbs.
	if(status & (ORGAN_ROBOT|ORGAN_DESTROYED))
		germ_level = 0
		return
	if(owner.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Syncing germ levels with external wounds
		handle_germ_sync()
		//** Handle antibiotics and curing infections
		handle_antibiotics()
		//** Handle the effects of infections
		handle_germ_effects()

/obj/item/organ/external/proc/handle_germ_sync()
	var/antibiotics = owner.reagents.get_reagent_amount("spaceacillin")
	for(var/datum/wound/W in wounds)
		//Open wounds can become infected
		if (owner.germ_level > W.germ_level && W.infection_check())
			W.germ_level++

	if (antibiotics < 5)
		for(var/datum/wound/W in wounds)
			//Infected wounds raise the organ's germ level
			if (W.germ_level > germ_level)
				germ_level++
				break	//limit increase to a maximum of one per second

/obj/item/organ/external/proc/handle_germ_effects()
	var/antibiotics = owner.reagents.get_reagent_amount("spaceacillin")

	if (germ_level > 0 && germ_level < INFECTION_LEVEL_ONE && prob(60))	//this could be an else clause, but it looks cleaner this way
		germ_level--	//since germ_level increases at a rate of 1 per second with dirty wounds, prob(60) should give us about 5 minutes before level one.

	if(germ_level >= INFECTION_LEVEL_ONE)
		//having an infection raises your body temperature
		var/fever_temperature = (owner.species.heat_level_1 - owner.species.body_temperature - 5)* min(germ_level/INFECTION_LEVEL_TWO, 1) + owner.species.body_temperature
		//need to make sure we raise temperature fast enough to get around environmental cooling preventing us from reaching fever_temperature
		owner.bodytemperature += between(0, (fever_temperature - T20C)/BODYTEMP_COLD_DIVISOR + 1, fever_temperature - owner.bodytemperature)

		if(prob(round(germ_level/10)))
			if (antibiotics < 5)
				germ_level++

			if (prob(10))	//adjust this to tweak how fast people take toxin damage from infections
				owner.adjustToxLoss(1)

	if(germ_level >= INFECTION_LEVEL_TWO && antibiotics < 5)
		//spread the infection to internal organs
		var/obj/item/organ/internal/target_organ = null	//make internal organs become infected one at a time instead of all at once
		for (var/obj/item/organ/internal/I in internal_organs)
			if (I.germ_level > 0 && I.germ_level < min(germ_level, INFECTION_LEVEL_TWO))	//once the organ reaches whatever we can give it, or level two, switch to a different one
				if (!target_organ || I.germ_level > target_organ.germ_level)	//choose the organ with the highest germ_level
					target_organ = I

		if (!target_organ)
			//figure out which organs we can spread germs to and pick one at random
			var/list/candidate_organs = list()
			for (var/obj/item/organ/internal/I in internal_organs)
				if (I.germ_level < germ_level)
					candidate_organs += I
			if (candidate_organs.len)
				target_organ = pick(candidate_organs)

		if (target_organ)
			target_organ.germ_level++

		//spread the infection to child and parent organs
		if (children)
			for (var/obj/item/organ/external/child in children)
				if (child.germ_level < germ_level && !(child.status & ORGAN_ROBOT))
					if (child.germ_level < INFECTION_LEVEL_ONE*2 || prob(30))
						child.germ_level++

		if (parent)
			if (parent.germ_level < germ_level && !(parent.status & ORGAN_ROBOT))
				if (parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(30))
					parent.germ_level++

	if(germ_level >= INFECTION_LEVEL_THREE && antibiotics < 30)	//overdosing is necessary to stop severe infections
		if (!(status & ORGAN_DEAD))
			status |= ORGAN_DEAD
			owner << "<span class='notice'>You can't feel your [display_name] anymore...</span>"
			owner.update_body(1)

		germ_level++
		owner.adjustToxLoss(1)

//Updating wounds. Handles wound natural healing, internal bleedings and infections
/obj/item/organ/external/proc/update_wounds()

	if((status & ORGAN_ROBOT)) //Robotic limbs don't heal or get worse.
		return

	for(var/datum/wound/W in wounds)
		// wounds can disappear after 10 minutes at the earliest
		if(W.damage <= 0 && W.created + 10 * 10 * 60 <= world.time)
			wounds -= W
			continue
			// let the GC handle the deletion of the wound

		// Internal wounds get worse over time. Low temperatures (cryo) stop them.
		if(W.internal && owner.bodytemperature >= 170)
			var/bicardose = owner.reagents.get_reagent_amount("bicaridine")
			var/inaprovaline = owner.reagents.get_reagent_amount("inaprovaline")
			if(!(W.can_autoheal() || (bicardose && inaprovaline)))	//bicaridine and inaprovaline stop internal wounds from growing bigger with time, unless it is so small that it is already healing
				W.open_wound(0.1 * wound_update_accuracy)
			if(bicardose >= 30)	//overdose of bicaridine begins healing IB
				W.damage = max(0, W.damage - 0.2)

			owner.vessel.remove_reagent("blood", wound_update_accuracy * W.damage/40) //line should possibly be moved to handle_blood, so all the bleeding stuff is in one place.
			if(prob(1 * wound_update_accuracy))
				owner.custom_pain("You feel a stabbing pain in your [display_name]!",1)

		// slow healing
		var/heal_amt = 0

		// if damage >= 50 AFTER treatment then it's probably too severe to heal within the timeframe of a round.
		if (W.can_autoheal() && W.wound_damage() < 50)
			heal_amt += 0.5

		//we only update wounds once in [wound_update_accuracy] ticks so have to emulate realtime
		heal_amt = heal_amt * wound_update_accuracy
		//configurable regen speed woo, no-regen hardcore or instaheal hugbox, choose your destiny
		heal_amt = heal_amt * config.organ_regeneration_multiplier
		// amount of healing is spread over all the wounds
		heal_amt = heal_amt / (wounds.len + 1)
		// making it look prettier on scanners
		heal_amt = round(heal_amt,0.1)
		W.heal_damage(heal_amt)

		// Salving also helps against infection
		if(W.germ_level > 0 && W.salved && prob(2))
			W.disinfected = 1
			W.germ_level = 0

	// sync the organ's damage with its wounds
	src.update_damages()
	if (update_icon())
		owner.UpdateDamageIcon(1)

/obj/item/organ/external/proc/is_bleeding()
	return 0

//Updates brute_damn and burn_damn from wound damages. Updates BLEEDING status.
/obj/item/organ/external/proc/update_damages()
	number_wounds = 0
	brute_dam = 0
	burn_dam = 0
	status &= ~ORGAN_BLEEDING
	var/clamped = 0

	var/mob/living/carbon/human/H
	if(istype(owner,/mob/living/carbon/human))
		H = owner

	for(var/datum/wound/W in wounds)
		if(W.damage_type == CUT || W.damage_type == BRUISE)
			brute_dam += W.damage
		else if(W.damage_type == BURN)
			burn_dam += W.damage

		if(!(status & ORGAN_ROBOT) && W.bleeding() && (H && !(H.species.flags & NO_BLOOD)))
			W.bleed_timer--
			status |= ORGAN_BLEEDING

		clamped |= W.clamped

		number_wounds += W.amount

	if (is_open() && is_bleeding() && (H && !(H.species.flags & NO_BLOOD)))	//things tend to bleed if they are CUT OPEN
		status |= ORGAN_BLEEDING

// new damage icon system
// adjusted to set damage_state to brute/burn code only (without r_name0 as before)
/obj/item/organ/external/update_icon()
	var/n_is = damage_state_text()
	if (n_is != damage_state)
		damage_state = n_is
		return 1
	return 0

// new damage icon system
// returns just the brute/burn damage code
/obj/item/organ/external/proc/damage_state_text()
	if(status & ORGAN_DESTROYED)
		return "--"

	var/tburn = 0
	var/tbrute = 0

	if(burn_dam ==0)
		tburn =0
	else if (burn_dam < (max_damage * 0.25 / 2))
		tburn = 1
	else if (burn_dam < (max_damage * 0.75 / 2))
		tburn = 2
	else
		tburn = 3

	if (brute_dam == 0)
		tbrute = 0
	else if (brute_dam < (max_damage * 0.25 / 2))
		tbrute = 1
	else if (brute_dam < (max_damage * 0.75 / 2))
		tbrute = 2
	else
		tbrute = 3
	return "[tbrute][tburn]"

/****************************************************
			   DISMEMBERMENT
****************************************************/

//Recursive setting of all child organs to amputated
/obj/item/organ/external/proc/setAmputatedTree()
	for(var/obj/item/organ/external/O in children)
		O.amputated=amputated
		O.setAmputatedTree()

//Handles dismemberment
/obj/item/organ/external/proc/droplimb(var/override = 0,var/no_explode = 0)
	if(destspawn) return
	if(override)
		status |= ORGAN_DESTROYED
	if(status & ORGAN_DESTROYED)
		if(body_part == UPPER_TORSO)
			return

		src.status &= ~ORGAN_BROKEN
		src.status &= ~ORGAN_BLEEDING
		src.status &= ~ORGAN_SPLINTED
		src.status &= ~ORGAN_DEAD
		for(var/implant in implants)
			del(implant)

		germ_level = 0

		//Replace all wounds on that arm with one wound on parent organ.
		wounds.Cut()
		if (parent)
			var/datum/wound/W
			if(max_damage < 50)
				W = new/datum/wound/lost_limb/small(max_damage)
			else
				W = new/datum/wound/lost_limb(max_damage)
			parent.wounds += W
			parent.update_damages()
		update_damages()

		// If any organs are attached to this, destroy them
		for(var/obj/item/organ/external/O in children)
			O.droplimb(1)

		var/is_robotic = (status & ORGAN_ROBOT) ? 1 : 0
		var/obj/item/organ/organ	//Dropped limb object
		switch(body_part)
			if(HEAD)
				organ= new /obj/item/organ/external/head(owner.loc, owner)
				owner.u_equip(owner.glasses)
				owner.u_equip(owner.head)
				owner.u_equip(owner.l_ear)
				owner.u_equip(owner.r_ear)
				owner.u_equip(owner.wear_mask)
			if(ARM_RIGHT)
				organ= new /obj/item/organ/external/r_arm(owner.loc, owner, is_robotic)
			if(ARM_LEFT)
				organ = new /obj/item/organ/external/l_arm(owner.loc, owner, is_robotic)
			if(LEG_RIGHT)
				organ= new /obj/item/organ/external/r_leg(owner.loc, owner, is_robotic)
			if(LEG_LEFT)
				organ= new /obj/item/organ/external/l_leg(owner.loc, owner, is_robotic)
			if(HAND_RIGHT)
				organ= new /obj/item/organ/external/r_hand(owner.loc, owner, is_robotic)
				owner.u_equip(owner.gloves)
			if(HAND_LEFT)
				organ= new /obj/item/organ/external/l_hand(owner.loc, owner, is_robotic)
				owner.u_equip(owner.gloves)
			if(FOOT_RIGHT)
				organ= new /obj/item/organ/external/r_foot/(owner.loc, owner, is_robotic)
				owner.u_equip(owner.shoes)
			if(FOOT_LEFT)
				organ = new /obj/item/organ/external/l_foot(owner.loc, owner, is_robotic)
				owner.u_equip(owner.shoes)

		destspawn = 1
		//Robotic limbs explode if sabotaged.
		if(status & ORGAN_ROBOT && !no_explode && sabotaged)
			owner.visible_message("\red \The [owner]'s [display_name] explodes violently!",\
			"\red <b>Your [display_name] explodes!</b>",\
			"You hear an explosion!")
			explosion(get_turf(owner),-1,-1,2,3)
			var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
			spark_system.set_up(5, 0, owner)
			spark_system.attach(owner)
			spark_system.start()
			spawn(10)
				del(spark_system)

		owner.visible_message("\red [owner.name]'s [display_name] flies off in an arc.",\
		"<span class='moderate'><b>Your [display_name] goes flying off!</b></span>",\
		"You hear a terrible sound of ripping tendons and flesh.")

		//Throw organs around
		if(istype(owner.loc,/turf) && organ)
			step(organ,pick(cardinal))

		owner.update_body(1)

		// OK so maybe your limb just flew off, but if it was attached to a pair of cuffs then hooray! Freedom!
		release_restraints()

		if(vital)
			owner.death()

/****************************************************
			   HELPERS
****************************************************/

/obj/item/organ/external/proc/release_restraints()
	if (owner.handcuffed && body_part in list(ARM_LEFT, ARM_RIGHT, HAND_LEFT, HAND_RIGHT))
		owner.visible_message(\
			"\The [owner.handcuffed.name] falls off of [owner.name].",\
			"\The [owner.handcuffed.name] falls off you.")

		owner.drop_from_inventory(owner.handcuffed)

	if (owner.legcuffed && body_part in list(FOOT_LEFT, FOOT_RIGHT, LEG_LEFT, LEG_RIGHT))
		owner.visible_message(\
			"\The [owner.legcuffed.name] falls off of [owner.name].",\
			"\The [owner.legcuffed.name] falls off you.")

		owner.drop_from_inventory(owner.legcuffed)

/obj/item/organ/external/proc/bandage()
	var/rval = 0
	src.status &= ~ORGAN_BLEEDING
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		rval |= !W.bandaged
		W.bandaged = 1
	return rval

/obj/item/organ/external/proc/disinfect()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		rval |= !W.disinfected
		W.disinfected = 1
		W.germ_level = 0
	return rval

/obj/item/organ/external/proc/clamp()
	var/rval = 0
	src.status &= ~ORGAN_BLEEDING
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		rval |= !W.clamped
		W.clamped = 1
	return rval

/obj/item/organ/external/proc/salve()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		rval |= !W.salved
		W.salved = 1
	return rval

/obj/item/organ/external/proc/fracture()

	if(status & ORGAN_BROKEN)
		return

	owner.visible_message(\
		"\red You hear a loud cracking sound coming from \the [owner].",\
		"\red <b>Something feels like it shattered in your [display_name]!</b>",\
		"You hear a sickening crack.")

	if(owner.species && !(owner.species.flags & NO_PAIN))
		owner.emote("scream")

	status |= ORGAN_BROKEN
	perma_injury = brute_dam

	// Fractures have a chance of getting you out of restraints
	if (prob(25))
		release_restraints()

	// This is mostly for the ninja suit to stop ninja being so crippled by breaks.
	// TODO: consider moving this to a suit proc or process() or something during
	// hardsuit rewrite.
	if(!(status & ORGAN_SPLINTED) && istype(owner,/mob/living/carbon/human))

		var/mob/living/carbon/human/H = owner

		if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))

			var/obj/item/clothing/suit/space/suit = H.wear_suit

			if(isnull(suit.supporting_limbs))
				return

			owner << "You feel \the [suit] constrict about your [display_name], supporting it."
			status |= ORGAN_SPLINTED
			suit.supporting_limbs |= src
	return

/obj/item/organ/external/proc/robotize()

/datum/organ/external/proc/mend_fracture()
	if(status & ORGAN_ROBOT)
		return 0	//ORGAN_BROKEN doesn't have the same meaning for robot limbs
	if(brute_dam > min_broken_damage * config.organ_health_multiplier)
		return 0	//will just immediately fracture again
	
	status &= ~ORGAN_BROKEN
	return 1

/obj/item/organ/external/proc/robotize()

	src.status &= ~ORGAN_BROKEN
	src.status &= ~ORGAN_BLEEDING
	src.status &= ~ORGAN_SPLINTED
	src.status &= ~ORGAN_CUT_AWAY
	src.status &= ~ORGAN_ATTACHABLE
	src.status &= ~ORGAN_DESTROYED
	src.status |= ORGAN_ROBOT
	src.destspawn = 0
	for (var/obj/item/organ/external/T in children)
		if(T)
			T.robotize()

/obj/item/organ/external/proc/mutate()
	src.status |= ORGAN_MUTATED
	owner.update_body()

/obj/item/organ/external/proc/unmutate()
	src.status &= ~ORGAN_MUTATED
	owner.update_body()

/obj/item/organ/external/proc/get_damage()	//returns total damage
	return max(brute_dam + burn_dam - perma_injury, perma_injury)	//could use health?

/obj/item/organ/external/proc/has_infected_wound()
	for(var/datum/wound/W in wounds)
		if(W.germ_level > INFECTION_LEVEL_ONE)
			return 1
	return 0

/obj/item/organ/external/get_icon(var/icon/race_icon, var/icon/deform_icon,gender="")

	if(mob_icon)
		return mob_icon

	if(!owner)
		return ..()

	//TODO: cache these icons
	if (status & ORGAN_ROBOT && !(owner.species && owner.species.flags & IS_SYNTHETIC))
		mob_icon = new /icon('icons/mob/human_races/robotic.dmi', "[icon_name][gender ? "_[gender]" : ""]")
	if (status & ORGAN_MUTATED)
		mob_icon = new /icon(deform_icon, "[icon_name][gender ? "_[gender]" : ""]")
	if(!mob_icon)
		mob_icon = new /icon(race_icon, "[icon_name][gender ? "_[gender]" : ""]")
	if(owner.species)
		if(owner.species.flags & HAS_SKIN_TONE)
			if(owner.s_tone >= 0)
				mob_icon.Blend(rgb(owner.s_tone, owner.s_tone, owner.s_tone), ICON_ADD)
			else
				mob_icon.Blend(rgb(-owner.s_tone,  -owner.s_tone,  -owner.s_tone), ICON_SUBTRACT)
		if(owner.species.flags & HAS_SKIN_COLOR)
			mob_icon.Blend(rgb(owner.r_skin, owner.g_skin, owner.b_skin), ICON_ADD)
	return mob_icon

/obj/item/organ/external/proc/is_usable()
	return !(status & (ORGAN_DESTROYED|ORGAN_MUTATED|ORGAN_DEAD))

/obj/item/organ/external/proc/is_broken()
	return ((status & ORGAN_BROKEN) && !(status & ORGAN_SPLINTED))

/obj/item/organ/external/proc/is_malfunctioning()
	return ((status & ORGAN_ROBOT) && prob(brute_dam + burn_dam))

//for arms and hands
/obj/item/organ/external/proc/process_grasp(var/obj/item/c_hand, var/hand_name)
	if (!c_hand)
		return

	if(is_broken())
		owner.u_equip(c_hand)
		var/emote_scream = pick("screams in pain and ", "lets out a sharp cry and ", "cries out and ")
		owner.emote("me", 1, "[(owner.species && owner.species.flags & NO_PAIN) ? "" : emote_scream ]drops what they were holding in their [hand_name]!")
	if(is_malfunctioning())
		owner.u_equip(c_hand)
		owner.emote("me", 1, "drops what they were holding, their [hand_name] malfunctioning!")
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, owner)
		spark_system.attach(owner)
		spark_system.start()
		spawn(10)
			del(spark_system)

/obj/item/organ/external/proc/embed(var/obj/item/weapon/W, var/silent = 0)
	if(!silent)
		owner.visible_message("<span class='danger'>\The [W] sticks in the wound!</span>")
	implants += W
	owner.embedded_flag = 1
	owner.verbs += /mob/proc/yank_out_object
	W.add_blood(owner)
	if(ismob(W.loc))
		var/mob/living/H = W.loc
		H.drop_item()
	W.loc = owner

/****************************************************
			   ORGAN DEFINES
****************************************************/

/obj/item/organ/external/chest
	name = "chest"
	icon_name = "torso"
	display_name = "chest"
	max_damage = 75
	min_broken_damage = 40
	body_part = UPPER_TORSO
	vital = 1
	//encased = "ribcage"

/obj/item/organ/external/groin
	name = "groin"
	icon_name = "groin"
	display_name = "groin"
	max_damage = 50
	min_broken_damage = 30
	body_part = LOWER_TORSO
	vital = 1
	parent_organ = "chest"

/obj/item/organ/external/l_arm
	name = "l_arm"
	display_name = "left arm"
	icon_name = "l_arm"
	max_damage = 50
	min_broken_damage = 20
	body_part = ARM_LEFT
	parent_organ = "chest"

/obj/item/organ/external/l_arm/process_internal()
	..()
	process_grasp(owner.l_hand, "left hand")

/obj/item/organ/external/r_arm
	name = "r_arm"
	display_name = "right arm"
	icon_name = "r_arm"
	max_damage = 50
	min_broken_damage = 20
	body_part = ARM_RIGHT
	parent_organ = "chest"

/obj/item/organ/external/r_arm/process_internal()
	..()
	process_grasp(owner.r_hand, "right hand")

/obj/item/organ/external/l_leg
	name = "l_leg"
	display_name = "left leg"
	icon_name = "l_leg"
	max_damage = 50
	min_broken_damage = 20
	body_part = LEG_LEFT
	icon_position = LEFT
	parent_organ = "groin"

/obj/item/organ/external/r_leg
	name = "r_leg"
	display_name = "right leg"
	icon_name = "r_leg"
	max_damage = 50
	min_broken_damage = 20
	body_part = LEG_RIGHT
	icon_position = RIGHT
	parent_organ = "groin"

/obj/item/organ/external/l_foot
	name = "l_foot"
	display_name = "left foot"
	icon_name = "l_foot"
	max_damage = 30
	min_broken_damage = 15
	body_part = FOOT_LEFT
	icon_position = LEFT
	parent_organ = "l_leg"

/obj/item/organ/external/r_foot
	name = "r_foot"
	display_name = "right foot"
	icon_name = "r_foot"
	max_damage = 30
	min_broken_damage = 15
	body_part = FOOT_RIGHT
	icon_position = RIGHT
	parent_organ = "r_leg"

/obj/item/organ/external/r_hand
	name = "r_hand"
	display_name = "right hand"
	icon_name = "r_hand"
	max_damage = 30
	min_broken_damage = 15
	body_part = HAND_RIGHT
	parent_organ = "r_arm"

/obj/item/organ/external/r_hand/process_internal()
	..()
	process_grasp(owner.r_hand, "right hand")

/obj/item/organ/external/l_hand
	name = "l_hand"
	display_name = "left hand"
	icon_name = "l_hand"
	max_damage = 30
	min_broken_damage = 15
	body_part = HAND_LEFT
	parent_organ = "l_arm"
/obj/item/organ/external/l_hand/process_internal()
	..()
	process_grasp(owner.l_hand, "left hand")

/obj/item/organ/external/head
	name = "head"
	icon_name = "head"
	display_name = "head"
	max_damage = 75
	min_broken_damage = 40
	body_part = HEAD
	vital = 1
	parent_organ = "chest"

/obj/item/organ/external/head/New()

	..()

	if(!istype(owner))
		return

	src.icon_state = owner.gender == MALE? "head_m" : "head_f"
	//Add (facial) hair.
	if(owner.f_style)
		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[owner.f_style]
		if(facial_hair_style)
			var/icon/facial = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(facial_hair_style.do_colouration)
				facial.Blend(rgb(owner.r_facial, owner.g_facial, owner.b_facial), ICON_ADD)

			overlays.Add(facial) // icon.Blend(facial, ICON_OVERLAY)

	if(owner.h_style && !(owner.head && (owner.head.flags & BLOCKHEADHAIR)))
		var/datum/sprite_accessory/hair_style = hair_styles_list[owner.h_style]
		if(hair_style)
			var/icon/hair = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			if(hair_style.do_colouration)
				hair.Blend(rgb(owner.r_hair, owner.g_hair, owner.b_hair), ICON_ADD)

			overlays.Add(hair) //icon.Blend(hair, ICON_OVERLAY)

	name = "[owner.real_name]'s [name]"
	owner.regenerate_icons()

/obj/item/organ/external/attackby(obj/item/weapon/W as obj, mob/user as mob)
	switch(op_stage)
		if(0)
			if(istype(W,/obj/item/weapon/scalpel))
				user.visible_message("<span class='danger'><b>[user]</b> cuts [src] open with [W]!")
				op_stage++
				return
		if(1)
			if(istype(W,/obj/item/weapon/retractor))
				user.visible_message("<span class='danger'><b>[user]</b> cracks [src] open like an egg with [W]!")
				op_stage++
				return
		if(2)
			if(istype(W,/obj/item/weapon/hemostat))
				if(contents.len)
					var/obj/item/removing = pick(contents)
					removing.loc = src.loc
					if(istype(removing,/obj/item/organ/internal))
						var/obj/item/organ/internal/removed_organ = removing
						internal_organs -= removed_organ
					user.visible_message("<span class='danger'><b>[user]</b> extracts [removing] from [src] with [W]!")
				else
					user.visible_message("<span class='danger'><b>[user]</b> fishes around fruitlessly in [src] with [W].")
				return
	..()

/obj/item/organ/external/proc/disfigure(var/type = "brute")
	if (disfigured)
		return
	if(type == "brute")
		owner.visible_message("\red You hear a sickening cracking sound coming from \the [owner]'s [display_name].",	\
		"\red <b>Your [display_name] is mangled!</b>",	\
		"\red You hear a sickening crack.")
	else
		owner.visible_message("\red [owner]'s [display_name] is scorched into an unrecognizable mess!",	\
		"\red <b>Your [display_name] melts!</b>",	\
		"\red You hear a sickening sizzle.")
	disfigured = 1

// Prosthetics.
/obj/item/organ/external/l_arm/robot
	robotic = 1
/obj/item/organ/external/l_foot/robot
	robotic = 1
/obj/item/organ/external/l_hand/robot
	robotic = 1
/obj/item/organ/external/l_leg/robot
	robotic = 1
/obj/item/organ/external/r_arm/robot
	robotic = 1
/obj/item/organ/external/r_foot/robot
	robotic = 1
/obj/item/organ/external/r_hand/robot
	robotic = 1
/obj/item/organ/external/r_leg/robot
	robotic = 1
/obj/item/organ/external/head/robot
	robotic = 1
/obj/item/organ/external/chest/robot
	robotic = 1