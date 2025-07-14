/mob/living/simple_animal/hostile/legion/harvester
	name = "legion harvester"
	icon = 'packs/legion/icons/harvester.dmi'
	icon_state = "base"
	default_pixel_x = -16
	default_pixel_y = -16
	pixel_x = -16
	pixel_y = -16
	maxHealth = 200
	health = 200

	mob_size = MOB_LARGE
	ai_holder = /datum/ai_holder/legion/harvester
	mob_flags = MOB_FLAG_UNPINNABLE | MOB_FLAG_DO_USER_INTERRUPT

	special_attack_min_range = 0
	special_attack_max_range = 1
	special_attack_cooldown = 0 // "cooldown" is just the time it takes the process to try to happen.

	/// The current atom selected for harvesting.
	var/atom/harvest_target

	/**
	 * LAZYLIST (Instances of `/obj/item/organ/internal/brain` and `/obj/item/organ/internal/posibrain`). The brains
	 * this harvester has collected. These should also be within `contents`.
	 */
	var/list/harvested_brains

	/// Integer (One of `src.HARVESTER_STATE_*`). The current activity state of the harvester.
	var/harvester_state

	/// The harvester is currently not doing anything special.
	var/const/HARVESTER_STATE_DEFAULT = 1
	/// The harvester is currently extracting a brain from `harvest_target`.
	var/const/HARVESTER_STATE_EXTRACTING = 2
	/// The harvester is currently storing an extracted brain.
	var/const/HARVESTER_STATE_STORING = 3


/mob/living/simple_animal/hostile/legion/harvester/loaded/Initialize(mapload, obj/structure/legion/beacon/spawner, brain_count)
	. = ..()

	// Preloaded with brains for extra pinata
	LAZYINITLIST(harvested_brains)
	if (!brain_count)
		brain_count = rand(1, 10)
	for (var/i = 1 to brain_count)
		var/brain_type = rand(0, 1) ? /obj/item/organ/internal/brain : /obj/item/organ/internal/posibrain
		harvested_brains += new brain_type(src)


/mob/living/simple_animal/hostile/legion/harvester/Destroy()
	QDEL_NULL_LIST(harvested_brains)
	harvest_target = null
	return ..()


/mob/living/simple_animal/hostile/legion/harvester/on_update_icon()
	ClearOverlays()
	..()
	if (icon_state == "base")
		AddOverlays(emissive_appearance(icon, "base-emissive", FLOAT_LAYER + 1))


