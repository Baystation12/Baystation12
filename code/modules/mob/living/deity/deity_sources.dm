/mob/living/deity/proc/add_follower(var/mob/living/L)
	if(is_follower(L, silent=1))
		return

	adjust_source(30, L)
	minions += L.mind
	if(form)
		L.faction = form.faction

/mob/living/deity/proc/remove_follower(var/mob/living/L)
	if(!is_follower(L, silent=1))
		return

	adjust_source(-30, L)

/mob/living/deity/proc/change_follower(var/mob/living/L, var/adding = 1)
	if(is_follower(L, silent=1) && adding)
		return

	adjust_source(30 * (adding ? 1 : -1), L, 0)
	if(adding)
		minions += L.mind
		if(form)
			L.faction = form.faction
	else
		minions -= L.mind
		L.faction = "neutral"

/mob/living/deity/proc/adjust_power(var/amount, var/silent = 0, var/msg)
	if(feats[DEITY_POWER_BONUS])
		amount += amount * feats[DEITY_POWER_BONUS]
	mob_uplink.uses = max(0, mob_uplink.uses + amount)
	if(!silent)
		var/feel = ""
		if(abs(amount) > 100)
			feel = " immensely"
		else if(abs(amount) > 50)
			feel = " greatly"
		if(abs(amount) >= 10)
			var/class = amount > 0 ? "notice" : "warning"
			to_chat(src, "<span class='[class]'>You feel your power [amount > 0 ? "increase" : "decrease"][feel][msg ? " [msg]" : ""]</span>")


/mob/living/deity/proc/adjust_source(var/amount, var/atom/source, var/silent = 0, var/msg)
	adjust_power(amount, silent, msg)
	if(!ismovable(source))
		return
	if(amount > 0)
		eyeobj.visualnet.add_source(source)
		if(isobj(source))
			structures |= source
	else
		if(isobj(source))
			structures -= source

/mob/living/deity/proc/is_follower(var/mob/living/L, var/silent = 0)
	if(istype(L))
		if(L.mind)
			if(L.mind in minions)
				return 1
		if(!silent)
			to_chat(src, "<span class='warning'>You do not feel a malleable mind behind that frame.</span>")
	return 0

/mob/living/deity/fully_replace_character_name(var/new_name, var/in_depth = TRUE)
	if(!..())
		return 0
	for(var/m in minions)
		var/datum/mind/minion = m
		to_chat(minion.current, "Your master is now known as [new_name]")
		minion.special_role = "Servant of [new_name]"
	eyeobj.name = "[src] ([eyeobj.name_sufix])"
	return 1

//Whether we are near an important structure.
/mob/living/deity/proc/near_structure(var/mob/living/L)
	var/turf/T = get_turf(L)
	for(var/s in structures)
		var/obj/structure/deity/D = s
		if(!D.important_structure)
			continue

		if(get_dist(T, s) <= 3)
			return 1
	return 0

/mob/living/deity/proc/take_cost(var/amount)
	if(amount)
		GLOB.nanomanager.update_uis(mob_uplink)
		mob_uplink.uses -= amount
		mob_uplink.used_TC += amount