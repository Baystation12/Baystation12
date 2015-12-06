/****************************************************
				EXTERNAL ORGANS
****************************************************/

//These control the damage thresholds for the various ways of removing limbs
#define DROPLIMB_THRESHOLD_EDGE 5
#define DROPLIMB_THRESHOLD_TEAROFF 2
#define DROPLIMB_THRESHOLD_DESTROY 1

/obj/item/organ/external
	name = "external"
	min_broken_damage = 30
	max_damage = 0
	dir = SOUTH
	organ_tag = "limb"

	var/icon_name = null
	var/body_part = null
	var/icon_position = 0
	var/model
	var/force_icon
	var/damage_state = "00"
	var/brute_dam = 0
	var/burn_dam = 0
	var/max_size = 0
	var/last_dam = -1
	var/icon/mob_icon
	var/gendered_icon = 0
	var/limb_name
	var/disfigured = 0
	var/cannot_amputate
	var/cannot_break
	var/s_tone
	var/list/s_col
	var/list/wounds = list()
	var/number_wounds = 0 // cache the number of wounds, which is NOT wounds.len!
	var/perma_injury = 0
	var/obj/item/organ/external/parent
	var/list/obj/item/organ/external/children
	var/list/internal_organs = list() 	// Internal organs of this body part
	var/damage_msg = "\red You feel an intense pain"
	var/broken_description
	var/open = 0
	var/stage = 0
	var/cavity = 0
	var/sabotaged = 0 // If a prosthetic limb is emagged, it will detonate when it fails.
	var/encased       // Needs to be opened with a saw to access the organs.
	var/list/implants = list()
	var/wound_update_accuracy = 1 	// how often wounds should be updated, a higher number means less often
	var/joint = "joint"   // Descriptive string used in dislocation.
	var/amputation_point  // Descriptive string used in amputation.
	var/dislocated = 0    // If you target a joint, you can dislocate the limb, causing temporary damage to the organ.
	var/can_grasp //It would be more appropriate if these two were named "affects_grasp" and "affects_stand" at this point
	var/can_stand

/obj/item/organ/external/Destroy()
	if(parent && parent.children)
		parent.children -= src

	if(children)
		for(var/obj/item/organ/external/C in children)
			qdel(C)

	if(internal_organs)
		for(var/obj/item/organ/O in internal_organs)
			qdel(O)

	return ..()

/obj/item/organ/external/attack_self(var/mob/user)
	if(!contents.len)
		return ..()
	var/list/removable_objects = list()
	for(var/obj/item/organ/external/E in (contents + src))
		if(!istype(E))
			continue
		for(var/obj/item/I in E.contents)
			if(istype(I,/obj/item/organ))
				continue
			removable_objects |= I
	if(removable_objects.len)
		var/obj/item/I = pick(removable_objects)
		I.loc = get_turf(user) //just in case something was embedded that is not an item
		if(istype(I))
			if(!(user.l_hand && user.r_hand))
				user.put_in_hands(I)
		user.visible_message("<span class='danger'>\The [user] rips \the [I] out of \the [src]!</span>")
		return //no eating the limb until everything's been removed
	return ..()

/obj/item/organ/external/examine()
	..()
	if(in_range(usr, src) || istype(usr, /mob/dead/observer))
		for(var/obj/item/I in contents)
			if(istype(I, /obj/item/organ))
				continue
			usr << "<span class='danger'>There is \a [I] sticking out of it.</span>"
	return

