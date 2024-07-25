/* Weapons
 * Contains:
 *		Sword
 *		Classic Baton
 */

/*
 * Classic Baton
 */
/obj/item/melee/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "baton"
	item_state = "classic_baton"
	base_parry_chance = 30
	slot_flags = SLOT_BELT
	force = 10

/obj/item/melee/classic_baton/use_before(mob/M as mob, mob/living/user as mob)
	. = FALSE
	if ((MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_WARNING("You club yourself over the head."))
		user.Weaken(3 * force)
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, DAMAGE_BRUTE, BP_HEAD)
		else
			user.take_organ_damage(2*force, 0)
		return TRUE

//Telescopic baton
/obj/item/melee/telebaton
	name = "telescopic baton"
	desc = "A compact yet balanced personal defense weapon. Can be concealed when collapsed."
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "telebaton_0"
	item_state = "telebaton_0"
	base_parry_chance = 30
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	force = 3
	var/on = 0


/obj/item/melee/telebaton/attack_self(mob/user as mob)
	on = !on
	if(on)
		user.visible_message(SPAN_WARNING("With a flick of their wrist, [user] extends their telescopic baton."),\
		SPAN_WARNING("You extend the baton."),\
		"You hear an ominous click.")
		w_class = ITEM_SIZE_NORMAL
		force = 15//quite robust
		attack_verb = list("cracked", "struck", "snapped", "thrashed", "whapped")
	else
		user.visible_message(SPAN_NOTICE("\The [user] collapses their telescopic baton."),\
		SPAN_NOTICE("You collapse the baton."),\
		"You hear a click.")
		w_class = ITEM_SIZE_SMALL
		force = 3//not so robust now
		attack_verb = list("hit", "punched")

	playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
	add_fingerprint(user)
	update_icon()

/obj/item/melee/telebaton/on_update_icon()
	if(on)
		icon_state = "telebaton_1"
		item_state = "telebaton_1"
	else
		icon_state = "telebaton_0"
		item_state = "telebaton_0"
	if(length(blood_DNA))
		generate_blood_overlay(TRUE) // Force recheck.
		ClearOverlays()
		AddOverlays(blood_overlay)

/obj/item/melee/telebaton/use_before(mob/target as mob, mob/living/user as mob)
	. = FALSE
	if (on && (MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_WARNING("You club yourself over the head."))
		user.Weaken(3 * force)
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2*force, DAMAGE_BRUTE, BP_HEAD)
		else
			user.take_organ_damage(2*force, 0)
		return TRUE
