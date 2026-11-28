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
	step_delay = 0.3

	muzzle_type = /obj/projectile/astral_razor/muzzle
	tracer_type = /obj/projectile/astral_razor/tracer
	impact_type = /obj/projectile/astral_razor/impact

	var/list/beam_sources

/obj/item/projectile/astral_razor_projectile/launch(atom/target, target_zone, x_offset, y_offset, angle_offset)
	if (!beam_sources)
		beam_sources = list()
		for (var/state in list("start", "middle", "end"))
			beam_sources[state] = new /obj/astral_razor_beam_render_source(null, state)
	return ..()

/obj/item/projectile/astral_razor_projectile/muzzle_effect()
	..()
	attach_segments()

/obj/item/projectile/astral_razor_projectile/tracer_effect()
	..()
	attach_segments()

/obj/item/projectile/astral_razor_projectile/impact_effect()
	..()
	attach_segments()

/obj/item/projectile/astral_razor_projectile/proc/attach_segments()
	for (var/obj/projectile/astral_razor/segment in segments)
		var/obj/astral_razor_beam_render_source/source = beam_sources?[segment.beam_state]
		if (QDELETED(source))
			qdel(segment)
			continue
		segment.render_source = source.render_target
		source.segments += segment
	segments.Cut()

/obj/astral_razor_beam_render_source
	icon = 'icons/coscult/cosmic-hitscan.dmi'
	icon_state = null
	screen_loc = "1,1"
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	var/anim_start_delay = 1
	var/anim_length = 4
	var/list/obj/projectile/astral_razor/segments = list()

/obj/astral_razor_beam_render_source/Initialize(mapload, state)
	. = ..()
	render_target = "*astral-razor-[state]-\ref[src]"
	for (var/client/C as anything in GLOB.clients)
		C.screen += src

	animate(src, icon_state = state, time = 0, delay = anim_start_delay) // workaround so the animation actually plays on the damn client
	QDEL_IN(src, anim_start_delay + anim_length + 1)

/obj/astral_razor_beam_render_source/Destroy()
	for (var/client/C as anything in GLOB.clients)
		C.screen -= src
	QDEL_NULL_LIST(segments)
	return ..()

/obj/projectile/astral_razor
	icon = null
	icon_state = null
	light_color = "#42a4ae"
	var/beam_state

/obj/projectile/astral_razor/tracer
	beam_state = "middle"

/obj/projectile/astral_razor/muzzle
	beam_state = "start"

/obj/projectile/astral_razor/impact
	beam_state = "end"