/obj/item/organ/external/attackby(obj/item/weapon/W as obj, mob/user as mob)
	switch(stage)
		if(0)
			if(istype(W,/obj/item/weapon/scalpel))
				user.visible_message("<span class='danger'><b>[user]</b> cuts [src] open with [W]!")
				stage++
				return
		if(1)
			if(istype(W,/obj/item/weapon/retractor))
				user.visible_message("<span class='danger'><b>[user]</b> cracks [src] open like an egg with [W]!")
				stage++
				return
		if(2)
			if(istype(W,/obj/item/weapon/hemostat))
				if(contents.len)
					var/obj/item/removing = pick(contents)
					removing.loc = get_turf(user.loc)
					if(!(user.l_hand && user.r_hand))
						user.put_in_hands(removing)
					user.visible_message("<span class='danger'><b>[user]</b> extracts [removing] from [src] with [W]!")
				else
					user.visible_message("<span class='danger'><b>[user]</b> fishes around fruitlessly in [src] with [W].")
				return
	..()

/obj/item/organ/external/proc/is_dislocated()
	if(dislocated > 0)
		return 1
	if(parent)
		return parent.is_dislocated()
	return 0

/obj/item/organ/external/proc/dislocate(var/primary)
	if(dislocated != -1)
		if(primary)
			dislocated = 2
		else
			dislocated = 1
	owner.verbs |= /mob/living/carbon/human/proc/undislocate
	if(children && children.len)
		for(var/obj/item/organ/external/child in children)
			child.dislocate()

/obj/item/organ/external/proc/undislocate()
	if(dislocated != -1)
		dislocated = 0
	if(children && children.len)
		for(var/obj/item/organ/external/child in children)
			if(child.dislocated == 1)
				child.undislocate()
	if(owner)
		owner.shock_stage += 20
		for(var/obj/item/organ/external/limb in owner.organs)
			if(limb.dislocated == 2)
				return
		owner.verbs -= /mob/living/carbon/human/proc/undislocate

/obj/item/organ/external/update_health()
	damage = min(max_damage, (brute_dam + burn_dam))
	return


/obj/item/organ/external/New(var/mob/living/carbon/holder)
	..(holder, 0)
	if(owner)
		replaced(owner)
		sync_colour_to_human(owner)
	spawn(1)
		get_icon()

/obj/item/organ/external/replaced(var/mob/living/carbon/human/target)
	owner = target
	if(istype(owner))
		owner.organs_by_name[limb_name] = src
		owner.organs |= src
		for(var/obj/item/organ/organ in src)
			organ.loc = owner
			organ.replaced(owner,src)

	if(parent_organ)
		parent = owner.organs_by_name[src.parent_organ]
		if(parent)
			if(!parent.children)
				parent.children = list()
			parent.children.Add(src)

/****************************************************
			   DAMAGE PROCS
****************************************************/

/obj/item/organ/external/proc/is_damageable(var/additional_damage = 0)
	return (vital || brute_dam + burn_dam + additional_damage < max_damage)

