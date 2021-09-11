/****************************************************
				EXTERNAL ORGANS
****************************************************/

/obj/item/organ/external
	name = "external"
	min_broken_damage = 30
	dir = SOUTH
	organ_tag = "limb"
	appearance_flags = DEFAULT_APPEARANCE_FLAGS | PIXEL_SCALE

	var/slowdown = 0

	// Strings
	var/broken_description             // fracture string if any.
	var/damage_state = "00"            // Modifier used for generating the on-mob damage overlay for this limb.

	// Damage vars.
	var/brute_dam = 0                  // Actual current brute damage.
	var/brute_ratio = 0                // Ratio of current brute damage to max damage.
	var/burn_dam = 0                   // Actual current burn damage.
	var/burn_ratio = 0                 // Ratio of current burn damage to max damage.
	var/last_dam = -1                  // used in healing/processing calculations.
	var/pain = 0                       // How much the limb hurts.
	var/pain_disability_threshold      // Point at which a limb becomes unusable due to pain.

	// A bitfield for a collection of limb behavior flags.
	var/limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_BREAK

	// Appearance vars.
	var/icon_name = null               // Icon state base.
	var/body_part = null               // Part flag
	var/icon_position = 0              // Used in mob overlay layering calculations.
	var/model                          // Used when caching robolimb icons.
	var/force_icon                     // Used to force override of species-specific limb icons (for prosthetics).
	var/icon/mob_icon                  // Cached icon for use in mob overlays.
	var/s_tone                         // Skin tone.
	var/s_base = ""                    // Skin base.
	var/list/s_col                     // skin colour
	var/s_col_blend = ICON_ADD         // How the skin colour is applied.
	var/list/h_col                     // hair colour
	var/body_hair                      // Icon blend for body hair if any.
	var/list/markings = list()         // Markings (body_markings) to apply to the icon

	// Wound and structural data.
	var/wound_update_accuracy = 1      // how often wounds should be updated, a higher number means less often
	var/list/wounds                    // wound datum list.
	var/number_wounds = 0              // number of wounds, which is NOT wounds.len!
	var/obj/item/organ/external/parent // Master-limb.
	var/list/children                  // Sub-limbs.
	var/list/internal_organs = list()  // Internal organs of this body part
	var/list/implants = list()         // Currently implanted objects.
	var/base_miss_chance = 20          // Chance of missing.
	var/genetic_degradation = 0        // Amount of current genetic damage.

	//Forensics stuff
	var/list/autopsy_data = list()    // Trauma data for forensics.

	// Joint/state stuff.
	var/joint = "joint"                // Descriptive string used in dislocation.
	var/amputation_point               // Descriptive string used in amputation.
	var/dislocated = 0                 // If you target a joint, you can dislocate the limb, causing temporary damage to the organ.
	var/encased                        // Needs to be opened with a saw to access the organs.
	var/artery_name = "artery"         // Flavour text for carotid artery, aorta, etc.
	var/arterial_bleed_severity = 1    // Multiplier for bleeding in a limb.
	var/tendon_name = "tendon"         // Flavour text for Achilles tendon, etc.
	var/cavity_name = "cavity"

	// Surgery vars.
	var/cavity_max_w_class = ITEM_SIZE_TINY //this is increased if bigger organs spawn by default inside
	var/hatch_state = 0
	var/stage = 0
	var/cavity = 0
	var/atom/movable/applied_pressure
	var/atom/movable/splinted

	// HUD element variable, see organ_icon.dm get_damage_hud_image()
	var/image/hud_damage_image

/obj/item/organ/external/proc/get_fingerprint()

	if((limb_flags & ORGAN_FLAG_FINGERPRINT) && dna && !is_stump() && !BP_IS_ROBOTIC(src))
		return md5(dna.uni_identity)

	for(var/obj/item/organ/external/E in children)
		var/print = E.get_fingerprint()
		if(print)
			return print

/obj/item/organ/external/afterattack(atom/A, mob/user, proximity)
	..()
	if(proximity && get_fingerprint())
		A.add_partial_print(get_fingerprint())

/obj/item/organ/external/New(var/mob/living/carbon/holder)
	..()
	if(isnull(pain_disability_threshold))
		pain_disability_threshold = (max_damage * 0.75)
	if(owner)
		replaced(owner)
		sync_colour_to_human(owner)
	get_icon()

	slowdown = species.get_slowdown(owner)

/obj/item/organ/external/Destroy()

	if(wounds)
		for(var/datum/wound/wound in wounds)
			qdel(wound)

	if(parent && parent.children)
		parent.children -= src
		parent = null

	if(children)
		for(var/obj/item/organ/external/C in children)
			qdel(C)

	if(internal_organs)
		for(var/obj/item/organ/O in internal_organs)
			qdel(O)

	applied_pressure = null
	if(splinted && splinted.loc == src)
		qdel(splinted)
	splinted = null

	if(owner)
		if(limb_flags & ORGAN_FLAG_CAN_GRASP) owner.grasp_limbs -= src
		if(limb_flags & ORGAN_FLAG_CAN_STAND) owner.stance_limbs -= src
		owner.organs -= src
		owner.organs_by_name[organ_tag] = null
		owner.organs_by_name -= organ_tag
		while(null in owner.organs)
			owner.organs -= null

	if(autopsy_data)    autopsy_data.Cut()

	return ..()

/obj/item/organ/external/set_dna(var/datum/dna/new_dna)
	..()
	s_col_blend = species.limb_blend
	s_base = new_dna.s_base

