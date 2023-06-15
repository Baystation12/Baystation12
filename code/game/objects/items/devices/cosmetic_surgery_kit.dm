/obj/item/device/cosmetic_surgery_kit
	name = "cosmetic surgery auto-kit"
	icon = 'icons/obj/chameleon_projector.dmi'
	icon_state = "shield0"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	item_state = "electronic"
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(
		TECH_ESOTERIC = 3,
		TECH_MAGNET = 4
	)

	/// Whether this cosmetic surgery kit is spent.
	var/used = FALSE


/obj/item/device/cosmetic_surgery_kit/attack_self(mob/living/carbon/human/user)
	if (used)
		to_chat(user, SPAN_WARNING("The [src] remains lifeless, as it's armatures dangle uselessly, now."))
		return
	if (!istype(user))
		return
	var/datum/pronouns/pronouns = user.choose_from_pronouns()
	user.visible_message(
		SPAN_WARNING("\The [user] places \the [src] up to [pronouns.his] face."),
		SPAN_WARNING("You place \the [src] up to your face.")
	)
	if (!do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE) || !user.use_sanity_check(src))
		return
	user.visible_message(SPAN_DANGER("\The [src] purrs maliciously and unfurls its armatures with frightening speed!"))
	playsound(user, 'sound/items/electronic_assembly_emptying.ogg', 50, TRUE)
	user.visible_message(
		SPAN_DANGER("\The [src]'s armatures begin chipping away at \the [user]'s face!"),
		SPAN_DANGER("\The [src]'s armatures begin chipping away at your face!")
	)
	user.custom_pain("Your face feels like it's being shredded apart!", 160)
	playsound(user, 'sound/effects/squelch1.ogg', 25, TRUE)
	if (!do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE) || !user.use_sanity_check(src))
		return
	user.change_appearance(APPEARANCE_BASIC, state = GLOB.z_state)
	used = TRUE
	var/response = input(user, "What would you like to call your new self?", "Name change") as null | text
	response = sanitize(response, MAX_NAME_LEN)
	if (!response)
		return
	user.real_name = response
	user.SetName(response)
	user.dna.real_name = response
	if (user.mind)
		user.mind.name = user.name
