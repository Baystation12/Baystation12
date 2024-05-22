/obj/item/clothing/mask/muzzle
	name = "muzzle"
	desc = "To stop that awful noise."
	icon_state = "muzzle"
	item_state = "muzzle"
	body_parts_covered = FACE
	w_class = ITEM_SIZE_SMALL
	gas_transfer_coefficient = 0.90
	voicechange = 1

/obj/item/clothing/mask/muzzle/tape
	name = "length of tape"
	desc = "It's a robust DIY muzzle!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape_cross"
	item_state = null
	w_class = ITEM_SIZE_TINY

/obj/item/clothing/mask/muzzle/Initialize()
	. = ..()
	say_messages = list("Mmfph!", "Mmmf mrrfff!", "Mmmf mnnf!")
	say_verbs = list("mumbles", "says")

// Clumsy folks can't take the mask off themselves.
/obj/item/clothing/mask/muzzle/attack_hand(mob/user as mob)
	if(user.wear_mask == src && !user.IsAdvancedToolUser())
		return 0
	..()

/obj/item/clothing/mask/surgical
	name = "sterile mask"
	desc = "A sterile mask designed to help prevent the spread of diseases."
	icon_state = "sterile"
	item_state = "sterile"
	w_class = ITEM_SIZE_TINY
	body_parts_covered = FACE
	item_flags = ITEM_FLAG_FLEXIBLEMATERIAL | ITEM_FLAG_WASHER_ALLOWED
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.01
	armor = list(
		bio = ARMOR_BIO_RESISTANT
		)
	down_gas_transfer_coefficient = 1
	down_body_parts_covered = null
	down_icon_state = "steriledown"
	pull_mask = 1

/obj/item/clothing/mask/fakemoustache
	name = "fake moustache"
	desc = "Warning: moustache is fake."
	icon_state = "fake-moustache"
	item_state = "fake-moustache"
	flags_inv = HIDEFACE
	body_parts_covered = 0
	visible_name = "Scoundrel"

/obj/item/clothing/mask/snorkel
	name = "snorkel"
	desc = "For the Swimming Savant."
	icon_state = "snorkel"
	item_state = "snorkel"
	item_flags = null
	flags_inv = HIDEFACE
	body_parts_covered = 0

/obj/item/clothing/mask/pig
	name = "pig mask"
	desc = "A rubber pig mask."
	icon_state = "pig"
	item_state = "pig"
	flags_inv = HIDEFACE|BLOCKHAIR
	w_class = ITEM_SIZE_SMALL
	siemens_coefficient = 0.9
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/horsehead
	name = "horse head mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a horse."
	icon_state = "horsehead"
	item_state = "horsehead"
	flags_inv = HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	w_class = ITEM_SIZE_SMALL
	siemens_coefficient = 0.9

/obj/item/clothing/mask/horsehead/New()
	..()
	// The horse mask doesn't cause voice changes by default, the wizard spell changes the flag as necessary
	say_messages = list("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")
	say_verbs = list("whinnies", "neighs", "says")


/obj/item/clothing/mask/ai
	name = "camera MIU"
	desc = "Allows for direct mental connection to accessible camera networks."
	icon_state = "s-ninja"
	item_state = "s-ninja"
	flags_inv = HIDEFACE
	item_flags = null
	body_parts_covered = FACE|EYES
	action_button_name = "Toggle MUI"
	origin_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5)
	active = FALSE
	var/mob/observer/eye/cameranet/eye

/obj/item/clothing/mask/ai/New()
	eye = new(src)
	eye.name_sufix = "camera MIU"
	..()

/obj/item/clothing/mask/ai/Destroy()
	if(eye)
		if(active)
			disengage_mask(eye.owner)
		qdel(eye)
		eye = null
	..()

/obj/item/clothing/mask/ai/attack_self(mob/user)
	if(user.incapacitated())
		return
	active = !active
	to_chat(user, SPAN_NOTICE("You [active ? "" : "dis"]engage \the [src]."))
	if(active)
		engage_mask(user)
	else
		disengage_mask(user)

/obj/item/clothing/mask/ai/equipped(mob/user, slot)
	..(user, slot)
	engage_mask(user)

/obj/item/clothing/mask/ai/dropped(mob/user)
	..()
	disengage_mask(user)

/obj/item/clothing/mask/ai/proc/engage_mask(mob/user)
	if(!active)
		return
	if(user.get_equipped_item(slot_wear_mask) != src)
		return

	eye.possess(user)
	to_chat(eye.owner, SPAN_NOTICE("You feel disorented for a moment as your mind connects to the camera network."))

/obj/item/clothing/mask/ai/proc/disengage_mask(mob/user)
	if(user == eye.owner)
		to_chat(eye.owner, SPAN_NOTICE("You feel disorented for a moment as your mind disconnects from the camera network."))
		eye.release(eye.owner)
		eye.forceMove(src)

/obj/item/clothing/mask/rubber
	name = "rubber mask"
	desc = "A rubber mask."
	icon_state = "balaclava"
	flags_inv = HIDEFACE|BLOCKHAIR
	siemens_coefficient = 0.9
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/mask/rubber/trasen
	name = "\improper Jack Trasen mask"
	desc = "CEO of NanoTrasen corporation. Perfect for scaring the unionizing children."
	icon_state = "trasen"
	visible_name = "Jack Trasen"