/obj/item/organ/external/emp_act(severity)

	if(!BP_IS_ROBOTIC(src))
		return

	if(owner && BP_IS_CRYSTAL(src)) // Crystalline robotics == piezoelectrics.
		owner.Weaken(4 - severity)
		owner.confused = max(owner.confused, 6 - (severity * 2))
		return

	var/burn_damage = 0
	switch (severity)
		if (1)
			burn_damage = 30
		if (2)
			burn_damage = 15
		if (3)
			burn_damage = 7.5

	var/mult = 1 + !!(BP_IS_ASSISTED(src)) // This macro returns (large) bitflags.
	burn_damage *= mult/species.get_burn_mod(owner) //ignore burn mod for EMP damage

	var/power = 4 - severity //stupid reverse severity
	for(var/obj/item/I in implants)
		if(I.obj_flags & OBJ_FLAG_CONDUCTIBLE)
			burn_damage += I.w_class * rand(power, 3*power)

	if(owner && burn_damage)
		owner.custom_pain("Something inside your [src] burns a [severity < 2 ? "bit" : "lot"]!", power * 15) //robotic organs won't feel it anyway
		take_external_damage(0, burn_damage, 0, used_weapon = "Hot metal")

	if(owner && limb_flags & ORGAN_FLAG_CAN_GRASP)
		owner.grasp_damage_disarm(src)

	if(owner && limb_flags & ORGAN_FLAG_CAN_STAND)
		owner.stance_damage_prone(src)

/obj/item/organ/external/attack_self(var/mob/user)
	if((owner && loc == owner) || !contents.len)
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
		I.forceMove(get_turf(user)) //just in case something was embedded that is not an item
		if(istype(I))
			if(!(user.l_hand && user.r_hand))
				user.put_in_hands(I)
		user.visible_message("<span class='danger'>\The [user] rips \the [I] out of \the [src]!</span>")
		return //no eating the limb until everything's been removed
	return ..()

/obj/item/organ/external/examine(mob/user, distance)
	. = ..()
	if(distance <= 1 || isghost(user))
		for(var/obj/item/I in contents)
			if(istype(I, /obj/item/organ))
				continue
			to_chat(user, "<span class='danger'>There is \a [I] sticking out of it.</span>")
		var/ouchies = get_wounds_desc()
		if(ouchies != "nothing")
			to_chat(user, "<span class='notice'>There is [ouchies] visible on it.</span>")

	return

/obj/item/organ/external/show_decay_status(mob/user)
	..(user)
	for(var/obj/item/organ/external/child in children)
		child.show_decay_status(user)

/obj/item/organ/external/attackby(obj/item/W as obj, mob/user as mob)
	switch(stage)
		if(0)
			if(W.sharp)
				user.visible_message("<span class='danger'><b>[user]</b> cuts [src] open with [W]!</span>")
				stage++
				return
		if(1)
			if(istype(W))
				user.visible_message("<span class='danger'><b>[user]</b> cracks [src] open like an egg with [W]!</span>")
				stage++
				return
		if(2)
			if(W.sharp || istype(W,/obj/item/hemostat) || isWirecutter(W))
				var/list/organs = get_contents_recursive()
				if(organs.len)
					var/obj/item/removing = pick(organs)
					var/obj/item/organ/external/current_child = removing.loc

					current_child.implants.Remove(removing)
					current_child.internal_organs.Remove(removing)

					status |= ORGAN_CUT_AWAY
					if(istype(removing, /obj/item/organ/internal/mmi_holder))
						var/obj/item/organ/internal/mmi_holder/O = removing
						removing = O.transfer_and_delete()

					removing.forceMove(get_turf(user))

					if(!(user.l_hand && user.r_hand))
						user.put_in_hands(removing)
					user.visible_message("<span class='danger'><b>[user]</b> extracts [removing] from [src] with [W]!</span>")
				else
					user.visible_message("<span class='danger'><b>[user]</b> fishes around fruitlessly in [src] with [W].</span>")
				return
	..()


/**
 *  Get a list of contents of this organ and all the child organs
 */
/obj/item/organ/external/proc/get_contents_recursive()
	var/list/all_items = list()

	all_items.Add(implants)
	all_items.Add(internal_organs)

	for(var/obj/item/organ/external/child in children)
		all_items.Add(child.get_contents_recursive())

	return all_items

/obj/item/organ/external/proc/is_dislocated()
	if(dislocated > 0)
		return 1
	if(is_parent_dislocated())
		return 1//if any parent is dislocated, we are considered dislocated as well
	return 0

/obj/item/organ/external/proc/is_parent_dislocated()
	var/obj/item/organ/external/O = parent
	while(O && O.dislocated != -1)
		if(O.dislocated == 1)
			return 1
		O = O.parent
	return 0


/obj/item/organ/external/proc/dislocate()
	if(dislocated == -1)
		return

	dislocated = 1
	if(owner)
		owner.verbs |= /mob/living/carbon/human/proc/undislocate

/obj/item/organ/external/proc/undislocate()
	if(dislocated == -1)
		return

	dislocated = 0
	if(owner)
		owner.shock_stage += 20

		//check to see if we still need the verb
		for(var/obj/item/organ/external/limb in owner.organs)
			if(limb.dislocated == 1)
				return
		owner.verbs -= /mob/living/carbon/human/proc/undislocate

/obj/item/organ/external/update_health()
	damage = min(max_damage, (brute_dam + burn_dam))
	return