/obj/item/organ/external/take_damage(brute, burn, sharp, edge, used_weapon = null, list/forbidden_limbs = list())
	if((brute <= 0) && (burn <= 0))
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
	if(internal_organs && (brute_dam >= max_damage || (((sharp && brute >= 5) || brute >= 10) && prob(5))))
		// Damage an internal organ
		if(internal_organs && internal_organs.len)
			var/obj/item/organ/I = pick(internal_organs)
			I.take_damage(brute / 2)
			brute -= brute / 2

	if(status & ORGAN_BROKEN && prob(40) && brute)
		if (!(owner.species && (owner.species.flags & NO_PAIN)))
			owner.emote("scream")	//getting hit on broken hand hurts
	if(used_weapon)
		add_autopsy_data("[used_weapon]", brute + burn)

	var/can_cut = (prob(brute*2) || sharp) && !(status & ORGAN_ROBOT)

	// If the limbs can break, make sure we don't exceed the maximum damage a limb can take before breaking
	// Non-vital organs are limited to max_damage. You can't kill someone by bludeonging their arm all the way to 200 -- you can
	// push them faster into paincrit though, as the additional damage is converted into shock.
	if(is_damageable(brute + burn) || !config.limbs_can_break)
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
		var/spillover = 0
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
				spillover += max(0, brute - temp)

			if (burn > 0 && can_inflict)
				//Inflict all burn damage we can
				createwound(BURN, min(burn,can_inflict))
				//How much burn damage is left to inflict
				spillover += max(0, burn - can_inflict)
		
		//If there are still hurties to dispense
		if (spillover)
			owner.shock_stage += spillover * config.organ_damage_spillover_multiplier

	// sync the organ's damage with its wounds
	src.update_damages()
	owner.updatehealth() //droplimb will call updatehealth() again if it does end up being called

	//If limb took enough damage, try to cut or tear it off
	if(owner && loc == owner && !is_stump())
		if(!cannot_amputate && config.limbs_can_break && (brute_dam + burn_dam) >= (max_damage * config.organ_health_multiplier))
			//organs can come off in three cases
			//1. If the damage source is edge_eligible and the brute damage dealt exceeds the edge threshold, then the organ is cut off.
			//2. If the damage amount dealt exceeds the disintegrate threshold, the organ is completely obliterated.
			//3. If the organ has already reached or would be put over it's max damage amount (currently redundant),
			//   and the brute damage dealt exceeds the tearoff threshold, the organ is torn off.
			
			//Check edge eligibility
			var/edge_eligible = 0
			if(edge)
				if(istype(used_weapon,/obj/item))
					var/obj/item/W = used_weapon
					if(W.w_class >= w_class)
						edge_eligible = 1
				else
					edge_eligible = 1

			if(edge_eligible && brute >= max_damage / DROPLIMB_THRESHOLD_EDGE && prob(brute))
				droplimb(0, DROPLIMB_EDGE)
			else if(burn >= max_damage / DROPLIMB_THRESHOLD_DESTROY && prob(burn/3))
				droplimb(0, DROPLIMB_BURN)
			else if(brute >= max_damage / DROPLIMB_THRESHOLD_DESTROY && prob(brute))
				droplimb(0, DROPLIMB_BLUNT)
			else if(brute >= max_damage / DROPLIMB_THRESHOLD_TEAROFF && prob(brute/3))
				droplimb(0, DROPLIMB_EDGE)

	return update_icon()

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

	/*if((brute || burn) && children && children.len && (owner.species.flags & REGENERATES_LIMBS))
		var/obj/item/organ/external/stump/S = locate() in children
		if(S)
			world << "Extra healing to go around ([brute+burn]) and [owner] needs a replacement limb."*/

	//Sync the organ's damage with its wounds
	src.update_damages()
	owner.updatehealth()

	var/result = update_icon()
	return result

