
//Contains the /obj/effect/ai_holo define as well as hologram decls.

/obj/effect/ai_holo
	name = "AI Hologram"
	desc = "A Hologram."
	density = 0
	var/mob/living/silicon/ai/our_ai

/obj/effect/ai_holo/New(var/turf/new_loc,var/master_ai,var/new_icon)
	. = ..()
	forceMove(new_loc)
	our_ai = master_ai
	name = "[our_ai.name] (Hologram)"
	icon = new_icon

/obj/effect/ai_holo/hear_talk(mob/M as mob, text, verb, datum/language/speaking)
	our_ai.hear_say(text, verb, speaking, "",1, M)

/obj/effect/ai_holo/see_emote(mob/living/M, text)
	our_ai.show_message(text, 2)

/obj/effect/ai_holo/show_message(msg, type, alt, alt_type)
	our_ai.show_message(msg,type,alt,alt_type)

//Hologram decls//

/decl/ai_holo/halo
	icon = 'code/modules/halo/icons/ai_holograms/holograms.dmi'
	icon_state = "icon_state"
	icon_colorize = TRUE

/decl/ai_holo/halo/melon
	icon_state = "melon"
	name = "melon"

/decl/ai_holo/halo/cov_logo
	icon_state = "cov_logo"
	name = "Covenant Logo"

/decl/ai_holo/halo/cov_human
	icon_state = "cov_human"
	name = "Corrupted Covenant Human"

/decl/ai_holo/halo/cov_elite
	icon_state = "elite_helm"
	name = "Sangheilli (Helmet)"

/decl/ai_holo/halo/cov_elite_nohelm
	icon_state = "elite_nohelm"
	name = "Sangheilli (No Helmet)"