/obj/item/organ/external/replaced(var/mob/living/carbon/human/target)
	..()

	if(istype(owner))

		if(limb_flags & ORGAN_FLAG_CAN_GRASP) owner.grasp_limbs[src] = TRUE
		if(limb_flags & ORGAN_FLAG_CAN_STAND) owner.stance_limbs[src] = TRUE
		owner.organs_by_name[organ_tag] = src
		owner.organs |= src

		for(var/obj/item/organ/organ in internal_organs)
			organ.replaced(owner, src)

		for(var/obj/implant in implants)
			implant.forceMove(owner)

			if(istype(implant, /obj/item/implant))
				var/obj/item/implant/imp_device = implant

				// we can't use implanted() here since it's often interactive
				imp_device.imp_in = owner
				imp_device.implanted = 1

		for(var/obj/item/organ/external/organ in children)
			organ.replaced(owner)

	if(!parent && parent_organ)
		parent = owner.organs_by_name[src.parent_organ]
		if(parent)
			if(!parent.children)
				parent.children = list()
			parent.children.Add(src)
			//Remove all stump wounds since limb is not missing anymore
			for(var/datum/wound/lost_limb/W in parent.wounds)
				qdel(W)
				break
			parent.update_damages()

//Helper proc used by various tools for repairing robot limbs
/obj/item/organ/external/proc/robo_repair(var/repair_amount, var/damage_type, var/damage_desc, obj/item/tool, mob/living/user)
	if((!BP_IS_ROBOTIC(src)))
		return 0

	var/damage_amount
	switch(damage_type)
		if(BRUTE) damage_amount = brute_dam
		if(BURN)  damage_amount = burn_dam
		else return 0

	if(!damage_amount)
		if(src.hatch_state != HATCH_OPENED)
			to_chat(user, "<span class='notice'>Nothing to fix!</span>")
		return 0

	if(damage_amount >= ROBOLIMB_SELF_REPAIR_CAP)
		to_chat(user, "<span class='danger'>The damage is far too severe to patch over externally.</span>")
		return 0

	if(user == src.owner)
		var/grasp
		if(user.l_hand == tool && (src.body_part & (ARM_LEFT|HAND_LEFT)))
			grasp = BP_L_HAND
		else if(user.r_hand == tool && (src.body_part & (ARM_RIGHT|HAND_RIGHT)))
			grasp = BP_R_HAND

		if(grasp)
			to_chat(user, "<span class='warning'>You can't reach your [src.name] while holding [tool] in your [owner.get_bodypart_name(grasp)].</span>")
			return 0

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!do_after(user, 1 SECOND, owner))
		to_chat(user, "<span class='warning'>You must stand still to do that.</span>")
		return 0

	switch(damage_type)
		if(BRUTE) src.heal_damage(repair_amount, 0, 0, 1)
		if(BURN)  src.heal_damage(0, repair_amount, 0, 1)
	owner.regenerate_icons()
	if(user == src.owner)
		user.visible_message("<span class='notice'>\The [user] patches [damage_desc] on \his [src.name] with [tool].</span>")
	else
		user.visible_message("<span class='notice'>\The [user] patches [damage_desc] on [owner]'s [src.name] with [tool].</span>")

	return 1


/*
This function completely restores a damaged organ to perfect condition.
*/
/obj/item/organ/external/rejuvenate(var/ignore_prosthetic_prefs)
	damage_state = "00"

	status = 0
	brute_dam = 0
	burn_dam = 0
	germ_level = 0
	pain = 0
	genetic_degradation = 0
	for(var/datum/wound/wound in wounds)
		qdel(wound)
	number_wounds = 0

	// handle internal organs
	for(var/obj/item/organ/current_organ in internal_organs)
		current_organ.rejuvenate(ignore_prosthetic_prefs)

	// remove embedded objects and drop them on the floor
	for(var/obj/implanted_object in implants)
		if(!istype(implanted_object,/obj/item/implant))	// We don't want to remove REAL implants. Just shrapnel etc.
			implanted_object.forceMove(get_turf(src))
			implants -= implanted_object

	if(owner && !ignore_prosthetic_prefs)
		if(owner.client && owner.client.prefs && owner.client.prefs.real_name == owner.real_name)
			var/status = owner.client.prefs.organ_data[organ_tag]
			if(status == "amputated")
				remove_rejuv()
			else if(status == "cyborg")
				var/robodata = owner.client.prefs.rlimb_data[organ_tag]
				if(robodata)
					robotize(robodata)
				else
					robotize()
		owner.updatehealth()

	if(!QDELETED(src) && species)
		species.post_organ_rejuvenate(src, owner)

/obj/item/organ/external/remove_rejuv()
	if(owner)
		owner.organs -= src
		owner.organs_by_name[organ_tag] = null
		owner.organs_by_name -= organ_tag
		while(null in owner.organs) owner.organs -= null
	if(LAZYLEN(children))
		for(var/obj/item/organ/external/E in children)
			E.remove_rejuv()
		children.Cut()
	for(var/obj/item/organ/internal/I in internal_organs)
		I.remove_rejuv()
	..()

