//as core click exists at the mob level
/mob/proc/trigger_aiming(var/trigger_type)
	return

/mob/living/trigger_aiming(var/trigger_type)
	if(!aimed.len)
		return
	for(var/obj/aiming_overlay/AO in aimed)
		if(AO.aiming_at == src)
			AO.update_aiming()
			if(AO.aiming_at == src)
				AO.trigger(trigger_type)
				AO.update_aiming_deferred()

/obj/aiming_overlay/proc/trigger(var/perm)
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
		addtimer(CALLBACK(G, /obj/item/gun/proc/handle_suicide, owner, 2))
		return
	if (prob(owner.skill_fail_chance(SKILL_WEAPONS, 30, SKILL_ADEPT, 3)))
		to_chat(owner, "<span class='warning'>You fumble with the gun, throwing your aim off!</span>")
		owner.stop_aiming(aiming_with)
		return
	owner.setClickCooldown(DEFAULT_QUICK_COOLDOWN) // Spam prevention, essentially.
	owner.visible_message("<span class='danger'>\The [owner] pulls the trigger reflexively!</span>")
	G.Fire(aiming_at, owner)
	toggle_active(FALSE, TRUE)
