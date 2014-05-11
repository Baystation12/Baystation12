/****************************************************
				EXTERNAL ORGANS
****************************************************/
/datum/organ/external
	name = "external"
	var/icon_name = null
	var/body_part = null
	var/icon_position = 0

	var/damage_state = "00"
	var/brute_dam = 0
	var/burn_dam = 0
	var/max_damage = 0
	var/max_size = 0
	var/last_dam = -1

	var/display_name
	var/list/wounds = list()
	var/number_wounds = 0 // cache the number of wounds, which is NOT wounds.len!

	var/tmp/perma_injury = 0
	var/tmp/destspawn = 0 //Has it spawned the broken limb?
	var/tmp/amputated = 0 //Whether this has been cleanly amputated, thus causing no pain
	var/min_broken_damage = 30

	var/datum/organ/external/parent
	var/list/datum/organ/external/children

	// Internal organs of this body part
	var/list/datum/organ/internal/internal_organs

	var/damage_msg = "\red You feel an intense pain"
	var/broken_description

	var/status = 0
	var/open = 0
	var/stage = 0
	var/cavity = 0
	var/sabotaged = 0 //If a prosthetic limb is emagged, it will detonate when it fails.

	var/obj/item/hidden = null
	var/list/implants = list()
	// INTERNAL germs inside the organ, this is BAD if it's greater 0
	var/germ_level = 0

	// how often wounds should be updated, a higher number means less often
	var/wound_update_accuracy = 1


/datum/organ/external/New(var/datum/organ/external/P)
	if(P)
		parent = P
		if(!parent.children)
			parent.children = list()
		parent.children.Add(src)
	return ..()

/****************************************************
			   DAMAGE PROCS
****************************************************/

/datum/organ/external/proc/emp_act(severity)
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
		take_damage(damage, 0, 1, used_weapon = "EMP")

/datum/organ/external/proc/take_damage(brute, burn, sharp, used_weapon = null, list/forbidden_limbs = list())
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

	//If limb took enough damage, try to cut or tear it off
	if(body_part != UPPER_TORSO && body_part != LOWER_TORSO) //as hilarious as it is, getting hit on the chest too much shouldn't effectively gib you.
		if(config.limbs_can_break && brute_dam >= max_damage * config.organ_health_multiplier)
			if( (sharp && prob(5 * brute)) || (brute > 20 && prob(2 * brute)) )
				droplimb(1)
				return

	// High brute damage or sharp objects may damage internal organs
	if(internal_organs != null) if( (sharp && brute >= 5) || brute >= 10) if(prob(5))
		// Damage an internal organ
		var/datum/organ/internal/I = pick(internal_organs)
		I.take_damage(brute / 2)
		brute -= brute / 2

	if(status & ORGAN_BROKEN && prob(40) && brute)
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
				var/list/datum/organ/external/possible_points = list()
				if(parent)
					possible_points += parent
				if(children)
					possible_points += children
				if(forbidden_limbs.len)
					possible_points -= forbidden_limbs
				if(possible_points.len)
					//And pass the pain around
					var/datum/organ/external/target = pick(possible_points)
					target.take_damage(brute, burn, sharp, used_weapon, forbidden_limbs + src)

	// sync the organ's damage with its wounds
	src.update_damages()
	owner.updatehealth()

	var/result = update_icon()
	return result

/datum/organ/external/proc/heal_damage(brute, burn, internal = 0, robo_repair = 0)
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
/datum/organ/external/proc/rejuvenate()
	damage_state = "00"
	if(status & 128)	//Robotic organs stay robotic.  Fix because right click rejuvinate makes IPC's organs organic.
		status = 128
	else
		status = 0
	perma_injury = 0
	brute_dam = 0
	burn_dam = 0

	// handle internal organs
	for(var/datum/organ/internal/current_organ in internal_organs)
		current_organ.rejuvenate()

	// remove embedded objects and drop them on the floor
	for(var/obj/implanted_object in implants)
		if(!istype(implanted_object,/obj/item/weapon/implant))	// We don't want to remove REAL implants. Just shrapnel etc.
			implanted_object.loc = owner.loc
			implants -= implanted_object

	owner.updatehealth()