/obj/item/organ/external/proc/createwound(var/type = CUT, var/damage, var/surgical)

	if(damage <= 0)
		return

	if(BP_IS_CRYSTAL(src) && (damage >= 15 || prob(1)))
		type = SHATTER
		playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 40, 1) // Crash!

	//moved these before the open_wound check so that having many small wounds for example doesn't somehow protect you from taking internal damage (because of the return)
	//Brute damage can possibly trigger an internal wound, too.
	var/local_damage = brute_dam + burn_dam + damage
	if(!surgical && (type in list(CUT, PIERCE, BRUISE)) && damage > 15 && local_damage > 30)

		var/internal_damage
		if(prob(damage) && sever_artery())
			internal_damage = TRUE
		if(prob(ceil(damage/4)) && sever_tendon())
			internal_damage = TRUE
		if(internal_damage)
			owner.custom_pain("You feel something rip in your [name]!", 50, affecting = src)

	//Burn damage can cause fluid loss due to blistering and cook-off
	if((type in list(BURN, LASER)) && (damage > 5 || damage + burn_dam >= 15) && !BP_IS_ROBOTIC(src))
		var/fluid_loss_severity
		switch(type)
			if(BURN)  fluid_loss_severity = FLUIDLOSS_WIDE_BURN
			if(LASER) fluid_loss_severity = FLUIDLOSS_CONC_BURN
		var/fluid_loss = (damage/(owner.maxHealth - config.health_threshold_dead)) * SPECIES_BLOOD_DEFAULT * fluid_loss_severity
		owner.remove_blood(fluid_loss)

	// first check whether we can widen an existing wound
	if(!surgical && LAZYLEN(wounds) && prob(max(50+(number_wounds-1)*10,90)))
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
					if(BP_IS_CRYSTAL(src))
						owner.visible_message("<span class='danger'>The cracks in \the [owner]'s [name] spread.</span>",\
						"<span class='danger'>The cracks in your [name] spread.</span>",\
						"<span class='danger'>You hear the cracking of crystal.</span>")
					else if(BP_IS_ROBOTIC(src))
						owner.visible_message("<span class='danger'>The damage to \the [owner]'s [name] worsens.</span>",\
						"<span class='danger'>The damage to your [name] worsens.</span>",\
						"<span class='danger'>You hear the screech of abused metal.</span>")
					else
						owner.visible_message("<span class='danger'>The wound on \the [owner]'s [name] widens with a nasty ripping noise.</span>",\
						"<span class='danger'>The wound on your [name] widens with a nasty ripping noise.</span>",\
						"<span class='danger'>You hear a nasty ripping noise, as if flesh is being torn apart.</span>")
				return W

	//Creating wound
	var/wound_type = get_wound_type(type, damage)

	if(wound_type)
		var/datum/wound/W = new wound_type(damage, src)

		//Check whether we can add the wound to an existing wound
		if(surgical)
			W.autoheal_cutoff = 0
		else
			for(var/datum/wound/other in wounds)
				if(other.can_merge(W))
					other.merge_wound(W)
					return
		LAZYADD(wounds, W)
		return W

/****************************************************
			   PROCESSING & UPDATING
****************************************************/

//external organs handle brokenness a bit differently when it comes to damage.
/obj/item/organ/external/is_broken()
	return ((status & ORGAN_CUT_AWAY) || ((status & ORGAN_BROKEN) && !splinted))

//Determines if we even need to process this organ.
/obj/item/organ/external/proc/need_process()
	if(get_pain())
		return 1
	if(status & (ORGAN_CUT_AWAY|ORGAN_BLEEDING|ORGAN_BROKEN|ORGAN_DEAD|ORGAN_MUTATED))
		return 1
	if((brute_dam || burn_dam) && !BP_IS_ROBOTIC(src)) //Robot limbs don't autoheal and thus don't need to process when damaged
		return 1
	if(last_dam != brute_dam + burn_dam) // Process when we are fully healed up.
		last_dam = brute_dam + burn_dam
		return 1
	else
		last_dam = brute_dam + burn_dam
	if(germ_level)
		return 1
	return 0

/obj/item/organ/external/Process()
	if(owner)

		if(pain)
			pain -= owner.lying ? 3 : 1
			if(pain<0)
				pain = 0

		// Process wounds, doing healing etc. Only do this every few ticks to save processing power
		if(owner.life_tick % wound_update_accuracy == 0)
			update_wounds()

		//Infections
		update_germs()
	else
		pain = 0
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
INFECTION_LEVEL_TWO		above this germ level the infection will start to spread to internal and adjacent organs and rest will be required to recover
INFECTION_LEVEL_THREE	above this germ level the player will take additional toxin damage per second, and will die in minutes without
						antitox. also, above this germ level you will need to overdose on spaceacillin and get rest to reduce the germ_level.

Note that amputating the affected organ does in fact remove the infection from the player's body.
*/
/obj/item/organ/external/proc/update_germs()

	if(BP_IS_ROBOTIC(src) || BP_IS_CRYSTAL(src) || (owner.species && owner.species.species_flags & SPECIES_FLAG_IS_PLANT)) //Robotic limbs shouldn't be infected, nor should nonexistant limbs.
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
	var/turf/simulated/T = get_turf(owner)
	for(var/datum/wound/W in wounds)
		//Open wounds can become infected
		if(max(istype(T) && T.dirt*10, 2*owner.germ_level) > W.germ_level && W.infection_check())
			W.germ_level++

	var/antibiotics = owner.chem_effects[CE_ANTIBIOTIC]
	if (!antibiotics)
		for(var/datum/wound/W in wounds)
			//Infected wounds raise the organ's germ level
			if (W.germ_level > germ_level || prob(min(W.germ_level, 30)))
				germ_level++
				break	//limit increase to a maximum of one per second

/obj/item/organ/external/handle_germ_effects()

	if(germ_level < INFECTION_LEVEL_TWO)
		return ..()

	var/antibiotics = owner.reagents.get_reagent_amount(/datum/reagent/spaceacillin)

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
				if (child.germ_level < germ_level && !BP_IS_ROBOTIC(child))
					if (child.germ_level < INFECTION_LEVEL_ONE*2 || prob(30))
						child.germ_level++

		if (parent)
			if (parent.germ_level < germ_level && !BP_IS_ROBOTIC(parent))
				if (parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(30))
					parent.germ_level++

	if(germ_level >= INFECTION_LEVEL_THREE && antibiotics < REAGENTS_OVERDOSE)	//overdosing is necessary to stop severe infections
		if (!(status & ORGAN_DEAD))
			status |= ORGAN_DEAD
			to_chat(owner, "<span class='notice'>You can't feel your [name] anymore...</span>")
			owner.update_body(1)

		germ_level++
		owner.adjustToxLoss(1)

