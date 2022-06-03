// Involves cooperating with other ai_holders.
/datum/ai_holder
	/// If true, asks allies to help when fighting something.
	var/cooperative = FALSE

	/// How far away calls for help will go for.
	var/call_distance = 10

	/// time when this mob is allowed to call for help
	var/next_sent_help_request  = 0

	/// time when the mob can receive a help request from another mob
	var/next_received_help_request  = 0

	/// List of all mobs inside the faction with ai_holders that have cooperate on, to call for help without using range(). Note that this is only used for sending calls out. Receiving calls doesn't care about this list, only if the mob is in the faction.
	var/list/faction_friends = list()


/datum/ai_holder/Destroy()
	if (faction_friends.len) //This list is shared amongst the faction
		faction_friends -= src
	return ..()

/* Handles everything about that list.
*  Call on initialization or if something weird happened like the mob switched factions.
*/
/datum/ai_holder/proc/build_faction_friends()
	if (faction_friends.len) // Already have a list.
		// Assume we're moving to a new faction.
		faction_friends -= src   // Get us out of the current list shared by everyone else.
		faction_friends = list() // Then make our list empty and unshared in case we become a loner.

	// Find another AI-controlled mob in the same faction if possible.
	var/mob/living/first_friend
	for (var/mob/living/L in GLOB.living_mob_list_)
		if (L.faction == holder.faction && L.ai_holder)
			first_friend = L
			break

	if (first_friend) // Joining an already established faction.
		faction_friends = first_friend.ai_holder.faction_friends
		faction_friends |= holder
	else // We're the 'founder' (first and/or only member) of this faction.
		faction_friends |= holder

/// Requests help in combat from other mobs possessing ai_holders.
/datum/ai_holder/proc/request_help()
	ai_log("request_help() : Entering.", AI_LOG_DEBUG)
	if (!cooperative || world.time < next_sent_help_request  || world.time < next_received_help_request)
		return



	ai_log("request_help() : Asking for help.", AI_LOG_INFO)
	next_sent_help_request  = world.time + 10 SECONDS
	if (!faction_friends)
		build_faction_friends()
	for (var/mob/living/L in faction_friends)
		if (L == holder) // Lets not call ourselves.
			continue
		if (holder.z != L.z) // On seperate z-level.
			continue
		if (get_dist(L, holder) > call_distance) // Too far to 'hear' the call for help.
			continue

		if (holder.IIsAlly(L) && L.ai_holder)
			ai_log("request_help() : Asking [L] (AI) for help.", AI_LOG_INFO)
			L.ai_holder.help_requested(holder)

	ai_log("request_help() : Exiting.", AI_LOG_DEBUG)

/// What allies receive when someone else is calling for help.
/datum/ai_holder/proc/help_requested(mob/living/friend)
	ai_log("help_requested() : Entering.", AI_LOG_DEBUG)
	if (stance == STANCE_SLEEP)
		ai_log("help_requested() : Help requested by [friend] but we are asleep.", AI_LOG_INFO)
		return
	if (!cooperative)
		ai_log("help_requested() : Help requested by [friend] but we're not cooperative.", AI_LOG_INFO)
		return
	if (stance in STANCES_COMBAT)
		ai_log("help_requested() : Help requested by [friend] but we are busy fighting something else.", AI_LOG_INFO)
		return
	if (!can_act())
		ai_log("help_requested() : Help requested by [friend] but cannot act (stunned or dead).", AI_LOG_INFO)
		return
	if (!holder.IIsAlly(friend)) // Extra sanity.
		ai_log("help_requested() : Help requested by [friend] but we hate them.", AI_LOG_INFO)
		return
	var/their_target = friend?.ai_holder?.target
	if (their_target) // They have a target and aren't just shouting for no reason
		if (!can_attack(their_target, vision_required = FALSE))
			ai_log("help_requested() : Help requested by [friend] but we don't want to fight their target.", AI_LOG_INFO)
			return
		if (get_dist(holder, friend) <= follow_distance)
			ai_log("help_requested() : Help requested by [friend] but we're already here.", AI_LOG_INFO)
			return
		if (get_dist(holder, friend) <= vision_range) // Within our sight.
			ai_log("help_requested() : Help requested by [friend], and within target sharing range.", AI_LOG_INFO)
			last_conflict_time = world.time // So we attack immediately and not threaten.
			next_received_help_request  = world.time + 15 SECONDS
			give_target(their_target, urgent = TRUE) // This will set us to the appropiate stance.
			ai_log("help_requested() : Given target [target] by [friend]. Exiting", AI_LOG_DEBUG)
			return

	// Otherwise they're outside our sight, lack a target, or aren't AI controlled, but within call range.
	// So assuming we're AI controlled, we'll go to them and see whats wrong.
	ai_log("help_requested() : Help requested by [friend], going to go to friend.", AI_LOG_INFO)
	if (their_target)
		add_attacker(their_target) // We won't wait and 'warn' them while they're stabbing our ally
	set_follow(friend, 10 SECONDS)
	ai_log("help_requested() : Exiting.", AI_LOG_DEBUG)
