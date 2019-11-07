/spell/targeted/heal_target
	name = "Cure Light Wounds"
	desc = "a rudimentary spell used mainly by wizards to heal papercuts. Does not require wizard garb."
	feedback = "CL"
	school = "transmutation"
	charge_max = 20 SECONDS
	spell_flags = INCLUDEUSER | SELECTABLE
	invocation = "Di'Nath!"
	invocation_type = SpI_SHOUT
	range = 2
	max_targets = 1
	level_max = list(Sp_TOTAL = 2, Sp_SPEED = 1, Sp_POWER = 2)

	cooldown_reduc = 50
	hud_state = "heal_minor"
	cast_sound = 'sound/magic/staff_healing.ogg'

	amt_dam_brute = -15
	amt_dam_fire = -5
	amt_dam_robo = -4
	effect_state = "green_sparkles"
	effect_duration = 5

	message = "You feel a pleasant rush of heat move through your body."

/spell/targeted/heal_target/empower_spell()
	if(!..())
		return 0
	amt_dam_brute -= 15
	amt_dam_fire -= 15
	amt_dam_robo -= 7
	return "[src] will now heal more."

/spell/targeted/heal_target/tower
	charge_max = 2

/spell/targeted/heal_target/touch
	name = "Healing Touch"
	desc = "Heals an adjacent target for a reasonable amount of health."
	range = 1
	amt_dam_fire = -7
	amt_dam_brute = -7
	amt_dam_robo = -5
	charge_max = 10 SECONDS
	spell_flags = SELECTABLE
	invocation = "Di'Na!"

	hud_state = "heal_touch"

/spell/targeted/heal_target/major
	name = "Cure Major Wounds"
	desc = "A spell used to fix others that cannot be fixed with regular medicine."
	feedback = "CM"
	charge_max = 30 SECONDS
	spell_flags = INCLUDEUSER | SELECTABLE | NEEDSCLOTHES
	invocation = "Borv Di'Nath!"
	range = 1
	level_max = list(Sp_TOTAL = 2, Sp_SPEED = 1, Sp_POWER = 1)
	cooldown_reduc = 100
	hud_state = "heal_major"

	amt_dam_brute = -75
	amt_dam_fire  = -50
	amt_dam_robo = -10
	amt_blood  = 28

	message = "Your body feels like a furnace."

/spell/targeted/heal_target/major/empower_spell()
	if(!..())
		return 0
	amt_blood  = 28
	amt_organ = 5
	amt_brain  = -5
	amt_radiation  = -25
	amt_dam_tox = -20
	amt_dam_oxy = -14
	amt_dam_brute = -35
	amt_dam_fire  = -35
	amt_dam_robo = -15

	return "[src] heals more, and heals organ damage and radiation."

/spell/targeted/heal_target/major/tower
	charge_max = 1
	spell_flags = INCLUDEUSER | SELECTABLE

/spell/targeted/heal_target/area
	name = "Cure Area"
	desc = "This spell heals everyone in an area."
	feedback = "HA"
	charge_max = 1 MINUTE
	spell_flags = INCLUDEUSER
	invocation = "Nal Di'Nath!"
	range = 2
	max_targets = 0
	level_max = list(Sp_TOTAL = 1, Sp_SPEED = 1, Sp_POWER = 1)
	cooldown_reduc = 300
	hud_state = "heal_area"
	amt_dam_robo = -6
	amt_dam_brute = -25
	amt_dam_fire = -25

/spell/targeted/heal_target/area/empower_spell()
	if(!..())
		return 0
	amt_dam_brute -= 15
	amt_dam_fire -= 15
	amt_dam_robo -= 4
	range += 2

	return "[src] now heals more in a wider area."

/spell/targeted/heal_target/area/tower
	charge_max = 1

/spell/targeted/heal_target/area/slow
	charge_max = 2 MINUTES