//Updating wounds. Handles wound natural I had some free spachealing, internal bleedings and infections
/obj/item/organ/external/proc/update_wounds()

	var/update_surgery
	if(BP_IS_ROBOTIC(src) || BP_IS_CRYSTAL(src)) //Robotic limbs don't heal or get worse.
		for(var/datum/wound/W in wounds) //Repaired wounds disappear though
			if(W.damage <= 0)  //and they disappear right away
				qdel(W)    //TODO: robot wounds for robot limbs
				update_surgery = TRUE
		if(owner && update_surgery)
			owner.update_surgery()
		return

	for(var/datum/wound/W in wounds)
		// wounds can disappear after 10 minutes at the earliest
		if(W.damage <= 0 && W.created + (10 MINUTES) <= world.time)
			qdel(W)
			update_surgery = TRUE
			continue
			// let the GC handle the deletion of the wound

		// slow healing
		var/heal_amt = 0
		// if damage >= 50 AFTER treatment then it's probably too severe to heal within the timeframe of a round.
		if (!owner.chem_effects[CE_TOXIN] && W.can_autoheal() && W.wound_damage() && brute_ratio < 0.5 && burn_ratio < 0.5)
			heal_amt += 0.5

		//we only update wounds once in [wound_update_accuracy] ticks so have to emulate realtime
		heal_amt = heal_amt * wound_update_accuracy
		//configurable regen speed woo, no-regen hardcore or instaheal hugbox, choose your destiny
		heal_amt = heal_amt * config.organ_regeneration_multiplier
		// amount of healing is spread over all the wounds
		heal_amt = heal_amt / (LAZYLEN(wounds) + 1)
		// making it look prettier on scanners
		heal_amt = round(heal_amt,0.1)
		var/dam_type = BRUTE
		if(W.damage_type == BURN)
			dam_type = BURN
		if(owner.can_autoheal(dam_type))
			W.heal_damage(heal_amt)

	// sync the organ's damage with its wounds
	update_damages()
	if(owner)
		if(update_surgery)
			owner.update_surgery()
		if (update_damstate())
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

	//update damage counts
	var/bleeds = (!BP_IS_ROBOTIC(src) && !BP_IS_CRYSTAL(src))
	for(var/datum/wound/W in wounds)

		if(W.damage <= 0)
			qdel(W)
			continue

		if(W.damage_type == BURN)
			burn_dam += W.damage
		else
			brute_dam += W.damage

		if(bleeds && W.bleeding() && (H && H.should_have_organ(BP_HEART)))
			W.bleed_timer--
			status |= ORGAN_BLEEDING

		clamped |= W.clamped
		number_wounds += W.amount

	damage = brute_dam + burn_dam
	update_damage_ratios()

/obj/item/organ/external/proc/update_damage_ratios()
	var/limb_loss_threshold = max_damage
	brute_ratio = brute_dam / (limb_loss_threshold * 2)
	burn_ratio = burn_dam / (limb_loss_threshold * 2)

//Returns 1 if damage_state changed
/obj/item/organ/external/proc/update_damstate()
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
/obj/item/organ/external/proc/get_droplimb_messages_for(var/droptype, var/clean)

	if(BP_IS_CRYSTAL(src))
		playsound(src, "shatter", 70, 1)
		return list(
			"\The [owner]'s [src.name] shatters into a thousand pieces!",
			"Your [src.name] shatters into a thousand pieces!",
			"You hear the sound of something shattering!"
		)
	else
		switch(droptype)
			if(DROPLIMB_EDGE)
				if(!clean)
					var/gore_sound = "[BP_IS_ROBOTIC(src) ? "tortured metal" : "ripping tendons and flesh"]"
					return list(
						"\The [owner]'s [src.name] flies off in an arc!",
						"Your [src.name] goes flying off!",
						"You hear a terrible sound of [gore_sound]."
						)
			if(DROPLIMB_BURN)
				var/gore = "[BP_IS_ROBOTIC(src) ? "": " of burning flesh"]"
				return list(
					"\The [owner]'s [src.name] flashes away into ashes!",
					"Your [src.name] flashes away into ashes!",
					"You hear a crackling sound[gore]."
					)
			if(DROPLIMB_BLUNT)
				var/gore = "[BP_IS_ROBOTIC(src) ? "": " in shower of gore"]"
				var/gore_sound = "[BP_IS_ROBOTIC(src) ? "rending sound of tortured metal" : "sickening splatter of gore"]"
				return list(
					"\The [owner]'s [src.name] explodes[gore]!",
					"Your [src.name] explodes[gore]!",
					"You hear the [gore_sound]."
					)