/*
This function completely restores a damaged organ to perfect condition.
*/
/obj/item/organ/external/rejuvenate()
	damage_state = "00"
	if(status & 128)	//Robotic organs stay robotic.  Fix because right click rejuvinate makes IPC's organs organic.
		status = 128
	else
		status = 0
	perma_injury = 0
	brute_dam = 0
	burn_dam = 0
	germ_level = 0
	wounds.Cut()
	number_wounds = 0

	// handle internal organs
	for(var/obj/item/organ/current_organ in internal_organs)
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
		owner.custom_pain("You feel something rip in your [name]!", 1)

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
					owner.visible_message("\red The wound on [owner.name]'s [name] widens with a nasty ripping noise.",\
					"\red The wound on your [name] widens with a nasty ripping noise.",\
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

//external organs handle brokenness a bit differently when it comes to damage. Instead brute_dam is checked inside process()
//this also ensures that an external organ cannot be "broken" without broken_description being set.
/obj/item/organ/external/is_broken()
	return ((status & ORGAN_CUT_AWAY) || ((status & ORGAN_BROKEN) && !(status & ORGAN_SPLINTED)))

//Determines if we even need to process this organ.
/obj/item/organ/external/proc/need_process()
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

/obj/item/organ/external/process()
	if(owner)
		//Dismemberment
		//if(parent && parent.is_stump()) //should never happen
		//	warning("\The [src] ([src.type]) belonging to [owner] ([owner.type]) was attached to a stump")
		//	remove()
		//	return

		// Process wounds, doing healing etc. Only do this every few ticks to save processing power
		if(owner.life_tick % wound_update_accuracy == 0)
			update_wounds()

		//Chem traces slowly vanish
		if(owner.life_tick % 10 == 0)
			for(var/chemID in trace_chemicals)
				trace_chemicals[chemID] = trace_chemicals[chemID] - 1
				if(trace_chemicals[chemID] <= 0)
					trace_chemicals.Remove(chemID)

		//Bone fractures
		if(config.bones_can_break && brute_dam > min_broken_damage * config.organ_health_multiplier && !(status & ORGAN_ROBOT))
			src.fracture()

		if(!(status & ORGAN_BROKEN))
			perma_injury = 0

		//Infections
		update_germs()
	else
		..()

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

	if(status & (ORGAN_ROBOT) || (owner.species && owner.species.flags & IS_PLANT)) //Robotic limbs shouldn't be infected, nor should nonexistant limbs.
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

/obj/item/organ/external/handle_germ_effects()

	if(germ_level < INFECTION_LEVEL_TWO)
		return ..()

	var/antibiotics = owner.reagents.get_reagent_amount("spaceacillin")

	if(germ_level >= INFECTION_LEVEL_TWO)
		//spread the infection to internal organs
		var/obj/item/organ/target_organ = null	//make internal organs become infected one at a time instead of all at once
		for (var/obj/item/organ/I in internal_organs)
			if (I.germ_level > 0 && I.germ_level < min(germ_level, INFECTION_LEVEL_TWO))	//once the organ reaches whatever we can give it, or level two, switch to a different one
				if (!target_organ || I.germ_level > target_organ.germ_level)	//choose the organ with the highest germ_level
					target_organ = I

		if (!target_organ)
			//figure out which organs we can spread germs to and pick one at random
			var/list/candidate_organs = list()
			for (var/obj/item/organ/I in internal_organs)
				if (I.germ_level < germ_level)
					candidate_organs |= I
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
			owner << "<span class='notice'>You can't feel your [name] anymore...</span>"
			owner.update_body(1)

		germ_level++
		owner.adjustToxLoss(1)

//Updating wounds. Handles wound natural I had some free spachealing, internal bleedings and infections
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
				owner.custom_pain("You feel a stabbing pain in your [name]!",1)

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
		if(!W.internal) //so IB doesn't count towards crit/paincrit
			if(W.damage_type == CUT || W.damage_type == BRUISE)
				brute_dam += W.damage
			else if(W.damage_type == BURN)
				burn_dam += W.damage

		if(!(status & ORGAN_ROBOT) && W.bleeding() && (H && !(H.species.flags & NO_BLOOD)))
			W.bleed_timer--
			status |= ORGAN_BLEEDING

		clamped |= W.clamped

		number_wounds += W.amount

	if (open && !clamped && (H && !(H.species.flags & NO_BLOOD)))	//things tend to bleed if they are CUT OPEN
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

//Handles dismemberment
/obj/item/organ/external/proc/droplimb(var/clean, var/disintegrate = DROPLIMB_EDGE, var/ignore_children = null)

	if(cannot_amputate || !owner)
		return

	switch(disintegrate)
		if(DROPLIMB_EDGE)
			if(!clean)
				owner.visible_message(
					"<span class='danger'>\The [owner]'s [src.name] flies off in an arc!</span>",\
					"<span class='moderate'><b>Your [src.name] goes flying off!</b></span>",\
					"<span class='danger'>You hear a terrible sound of ripping tendons and flesh.</span>")
		if(DROPLIMB_BURN)
			owner.visible_message(
				"<span class='danger'>\The [owner]'s [src.name] flashes away into ashes!</span>",\
				"<span class='moderate'><b>Your [src.name] flashes away into ashes!</b></span>",\
				"<span class='danger'>You hear the crackling sound of burning flesh.</span>")
		if(DROPLIMB_BLUNT)
			owner.visible_message(
				"<span class='danger'>\The [owner]'s [src.name] explodes in a shower of gore!</span>",\
				"<span class='moderate'><b>Your [src.name] explodes in a shower of gore!</b></span>",\
				"<span class='danger'>You hear the sickening splatter of gore.</span>")

	var/mob/living/carbon/human/victim = owner //Keep a reference for post-removed().
	var/obj/item/organ/external/parent_organ = parent
	removed(null, ignore_children)
	victim.traumatic_shock += 60

	wounds.Cut()
	if(parent_organ)
		var/datum/wound/lost_limb/W = new (src, disintegrate, clean)
		if(clean)
			parent_organ.wounds |= W
			parent_organ.update_damages()
		else
			var/obj/item/organ/external/stump/stump = new (victim, 0, src)
			stump.wounds |= W
			victim.organs |= stump
			stump.update_damages()

	spawn(1)
		victim.updatehealth()
		victim.UpdateDamageIcon()
		victim.regenerate_icons()
		dir = 2

	switch(disintegrate)
		if(DROPLIMB_EDGE)
			compile_icon()
			add_blood(victim)
			var/matrix/M = matrix()
			M.Turn(rand(180))
			src.transform = M
			if(!clean)
				// Throw limb around.
				if(src && istype(loc,/turf))
					throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)
				dir = 2
		if(DROPLIMB_BURN)
			new /obj/effect/decal/cleanable/ash(get_turf(victim))
			for(var/obj/item/I in src)
				if(I.w_class > 2 && !istype(I,/obj/item/organ))
					I.loc = get_turf(src)
			qdel(src)
		if(DROPLIMB_BLUNT)
			var/obj/effect/decal/cleanable/blood/gibs/gore = new victim.species.single_gib_type(get_turf(victim))
			if(victim.species.flesh_color)
				gore.fleshcolor = victim.species.flesh_color
			if(victim.species.blood_color)
				gore.basecolor = victim.species.blood_color
			gore.update_icon()
			gore.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)

			for(var/obj/item/organ/I in internal_organs)
				I.removed()
				if(istype(loc,/turf))
					I.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)

			for(var/obj/item/I in src)
				if(I.w_class <= 2)
					qdel(I)
					continue
				I.loc = get_turf(src)
				I.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)

			qdel(src)

