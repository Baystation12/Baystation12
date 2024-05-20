//as core click exists at the mob level
/mob/proc/trigger_aiming(trigger_type)
	return

/mob/living/trigger_aiming(trigger_type)
	if(!length(aimed))
		return
	for(var/obj/aiming_overlay/AO in aimed)
		if(AO.aiming_at == src)
			AO.update_aiming()
			if(AO.aiming_at == src)
				AO.trigger(trigger_type)
				AO.update_aiming_deferred()

/obj/aiming_overlay/proc/trigger(perm)
	if (!owner || !aiming_with || !aiming_at || !locked)
		return
	if (perm && (target_permissions & perm))
		return
	if (!owner.canClick())
		return
	var/obj/item/gun/G = aiming_with
	if (!istype(G))
		return
	if (owner == aiming_at)
		addtimer(new Callback(G, TYPE_PROC_REF(/obj/item/gun, handle_suicide), owner, 2))
		return
	if (prob(owner.skill_fail_chance(SKILL_WEAPONS, 30, SKILL_TRAINED, 3)))
		to_chat(owner, SPAN_WARNING("You fumble with the gun, throwing your aim off!"))
		owner.stop_aiming(aiming_with)
		return
	owner.setClickCooldown(DEFAULT_QUICK_COOLDOWN) // Spam prevention, essentially.
	owner.visible_message(SPAN_DANGER("\The [owner] pulls the trigger reflexively!"))
	G.Fire(aiming_at, owner)
	toggle_active(FALSE, TRUE)
