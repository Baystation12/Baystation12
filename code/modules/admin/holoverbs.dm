
/datum/admins/proc/ai_hologram_set(mob/appear as mob in world)
	set name = "Set AI Hologram"
	set desc = "Set an AI's hologram to a mob. Use this verb on the mob you want the hologram to look like."
	set category = "Fun"

	if(!check_rights(R_FUN)) return

	var/list/AIs = list()
	for(var/mob/living/silicon/ai/AI in GLOB.mob_list)
		AIs += AI

	var/mob/living/silicon/ai/AI = input("Which AI do you want to apply [appear] to as a hologram?") as null|anything in AIs
	if(!AI) return

	var/image/I = image(appear.icon, appear.icon_state)
	I.overlays = appear.overlays
	I.underlays = appear.underlays
	I.color = list(
			0.30, 0.30, 0.30, 0.0, // Greyscale and reduce the alpha of the icon
			0.59, 0.59, 0.59, 0.0,
			0.11, 0.11, 0.11, 0.0,
			0.00, 0.00, 0.00, 0.5,
			0.00, 0.00, 0.00, 0.0
		)
	var/image/scan = image('icons/effects/effects.dmi', "scanline")
	scan.color = list(
			0.30,0.30,0.30,0.00, // Greyscale the scanline icon too
			0.59,0.59,0.59,0.00,
			0.11,0.11,0.11,0.00,
			0.00,0.00,0.00,1.00,
			0.00,0.00,0.00,0.00
		)
	scan.blend_mode = BLEND_MULTIPLY

	// Combine the mob image and the scanlines into a single KEEP_TOGETHER'd image
	var/image/I2 = image(null)
	I2.underlays += I
	I2.overlays += scan
	I2.appearance_flags = KEEP_TOGETHER
	I2.color = rgb(125, 180, 225) // make it blue!
	AI.holo_icon = I2

	to_chat(AI, "Your hologram icon has been set to [appear].")
	log_and_message_admins("set [key_name(AI)]'s hologram icon to [key_name(appear)]")