/****************************************************
			   HELPERS
****************************************************/

/obj/item/organ/external/proc/is_stump()
	return 0

/obj/item/organ/external/proc/release_restraints(var/mob/living/carbon/human/holder)
	if(!holder)
		holder = owner
	if(!holder)
		return
	if (holder.handcuffed && body_part in list(ARM_LEFT, ARM_RIGHT, HAND_LEFT, HAND_RIGHT))
		holder.visible_message(\
			"\The [holder.handcuffed.name] falls off of [holder.name].",\
			"\The [holder.handcuffed.name] falls off you.")
		holder.drop_from_inventory(holder.handcuffed)
	if (holder.legcuffed && body_part in list(FOOT_LEFT, FOOT_RIGHT, LEG_LEFT, LEG_RIGHT))
		holder.visible_message(\
			"\The [holder.legcuffed.name] falls off of [holder.name].",\
			"\The [holder.legcuffed.name] falls off you.")
		holder.drop_from_inventory(holder.legcuffed)

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

	if((status & ORGAN_BROKEN) || cannot_break)
		return

	owner.visible_message(\
		"\red You hear a loud cracking sound coming from \the [owner].",\
		"\red <b>Something feels like it shattered in your [name]!</b>",\
		"You hear a sickening crack.")

	if(owner.species && !(owner.species.flags & NO_PAIN))
		owner.emote("scream")

	status |= ORGAN_BROKEN
	broken_description = pick("broken","fracture","hairline fracture")
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

			owner << "You feel \the [suit] constrict about your [name], supporting it."
			status |= ORGAN_SPLINTED
			suit.supporting_limbs |= src
	return

