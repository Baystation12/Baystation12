/mob/living/deity/proc/add_follower(var/mob/living/L)
	if(is_follower(L, silent=1))
		return

	adjust_source(3, L)
	minions += L.mind
	var/spell/construction/C = new()
	L.add_spell(C)
	C.set_connected_god(src)
	if(form)
		L.faction = form.faction
	update_followers()
	GLOB.destroyed_event.register(L,src, .proc/dead_follower)
	GLOB.death_event.register(L,src, .proc/update_followers)

/mob/living/deity/proc/dead_follower(var/mob/living/L)
	GLOB.death_event.unregister(L,src)
	GLOB.destroyed_event.unregister(L,src)

/mob/living/deity/proc/remove_follower_spells(var/datum/mind/M)
	if(M.learned_spells)
		for(var/s in M.learned_spells)
			var/spell/S = s
			if(S.connected_god == src)
				M.current.remove_spell(S)
				qdel(S)

/mob/living/deity/proc/remove_follower(var/mob/living/L)
	if(!is_follower(L, silent=1))
		return

	adjust_source(-3, L)
	minions -= L.mind
	L.faction = MOB_FACTION_NEUTRAL
	if(L.mind)
		remove_follower_spells(L.mind)
	update_followers()


/mob/living/deity/proc/adjust_source(var/amount, var/atom/source, var/silent = 0, var/msg)
	adjust_power_min(amount, silent, msg)
	if(!ismovable(source))
		return
	if(amount > 0)
		eyeobj.visualnet.add_source(source)
		if(istype(source, /obj/structure/deity))
			structures |= source
	else
		eyeobj.visualnet.remove_source(source)
		if(istype(source, /obj/structure/deity))
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
	eyeobj.SetName("[src] ([eyeobj.name_sufix])")
	nano_data["name"] = new_name
	return 1

//Whether we are near an important structure.
/mob/living/deity/proc/near_structure(var/atom/A, var/all_structures = 0)
	var/turf/T = get_turf(A)
	for(var/s in structures)
		if(!all_structures)
			var/obj/structure/deity/D = s
			if(D.deity_flags & DEITY_STRUCTURE_NEAR_IMPORTANT)//If it needs to be near an important structure, it isn't important.
				continue

		if(get_dist(T, s) <= 3)
			return 1
	return 0