/decl/psionic_power
	var/name             // Name. If null, psipower won't be generated on roundstart.
	var/faculty          // Associated psi faculty.
	var/min_rank         // Minimum psi rank to use this power.
	var/cost             // Base psi stamina cost for using this power.
	var/cooldown         // Deciseconds cooldown after using this power.
	var/admin_log = TRUE // Whether or not using this power prints an admin attack log.
	var/use_ranged       // This power functions from a distance.
	var/use_melee        // This power functions at melee range.
	var/use_grab         // This power has a variant invoked via grab.
	var/use_manifest     // This power manifests an item in the user's hands.
	var/use_description  // A short description of how to use this power, shown via assay.
	// A sound effect to play when the power is used.
	var/use_sound = 'sound/effects/psi/power_used.ogg'

/decl/psionic_power/proc/invoke(var/mob/living/user, var/atom/target)

	if(!user.psi)
		return FALSE

	if(faculty && min_rank)
		var/user_rank = user.psi.get_rank(faculty)
		if(user_rank < min_rank)
			return FALSE

	if(cost && !user.psi.spend_power(cost))
		return FALSE

	var/user_psi_leech = user.do_psionics_check(cost, user)
	if(user_psi_leech)
		to_chat(user, SPAN_WARNING("Your power is leeched away by \the [user_psi_leech] as fast as you can focus it..."))
		return FALSE

	if(target.do_psionics_check(cost, user))
		to_chat(user, SPAN_WARNING("Your power skates across \the [target], but cannot get a grip..."))
		return FALSE

	return TRUE

/decl/psionic_power/proc/handle_post_power(var/mob/living/user, var/atom/target)
	if(cooldown)
		user.psi.set_cooldown(cooldown)
	if(admin_log && ismob(user) && ismob(target))
		admin_attack_log(user, target, "Used psipower ([name])", "Was subjected to a psipower ([name])", "used a psipower ([name]) on")
	if(use_sound)
		playsound(user.loc, use_sound, 75)