/obj/item/organ/external/proc/mend_fracture()
	if(status & ORGAN_ROBOT)
		return 0	//ORGAN_BROKEN doesn't have the same meaning for robot limbs
	if(brute_dam > min_broken_damage * config.organ_health_multiplier)
		return 0	//will just immediately fracture again

	status &= ~ORGAN_BROKEN
	return 1

/obj/item/organ/external/robotize(var/company)
	..()

	if(company)
		model = company
		var/datum/robolimb/R = all_robolimbs[company]
		if(R)
			force_icon = R.icon
			name = "[R.company] [initial(name)]"
			desc = "[R.desc]"

	dislocated = -1 //TODO, make robotic limbs a separate type, remove snowflake
	cannot_break = 1
	get_icon()
	unmutate()
	for (var/obj/item/organ/external/T in children)
		if(T)
			T.robotize()

/obj/item/organ/external/proc/mutate()
	if(src.status & ORGAN_ROBOT)
		return
	src.status |= ORGAN_MUTATED
	owner.update_body()

/obj/item/organ/external/proc/unmutate()
	src.status &= ~ORGAN_MUTATED
	owner.update_body()

/obj/item/organ/external/proc/get_damage()	//returns total damage
	return max(brute_dam + burn_dam - perma_injury, perma_injury)	//could use max_damage?

/obj/item/organ/external/proc/has_infected_wound()
	for(var/datum/wound/W in wounds)
		if(W.germ_level > INFECTION_LEVEL_ONE)
			return 1
	return 0

/obj/item/organ/external/proc/is_usable()
	return !is_dislocated() && !(status & (ORGAN_MUTATED|ORGAN_DEAD))

/obj/item/organ/external/proc/is_malfunctioning()
	return ((status & ORGAN_ROBOT) && (brute_dam + burn_dam) >= 10 && prob(brute_dam + burn_dam))

/obj/item/organ/external/proc/embed(var/obj/item/weapon/W, var/silent = 0)
	if(loc != owner)
		return
	if(!silent)
		owner.visible_message("<span class='danger'>\The [W] sticks in the wound!</span>")
	implants += W
	owner.embedded_flag = 1
	owner.verbs += /mob/proc/yank_out_object
	W.add_blood(owner)
	if(ismob(W.loc))
		var/mob/living/H = W.loc
		H.drop_from_inventory(W)
	W.loc = owner

/obj/item/organ/external/removed(var/mob/living/user, var/ignore_children = 0)

	if(!owner)
		return
	var/is_robotic = status & ORGAN_ROBOT
	var/mob/living/carbon/human/victim = owner

	..()

	victim.bad_external_organs -= src

	for(var/atom/movable/implant in implants)
		//large items and non-item objs fall to the floor, everything else stays
		var/obj/item/I = implant
		if(istype(I) && I.w_class < 3)
			implant.loc = get_turf(victim.loc)
		else
			implant.loc = src
	implants.Cut()

	// Attached organs also fly off.
	if(!ignore_children)
		for(var/obj/item/organ/external/O in children)
			O.removed()
			if(O)
				O.loc = src
				for(var/obj/item/I in O.contents)
					I.loc = src

	// Grab all the internal giblets too.
	for(var/obj/item/organ/organ in internal_organs)
		organ.removed()
		organ.loc = src

	// Remove parent references
	parent.children -= src
	parent = null

	release_restraints(victim)
	victim.organs -= src
	victim.organs_by_name[limb_name] = null // Remove from owner's vars.

	//Robotic limbs explode if sabotaged.
	if(is_robotic && sabotaged)
		victim.visible_message(
			"<span class='danger'>\The [victim]'s [src.name] explodes violently!</span>",\
			"<span class='danger'>Your [src.name] explodes!</span>",\
			"<span class='danger'>You hear an explosion!</span>")
		explosion(get_turf(owner),-1,-1,2,3)
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, victim)
		spark_system.attach(owner)
		spark_system.start()
		spawn(10)
			qdel(spark_system)
		qdel(src)

