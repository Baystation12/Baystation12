/obj/item/cosmic_cult/entropic_blade
	name = "entropic blade"
	desc = "An eerie greatsword wrought of indescribable material, forcibly extruded down into reality."
	icon = 'icons/coscult/cosmic-entropic-blade.dmi'
	icon_state = "icon"
	item_icons = list(
		slot_l_hand_str = 'icons/coscult/cosmic-entropic-blade-inhands.dmi',
		slot_r_hand_str = 'icons/coscult/cosmic-entropic-blade-inhands.dmi',
	)
	item_state_slots = list(
		slot_l_hand_str = "inhand-left",
		slot_r_hand_str = "inhand-right",
	)

	force = 35
	var/structural_bonus = 2.5
	edge = TRUE

	hitsound = 'sound/coscult/cosmic-sword-hit.ogg'
	hit_miss_sound = 'sound/coscult/cosmic-weapon-swing.ogg'
	hit_glance_sound = 'sound/coscult/cosmic-sword-glance.ogg'
	hit_sounds_override_target = TRUE

/obj/item/cosmic_cult/entropic_blade/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	var/shift = (world.icon_size - 64) / 2
	ret.pixel_x = shift
	ret.pixel_y = shift
	return ret

/obj/item/cosmic_cult/entropic_blade/before_apply_hit_effect(atom/target, user)
	cosmic_cult_hit_vfx(target)

/obj/item/cosmic_cult/entropic_blade/use_before(atom/target, mob/living/user, click_params)
	if (ismob(target) || (user.a_intent != I_HURT))
		return ..()
	if (!istype(target, /obj/structure) && !istype(target, /obj/machinery) && !istype(target, /turf/simulated/wall))
		return ..()
	var/old_force = force
	force *= structural_bonus
	. = target.use_weapon(src, user, click_params)
	force = old_force
	if (!.)
		return ..()
