// Base AIs for simple mobs.
// Mob-specific AIs are in their mob's file.

/datum/ai_holder/simple_animal
	hostile = TRUE // The majority of simplemobs are hostile.
	retaliate = TRUE	// The majority of simplemobs will fight back.
	cooperative = TRUE
	returns_home = FALSE
	can_flee = FALSE
	speak_chance = 1 // If the mob's saylist is empty, nothing will happen.
	wander = TRUE
	base_wander_delay = 4

// For non-hostile animals, and pets like Ian and Runtime.
/datum/ai_holder/simple_animal/passive
	hostile = FALSE
	retaliate = FALSE
	can_flee = TRUE
	violent_breakthrough = FALSE

// Won't wander away as quickly, ideal for event-spawned mobs like carp or drones.
/datum/ai_holder/simple_animal/event
	base_wander_delay = 8

// Will keep the mob within a limited radius of its home, useful for guarding an area
/datum/ai_holder/simple_animal/guard
	returns_home = TRUE

// Won't return home while it's busy doing something else, like chasing a player
/datum/ai_holder/simple_animal/guard/give_chase
	home_low_priority = TRUE

// Doesn't really act until told to by something on the outside.
/datum/ai_holder/simple_animal/inert
	hostile = FALSE
	retaliate = FALSE
	can_flee = FALSE
	wander = FALSE
	speak_chance = 0
	cooperative = FALSE
	violent_breakthrough = FALSE // So it can open doors but not attack windows and shatter the literal illusion.

/datum/ai_holder/simple_animal/stationary
	wander = FALSE
// Ranged mobs.

/datum/ai_holder/simple_animal/ranged

// Tries to not waste ammo.
/datum/ai_holder/simple_animal/ranged/careful
	conserve_ammo = TRUE

/datum/ai_holder/simple_animal/ranged/pointblank
	pointblank = TRUE

// Runs away from its target if within a certain distance.
/datum/ai_holder/simple_animal/ranged/kiting
	pointblank = TRUE // So we don't need to copypaste post_melee_attack().
	/// If anything gets within this range, it'll try to move away.
	var/run_if_this_close = 4
	/// If true, mob turns to face the target while kiting, otherwise they turn in the direction they moved towards.
	var/moonwalk = TRUE

/datum/ai_holder/simple_animal/ranged/kiting/threatening
	threaten = TRUE
	threaten_delay = 1 SECOND // Less of a threat and more of pre-attack notice.
	threaten_timeout = 30 SECONDS
	conserve_ammo = TRUE

// For event-spawned malf drones.
/datum/ai_holder/simple_animal/ranged/kiting/threatening/event
	base_wander_delay = 8

/datum/ai_holder/simple_animal/ranged/kiting/no_moonwalk
	moonwalk = FALSE

/datum/ai_holder/simple_animal/ranged/kiting/on_engagement(atom/A)
	if(get_dist(holder, A) < run_if_this_close)
		holder.IMove(get_step_away(holder, A, run_if_this_close))
		if(moonwalk)
			holder.face_atom(A)

// Closes distance from the target even while in range.
/datum/ai_holder/simple_animal/ranged/aggressive
	pointblank = TRUE
	/// How close to get to the target. By default they will get into melee range (and then pointblank them).
	var/closest_distance = 1

/datum/ai_holder/simple_animal/ranged/aggressive/on_engagement(atom/A)
	if(get_dist(holder, A) > closest_distance)
		holder.IMove(get_step_towards(holder, A))
		holder.face_atom(A)

// Yakkity saxes while firing at you.
/datum/ai_holder/hostile/ranged/robust/on_engagement(atom/movable/AM)
	step_rand(holder)
	holder.face_atom(AM)

// Switches intents based on specific criteria.
// Used for special mobs who do different things based on intents (and aren't slimes).
// Intent switching is generally done in pre_[ranged/special]_attack(), so that the mob can use the right attack for the right time.
/datum/ai_holder/simple_animal/intentional


// These try to avoid collateral damage.
/datum/ai_holder/simple_animal/restrained
	violent_breakthrough = FALSE
	conserve_ammo = TRUE
	destructive = FALSE

// This does the opposite of the above subtype.
/datum/ai_holder/simple_animal/destructive
	destructive = TRUE

// Melee mobs.

/datum/ai_holder/simple_animal/melee

// Dances around the enemy its fighting, making it harder to fight back.
/datum/ai_holder/simple_animal/melee/evasive

/datum/ai_holder/simple_animal/melee/evasive/post_melee_attack(atom/A)
	if(holder.Adjacent(A))
		holder.IMove(get_step(holder, pick(GLOB.alldirs)))
		holder.face_atom(A)



// This AI hits something, then runs away for awhile.
// It will (almost) always flee if they are uncloaked, AND their target is not stunned.
/datum/ai_holder/simple_animal/melee/hit_and_run
	can_flee = TRUE

// Used for the 'running' part of hit and run.
/datum/ai_holder/simple_animal/melee/hit_and_run/special_flee_check()
	if(!holder.is_cloaked())
		if(isliving(target))
			var/mob/living/L = target
			return !L.incapacitated(INCAPACITATION_DISABLED) // Don't flee if our target is stunned in some form, even if uncloaked. This is so the mob keeps attacking a stunned opponent.
		return TRUE // We're out in the open, uncloaked, and our target isn't stunned, so lets flee.
	return FALSE


// Simple mobs that aren't hostile, but will fight back.
/datum/ai_holder/simple_animal/retaliate
	hostile = FALSE
	retaliate = TRUE

// Simple mobs that retaliate and support others in their faction who get attacked.
/datum/ai_holder/simple_animal/retaliate/cooperative
	cooperative = TRUE

// With all the bells and whistles
/datum/ai_holder/simple_animal/humanoid
	intelligence_level = AI_SMART //Purportedly
	retaliate = TRUE //If attacked, attack back
	threaten = TRUE //Verbal threats
	firing_lanes = TRUE //Avoid shooting allies
	conserve_ammo = TRUE //Don't shoot when it can't hit target
	can_breakthrough = TRUE //Can break through doors
	violent_breakthrough = FALSE //Won't try to break through walls (humans can, but usually don't)
	speak_chance = 2 //Babble chance
	cooperative = TRUE //Assist each other
	wander = TRUE //Wander around
	returns_home = TRUE //But not too far
	use_astar = TRUE //Path smartly
	home_low_priority = TRUE //Following/helping is more important

// The hostile subtype is implied to be trained combatants who use ""tactics""
/datum/ai_holder/simple_animal/humanoid/hostile
	/// If anything gets within this range, it'll try to move away.
	var/run_if_this_close = 4
	hostile = TRUE //Attack!

// Juke
/datum/ai_holder/simple_animal/humanoid/hostile/post_melee_attack(atom/A)
	holder.IMove(get_step(holder, pick(GLOB.alldirs)))
	holder.face_atom(A)

/datum/ai_holder/simple_animal/humanoid/hostile/post_ranged_attack(atom/A)
	//Pick a random turf to step into
	var/turf/T = get_step(holder, pick(GLOB.alldirs))
	if(check_trajectory(A, T)) // Can we even hit them from there?
		holder.IMove(T)
		holder.face_atom(A)

	if(get_dist(holder, A) < run_if_this_close)
		holder.IMove(get_step_away(holder, A))
		holder.face_atom(A)
