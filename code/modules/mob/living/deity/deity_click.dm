/mob/living/deity/ClickOn(var/atom/A, var/params)
	if(A == src)
		if(form)
			ui_interact(src)
		else
			choose_form()
		return
	var/list/modifiers = params2list(params)
	if(modifiers["shift"] || modifiers["ctrl"])
		if(silenced)
			to_chat(src, "<span class='warning'>You cannot do that as you are silenced!</span>")
		else
			var/datum/phenomena/phenomena = get_phenomena(modifiers["shift"], modifiers["ctrl"])
			if(phenomena)
				phenomena.Click(A)
		return
	if(current_boon && is_follower(A))
		grant_boon(A)
	else if(istype(A, /obj/structure/deity))
		var/obj/structure/deity/D = A
		if(D.linked_god == src)
			D.attack_deity(src)
			return
	..()