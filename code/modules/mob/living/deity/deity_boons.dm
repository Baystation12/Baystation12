/mob/living/deity/proc/set_boon(var/datum/boon)
	if(current_boon)
		qdel(current_boon)
	current_boon = boon
	if(istype(boon, /atom/movable))
		var/atom/movable/A = boon
		A.forceMove(src)

/mob/living/deity/proc/grant_boon(var/mob/living/L)
	if(istype(current_boon, /spell) && !grant_spell(L, current_boon))
		return
	else if(istype(current_boon, /obj/item))
		var/obj/item/I = current_boon
		I.forceMove(get_turf(L))
		var/origin_text = "on the floor"
		if(L.equip_to_appropriate_slot(I))
			origin_text = "on your body"
		else if(L.put_in_any_hand_if_possible(I))
			origin_text = "in your hands"
		else
			var/obj/O =  L.equip_to_storage(I)
			if(O)
				origin_text = "in \the [O]"
		to_chat(L,"<span class='notice'>It appears [origin_text].</span>")

	to_chat(L, "<span class='cult'>\The [src] grants you a boon of [current_boon]!</span>")
	log_admin("[key_name(src)] gave [key_name(L)] the boon [current_boon]")
	current_boon = null
	return

/mob/living/deity/proc/grant_spell(var/mob/living/target, var/spell/spell)
	var/datum/mind/M = target.mind
	for(var/s in M.learned_spells)
		var/spell/S = s
		if(istype(S, spell.type))
			to_chat(src, "<span class='warning'>They already know that spell!</span>")
			return 0
	target.add_spell(spell)
	spell.set_connected_god(src)
	to_chat(target, "<span class='notice'>You feel a surge of power as you learn the art of [current_boon].</span>")
	return 1

/* This is a generic proc used by the God to inact a sacrifice from somebody. Power is a value of magnitude.
*/
/mob/living/deity/proc/take_charge(var/mob/living/L, var/power)
	if(form)
		return form.take_charge(L, power)
	return 1