/mob/living
	var/datum/psi_complexus/psi

/mob/living/Login()
	. = ..()
	if(psi)
		psi.update(TRUE)

/mob/living/Destroy()
	if(psi) qdel(psi)
	. = ..()

/mob/living/proc/set_psi_rank(var/faculty, var/rank, var/take_larger, var/defer_update, var/temporary)
	if(!psi)
		psi = new(src)
	var/current_rank = psi.get_rank(faculty)
	if(current_rank != rank && (!take_larger || current_rank < rank))
		psi.set_rank(faculty, rank, defer_update, temporary)

/mob/living/proc/announce_psionics()
	if(client && psi)
		to_chat(src, SPAN_NOTICE("<font size = 3>You are <b>psionic</b>, touched by powers beyond understanding.</font>"))

		var/latent_only = TRUE
		for(var/rank in psi.base_ranks)
			if(psi.base_ranks[rank] > 1)
				latent_only = FALSE
		if(latent_only)
			to_chat(src, SPAN_NOTICE("Your powers are <b>latent</b> and only debilitating trauma has a chance of making them available for use."))
		else
			to_chat(src, SPAN_NOTICE("Your powers are <b>operant</b>. <b>Shift-left-click your Psi icon</b> on the bottom right to <b>view a summary of how to use them</b>, or <b>left click</b> it to <b>suppress or unsuppress</b> your psionics. Beware: overusing your gifts can have <b>deadly consequences</b>."))
