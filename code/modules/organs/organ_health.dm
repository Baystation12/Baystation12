// Legacy damage properties
/// Current damage to the organ
/obj/item/organ/var/damage = 0
/// Damage before becoming broken
/obj/item/organ/var/min_broken_damage = 30
/// Damage cap
/obj/item/organ/var/max_damage = 30
/// Time of organ death
/obj/item/organ/var/death_time


/obj/item/organ/Initialize()
	. = ..()

	if(max_damage)
		min_broken_damage = floor(max_damage / 2)
	else
		max_damage = min_broken_damage * 2

	queue_icon_update()


/**
 * Whether or not the organ is considered broken. By default, this checks `health_broken_threshhold`, and the
 * `ORGAN_CUT_AWAY` and `ORGAN_BROKEN` status flags.
 *
 * Returns boolean.
 */
/obj/item/organ/proc/is_broken()
	return (damage >= min_broken_damage || (status & ORGAN_CUT_AWAY) || (status & ORGAN_BROKEN))
	// return (get_current_health() <= health_broken_threshhold || GET_FLAGS(status, ORGAN_CUT_AWAY | ORGAN_BROKEN)) TODO: Swap over


/**
 * Kills the organ.
 */
/obj/item/organ/proc/die()
	damage = max_damage
	status |= ORGAN_DEAD
	STOP_PROCESSING(SSobj, src)
	death_time = world.time
	if(owner && vital)
		owner.death()


/**
 * Displays a message to `user` if the organ is decayed.
 */
/obj/item/organ/proc/show_decay_status(mob/user)
	if(BP_IS_ROBOTIC(src))
		if(status & ORGAN_DEAD)
			to_chat(user, SPAN_NOTICE("\The [src] looks completely spent."))
	else
		if(status & ORGAN_DEAD)
			to_chat(user, SPAN_NOTICE("The decay has set into \the [src]."))


/**
 *
 */
/obj/item/organ/proc/take_general_damage(amount, silent = FALSE)
	CRASH("Not Implemented")


/**
 * Heals `amount` points of damage.
 */
/obj/item/organ/proc/heal_damage(amount)
	if (can_recover())
		damage = clamp(damage - round(amount, 0.1), 0, max_damage)


/**
 * Whether or not the organ can be revived through normal means.
 */
/obj/item/organ/proc/can_recover()
	return (max_damage > 0) && !(status & ORGAN_DEAD) || death_time >= world.time - ORGAN_RECOVERY_THRESHOLD