/obj/item/organ/external/proc/disfigure(var/type = "brute")
	if (disfigured)
		return
	if(owner)
		if(type == "brute")
			owner.visible_message("\red You hear a sickening cracking sound coming from \the [owner]'s [name].",	\
			"\red <b>Your [name] becomes a mangled mess!</b>",	\
			"\red You hear a sickening crack.")
		else
			owner.visible_message("\red \The [owner]'s [name] melts away, turning into mangled mess!",	\
			"\red <b>Your [name] melts away!</b>",	\
			"\red You hear a sickening sizzle.")
	disfigured = 1

/obj/item/organ/external/proc/get_wounds_desc()
	. = ""
	if(status & ORGAN_ROBOT)
		if(brute_dam)
			switch(brute_dam)
				if(0 to 20)
					. += " some dents"
				if(21 to INFINITY)
					. += pick(" a lot of dents"," severe denting")
		if(brute_dam && burn_dam)
			. += " and"
		if(burn_dam)
			switch(burn_dam)
				if(0 to 20)
					. += " some burns"
				if(21 to INFINITY)
					. += pick(" a lot of burns"," severe melting")
		return

	var/list/wound_descriptors = list()
	if(open > 1)
		wound_descriptors["an open incision"] = 1
	else if (open)
		wound_descriptors["an incision"] = 1
	for(var/datum/wound/W in wounds)
		if(W.internal && !open) continue // can't see internal wounds
		var/this_wound_desc = W.desc
		if(W.damage_type == BURN && W.salved) this_wound_desc = "salved [this_wound_desc]"
		if(W.bleeding()) this_wound_desc = "bleeding [this_wound_desc]"
		else if(W.bandaged) this_wound_desc = "bandaged [this_wound_desc]"
		if(W.germ_level > 600) this_wound_desc = "badly infected [this_wound_desc]"
		else if(W.germ_level > 330) this_wound_desc = "lightly infected [this_wound_desc]"
		if(wound_descriptors[this_wound_desc])
			wound_descriptors[this_wound_desc] += W.amount
		else
			wound_descriptors[this_wound_desc] = W.amount

	if(wound_descriptors.len)
		var/list/flavor_text = list()
		var/list/no_exclude = list("gaping wound", "big gaping wound", "massive wound", "large bruise",\
		"huge bruise", "massive bruise", "severe burn", "large burn", "deep burn", "carbonised area") //note to self make this more robust
		for(var/wound in wound_descriptors)
			switch(wound_descriptors[wound])
				if(1)
					flavor_text += "[prob(10) && !(wound in no_exclude) ? "what might be " : ""]a [wound]"
				if(2)
					flavor_text += "[prob(10) && !(wound in no_exclude) ? "what might be " : ""]a pair of [wound]s"
				if(3 to 5)
					flavor_text += "several [wound]s"
				if(6 to INFINITY)
					flavor_text += "a ton of [wound]\s"
		return english_list(flavor_text)
/****************************************************
			   ORGAN DEFINES
****************************************************/

/obj/item/organ/external/chest
	name = "upper body"
	limb_name = "chest"
	icon_name = "torso"
	max_damage = 100
	min_broken_damage = 35
	w_class = 5
	body_part = UPPER_TORSO
	vital = 1
	amputation_point = "spine"
	joint = "neck"
	dislocated = -1
	gendered_icon = 1
	cannot_amputate = 1
	parent_organ = null
	encased = "ribcage"

/obj/item/organ/external/groin
	name = "lower body"
	limb_name = "groin"
	icon_name = "groin"
	max_damage = 100
	min_broken_damage = 35
	w_class = 5
	body_part = LOWER_TORSO
	vital = 1
	parent_organ = "chest"
	amputation_point = "lumbar"
	joint = "hip"
	dislocated = -1
	gendered_icon = 1