//Handles dismemberment
/obj/item/organ/external/proc/droplimb(var/clean, var/disintegrate = DROPLIMB_EDGE, var/ignore_children, var/silent)

	if(!(limb_flags & ORGAN_FLAG_CAN_AMPUTATE) || !owner)
		return

	if(BP_IS_CRYSTAL(src) || (disintegrate == DROPLIMB_EDGE && species.limbs_are_nonsolid))
		disintegrate = DROPLIMB_BLUNT //splut

	var/list/organ_msgs = get_droplimb_messages_for(disintegrate, clean)
	if(LAZYLEN(organ_msgs) >= 3)
		owner.visible_message("<span class='danger'>[organ_msgs[1]]</span>", \
			"<span class='moderate'><b>[organ_msgs[2]]</b></span>", \
			"<span class='danger'>[organ_msgs[3]]</span>")

	var/mob/living/carbon/human/victim = owner //Keep a reference for post-removed().
	var/obj/item/organ/external/original_parent = parent

	var/use_flesh_colour = species.get_flesh_colour(owner)
	var/use_blood_colour = species.get_blood_colour(owner)

	add_pain(60)
	if(!clean)
		victim.shock_stage += min_broken_damage

	removed(null, ignore_children)
	if(QDELETED(src))
		return

	if(original_parent)
		var/datum/wound/lost_limb/W = new (src, disintegrate, clean)
		var/obj/item/organ/external/damaged_organ = original_parent
		if(!clean)
			var/obj/item/organ/external/stump/stump = new (victim, 0, src)
			stump.add_pain(max_damage)
			damaged_organ = stump
			if(disintegrate != DROPLIMB_BURN)
				stump.sever_artery()
		W.parent_organ = damaged_organ
		LAZYADD(damaged_organ.wounds, W)
		damaged_organ.update_damages()

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
			forceMove(get_turf(src))
			if(!clean)
				// Throw limb around.
				if(src && istype(loc,/turf))
					throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),30)
				dir = 2
		if(DROPLIMB_BURN)
			new /obj/effect/decal/cleanable/ash(get_turf(victim))
			for(var/obj/item/I in src)
				if(I.w_class > ITEM_SIZE_SMALL && !istype(I,/obj/item/organ))
					I.dropInto(loc)
			qdel(src)
		if(DROPLIMB_BLUNT)
			var/obj/gore
			if(BP_IS_CRYSTAL(src))
				gore = new /obj/item/material/shard(get_turf(victim), MATERIAL_CRYSTAL)
			else if(BP_IS_ROBOTIC(src))
				gore = new /obj/effect/decal/cleanable/blood/gibs/robot(get_turf(victim))
			else
				gore = new /obj/effect/decal/cleanable/blood/gibs(get_turf(victim))
				if(species)
					var/obj/effect/decal/cleanable/blood/gibs/G = gore
					G.fleshcolor = use_flesh_colour
					G.basecolor =  use_blood_colour
					G.update_icon()

			gore.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),30)

			for(var/obj/item/organ/I in internal_organs)
				I.removed()
				if(!QDELETED(I) && isturf(loc))
					I.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),30)

			for(var/obj/item/I in src)
				I.dropInto(loc)
				I.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),30)

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
	if (holder.handcuffed && (body_part in list(ARM_LEFT, ARM_RIGHT, HAND_LEFT, HAND_RIGHT)))
		holder.visible_message(\
			"\The [holder.handcuffed.name] falls off of [holder.name].",\
			"\The [holder.handcuffed.name] falls off you.")
		holder.drop_from_inventory(holder.handcuffed)

// checks if all wounds on the organ are bandaged
/obj/item/organ/external/proc/is_bandaged()
	for(var/datum/wound/W in wounds)
		if(!W.bandaged)
			return 0
	return 1

// checks if all wounds on the organ are salved
/obj/item/organ/external/proc/is_salved()
	for(var/datum/wound/W in wounds)
		if(!W.salved)
			return 0
	return 1

// checks if all wounds on the organ are disinfected
/obj/item/organ/external/proc/is_disinfected()
	for(var/datum/wound/W in wounds)
		if(!W.disinfected)
			return 0
	return 1

/obj/item/organ/external/proc/bandage()
	var/rval = 0
	status &= ~ORGAN_BLEEDING
	for(var/datum/wound/W in wounds)
		rval |= !W.bandaged
		W.bandaged = 1
	if(rval)
		owner.update_surgery()
	return rval

/obj/item/organ/external/proc/salve()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		rval |= !W.salved
		W.salved = 1
	return rval

/obj/item/organ/external/proc/disinfect()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		rval |= !W.disinfected
		W.disinfected = 1
		W.germ_level = 0
	return rval

/obj/item/organ/external/proc/clamp_organ()
	var/rval = 0
	src.status &= ~ORGAN_BLEEDING
	for(var/datum/wound/W in wounds)
		rval |= !W.clamped
		W.clamped = 1
	return rval

/obj/item/organ/external/proc/clamped()
	for(var/datum/wound/W in wounds)
		if(W.clamped)
			return 1

obj/item/organ/external/proc/remove_clamps()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		rval |= W.clamped
		W.clamped = 0
	return rval

// open incisions and expose implants
// this is the retract step of surgery
/obj/item/organ/external/proc/open_incision()
	var/datum/wound/W = get_incision()
	if(!W)	return
	W.open_wound(min(W.damage * 2, W.damage_list[1] - W.damage))

	if(!encased)
		for(var/obj/item/implant/I in implants)
			I.exposed()

/obj/item/organ/external/proc/fracture()
	if(!config.bones_can_break)
		return
	if(BP_IS_ROBOTIC(src))
		return	//ORGAN_BROKEN doesn't have the same meaning for robot limbs
	if((status & ORGAN_BROKEN) || !(limb_flags & ORGAN_FLAG_CAN_BREAK))
		return

	if(owner)
		owner.visible_message(\
			"<span class='danger'>You hear a loud cracking sound coming from \the [owner].</span>",\
			"<span class='danger'>Something feels like it shattered in your [name]!</span>",\
			"<span class='danger'>You hear a sickening crack.</span>")
		jostle_bone()
		if(can_feel_pain())
			owner.emote("scream")

	playsound(src.loc, "fracture", 100, 1, -2)
	status |= ORGAN_BROKEN
	broken_description = pick("broken","fracture","hairline fracture")

	// Fractures have a chance of getting you out of restraints
	if (prob(25))
		release_restraints()

	// This is mostly for the ninja suit to stop ninja being so crippled by breaks.
	// TODO: consider moving this to a suit proc or process() or something during
	// hardsuit rewrite.
	if(!splinted && owner && istype(owner.wear_suit, /obj/item/clothing/suit/space/rig))
		var/obj/item/clothing/suit/space/rig/suit = owner.wear_suit
		suit.handle_fracture(owner, src)