/datum/organ/external/proc/createwound(var/type = CUT, var/damage)
	if(damage == 0) return

	// first check whether we can widen an existing wound
	if(wounds.len > 0 && prob(max(50+owner.number_wounds*10,100)))
		if((type == CUT || type == BRUISE) && damage >= 5)
			var/datum/wound/W = pick(wounds)
			if(W.amount == 1 && W.started_healing())
				W.open_wound(damage)
				if(prob(25))
					owner.visible_message("\red The wound on [owner.name]'s [display_name] widens with a nasty ripping voice.",\
					"\red The wound on your [display_name] widens with a nasty ripping voice.",\
					"You hear a nasty ripping noise, as if flesh is being torn apart.")
				return

	//Creating wound
	var/datum/wound/W
	var/size = min( max( 1, damage/10 ) , 6)
	//Possible types of wound
	var/list/size_names = list()
	switch(type)
		if(CUT)
			size_names = typesof(/datum/wound/cut/) - /datum/wound/cut/
		if(BRUISE)
			size_names = typesof(/datum/wound/bruise/) - /datum/wound/bruise/
		if(BURN)
			size_names = typesof(/datum/wound/burn/) - /datum/wound/burn/

	size = min(size,size_names.len)
	var/wound_type = size_names[size]
	W = new wound_type(damage)

	//Possibly trigger an internal wound, too.
	var/local_damage = brute_dam + burn_dam + damage
	if(damage > 15 && type != BURN && local_damage > 30 && prob(damage) && !(status & ORGAN_ROBOT))
		var/datum/wound/internal_bleeding/I = new (15)
		wounds += I
		owner.custom_pain("You feel something rip in your [display_name]!", 1)

	//Check whether we can add the wound to an existing wound
	for(var/datum/wound/other in wounds)
		if(other.desc == W.desc)
			// okay, add it!
			other.damage += W.damage
			other.amount += 1
			W = null // to signify that the wound was added
			break
	if(W)
		wounds += W

/****************************************************
			   PROCESSING & UPDATING
****************************************************/

//Determines if we even need to process this organ.

/datum/organ/external/proc/need_process()
	if(status && status != ORGAN_ROBOT) // If it's robotic, that's fine it will have a status.
		return 1
	if(brute_dam || burn_dam)
		return 1
	if(last_dam != brute_dam + burn_dam) // Process when we are fully healed up.
		last_dam = brute_dam + burn_dam
		return 1
	last_dam = brute_dam + burn_dam
	return 0

/datum/organ/external/process()
	// Process wounds, doing healing etc. Only do this every few ticks to save processing power
	if(owner.life_tick % wound_update_accuracy == 0)
		update_wounds()

	//Chem traces slowly vanish
	if(owner.life_tick % 10 == 0)
		for(var/chemID in trace_chemicals)
			trace_chemicals[chemID] = trace_chemicals[chemID] - 1
			if(trace_chemicals[chemID] <= 0)
				trace_chemicals.Remove(chemID)

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

	//Bone fracurtes
	if(config.bones_can_break && brute_dam > min_broken_damage * config.organ_health_multiplier && !(status & ORGAN_ROBOT))
		src.fracture()
	if(!(status & ORGAN_BROKEN))
		perma_injury = 0

	update_germs()
	return