/obj/item/organ/external/arm
	limb_name = "l_arm"
	name = "left arm"
	icon_name = "l_arm"
	max_damage = 50
	min_broken_damage = 30
	w_class = 3
	body_part = ARM_LEFT
	parent_organ = "chest"
	joint = "left elbow"
	amputation_point = "left shoulder"
	can_grasp = 1

/obj/item/organ/external/arm/right
	limb_name = "r_arm"
	name = "right arm"
	icon_name = "r_arm"
	body_part = ARM_RIGHT
	joint = "right elbow"
	amputation_point = "right shoulder"

/obj/item/organ/external/leg
	limb_name = "l_leg"
	name = "left leg"
	icon_name = "l_leg"
	max_damage = 50
	min_broken_damage = 30
	w_class = 3
	body_part = LEG_LEFT
	icon_position = LEFT
	parent_organ = "groin"
	joint = "left knee"
	amputation_point = "left hip"
	can_stand = 1

/obj/item/organ/external/leg/right
	limb_name = "r_leg"
	name = "right leg"
	icon_name = "r_leg"
	body_part = LEG_RIGHT
	icon_position = RIGHT
	joint = "right knee"
	amputation_point = "right hip"

/obj/item/organ/external/foot
	limb_name = "l_foot"
	name = "left foot"
	icon_name = "l_foot"
	min_broken_damage = 15
	w_class = 2
	body_part = FOOT_LEFT
	icon_position = LEFT
	parent_organ = "l_leg"
	joint = "left ankle"
	amputation_point = "left ankle"
	can_stand = 1

/obj/item/organ/external/foot/removed()
	if(owner) owner.u_equip(owner.shoes)
	..()

/obj/item/organ/external/foot/right
	limb_name = "r_foot"
	name = "right foot"
	icon_name = "r_foot"
	body_part = FOOT_RIGHT
	icon_position = RIGHT
	parent_organ = "r_leg"
	joint = "right ankle"
	amputation_point = "right ankle"

/obj/item/organ/external/hand
	limb_name = "l_hand"
	name = "left hand"
	icon_name = "l_hand"
	min_broken_damage = 15
	w_class = 2
	body_part = HAND_LEFT
	parent_organ = "l_arm"
	joint = "left wrist"
	amputation_point = "left wrist"
	can_grasp = 1

/obj/item/organ/external/hand/removed()
	owner.u_equip(owner.gloves)
	..()

/obj/item/organ/external/hand/right
	limb_name = "r_hand"
	name = "right hand"
	icon_name = "r_hand"
	body_part = HAND_RIGHT
	parent_organ = "r_arm"
	joint = "right wrist"
	amputation_point = "right wrist"

/obj/item/organ/external/head
	limb_name = "head"
	icon_name = "head"
	name = "head"
	max_damage = 75
	min_broken_damage = 35
	w_class = 3
	body_part = HEAD
	vital = 1
	parent_organ = "chest"
	joint = "jaw"
	amputation_point = "neck"
	gendered_icon = 1
	encased = "skull"

/obj/item/organ/external/head/removed()
	if(owner)
		name = "[owner.real_name]'s head"
		owner.u_equip(owner.glasses)
		owner.u_equip(owner.head)
		owner.u_equip(owner.l_ear)
		owner.u_equip(owner.r_ear)
		owner.u_equip(owner.wear_mask)
		spawn(1)
			owner.update_hair()
	..()

/obj/item/organ/external/head/take_damage(brute, burn, sharp, edge, used_weapon = null, list/forbidden_limbs = list())
	..(brute, burn, sharp, edge, used_weapon, forbidden_limbs)
	if (!disfigured)
		if (brute_dam > 40)
			if (prob(50))
				disfigure("brute")
		if (burn_dam > 40)
			disfigure("burn")
