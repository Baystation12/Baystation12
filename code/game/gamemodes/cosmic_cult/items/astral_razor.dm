/obj/item/cosmic_cult/astral_razor
	name = "astral razor"
	desc = "An wicked scythe wrought of malign material. The air near its edge is torn."
	icon = 'icons/coscult/cosmic-astral-razor.dmi'
	icon_state = "icon"
	item_icons = list(
		slot_l_hand_str = 'icons/coscult/cosmic-astral-razor-inhands.dmi',
		slot_r_hand_str = 'icons/coscult/cosmic-astral-razor-inhands.dmi',
	)
	item_state_slots = list(
		slot_l_hand_str = "inhand-left",
		slot_r_hand_str = "inhand-right",
	)

	force = 15
	edge = TRUE
	sharp = TRUE

	hitsound = 'sound/coscult/cosmic-sword-hit.ogg'
	hit_miss_sound = 'sound/coscult/cosmic-weapon-swing.ogg'
	hit_glance_sound = 'sound/coscult/cosmic-sword-glance.ogg'
	hit_sounds_override_target = TRUE

/obj/item/cosmic_cult/astral_razor/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	var/shift = (world.icon_size - 64) / 2
	ret.pixel_x = shift
	ret.pixel_y = shift
	return ret

/obj/item/cosmic_cult/astral_razor/before_apply_hit_effect(atom/target, user)
	cosmic_cult_hit_vfx(target)

/obj/item/cosmic_cult/astral_razor/afterattack(atom/target, mob/living/user, adjacent, params)
	if (adjacent)
		return ..()

	var/obj/item/projectile/astral_razor_projectile/P = new(get_turf(user))
	P.firer = user
	playsound(src, P.fire_sound, 50, TRUE)
	P.launch(target, user.zone_sel?.selecting || BP_CHEST)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

/obj/item/projectile/astral_razor_projectile
	name = "malign beam"
	fire_sound = 'sound/coscult/cosmic-projectile.ogg'
	impact_sounds = list(
		BULLET_IMPACT_MEAT = list('sound/coscult/cosmic-projectile-hit.ogg'),
		BULLET_IMPACT_METAL = list('sound/coscult/cosmic-projectile-hit.ogg'),
	)
	invisibility = INVISIBILITY_ABSTRACT
	damage = 20
	damage_type = DAMAGE_BURN
	hitscan = FALSE
	beam = TRUE
	distance_falloff = 1.5

	muzzle_type = /obj/projectile/astral_razor/muzzle
	tracer_type = /obj/projectile/astral_razor/tracer
	impact_type = /obj/projectile/astral_razor/impact

/obj/item/projectile/astral_razor_projectile/muzzle_effect()
	..()
	animate_segments()

/obj/item/projectile/astral_razor_projectile/tracer_effect()
	..()
	animate_segments()

/obj/item/projectile/astral_razor_projectile/impact_effect()
	..()
	animate_segments()

/obj/item/projectile/astral_razor_projectile/proc/animate_segments()
	for (var/obj/projectile/astral_razor/segment in segments)
		segment.start_animation()
	segments.Cut()

/obj/projectile/astral_razor
	icon = 'icons/coscult/cosmic-hitscan.dmi'
	icon_state = null
	light_color = "#42a4ae"
	var/anim_state
	var/anim_start_delay = 1
	var/anim_length = 4

/obj/projectile/astral_razor/proc/start_animation()
	animate(src, icon_state = anim_state, time = 0, delay = anim_start_delay) // workaround so the animation actually plays on the damn client
	QDEL_IN(src, anim_start_delay + anim_length + 1)

/obj/projectile/astral_razor/tracer
	anim_state = "middle"

/obj/projectile/astral_razor/muzzle
	anim_state = "start"

/obj/projectile/astral_razor/impact
	anim_state = "end"