/spell/targeted/heal_target/sacrifice
	name = "Sacrifice"
	desc = "This spell heals immensily. For a price. Does not require wizard garb."
	feedback = "SF"
	spell_flags = SELECTABLE
	invocation = "Ei'Nath Borv Di'Nath!"
	charge_type = Sp_HOLDVAR
	holder_var_type = "fireloss"
	holder_var_amount = 100
	level_max = list(Sp_TOTAL = 1, Sp_SPEED = 0, Sp_POWER = 1)

	amt_dam_brute = -1000
	amt_dam_fire = -1000
	amt_dam_oxy = -100
	amt_dam_tox = -100
	amt_dam_robo = -1000
	amt_blood  = 280
	effect_color = "#ff0000"

	hud_state = "gen_dissolve"
	cast_sound = 'sound/magic/disintegrate.ogg'

/spell/targeted/heal_target/sacrifice/empower_spell()
	if(!..())
		return 0

	amt_organ = 25
	amt_brain  = -25
	amt_radiation  = -100


	return "You will now heal organ and brain damage, as well as virtually purge all radiation."


/spell/targeted/heal_target/trance
	name = "trance"
	desc = "A mighty spell of restoration that briefly forces its target into a deep, dreamless sleep, rapidly repairing their body and soul as their senses are dulled. The users of this mighty art are known for being short lived, slowly devolving into raving madness as the power they once relied on fails them with excessive use."
	feedback = "TC"
	spell_flags = SELECTABLE
	invocation = "Di' Dae Nath!"
	charge_max = 2 MINUTES

	amt_dam_brute = -1000
	amt_dam_fire = -1000
	amt_dam_oxy = -100
	amt_dam_tox = -100
	amt_dam_robo = -1000
	hud_state = "trance"
	var/obj/effect/effect

/spell/targeted/heal_target/trance/cast(var/list/targets, var/mob/user)
	for(var/t in targets)
		var/mob/living/L = t
		var/turf/T = get_turf(L)
		effect = new /obj/effect/rift(T)
		effect.color = "f0e68c"
		L.forceMove(effect)
		var/time = (L.getBruteLoss() + L.getFireLoss()) * 20
		L.status_flags &= GODMODE
		to_chat(L,"<span class='notice'>You will be in stasis for [time/10] second\s</span>")
		addtimer(CALLBACK(src,.proc/cancel_rift),time)

/spell/targeted/heal_target/trance/Destroy()
	cancel_rift()
	return ..()

/spell/targeted/heal_target/trance/proc/cancel_rift()
	if(effect)
		var/mob/living/L = locate() in effect
		L.status_flags &= ~GODMODE
		L.forceMove(get_turf(L))
		apply_spell_damage(L)
		charge_max += 300
		QDEL_NULL(effect)

/spell/targeted/revoke
	name = "Revoke Death"
	desc = "Revoke that of death itself. Comes at a cost that may be hard to manage for some."
	feedback = "RK"

	spell_flags = SELECTABLE

	charge_type = Sp_CHARGES
	charge_max = 1
	invocation = "Di Le Nal Yen Nath!"
	invocation_type = SpI_SHOUT
	range = 1
	hud_state = "heal_revoke"

/spell/targeted/revoke/cast(var/list/targets, var/mob/living/user)
	if(alert(user, "Are you sure?", "Alert", "Yes", "No") == "Yes" && alert(user, "Are you ABSOLUTELY SURE?", "Alert", "Absolutely!", "No") == "Absolutely!")
		var/should_wait = 1
		for(var/t in targets)
			var/mob/living/M = t
			M.rejuvenate()
			if(M.client) //We've got a dude
				should_wait = 0
				break //Don't need to check anymore.
		if(should_wait)
			addtimer(CALLBACK(src,.proc/check_for_revoke,targets), 30 SECONDS)
		else
			revoke_spells()


/spell/targeted/revoke/proc/check_for_revoke(var/list/targets)
	for(var/t in targets)
		var/mob/M = t
		if(M.client)
			revoke_spells()
			return
	charge_counter = charge_max
	to_chat(holder,"<span class='notice'>\The [src] refreshes as it seems it could not bring back the souls of those you healed.</span>")

/spell/targeted/revoke/proc/revoke_spells()
	if(!istype(holder, /mob/living))
		return
	var/mob/living/M = holder
	if(M.mind)
		for(var/s in M.mind.learned_spells)
			if(istype(s, /spell/toggle_armor)) //Can keep the armor n junk.
				continue
			M.remove_spell(s)
	for(var/a in M.auras)
		M.remove_aura(a)