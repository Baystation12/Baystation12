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

	var/damage_state = "00" // Damage overlay key.
	var/limb_name        // Index for organ lists, etc.
	var/disfigured = 0      // Is this limb hideously scarred?
	var/gendered_icon = 0   // During icon generation, does this limb's icon_state require a gender?
	var/cavity = 0          // Can things currently be hidden in this organ?
	var/obj/item/hidden     // Holder for cavity item.

	var/tmp/perma_injury = 0
	var/tmp/amputated = 0 // Whether this has been cleanly amputated, thus causing no pain
	var/joint = "joint"   // Descriptive string used in amputation.

	var/obj/item/organ/external/parent // Organ that this organ is attached to.
	var/list/tissue_layers = list()    // Layers comprising this organ.
	var/list/children                  // Sub-organs (hands, etc)
	var/list/internal_organs           // Organs contained in this limb.
	var/list/implants = list()         // Implanted devices.

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
		if(tissue_layer.is_wounded() && (tissue_layer.tissue.flags & TISSUE_INFECTS))
			return 1
	return 0

/obj/item/organ/external/rejuvenate()
	..()
	damage_state = "00"
	perma_injury = 0

	// Handle wounded tissue layers.
	for(var/datum/tissue_layer/tissue_layer in tissue_layers)
		tissue_layer.wounds.Cut()
		tissue_layer.update()

	// Handle internal organs
	for(var/obj/item/organ/internal/current_organ in internal_organs)
		current_organ.rejuvenate()

	// Remove embedded objects and drop them on the floor
	for(var/obj/implanted_object in implants)
		if(!istype(implanted_object,/obj/item/weapon/implant))	// We don't want to remove REAL implants. Just shrapnel etc.
			implanted_object.loc = owner.loc
			implants -= implanted_object

	owner.updatehealth()

/****************************************************
			   PROCESSING & UPDATING
****************************************************/

//Determines if we even need to process this organ.

/obj/item/organ/external/proc/need_process()
	if(status & ORGAN_ROBOT)	//Missing limb is missing
		return 0
	if(brute_dam || burn_dam || germ_level)
		return 1
	return 0

/obj/item/organ/external/process_internal()

	..()

	//Dismemberment
	if(status & ORGAN_DESTROYED)
		if(config.limbs_can_break)
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

//Updating wounds. Handles wound natural healing, internal bleedings and infections
/obj/item/organ/external/proc/update_wounds()

	if((status & ORGAN_ROBOT)) //Robotic limbs don't heal or get worse.
		return

	var/healing = 10 //arbitrary, todo
	for(var/datum/tissue_layer/tissue_layer in tissue_layers)
		if(!tissue_layer.wounds.len)
			continue
		healing = tissue_layer.handle_healing(healing)

	src.update_health()

//Updates brute_damn and burn_damn from wound damages. Updates BLEEDING status.
/obj/item/organ/external/update_health()
	brute_dam = 0
	burn_dam = 0
	status &= ~ORGAN_BLEEDING
	//var/clamped = 0
	if (is_open() && is_bleeding())
		status |= ORGAN_BLEEDING
	..()

/****************************************************
			   DISMEMBERMENT
****************************************************/

//Recursive setting of all child organs to amputated
/obj/item/organ/external/proc/setAmputatedTree()
	for(var/obj/item/organ/external/O in children)
		O.amputated=amputated
		O.setAmputatedTree()

/obj/item/organ/external/removed(var/mob/living/user)

	var/is_robotic = status & ORGAN_ROBOT
	..()

	for(var/implant in implants) //todo: check if this can be left alone
		del(implant)

	//Replace all wounds on that arm with one wound on parent organ.
	for(var/datum/tissue_layer/tissue_layer in tissue_layers)
		tissue_layer.wounds.Cut()
		tissue_layer.update()

	if (parent)
		parent.take_damage(20,0,1,1) //todo: amputation should not cause this kind of damage.
		parent.update_health()

	update_health()

	// Attached organs also fly off.
	for(var/obj/item/organ/external/O in children)
		O.droplimb(1)
		O.loc = src //TODO: generate entire limb icons from contents.

	release_restraints()

	owner.organs -= src
	owner.organs_by_name[limb_name] = null // Remove from owner's vars.

	//Robotic limbs explode if sabotaged.
	if(is_robotic)
		owner.visible_message(
			"<span class='danger'>\The [owner]'s [src.name] explodes violently!</span>",\
			"<span class='danger'>Your [src.name] explodes!</span>",\
			"<span class='danger'>You hear an explosion!</span>")
		explosion(get_turf(owner),-1,-1,2,3)
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, owner)
		spark_system.attach(owner)
		spark_system.start()
		spawn(10)
			del(spark_system)
		del(src)

//Handles dismemberment
/obj/item/organ/external/proc/droplimb(var/override = 0)

	if(override)
		status |= ORGAN_DESTROYED
	if(status & ORGAN_DESTROYED)
		if(body_part == UPPER_TORSO)
			return

	owner.visible_message(
		"<span class='danger'>[owner.name]'s [src] flies off in an arc!</span>",\
		"<span class='moderate'><b>Your [src] goes flying off!</b></span>",\
		"<span class='danger'>You hear a terrible sound of ripping tendons and flesh.</span>")

	src.removed(owner)

	//Throw organs around
	if(src && owner && istype(owner.loc,/turf))
		step(src,pick(cardinal))

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

//for arms and hands
/obj/item/organ/external/proc/process_grasp(var/obj/item/c_hand, var/hand_name)
	if (!c_hand)
		return

	if(is_broken())
		owner.u_equip(c_hand)
		var/emote_scream = pick("screams in pain and", "lets out a sharp cry and", "cries out and")
		owner.emote("me", 1, "[(owner.species && owner.species.flags & NO_PAIN) ? "" : emote_scream ] drops what they were holding in their [hand_name]!")
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
		owner.visible_message("\red You hear a sickening cracking sound coming from \the [owner]'s [src].",	\
		"\red <b>Your [src] is mangled!</b>",	\
		"\red You hear a sickening crack.")
	else
		owner.visible_message(
		"<span class='danger'>[owner]'s [src] is scorched into an unrecognizable mess!</span>",	\
		"<span class='danger'>Your [src] melts!</span>",	\
		"<span class='danger'>You hear a sickening sizzle.</span>")
	disfigured = 1