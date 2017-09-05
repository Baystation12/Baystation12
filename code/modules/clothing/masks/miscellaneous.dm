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

/obj/item/clothing/mask/muzzle/New()
    ..()
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
	w_class = ITEM_SIZE_SMALL
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 60, rad = 0)
	down_gas_transfer_coefficient = 1
	down_body_parts_covered = null
	down_icon_state = "steriledown"
	pull_mask = 1

/obj/item/clothing/mask/fakemoustache
	name = "fake moustache"
	desc = "Warning: moustache is fake."
	icon_state = "fake-moustache"
	flags_inv = HIDEFACE
	body_parts_covered = 0
	visible_name = "Scoundrel"

/obj/item/clothing/mask/snorkel
	name = "Snorkel"
	desc = "For the Swimming Savant."
	icon_state = "snorkel"
	flags_inv = HIDEFACE
	body_parts_covered = 0

//scarves (fit in in mask slot)
//None of these actually have on-mob sprites...
/obj/item/clothing/mask/bluescarf
	name = "blue neck scarf"
	desc = "A blue neck scarf."
	icon_state = "blueneckscarf"
	item_state = "blueneckscarf"
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	w_class = ITEM_SIZE_SMALL
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/redscarf
	name = "red scarf"
	desc = "A red and white checkered neck scarf."
	icon_state = "redwhite_scarf"
	item_state = "redwhite_scarf"
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	w_class = ITEM_SIZE_SMALL
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/greenscarf
	name = "green scarf"
	desc = "A green neck scarf."
	icon_state = "green_scarf"
	item_state = "green_scarf"
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	w_class = ITEM_SIZE_SMALL
	gas_transfer_coefficient = 0.90

/obj/item/clothing/mask/ninjascarf
	name = "ninja scarf"
	desc = "A stealthy, dark scarf."
	icon_state = "ninja_scarf"
	item_state = "ninja_scarf"
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	w_class = ITEM_SIZE_SMALL
	gas_transfer_coefficient = 0.90
	siemens_coefficient = 0

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
	body_parts_covered = FACE|EYES
	action_button_name = "Toggle MUI"
	origin_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5)
	var/active = FALSE
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

/obj/item/clothing/mask/ai/attack_self(var/mob/user)
	if(user.incapacitated())
		return
	active = !active
	to_chat(user, "<span class='notice'>You [active ? "" : "dis"]engage \the [src].</span>")
	if(active)
		engage_mask(user)
	else
		disengage_mask(user)

/obj/item/clothing/mask/ai/equipped(var/mob/user, var/slot)
	..(user, slot)
	engage_mask(user)

/obj/item/clothing/mask/ai/dropped(var/mob/user)
	..()
	disengage_mask(user)

/obj/item/clothing/mask/ai/proc/engage_mask(var/mob/user)
	if(!active)
		return
	if(user.get_equipped_item(slot_wear_mask) != src)
		return

	eye.possess(user)
	to_chat(eye.owner, "<span class='notice'>You feel disorented for a moment as your mind connects to the camera network.</span>")

/obj/item/clothing/mask/ai/proc/disengage_mask(var/mob/user)
	if(user == eye.owner)
		to_chat(eye.owner, "<span class='notice'>You feel disorented for a moment as your mind disconnects from the camera network.</span>")
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
	name = "Jack Trasen mask"
	desc = "CEO of NanoTrasen corporation. Perfect for scaring the unionizing children."
	icon_state = "trasen"
	visible_name = "Jack Trasen"

/obj/item/clothing/mask/rubber/barros
	name = "Amaya Barros mask"
	desc = "Current Secretary-General of Sol Cental Government. Not that the real thing would visit this pigsty."
	icon_state = "barros"
	visible_name = "Amaya Barros"

/obj/item/clothing/mask/rubber/admiral
	name = "Admiral Diwali mask"
	desc = "Admiral that defeated the Terran Confederacy fleet in Gaia war. For bridge officers who wish they'd achieve a fraction of that."
	icon_state = "admiral"
	visible_name = "Admiral Diwali"

/obj/item/clothing/mask/rubber/turner
	name = "Charles Turner mask"
	desc = "Speaker of the Terran Confederacy. Probably shouldn't wear this in front of your veteran uncle."
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
		visible_name = S.get_random_name(pick(MALE,FEMALE))

/obj/item/clothing/mask/rubber/species/tajaran
	name = "tajara mask"
	desc = "A rubber tajara mask."
	icon_state = "catmet"
	species = SPECIES_TAJARA

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