/mob/living/simple_animal/hostile/legion/harvester/examine(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()

	switch (harvester_state)
		if (HARVESTER_STATE_DEFAULT)
			if (ai_holder.target)
				if (ai_holder.target == user)
					to_chat(user, FONT_LARGE(SPAN_DANGER("It seems focused on <b>you</b>.")))
				else
					to_chat(user, SPAN_WARNING("It seems focused on \the [ai_holder.target]."))
			else
				to_chat(user, SPAN_WARNING("It seems to be searching for something..."))

		if (HARVESTER_STATE_EXTRACTING)
			to_chat(user, SPAN_WARNING("It is currently cutting into \the [harvest_target]..."))

		if (HARVESTER_STATE_STORING)
			to_chat(user, SPAN_WARNING("It is currently drawing \the [harvest_target] into its storage compartment..."))


/mob/living/simple_animal/hostile/legion/harvester/on_death()
	if (!length(harvested_brains))
		visible_message(
			SPAN_DANGER("\The [src] blows apart!")
		)
	else
		visible_message(
			SPAN_DANGER("\The [src] blows apart, spewing the contents of its internal storage unit everywhere!")
		)
		explosion(get_turf(src), 2, EX_ACT_LIGHT)
		for (var/atom/movable/harvested_brain in harvested_brains)
			harvested_brain.forceMove(get_turf(src))
			harvested_brain.throw_at_random(FALSE, 4, 3)
		harvested_brains.Cut()
	qdel(src)


/mob/living/simple_animal/hostile/legion/harvester/do_special_attack(atom/A)
	return harvest_brain(A)


/mob/living/simple_animal/hostile/legion/harvester/get_tension()
	var/list/potential_threats = list()

	for (var/thing in view(src))
		if (!isliving(thing))
			continue
		var/mob/living/carbon/human/human = thing
		if (human.incapacitated())
			continue
		potential_threats += human

	return length(potential_threats)


/**
 * Sets the harvester's harvesting state. Primarily used to synchronize the harvester's AI busy state.
 *
 * Includes validation to ensure `new_state` is a valid state, otherwise crashes without updating.
 *
 * **Parameters**:
 * - `new_state` (Integer - One of `HARVESTER_STATE_*`, default `HARVESTER_STATE_DEFAULT`) - The new state to set.
 *
 * Has no return value.
 */
/mob/living/simple_animal/hostile/legion/harvester/proc/set_harvester_state(new_state = HARVESTER_STATE_DEFAULT)
	if (harvester_state == new_state)
		return

	switch (new_state)
		if (HARVESTER_STATE_DEFAULT)
			ai_holder.set_busy(FALSE)
		if (HARVESTER_STATE_EXTRACTING)
			ai_holder.set_busy(TRUE)
		if (HARVESTER_STATE_STORING)
			ai_holder.set_busy(TRUE)
		else
			crash_with("Invalid harvester state [new_state]")
			return

	harvester_state = new_state


/**
 * Whether or not the target is valid for harvesting a brain from. Legion have fancy sensors that can detect the presence of a brain from a distance or something like that.
 *
 * Does not include adjacency checks as this is also intended for selecting a target to move to.
 *
 * **Parameters**:
 * - `target` - The atom to validate.
 * - `skip_incapacitation_checks` (Boolean, default `FALSE`) - If set, and `target` is a mob, skips checks that ensure the target is incapacitated and "safe" to extract from.
 *
 * Returns boolean. If `TRUE`, `target` is a valid target for `harvest_brain()`.
 */
/mob/living/simple_animal/hostile/legion/harvester/proc/can_harvest_brain(atom/movable/target, skip_incapacitation_checks = FALSE)
	// Raw brains and positronics
	if (istype(target, /obj/item/organ/internal/brain) || istype(target, /obj/item/organ/internal/posibrain))
		return TRUE

	// MMIs
	if (istype(target, /obj/item/device/mmi))
		var/obj/item/device/mmi/mmi = target
		if (!mmi.brainobj)
			return FALSE
		return TRUE

	// Heads/raw body parts that might have juicy brains
	if (istype(target, /obj/item/organ/external))
		var/found_brain = locate(/obj/item/organ/internal/brain) in target
		if (!found_brain)
			found_brain = locate(/obj/item/organ/internal/posibrain) in target
		if (!found_brain)
			return FALSE
		return TRUE

	// Human mobs
	if (ishuman(target))
		var/mob/living/carbon/human/human_target = target
		var/obj/item/organ/internal/brain = human_target.internal_organs_by_name[BP_BRAIN] || human_target.internal_organs_by_name[BP_POSIBRAIN]
		if (!brain)
			return FALSE
		var/obj/item/organ/external/external_organ = human_target.organs_by_name[brain.parent_organ]
		if (!external_organ)
			return FALSE
		if (skip_incapacitation_checks)
			return TRUE
		if (!human_target.incapacitated())
			return FALSE
		return TRUE

	return FALSE



/**
 * Attempts to 'harvest' the target's brain into this harvester's internal storage.
 *
 * Does not perform `can_harvest_brain()` checks as it's assumed this was already checked before calling this proc.
 *
 * **Parameters**:
 *  - `target` - The atom being harvested. Currently valid types include:
 *  	- `/obj/item/organ/internal/brain` - Collects the brain
 *  	- `/obj/item/organ/internal/posibrain` - Collects the brain
 *  	- `/obj/item/organ/external` - Will attempt to extract a brain if present
 *  	- `/mob/living/carbon/human` - Will attempt to extract a brain if present
 *
 * Returns boolean. Whether or not a brain was successfully harvested.
 */
/mob/living/simple_animal/hostile/legion/harvester/proc/harvest_brain(atom/movable/target)
	if (!Adjacent(target))
		return FALSE


	// Raw brains and positronics
	if (istype(target, /obj/item/organ/internal/brain) || istype(target, /obj/item/organ/internal/posibrain))
		return collect_brain(target)


	// MMIs
	if (istype(target, /obj/item/device/mmi))
		var/obj/item/device/mmi/mmi = target
		var/obj/item/organ/internal/brain/brain = mmi.brainobj
		return extract_brain_from_mmi(mmi, brain)


	// Heads/raw body parts that might have juicy brains
	if (istype(target, /obj/item/organ/external))
		var/obj/item/organ/external/external = target
		var/obj/item/organ/internal/found_brain = locate(/obj/item/organ/internal/brain) in target
		if (!found_brain)
			found_brain = locate(/obj/item/organ/internal/posibrain) in target
		if (!found_brain)
			found_brain = locate(/obj/item/organ/internal/mmi_holder) in target
		if (!found_brain)
			return FALSE // Runtime protection. This theoretically shouldn't be possible but you never know.
		return extract_brain_from_external_organ(external, found_brain)


	// Human mobs
	if (ishuman(target))
		var/mob/living/carbon/human/human_target = target
		var/obj/item/organ/internal/brain = human_target.internal_organs_by_name[BP_BRAIN] || human_target.internal_organs_by_name[BP_POSIBRAIN]
		if (!brain)
			return FALSE
		var/obj/item/organ/external/external_organ = human_target.organs_by_name[brain.parent_organ]
		if (!brain || !external_organ)
			return FALSE
		return extract_brain_from_mob(target, external_organ, brain)


	// Anything else. We theoretically shouldn't be here, but byond be byond.
	return FALSE


/**
 * Handles storing `brain` in this harvester's cargo.
 *
 * Returns boolean.
 */
/mob/living/simple_animal/hostile/legion/harvester/proc/collect_brain(obj/item/organ/internal/brain)
	set_dir(get_dir(src, brain))
	visible_message(
		SPAN_WARNING("\The [src] starts scooping up \the [brain] into its internal storage.")
	)
	set_harvester_state(HARVESTER_STATE_STORING)
	if (!do_after(src, 5 SECONDS, brain, DO_PUBLIC_UNIQUE) || !use_sanity_check(brain))
		set_harvester_state(HARVESTER_STATE_DEFAULT)
		return FALSE
	visible_message(
		SPAN_WARNING("\The [src] scoops up \the [brain] into its internal storage!")
	)
	set_harvester_state(HARVESTER_STATE_DEFAULT)
	brain.forceMove(src)
	LAZYADD(harvested_brains, brain)
	return TRUE


/**
 * Handles extracting `brain` from `external`.
 *
 * Returns boolean.
 */
/mob/living/simple_animal/hostile/legion/harvester/proc/extract_brain_from_external_organ(obj/item/organ/external/external, obj/item/organ/internal/brain, mob/living/carbon/human/human)
	var/target_name = external.name
	if (human)
		target_name = "[human.name]'s [external.name]"

	set_dir(get_dir(src, external))
	visible_message(
		SPAN_WARNING("\The [src] starts ravenously digging into \the [target_name] with its tentacles!"),
		exclude_mobs = list(human)
	)
	if (human)
		human.show_message(
			SPAN_DANGER("\The [src] starts ravenously digging into your [external.name] with its tentacles!"),
			VISIBLE_MESSAGE,
			SPAN_DANGER("Something's tearing into your [external.name]!")
		)
		human.custom_pain("Your [external.name] is being torn open!", 50, affecting = external)
	playsound(external, 'sound/items/scalpel.ogg', 50, TRUE)
	external.take_external_damage(10, 0, DAMAGE_FLAG_EDGE | DAMAGE_FLAG_SHARP, "harvester tendrils")

	set_harvester_state(HARVESTER_STATE_EXTRACTING)
	if (!do_after(src, 5 SECONDS, external, DO_PUBLIC_UNIQUE) || !use_sanity_check(external) || !(brain in human ? human : external))
		set_harvester_state(HARVESTER_STATE_DEFAULT)
		return FALSE

	visible_message(
		SPAN_WARNING("\The [src] tears open \the [target_name], releasing \the [brain] from its confines!"),
		exclude_mobs = list(human)
	)
	if (human)
		human.show_message(
			SPAN_DANGER("\The [src] tears open your [external.name] with its tentacles!"),
			VISIBLE_MESSAGE,
			SPAN_DANGER("Something's torn open your [external.name]!")
		)
	playsound(external, 'sound/weapons/bladeslice.ogg', 50, TRUE)
	external.fracture()
	external.createwound(INJURY_TYPE_CUT, external.min_broken_damage)
	brain.cut_away(src)
	external.implants -= brain
	brain.dropInto(get_turf(external))
	if (istype(brain, /obj/item/organ/internal/mmi_holder))
		var/obj/item/organ/internal/mmi_holder/mmi_holder = brain
		var/obj/item/device/mmi/mmi = mmi_holder.transfer_and_delete()
		return extract_brain_from_mmi(mmi, mmi.brainobj)
	return collect_brain(brain)


/**
 * Handles extracting `brain` from `external` while still connected to `human`.
 *
 * If the target organ can be amputated, tears it off before extracting for extra brutality.
 *
 * Returns boolean.
 */
/mob/living/simple_animal/hostile/legion/harvester/proc/extract_brain_from_mob(mob/living/carbon/human/human, obj/item/organ/external/external, obj/item/organ/internal/brain)
	if (!HAS_FLAGS(external.limb_flags, ORGAN_FLAG_CAN_AMPUTATE))
		return extract_brain_from_external_organ(external, brain, human)

	set_dir(get_dir(src, human))
	visible_message(
		SPAN_WARNING("\The [src] starts cutting through and tearing off \the [human]'s [external.name] with its tendrils!"),
		exclude_mobs = list(human)
	)
	human.show_message(
		SPAN_DANGER("\The [src] starts cutting through and tearing off your [external.name]!"),
		VISIBLE_MESSAGE
	)
	human.custom_pain("Your [external.name] is being torn apart!", 50, TRUE, external)
	playsound(external, 'sound/items/amputation.ogg', 50, TRUE)

	set_harvester_state(HARVESTER_STATE_EXTRACTING)
	if (!do_after(src, 5 SECONDS, human, DO_PUBLIC_UNIQUE) || !use_sanity_check(human) || !(external in human) || !(brain in human))
		set_harvester_state(HARVESTER_STATE_DEFAULT)
		return FALSE

	visible_message(
		SPAN_WARNING("\The [src] tears \the [human]'s [external.name] off!"),
		exclude_mobs = list(human)
	)
	human.show_message(
		SPAN_DANGER("\The [src] tears your [external.name] off!"),
		VISIBLE_MESSAGE
	)
	external.droplimb(FALSE, DROPLIMB_EDGE, skip_throw = TRUE)

	return extract_brain_from_external_organ(external, brain)


/**
 * Handles extracting `brain` from `mmi`.
 *
 * Returns boolean.
 */
/mob/living/simple_animal/hostile/legion/harvester/proc/extract_brain_from_mmi(obj/item/device/mmi/mmi, obj/item/organ/internal/brain/brain)
	set_dir(get_dir(src, mmi))
	set_harvester_state(HARVESTER_STATE_EXTRACTING)
	var/mob/living/carbon/brain/brainmob = mmi.brainmob
	if (mmi.locked)
		visible_message(
			SPAN_WARNING("\The [src] starts forcing \the [mmi] open!")
		)
		if (!do_after(src, 5 SECONDS, mmi, DO_PUBLIC_UNIQUE) || !use_sanity_check(mmi) || mmi.brainobj != brain)
			set_harvester_state(HARVESTER_STATE_DEFAULT)
			return FALSE
		mmi.locked = FALSE
		visible_message(
			SPAN_WARNING("\The [src] forces \the [mmi] open and pulls \the [brain] out!")
		)
	else
		visible_message(
			SPAN_WARNING("\The [src] starts pulling \the [brain] out of \the [mmi]!")
		)
		if (!do_after(src, 5 SECONDS, mmi, DO_PUBLIC_UNIQUE) || !use_sanity_check(mmi) || mmi.brainobj != brain)
			set_harvester_state(HARVESTER_STATE_DEFAULT)
			return FALSE
		visible_message(
			SPAN_WARNING("\The [src] pulls \the [brain] out of \the [mmi]!")
		)
	brain.dropInto(get_turf(mmi))
	mmi.brainobj = null
	mmi.brainmob = null
	mmi.update_icon()
	mmi.SetName(initial(mmi.name))
	if (!brainmob)
		return collect_brain(brain)
	brainmob.container = null
	brainmob.forceMove(brain)
	brainmob.remove_from_living_mob_list()
	brain.brainmob = brainmob
	return collect_brain(brain)