/obj/item/clothing/mask/rubber/barros
	name = "\improper Amaya Barros mask"
	desc = "Current Secretary-General of Sol Cental Government. Not that the real thing would visit this pigsty."
	icon_state = "barros"
	visible_name = "Amaya Barros"

/obj/item/clothing/mask/rubber/admiral
	name = "\improper Admiral Diwali mask"
	desc = "Admiral that led the infamous last stand at Helios against the Independent Navy in the Gaia conflict. For bridge officers who wish they'd achieve a fraction of that."
	icon_state = "admiral"
	visible_name = "Admiral Diwali"

/obj/item/clothing/mask/rubber/turner
	name = "\improper Charles Turner mask"
	desc = "Premier of the Gilgamesh Colonial Confederation. Probably shouldn't wear this in front of your veteran uncle."
	icon_state = "turner"
	visible_name = "Charles Turner"

/obj/item/clothing/mask/rubber/species
	name = "human mask"
	desc = "A rubber human mask."
	icon_state = "manmet"
	var/species = SPECIES_HUMAN

/obj/item/clothing/mask/rubber/species/New()
	..()
	visible_name = species
	var/datum/species/S = all_species[species]
	if(istype(S))
		var/singleton/cultural_info/C = SSculture.get_culture(S.default_cultural_info[TAG_CULTURE])
		if(istype(C))
			visible_name = C.get_random_name(pick(MALE,FEMALE))

/obj/item/clothing/mask/rubber/species/cat
	name = "cat mask"
	desc = "A rubber cat mask."
	icon_state = "catmet"

/obj/item/clothing/mask/rubber/species/unathi
	name = "unathi mask"
	desc = "A rubber unathi mask."
	icon_state = "lizmet"
	species = SPECIES_UNATHI

/obj/item/clothing/mask/rubber/species/skrell
	name = "skrell mask"
	desc = "A rubber skrell mask."
	icon_state = "skrellmet"
	species = SPECIES_SKRELL

/obj/item/clothing/mask/spirit
	name = "spirit mask"
	desc = "An eerie mask of ancient, pitted wood."
	icon_state = "spirit_mask"
	item_state = "spirit_mask"
	flags_inv = HIDEFACE
	body_parts_covered = FACE|EYES

// Bandanas below
/obj/item/clothing/mask/bandana
	name = "bandana"
	desc = "A soft piece of cloth. Can be worn on the head or face."
	flags_inv = HIDEFACE
	slot_flags = SLOT_MASK|SLOT_HEAD
	body_parts_covered = FACE
	icon_state = "bandana"
	item_state = "bandana"
	item_flags = ITEM_FLAG_FLEXIBLEMATERIAL | ITEM_FLAG_WASHER_ALLOWED
	w_class = ITEM_SIZE_SMALL

/obj/item/clothing/mask/bandana/equipped(mob/user, slot)
	switch(slot)
		if(slot_wear_mask) //Mask is the default for all the settings
			flags_inv = initial(flags_inv)
			body_parts_covered = initial(body_parts_covered)
			icon_state = initial(icon_state)
			sprite_sheets = list(
				SPECIES_VOX = 'icons/mob/species/vox/onmob_mask_vox.dmi',
				// [SIERRA-ADD] - RESOMI
				SPECIES_RESOMI = 'mods/resomi/icons/clothing/onmob_mask_resomi.dmi',
				// [/SIERRA-ADD]
				SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_mask_unathi.dmi'
				)
		if(slot_head)
			flags_inv = 0
			body_parts_covered = HEAD
			icon_state = "[initial(icon_state)]_up"
			sprite_sheets = list(
				SPECIES_VOX = 'icons/mob/species/vox/onmob_head_vox.dmi',
				// [SIERRA-ADD] - RESOMI
				SPECIES_RESOMI = 'mods/resomi/icons/clothing/onmob_head_resomi.dmi',
				// [/SIERRA-ADD]
				SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_head_unathi.dmi'
				)

	return ..()

/obj/item/clothing/mask/bandana/red
	color = COLOR_MAROON

/obj/item/clothing/mask/bandana/blue
	color = COLOR_NAVY_BLUE

/obj/item/clothing/mask/bandana/yellow
	color = COLOR_YELLOW_GRAY

/obj/item/clothing/mask/bandana/black
	color = COLOR_GRAY20

/obj/item/clothing/mask/bandana/engi
	name = "engineering bandana"
	icon_state = "bandorange"
	item_state = "bandorange"
	desc = "A soft piece of cloth that can be worn on the head or face. This one is orange and yellow."

/obj/item/clothing/mask/bandana/botany
	name = "botany bandana"
	icon_state = "bandbotany"
	item_state = "bandbotany"
	desc = "A soft piece of cloth that can be worn on the head or face. This one is green and blue."

/obj/item/clothing/mask/bandana/camo
	name = "camo bandana"
	icon_state = "bandcamo"
	item_state = "bandcamo"
	desc = "A soft piece of cloth that can be worn on the head or face. This one is camo."

/obj/item/clothing/mask/bandana/skull
	name = "skull bandana"
	icon_state = "bandskull"
	item_state = "bandskull"
	desc = "A soft piece of cloth that can be worn on the head or face. This one is black with a skull on it."