//Updating germ levels. Handles organ germ levels and necrosis.
#define GANGREN_LEVEL_ONE		100
#define GANGREN_LEVEL_TWO		1000
#define GANGREN_LEVEL_TERMINAL	2500
#define GERM_TRANSFER_AMOUNT	germ_level/500
/datum/organ/external/proc/update_germs()

	if(status & ORGAN_ROBOT|ORGAN_DESTROYED) //Robotic limbs shouldn't be infected, nor should nonexistant limbs.
		germ_level = 0
		return

	if(germ_level > 0 && owner.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//Syncing germ levels with external wounds
		for(var/datum/wound/W in wounds)
			if(!W.bandaged && !W.salved)
				W.germ_level = max(W.germ_level, germ_level)	//Wounds get all the germs
				if (W.germ_level > germ_level)	//Badly infected wounds raise internal germ levels
					germ_level++

		if(germ_level > GANGREN_LEVEL_ONE && prob(round(germ_level/100)))
			germ_level++
			owner.adjustToxLoss(1)

		if(germ_level > GANGREN_LEVEL_TWO)
			germ_level++
			owner.adjustToxLoss(1)
/*
		if(germ_level > GANGREN_LEVEL_TERMINAL)
			if (!(status & ORGAN_DEAD))
				status |= ORGAN_DEAD
				owner << "<span class='notice'>You can't feel your [display_name] anymore...</span>"
				owner.update_body(1)
			if (prob(10))	//Spreading the fun
				if (children)	//To child organs
					for (var/datum/organ/external/child in children)
						if (!(child.status & (ORGAN_DEAD|ORGAN_DESTROYED|ORGAN_ROBOT)))
							child.germ_level += round(GERM_TRANSFER_AMOUNT)
				if (parent)
					if (!(parent.status & (ORGAN_DEAD|ORGAN_DESTROYED|ORGAN_ROBOT)))
						parent.germ_level += round(GERM_TRANSFER_AMOUNT)
*/

//Updating wounds. Handles wound natural I had some free spachealing, internal bleedings and infections
/datum/organ/external/proc/update_wounds()

	if((status & ORGAN_ROBOT)) //Robotic limbs don't heal or get worse.
		return

	for(var/datum/wound/W in wounds)
		// wounds can disappear after 10 minutes at the earliest
		if(W.damage <= 0 && W.created + 10 * 10 * 60 <= world.time)
			wounds -= W
			continue
			// let the GC handle the deletion of the wound

		// Internal wounds get worse over time. Low temperatures (cryo) stop them.
		if(W.internal && !W.is_treated() && owner.bodytemperature >= 170)
			var/bicardose = owner.reagents.get_reagent_amount("bicaridine")
			if(!bicardose)	//bicard stops internal wounds from growing bigger with time, and also stop bleeding
				W.open_wound(0.1 * wound_update_accuracy)
				owner.vessel.remove_reagent("blood",0.05 * W.damage * wound_update_accuracy)
			if(bicardose >= 30)	//overdose of bicaridine begins healing IB
				W.damage = max(0, W.damage - 0.2)

			if(!owner.reagents.has_reagent("inaprovaline")) //This little copypaste will allow inaprovaline to work too, giving it a much needed buff to help medical.
				W.open_wound(0.1 * wound_update_accuracy)
				owner.vessel.remove_reagent("blood",0.05 * W.damage * wound_update_accuracy)

			owner.vessel.remove_reagent("blood",0.02 * W.damage * wound_update_accuracy)
			if(prob(1 * wound_update_accuracy))
				owner.custom_pain("You feel a stabbing pain in your [display_name]!",1)


		// slow healing
		var/heal_amt = 0

		if (W.damage < 15) //this thing's edges are not in day's travel of each other, what healing?
			heal_amt += 0.2

		if(W.is_treated() && W.damage < 50) //whoa, not even magical band aid can hold it together
			heal_amt += 0.3

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
			W.germ_level = 0
			W.disinfected = 1

	// sync the organ's damage with its wounds
	src.update_damages()
	if (update_icon())
		owner.UpdateDamageIcon(1)

//Updates brute_damn and burn_damn from wound damages. Updates BLEEDING status.
/datum/organ/external/proc/update_damages()
	number_wounds = 0
	brute_dam = 0
	burn_dam = 0
	status &= ~ORGAN_BLEEDING
	var/clamped = 0
	for(var/datum/wound/W in wounds)
		if(W.damage_type == CUT || W.damage_type == BRUISE)
			brute_dam += W.damage
		else if(W.damage_type == BURN)
			burn_dam += W.damage

		if(!(status & ORGAN_ROBOT) && W.bleeding())
			W.bleed_timer--
			status |= ORGAN_BLEEDING

		clamped |= W.clamped

		number_wounds += W.amount

	if (open && !clamped)	//things tend to bleed if they are CUT OPEN
		status |= ORGAN_BLEEDING


// new damage icon system
// adjusted to set damage_state to brute/burn code only (without r_name0 as before)
/datum/organ/external/proc/update_icon()
	var/n_is = damage_state_text()
	if (n_is != damage_state)
		damage_state = n_is
		return 1
	return 0

// new damage icon system
// returns just the brute/burn damage code
/datum/organ/external/proc/damage_state_text()
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
/datum/organ/external/proc/setAmputatedTree()
	for(var/datum/organ/external/O in children)
		O.amputated=amputated
		O.setAmputatedTree()

//Handles dismemberment
/datum/organ/external/proc/droplimb(var/override = 0,var/no_explode = 0)
	if(destspawn) return
	if(override)
		status |= ORGAN_DESTROYED
	if(status & ORGAN_DESTROYED)
		if(body_part == UPPER_TORSO)
			return

		src.status &= ~ORGAN_BROKEN
		src.status &= ~ORGAN_BLEEDING
		src.status &= ~ORGAN_SPLINTED
		for(var/implant in implants)
			del(implant)

		// If any organs are attached to this, destroy them
		for(var/datum/organ/external/O in owner.organs)
			if(O.parent == src)
				O.droplimb(1)

		var/obj/organ	//Dropped limb object
		switch(body_part)
			if(HEAD)
				if(owner.species.flags & IS_SYNTHETIC)
					organ= new /obj/item/weapon/organ/head/posi(owner.loc, owner)
				else
					organ= new /obj/item/weapon/organ/head(owner.loc, owner)
				owner.u_equip(owner.glasses)
				owner.u_equip(owner.head)
				owner.u_equip(owner.l_ear)
				owner.u_equip(owner.r_ear)
				owner.u_equip(owner.wear_mask)
			if(ARM_RIGHT)
				if(status & ORGAN_ROBOT)
					organ = new /obj/item/robot_parts/r_arm(owner.loc)
				else
					organ= new /obj/item/weapon/organ/r_arm(owner.loc, owner)
			if(ARM_LEFT)
				if(status & ORGAN_ROBOT)
					organ= new /obj/item/robot_parts/l_arm(owner.loc)
				else
					organ= new /obj/item/weapon/organ/l_arm(owner.loc, owner)
			if(LEG_RIGHT)
				if(status & ORGAN_ROBOT)
					organ = new /obj/item/robot_parts/r_leg(owner.loc)
				else
					organ= new /obj/item/weapon/organ/r_leg(owner.loc, owner)
			if(LEG_LEFT)
				if(status & ORGAN_ROBOT)
					organ = new /obj/item/robot_parts/l_leg(owner.loc)
				else
					organ= new /obj/item/weapon/organ/l_leg(owner.loc, owner)
			if(HAND_RIGHT)
				if(!(status & ORGAN_ROBOT))
					organ= new /obj/item/weapon/organ/r_hand(owner.loc, owner)
				owner.u_equip(owner.gloves)
			if(HAND_LEFT)
				if(!(status & ORGAN_ROBOT))
					organ= new /obj/item/weapon/organ/l_hand(owner.loc, owner)
				owner.u_equip(owner.gloves)
			if(FOOT_RIGHT)
				if(!(status & ORGAN_ROBOT))
					organ= new /obj/item/weapon/organ/r_foot/(owner.loc, owner)
				owner.u_equip(owner.shoes)
			if(FOOT_LEFT)
				if(!(status & ORGAN_ROBOT))
					organ = new /obj/item/weapon/organ/l_foot(owner.loc, owner)
				owner.u_equip(owner.shoes)
		if(organ)
			destspawn = 1
			//Robotic limbs explode if sabotaged.
			if(status & ORGAN_ROBOT && !no_explode && sabotaged)
				owner.visible_message("\red \The [owner]'s [display_name] explodes violently!",\
				"\red <b>Your [display_name] explodes!</b>",\
				"You hear an explosion followed by a scream!")
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
			var/lol = pick(cardinal)
			step(organ,lol)

			owner.update_body(1)

			// OK so maybe your limb just flew off, but if it was attached to a pair of cuffs then hooray! Freedom!
			release_restraints()

/****************************************************
			   HELPERS
****************************************************/

/datum/organ/external/proc/release_restraints()
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

/datum/organ/external/proc/bandage()
	var/rval = 0
	src.status &= ~ORGAN_BLEEDING
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		rval |= !W.bandaged
		W.bandaged = 1
	return rval

/datum/organ/external/proc/clamp()
	var/rval = 0
	src.status &= ~ORGAN_BLEEDING
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		rval |= !W.clamped
		W.clamped = 1
	return rval

/datum/organ/external/proc/salve()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		rval |= !W.salved
		W.salved = 1
	return rval

/datum/organ/external/proc/fracture()
	if(status & ORGAN_BROKEN)
		return
	owner.visible_message(\
		"\red You hear a loud cracking sound coming from \the [owner].",\
		"\red <b>Something feels like it shattered in your [display_name]!</b>",\
		"You hear a sickening crack.")

	if(owner.species && !(owner.species.flags & NO_PAIN))
		owner.emote("scream")

	status |= ORGAN_BROKEN
	broken_description = pick("broken","fracture","hairline fracture")
	perma_injury = brute_dam

	// Fractures have a chance of getting you out of restraints
	if (prob(25))
		release_restraints()

/datum/organ/external/proc/robotize()
	src.status &= ~ORGAN_BROKEN
	src.status &= ~ORGAN_BLEEDING
	src.status &= ~ORGAN_SPLINTED
	src.status &= ~ORGAN_CUT_AWAY
	src.status &= ~ORGAN_ATTACHABLE
	src.status &= ~ORGAN_DESTROYED
	src.status |= ORGAN_ROBOT
	src.destspawn = 0
	for (var/datum/organ/external/T in children)
		if(T)
			T.robotize()

/datum/organ/external/proc/mutate()
	src.status |= ORGAN_MUTATED
	owner.update_body()

/datum/organ/external/proc/unmutate()
	src.status &= ~ORGAN_MUTATED
	owner.update_body()

/datum/organ/external/proc/get_damage()	//returns total damage
	return max(brute_dam + burn_dam - perma_injury, perma_injury)	//could use health?

/datum/organ/external/proc/is_infected()
	for(var/datum/wound/W in wounds)
		if(W.germ_level > 100)
			return 1
	return 0

/datum/organ/external/get_icon(gender="")
	if (status & ORGAN_ROBOT && !(owner.species && owner.species.flags & IS_SYNTHETIC))
		return new /icon('icons/mob/human_races/robotic.dmi', "[icon_name][gender ? "_[gender]" : ""]")

	if (status & ORGAN_MUTATED)
		return new /icon(owner.deform_icon, "[icon_name][gender ? "_[gender]" : ""]")

	return new /icon(owner.race_icon, "[icon_name][gender ? "_[gender]" : ""]")


/datum/organ/external/proc/is_usable()
	return !(status & (ORGAN_DESTROYED|ORGAN_MUTATED|ORGAN_DEAD))

/****************************************************
			   ORGAN DEFINES
****************************************************/

/datum/organ/external/chest
	name = "chest"
	icon_name = "torso"
	display_name = "chest"
	max_damage = 75
	min_broken_damage = 40
	body_part = UPPER_TORSO


/datum/organ/external/groin
	name = "groin"
	icon_name = "groin"
	display_name = "groin"
	max_damage = 50
	min_broken_damage = 30
	body_part = LOWER_TORSO

/datum/organ/external/l_arm
	name = "l_arm"
	display_name = "left arm"
	icon_name = "l_arm"
	max_damage = 50
	min_broken_damage = 20
	body_part = ARM_LEFT

/datum/organ/external/l_leg
	name = "l_leg"
	display_name = "left leg"
	icon_name = "l_leg"
	max_damage = 50
	min_broken_damage = 20
	body_part = LEG_LEFT
	icon_position = LEFT

/datum/organ/external/r_arm
	name = "r_arm"
	display_name = "right arm"
	icon_name = "r_arm"
	max_damage = 50
	min_broken_damage = 20
	body_part = ARM_RIGHT

/datum/organ/external/r_leg
	name = "r_leg"
	display_name = "right leg"
	icon_name = "r_leg"
	max_damage = 50
	min_broken_damage = 20
	body_part = LEG_RIGHT
	icon_position = RIGHT

/datum/organ/external/l_foot
	name = "l_foot"
	display_name = "left foot"
	icon_name = "l_foot"
	max_damage = 30
	min_broken_damage = 15
	body_part = FOOT_LEFT
	icon_position = LEFT

/datum/organ/external/r_foot
	name = "r_foot"
	display_name = "right foot"
	icon_name = "r_foot"
	max_damage = 30
	min_broken_damage = 15
	body_part = FOOT_RIGHT
	icon_position = RIGHT

/datum/organ/external/r_hand
	name = "r_hand"
	display_name = "right hand"
	icon_name = "r_hand"
	max_damage = 30
	min_broken_damage = 15
	body_part = HAND_RIGHT

/datum/organ/external/l_hand
	name = "l_hand"
	display_name = "left hand"
	icon_name = "l_hand"
	max_damage = 30
	min_broken_damage = 15
	body_part = HAND_LEFT

/datum/organ/external/head
	name = "head"
	icon_name = "head"
	display_name = "head"
	max_damage = 75
	min_broken_damage = 40
	body_part = HEAD
	var/disfigured = 0

/datum/organ/external/head/get_icon()
	if (!owner)
	 return ..()
	var/g = "m"
	if(owner.gender == FEMALE)	g = "f"
	if (status & ORGAN_MUTATED)
		. = new /icon(owner.deform_icon, "[icon_name]_[g]")
	else
		. = new /icon(owner.race_icon, "[icon_name]_[g]")

/datum/organ/external/head/take_damage(brute, burn, sharp, used_weapon = null, list/forbidden_limbs = list())
	..(brute, burn, sharp, used_weapon, forbidden_limbs)
	if (!disfigured)
		if (brute_dam > 40)
			if (prob(50))
				disfigure("brute")
		if (burn_dam > 40)
			disfigure("burn")

/datum/organ/external/head/proc/disfigure(var/type = "brute")
	if (disfigured)
		return
	if(type == "brute")
		owner.visible_message("\red You hear a sickening cracking sound coming from \the [owner]'s face.",	\
		"\red <b>Your face becomes unrecognizible mangled mess!</b>",	\
		"\red You hear a sickening crack.")
	else
		owner.visible_message("\red [owner]'s face melts away, turning into mangled mess!",	\
		"\red <b>Your face melts off!</b>",	\
		"\red You hear a sickening sizzle.")
	disfigured = 1

/****************************************************
			   EXTERNAL ORGAN ITEMS
****************************************************/

obj/item/weapon/organ
	icon = 'icons/mob/human_races/r_human.dmi'

obj/item/weapon/organ/New(loc, mob/living/carbon/human/H)
	..(loc)
	if(!istype(H))
		return
	if(H.dna)
		if(!blood_DNA)
			blood_DNA = list()
		blood_DNA[H.dna.unique_enzymes] = H.dna.b_type

	//Forming icon for the limb

	//Setting base icon for this mob's race
	var/icon/base
	if(H.species && H.species.icobase)
		base = icon(H.species.icobase)
	else
		base = icon('icons/mob/human_races/r_human.dmi')

	if(base)
		//Changing limb's skin tone to match owner
		if(!H.species || H.species.flags & HAS_SKIN_TONE)
			if (H.s_tone >= 0)
				base.Blend(rgb(H.s_tone, H.s_tone, H.s_tone), ICON_ADD)
			else
				base.Blend(rgb(-H.s_tone,  -H.s_tone,  -H.s_tone), ICON_SUBTRACT)

	if(base)
		//Changing limb's skin color to match owner
		if(!H.species || H.species.flags & HAS_SKIN_COLOR)
			base.Blend(rgb(H.r_skin, H.g_skin, H.b_skin), ICON_ADD)

	icon = base
	dir = SOUTH
	src.transform = turn(src.transform, rand(70,130))


/****************************************************
			   EXTERNAL ORGAN ITEMS DEFINES
****************************************************/

obj/item/weapon/organ/l_arm
	name = "left arm"
	icon_state = "l_arm"
obj/item/weapon/organ/l_foot
	name = "left foot"
	icon_state = "l_foot"
obj/item/weapon/organ/l_hand
	name = "left hand"
	icon_state = "l_hand"
obj/item/weapon/organ/l_leg
	name = "left leg"
	icon_state = "l_leg"
obj/item/weapon/organ/r_arm
	name = "right arm"
	icon_state = "r_arm"
obj/item/weapon/organ/r_foot
	name = "right foot"
	icon_state = "r_foot"
obj/item/weapon/organ/r_hand
	name = "right hand"
	icon_state = "r_hand"
obj/item/weapon/organ/r_leg
	name = "right leg"
	icon_state = "r_leg"
obj/item/weapon/organ/head
	name = "head"
	icon_state = "head_m"
	var/mob/living/carbon/brain/brainmob
	var/brain_op_stage = 0

/obj/item/weapon/organ/head/posi
	name = "robotic head"

obj/item/weapon/organ/head/New(loc, mob/living/carbon/human/H)
	if(istype(H))
		src.icon_state = H.gender == MALE? "head_m" : "head_f"
	..()
	//Add (facial) hair.
	if(H.f_style)
		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[H.f_style]
		if(facial_hair_style)
			var/icon/facial = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(facial_hair_style.do_colouration)
				facial.Blend(rgb(H.r_facial, H.g_facial, H.b_facial), ICON_ADD)

			overlays.Add(facial) // icon.Blend(facial, ICON_OVERLAY)

	if(H.h_style && !(H.head && (H.head.flags & BLOCKHEADHAIR)))
		var/datum/sprite_accessory/hair_style = hair_styles_list[H.h_style]
		if(hair_style)
			var/icon/hair = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			if(hair_style.do_colouration)
				hair.Blend(rgb(H.r_hair, H.g_hair, H.b_hair), ICON_ADD)

			overlays.Add(hair) //icon.Blend(hair, ICON_OVERLAY)
	spawn(5)
	if(brainmob && brainmob.client)
		brainmob.client.screen.len = null //clear the hud

	//if(ishuman(H))
	//	if(H.gender == FEMALE)
	//		H.icon_state = "head_f"
	//	H.overlays += H.generate_head_icon()
	transfer_identity(H)

	name = "[H.real_name]'s head"

	H.regenerate_icons()

	brainmob.stat = 2
	brainmob.death()

obj/item/weapon/organ/head/proc/transfer_identity(var/mob/living/carbon/human/H)//Same deal as the regular brain proc. Used for human-->head
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna.Clone()
	if(H.mind)
		H.mind.transfer_to(brainmob)
	brainmob.container = src

obj/item/weapon/organ/head/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/scalpel))
		switch(brain_op_stage)
			if(0)
				for(var/mob/O in (oviewers(brainmob) - user))
					O.show_message("\red [brainmob] is beginning to have \his head cut open with [W] by [user].", 1)
				brainmob << "\red [user] begins to cut open your head with [W]!"
				user << "\red You cut [brainmob]'s head open with [W]!"

				brain_op_stage = 1

			if(2)
				for(var/mob/O in (oviewers(brainmob) - user))
					O.show_message("\red [brainmob] is having \his connections to the brain delicately severed with [W] by [user].", 1)
				brainmob << "\red [user] begins to cut open your head with [W]!"
				user << "\red You cut [brainmob]'s head open with [W]!"

				brain_op_stage = 3.0
			else
				..()
	else if(istype(W,/obj/item/weapon/circular_saw))
		switch(brain_op_stage)
			if(1)
				for(var/mob/O in (oviewers(brainmob) - user))
					O.show_message("\red [brainmob] has \his head sawed open with [W] by [user].", 1)
				brainmob << "\red [user] begins to saw open your head with [W]!"
				user << "\red You saw [brainmob]'s head open with [W]!"

				brain_op_stage = 2
			if(3)
				for(var/mob/O in (oviewers(brainmob) - user))
					O.show_message("\red [brainmob] has \his spine's connection to the brain severed with [W] by [user].", 1)
				brainmob << "\red [user] severs your brain's connection to the spine with [W]!"
				user << "\red You sever [brainmob]'s brain's connection to the spine with [W]!"

				user.attack_log += "\[[time_stamp()]\]<font color='red'> Debrained [brainmob.name] ([brainmob.ckey]) with [W.name] (INTENT: [uppertext(user.a_intent)])</font>"
				brainmob.attack_log += "\[[time_stamp()]\]<font color='orange'> Debrained by [user.name] ([user.ckey]) with [W.name] (INTENT: [uppertext(user.a_intent)])</font>"
				msg_admin_attack("[user] ([user.ckey]) debrained [brainmob] ([brainmob.ckey]) (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

				if(istype(src,/obj/item/weapon/organ/head/posi))
					var/obj/item/device/mmi/posibrain/B = new(loc)
					B.transfer_identity(brainmob)
				else
					var/obj/item/brain/B = new(loc)
					B.transfer_identity(brainmob)

				brain_op_stage = 4.0
			else
				..()
	else
		..()
