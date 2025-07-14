/datum/ai_holder/legion/harvester
	cooperative = FALSE // So that the harvester doesnt get confused receiving invalid targets from other mobs.
	handle_corpse = TRUE
	respect_confusion = FALSE
	flee_when_outmatched = TRUE


/datum/ai_holder/legion/harvester/list_targets()
	var/list/targets = list()

	for (var/atom/thing as anything in range(vision_range, holder))
		if (!isitem(thing) && !ishuman(thing))
			continue
		if (!isturf(thing.loc))
			continue
		if (!can_see(holder, thing, vision_range))
			continue
		targets += thing

	return targets


/datum/ai_holder/legion/harvester/can_pursue(atom/movable/target)
	ai_log("can_pursue() : Entering.", AI_LOG_TRACE)

	if (!isturf(target.loc))
		return FALSE

	if (ishuman(target))
		var/mob/living/carbon/human/human = target
		if (human.key && !human.client)
			return FALSE
		if (HAS_FLAGS(human.status_flags, NOTARGET))
			return FALSE
		if (holder.IIsAlly(target))
			return FALSE

	var/mob/living/simple_animal/hostile/legion/harvester/harvester = holder
	return harvester.can_harvest_brain(target)


/datum/ai_holder/legion/harvester/give_target(new_target, urgent)
	var/old_target = target
	. = ..()
	if (!. || !target || target == old_target)
		return

	holder.visible_message(
		SPAN_WARNING("\The [holder] turns its focus on \the [target]..."),
		exclude_mobs = list(target)
	)
	if (!ismob(target))
		return
	var/mob/mob = target
	mob.show_message(
		FONT_LARGE(SPAN_DANGER("\The [holder] turns its focus on you!")),
		VISIBLE_MESSAGE
	)


// Flee if there's more than 1 threat (Still standing mob) nearby.
/datum/ai_holder/legion/harvester/special_flee_check()
	var/list/dangers = list()

	for (var/mob/living/living in range(vision_range, holder))
		if (!living.get_threat(holder))
			continue
		dangers += living

	return length(dangers) > 1


/datum/ai_holder/legion/harvester/react_to_attack(atom/movable/attacker)
	. = ..()
	if (rand(0, 100) >= 100) // 5% chance when hit to be interrupted
		return
	holder.do_user_interrupted = world.time