/obj/item/organ/external/proc/mend_fracture()
	if(BP_IS_ROBOTIC(src))
		return 0	//ORGAN_BROKEN doesn't have the same meaning for robot limbs
	if(brute_dam > min_broken_damage * config.organ_health_multiplier)
		return 0	//will just immediately fracture again

	status &= ~ORGAN_BROKEN
	return 1

/obj/item/organ/external/proc/apply_splint(var/atom/movable/splint)
	if(!splinted)
		splinted = splint
		if(!applied_pressure)
			applied_pressure = splint
		return 1
	return 0

/obj/item/organ/external/proc/remove_splint()
	if(splinted)
		if(splinted.loc == src)
			splinted.dropInto(owner? owner.loc : src.loc)
		if(applied_pressure == splinted)
			applied_pressure = null
		splinted = null
		return 1
	return 0

/obj/item/organ/external/robotize(var/company, var/skip_prosthetics = 0, var/keep_organs = 0)

	if(BP_IS_ROBOTIC(src))
		return

	..()


	if(company)
		var/datum/robolimb/R = all_robolimbs[company]
		if(!istype(R) || (species && (species.name in R.species_cannot_use)) || \
		 (species && !(species.get_bodytype(owner) in R.allowed_bodytypes)) || \
		 (R.applies_to_part.len && !(organ_tag in R.applies_to_part)))
			R = basic_robolimb
		else
			model = company
			force_icon = R.icon
			name = "robotic [initial(name)]"
			desc = "[R.desc] It looks like it was produced by [R.company]."

	dislocated = -1
	remove_splint()
	update_icon(1)
	unmutate()

	slowdown = 0

	for(var/obj/item/organ/external/T in children)
		T.robotize(company, 1)

	if(owner)

		if(!skip_prosthetics)
			owner.full_prosthetic = null // Will be rechecked next isSynthetic() call.

		if(!keep_organs)
			for(var/obj/item/organ/thing in internal_organs)
				if(istype(thing))
					if(thing.vital || BP_IS_ROBOTIC(thing))
						continue
					internal_organs -= thing
					owner.internal_organs_by_name[thing.organ_tag] = null
					owner.internal_organs_by_name -= thing.organ_tag
					owner.internal_organs.Remove(thing)
					qdel(thing)

		while(null in owner.internal_organs)
			owner.internal_organs -= null

	return 1

/obj/item/organ/external/proc/get_damage()	//returns total damage
	return (brute_dam+burn_dam)	//could use max_damage?

/obj/item/organ/external/proc/has_infected_wound()
	for(var/datum/wound/W in wounds)
		if(W.germ_level > INFECTION_LEVEL_ONE)
			return 1
	return 0

/obj/item/organ/external/is_usable()
	return ..() && !is_stump() && !(status & ORGAN_TENDON_CUT) && (!can_feel_pain() || get_pain() < pain_disability_threshold) && brute_ratio < 1 && burn_ratio < 1

/obj/item/organ/external/proc/is_malfunctioning()
	return (BP_IS_ROBOTIC(src) && (brute_dam + burn_dam) >= 10 && prob(brute_dam + burn_dam))

/obj/item/organ/external/proc/embed(var/obj/item/W, var/silent = 0, var/supplied_message, var/datum/wound/supplied_wound)
	if(!owner || loc != owner)
		return
	if(species.species_flags & SPECIES_FLAG_NO_EMBED)
		return
	if(!silent)
		if(supplied_message)
			owner.visible_message("<span class='danger'>[supplied_message]</span>")
		else
			owner.visible_message("<span class='danger'>\The [W] sticks in the wound!</span>")

	if(!supplied_wound)
		for(var/datum/wound/wound in wounds)
			if((wound.damage_type == CUT || wound.damage_type == PIERCE) && wound.damage >= W.w_class * 5)
				supplied_wound = wound
				break
	if(!supplied_wound)
		supplied_wound = createwound(PIERCE, W.w_class * 5)

	if(!supplied_wound || (W in supplied_wound.embedded_objects)) // Just in case.
		return

	LAZYADD(supplied_wound.embedded_objects, W)
	implants += W
	owner.embedded_flag = 1
	owner.verbs += /mob/proc/yank_out_object
	W.add_blood(owner)
	if(ismob(W.loc))
		var/mob/living/H = W.loc
		H.drop_from_inventory(W)
	W.forceMove(owner)

/obj/item/organ/external/removed(var/mob/living/user, var/ignore_children = 0)

	if(!owner)
		return

	if(limb_flags & ORGAN_FLAG_CAN_GRASP) owner.grasp_limbs -= src
	if(limb_flags & ORGAN_FLAG_CAN_STAND) owner.stance_limbs -= src

	switch(body_part)
		if(FOOT_LEFT, FOOT_RIGHT)
			owner.drop_from_inventory(owner.shoes)
		if(HAND_LEFT, HAND_RIGHT)
			owner.drop_from_inventory(owner.gloves)
		if(HEAD)
			owner.drop_from_inventory(owner.glasses)
			owner.drop_from_inventory(owner.head)
			owner.drop_from_inventory(owner.l_ear)
			owner.drop_from_inventory(owner.r_ear)
			owner.drop_from_inventory(owner.wear_mask)

	var/mob/living/carbon/human/victim = owner
	var/is_robotic = BP_IS_ROBOTIC(src)

	..()

	victim.bad_external_organs -= src

	remove_splint()
	for(var/atom/movable/implant in implants)
		//large items and non-item objs fall to the floor, everything else stays
		var/obj/item/I = implant
		if(istype(I) && I.w_class < ITEM_SIZE_NORMAL)
			implant.forceMove(src)

			// let actual implants still inside know they're no longer implanted
			if(istype(I, /obj/item/implant))
				var/obj/item/implant/imp_device = I
				imp_device.removed()
		else
			implants.Remove(implant)
			implant.forceMove(get_turf(src))

	// Attached organs also fly off.
	if(!ignore_children)
		for(var/obj/item/organ/external/O in children)
			O.removed()
			if(!QDELETED(O))
				O.forceMove(src)

				// if we didn't lose the organ we still want it as a child
				children += O
				O.parent = src

	// Grab all the internal giblets too.
	for(var/obj/item/organ/organ in internal_organs)
		organ.removed(user, 0, 0)  // Organ stays inside and connected
		if(!QDELETED(organ))
			organ.forceMove(src)

	// Remove parent references
	if(parent)
		parent.children -= src
		parent = null

	if(!is_robotic)
		status |= ORGAN_CUT_AWAY

	release_restraints(victim)
	victim.organs -= src
	victim.organs_by_name[organ_tag] = null // Remove from owner's vars.
	victim.organs_by_name -= organ_tag

	//Robotic limbs explode if sabotaged.
	if(is_robotic && (status & ORGAN_SABOTAGED))
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
	else if(is_stump())
		qdel(src)

