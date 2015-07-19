/datum/mob_ai
	var/disable_ai	= 0	// To allow ease of
	var/mob/host	// The mobs to which the AI belongs

	var/has_retaliated
	var/was_alive		// If the host was alive last tick
	var/was_enabled		// If the AI was enabled last tick
	var/had_client		// if the host had a client last tick

	var/list/last_damage
	var/list/current_damage

	var/list/friends	// Friends whom we will never attack.
	var/list/enemies	// Enemies whom we will always attack.
	var/attack_same = 0	// Do we attack mobs of the same faction?

	var/destroy_probability = 10
	var/atom/target
	var/stance = HOSTILE_STANCE_IDLE	//Used to determine behavior
	var/behaviour = AI_WANDER
	var/datum/mob_ai_state/current_state

/datum/mob_ai/New(var/mob/host)
	if(!istype(host))
		CRASH()
	src.host = host
	was_alive = host.stat != DEAD
	had_client = !isnull(host.client) // Making sure we keep a true/false value instead of reference

	friends = list()
	enemies = list()
	last_damage = list()
	current_damage = list()

/datum/mob_ai/Destroy()
	host = null
	return ..()

/datum/mob_ai/proc/Process()
	if(HasLostControl())
		current_state.LostControl(src)
	had_client = !isnull(host.client)
	was_enabled = !disable_ai

	if(had_client || disable_ai)
		return

	var/is_alive = host.stat != DEAD
	if(is_alive)
		current_state.Life(src)
	if(!is_alive && was_alive)
		current_state.Died(src)
	if(!is_alive)
		current_state.Death(src)
	was_alive = is_alive

	current_state = current_state.NextState(src)

// Called if the mob was alive the previous tick and dead in the current
/datum/mob_ai/proc/Died()
	walk(host, 0)			// Cease any potential move_to if we died

// Called every tick if the mob is dead
/datum/mob_ai/proc/Death()
	return

/datum/mob_ai/proc/UpdateDamage()
	/*last_damage = current_damage.Copy()
	current_damage[BRUTE]	= host.getBruteLoss()
	current_damage[TOX]		= host.getToxLoss()
	current_damage[OXY]		= host.getOxyLoss()
	current_damage[BURN]	= host.getFireLoss()*/

/datum/mob_ai/proc/HasLostControl()
	return (!had_client && host.client) || (disable_ai && was_enabled)

// Called when the AI has lost control of the host
/datum/mob_ai/proc/LostControl()
	target = null
	walk(host, 0)										// walk() to ensure the client can move in case of a prior move_to.
	host.a_intent = (is_aggressive ? I_HURT : I_HELP)	// Attempt to set the appropriate intention as not all mobs can easily set it currently
