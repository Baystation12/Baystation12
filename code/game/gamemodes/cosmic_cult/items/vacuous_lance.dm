/obj/item/cosmic_cult/vacuous_lance
	name = "vacuous lance"
	desc = "An unnerving spear, wrought of indescribable material. Being near it feels like a prickle of static spreading through your nerves."
	icon = 'icons/coscult/cosmic-vacuous-lance.dmi'
	icon_state = "icon"
	item_icons = list(
		slot_l_hand_str = 'icons/coscult/cosmic-vacuous-lance-inhands.dmi',
		slot_r_hand_str = 'icons/coscult/cosmic-vacuous-lance-inhands.dmi',
	)
	item_state_slots = list(
		slot_l_hand_str = "inhand-left",
		slot_r_hand_str = "inhand-right",
	)

	force = 20
	armor_penetration = 20
	throwforce = 36
	puncture = TRUE
	sharp = TRUE

	hitsound = 'sound/coscult/cosmic-lance-hit.ogg'
	hit_miss_sound = 'sound/coscult/cosmic-weapon-swing.ogg'
	hit_glance_sound = 'sound/coscult/cosmic-sword-glance.ogg'
	hit_sounds_override_target = TRUE

/obj/item/cosmic_cult/vacuous_lance/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	var/shift = (world.icon_size - 64) / 2
	ret.pixel_x = shift
	ret.pixel_y = shift
	return ret

/obj/item/cosmic_cult/vacuous_lance/before_apply_hit_effect(atom/target, user)
	cosmic_cult_hit_vfx(target)
