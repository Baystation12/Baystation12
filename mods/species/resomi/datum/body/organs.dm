
	//						//
	//EXTERNAL RESOMI ORGANS//
	//						//

/obj/item/organ/external/foot/resomi
	body_hair = "feathers"

/obj/item/organ/external/foot/right/resomi
	body_hair = "feathers"

/obj/item/organ/external/hand/resomi
	body_hair = "feathers"

/obj/item/organ/external/hand/right/resomi
	body_hair = "feathers"

	//						//
	//INTERNAL RESOMI ORGANS//
	//						//

/obj/item/organ/internal/kidneys/resomi
	parent_organ = BP_CHEST

/obj/item/organ/internal/liver/resomi
	parent_organ = BP_CHEST

/obj/item/organ/internal/eyes/resomi
	icon = 'packs/infinity/icons/mob/human_races/species/resomi/eyes.dmi'
	eye_icon = 'packs/infinity/icons/mob/human_races/species/resomi/eyes.dmi'
	icon_state = "eyes_resomi"

	//							//
	// PROSTHETIC RESOMI ORGANS	//
	//							//

/datum/robolimb/resomi
	company = "Small prosthetic"
	desc = "This prosthetic is small and fit for nonhuman proportions."
	icon = 'packs/infinity/icons/mob/human_races/cyberlimbs/resomi/resomi_main.dmi'
	species_cannot_use = list(SPECIES_ADHERENT, SPECIES_YEOSA, SPECIES_UNATHI, SPECIES_NABBER, SPECIES_DIONA)
	restricted_to = list(SPECIES_RESOMI)
	allowed_bodytypes = list(SPECIES_RESOMI)
	applies_to_part = list(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT, BP_L_HAND, BP_R_HAND)


	//							//
	//    RESOMI ABILITY 		//
	//							//

/mob/living/proc/toggle_pass_table()
	set category = "Abilities"
	set name = "Toggle Agility" //Dunno a better name for this. You have to be pretty agile to hop over stuff!!!
	set desc = "Allows you to start/stop hopping over things such as hydroponics trays, tables, and railings."
	pass_flags ^= PASS_FLAG_TABLE //I dunno what this fancy ^= is but Aronai gave it to me.
	to_chat(src, "You [pass_flags&PASS_FLAG_TABLE ? "will" : "will NOT"] move over tables/railings/trays!")


/mob/living/carbon/human/proc/resomi_sonar_ping()
	set name = "Listen In"
	set desc = "Allows you to listen in to movement and noises around you."
	set category = "Abilities"

	if(incapacitated())
		to_chat(src, "<span class='warning'>You need to recover before you can use this ability.</span>")
		return
	if(is_deaf() || is_below_sound_pressure(get_turf(src)))
		to_chat(src, "<span class='warning'>You are for all intents and purposes currently deaf!</span>")
		return
	to_chat(src, "<span class='notice'>You take a moment to listen in to your environment...</span>")
	if(do_after(src, delay = 5, do_flags = DO_DEFAULT & ~DO_USER_SAME_HAND))
		var/heard_something = FALSE
		for(var/mob/living/L in range(client.view, src))
			var/turf/T = get_turf(L)
			if(!T || L == src || L.stat == DEAD || is_below_sound_pressure(T))
				continue
			heard_something = TRUE
			var/image/ping_image = image(icon = 'icons/effects/effects.dmi', icon_state = "sonar_ping", loc = src)
			ping_image.plane = HUD_PLANE
			ping_image.layer = UNDER_HUD_LAYER
			ping_image.pixel_x = (T.x - src.x) * WORLD_ICON_SIZE
			ping_image.pixel_y = (T.y - src.y) * WORLD_ICON_SIZE
			image_to(src, ping_image)
			addtimer(CALLBACK(src, .proc/clear_sonar_effect, src.client, ping_image), 8)
			var/feedback = list("<span class='notice'>There are noises of movement ")
			var/direction = get_dir(src, L)
			if(direction)
				feedback += "towards the [dir2text(direction)], "
				switch(get_dist(src, L) / client.view)
					if(0 to 0.2)
						feedback += "very close by."
					if(0.2 to 0.4)
						feedback += "close by."
					if(0.4 to 0.6)
						feedback += "some distance away."
					if(0.6 to 0.8)
						feedback += "further away."
					else
						feedback += "far away."
			else // No need to check distance if they're standing right on-top of us
				feedback += "right on top of you."
			feedback += "</span>"
			to_chat(src, jointext(feedback,null))
		if(!heard_something)
			to_chat(src, "<span class='notice'>You hear no movement but your own.</span>")
	else
		to_chat(src, "<span class='notice'>You need to stand still while you listen.</span>")


/mob/living/carbon/human/proc/clear_sonar_effect(var/client/C, var/image/I)
	if(C && I)
		C.images -= I
	qdel(I)
