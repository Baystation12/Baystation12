
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

/decl/ai_holo/halo/human_female
	icon_state = "hum_f"
	name = "Human Female"

/decl/ai_holo/halo/human_male
	icon_state = "hum_m"
	name = "Human Male"

//Covenant//

/decl/ai_holo/halo/cov_logo
	icon_state = "cov_logo"
	name = "Covenant Logo"
	faction_lock = "Covenant"

/decl/ai_holo/halo/cov_human
	icon_state = "cov_human"
	name = "Corrupted Covenant Human"
	faction_lock = "Covenant"

/decl/ai_holo/halo/cov_elite
	icon_state = "elite_helm"
	name = "Sangheilli (Helmet)"
	faction_lock = "Covenant"

/decl/ai_holo/halo/cov_elite_nohelm
	icon_state = "elite_nohelm"
	name = "Sangheilli (No Helmet)"
	faction_lock = "Covenant"

//UNSC//

/decl/ai_holo/halo/unsc_smallbird
	icon_state = "unschologram_smallbird"
	name = "Small Bird"
	faction_lock = "UNSC"

/decl/ai_holo/halo/unsc_largebird
	icon_state = "unschologram_bigbird"
	name = "Big Bird"
	faction_lock = "UNSC"

/decl/ai_holo/halo/unsc_aquila
	icon_state = "unschologram_aquila"
	name = "Aquila"
	faction_lock = "UNSC"

/decl/ai_holo/halo/unsc_mansus
	icon_state = "unschologram_mansus"
	name = "The Mansus"
	faction_lock = "UNSC"

/decl/ai_holo/halo/unsc_atlas
	icon_state = "unschologram_atlas"
	name = "Atlas"
	faction_lock = "UNSC"

/decl/ai_holo/halo/urf_mordred
	icon_state = "urfhologram_mordred"
	name = "Knight"
	faction_lock = "Insurrectionist"

/decl/ai_holo/halo/urf_cowboy
	icon_state = "urfhologram_cowboy"
	name = "Cowboy"
	faction_lock = "Insurrectionist"

/decl/ai_holo/halo/urf_brotherhood
	icon_state = "urfhologram_brotherhood"
	name = "Brotherhood"
	faction_lock = "Insurrectionist"

/decl/ai_holo/halo/urf_anonymous
	icon_state = "urfhologram_anonymous"
	name = "Anonymous"
	faction_lock = "Insurrectionist"

/decl/ai_holo/halo/urf_liberty
	icon_state = "urfhologram_liberty"
	name = "Sickle"
	faction_lock = "Insurrectionist"

/decl/ai_holo/halo/urf_undivided
	icon_state = "urfhologram_undivided"
	name = "Undivided"
	faction_lock = "Insurrectionist"