/obj/item/organ/external/proc/disfigure(var/type = "brute")
	if(status & ORGAN_DISFIGURED)
		return
	if(owner)
		if(type == "brute")
			owner.visible_message("<span class='danger'>You hear a sickening cracking sound coming from \the [owner]'s [name].</span>",	\
			"<span class='danger'>Your [name] becomes a mangled mess!</span>",	\
			"<span class='danger'>You hear a sickening crack.</span>")
		else
			owner.visible_message("<span class='danger'>\The [owner]'s [name] melts away, turning into mangled mess!</span>",	\
			"<span class='danger'>Your [name] melts away!</span>",	\
			"<span class='danger'>You hear a sickening sizzle.</span>")
	status |= ORGAN_DISFIGURED

/obj/item/organ/external/proc/get_incision(var/strict)

	var/datum/wound/incision
	if(BP_IS_CRYSTAL(src))
		for(var/datum/wound/shatter/other in wounds)
			if(!incision || incision.damage < other.damage)
				incision = other
	else
		for(var/datum/wound/cut/W in wounds)
			if(W.bandaged || W.current_stage > W.max_bleeding_stage) // Shit's unusable
				continue
			if(strict && !W.is_surgical()) //We don't need dirty ones
				continue
			if(!incision)
				incision = W
				continue
			var/same = W.is_surgical() == incision.is_surgical()
			if(same) //If they're both dirty or both are surgical, just get bigger one
				if(W.damage > incision.damage)
					incision = W
			else if(W.is_surgical()) //otherwise surgical one takes priority
				incision = W
	return incision

/obj/item/organ/external/proc/how_open()
	. = 0
	var/datum/wound/incision = get_incision()
	if(incision)
		if(BP_IS_CRYSTAL(src))
			. = SURGERY_RETRACTED
			if(encased && (status & ORGAN_BROKEN))
				. = SURGERY_ENCASED
		else
			var/smol_threshold = min_broken_damage * 0.4
			var/beeg_threshold = min_broken_damage * 0.6
			if(!incision.autoheal_cutoff == 0) //not clean incision
				smol_threshold *= 1.5
				beeg_threshold = max(beeg_threshold, min(beeg_threshold * 1.5, incision.damage_list[1])) //wounds can't achieve bigger
			if(incision.damage >= smol_threshold) //smol incision
				. = SURGERY_OPEN
			if(incision.damage >= beeg_threshold) //beeg incision
				. = SURGERY_RETRACTED
			if(. == SURGERY_RETRACTED && encased && (status & ORGAN_BROKEN))
				. = SURGERY_ENCASED

/obj/item/organ/external/proc/jostle_bone(force)
	if(!(status & ORGAN_BROKEN)) //intact bones stay still
		return
	if(brute_dam + force < min_broken_damage/5)	//no papercuts moving bones
		return
	if(internal_organs.len && prob(brute_dam + force))
		owner.custom_pain("A piece of bone in your [encased ? encased : name] moves painfully!", 50, affecting = src)
		var/obj/item/organ/internal/I = pick(internal_organs)
		I.take_internal_damage(rand(3,5))

/obj/item/organ/external/proc/jointlock(mob/attacker)
	if(!can_feel_pain())
		return

	var/armor = 100 * owner.get_blocked_ratio(owner, BRUTE, damage = 30)
	if(armor < 70)
		to_chat(owner, "<span class='danger'>You feel extreme pain!</span>")

		var/max_halloss = round(owner.species.total_health * 0.8 * ((100 - armor) / 100)) //up to 80% of passing out, further reduced by armour
		add_pain(Clamp(0, max_halloss - owner.getHalLoss(), 30))

//Adds autopsy data for used_weapon.
/obj/item/organ/external/proc/add_autopsy_data(var/used_weapon, var/damage)
	var/datum/autopsy_data/W = autopsy_data[used_weapon]
	if(!W)
		W = new()
		W.weapon = used_weapon
		autopsy_data[used_weapon] = W

	W.hits += 1
	W.damage += damage
	W.time_inflicted = world.time

/obj/item/organ/external/proc/has_genitals()
	return !BP_IS_ROBOTIC(src) && species && species.sexybits_location == organ_tag

// Added to the mob's move delay tally if this organ is being used to move with.
/obj/item/organ/external/proc/movement_delay(max_delay)
	. = 0
	if(is_stump())
		. += max_delay
	else if(splinted)
		. += max_delay/8
	else if(status & ORGAN_BROKEN)
		. += max_delay * 3/8
	else if(BP_IS_ROBOTIC(src))
		. += max_delay * CLAMP01(damage/max_damage)
