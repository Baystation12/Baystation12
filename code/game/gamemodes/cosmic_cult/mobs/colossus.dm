/mob/living/simple_animal/colossus
	name = "entropic colossus"
	desc = "A colossal monstrosity wrought of malign plating."
	icon = 'icons/coscult/cosmic-colossus.dmi'
	icon_state = null
	pixel_z = -16
	pixel_w = -16
	mob_size = MOB_LARGE
	mob_push_flags = ALLMOBS
	mob_flags = MOB_FLAG_UNPINNABLE
	a_intent = I_HURT
	hud_type = /datum/hud

	min_gas = null
	max_gas = null
	minbodytemp = 0
	meat_type = null
	meat_amount = 0
	bone_material = null
	bone_amount = 0
	skin_material = null
	skin_amount = 0

	pass_flags = PASS_FLAG_TABLE

	var/datum/sound_token/colossus_ambience = null
	natural_weapon = /obj/item/natural_weapon/colossus

/mob/living/simple_animal/colossus/Initialize()
	. = ..()
	update_icon()
	set_light(2, 2, "#42a4ae")
	colossus_ambience = GLOB.sound_player.PlayLoopingSound(src, "[type]-ambience", 'sound/coscult/colossus-ambience.ogg', volume = 100, range = 18, falloff = 2)

	mind_initialize()
	var/datum/cosmic_cultist/cultist = new(src.mind, FALSE)
	cultist.grant_power(/datum/power/cosmic_cult/ingress/colossus)

/mob/living/simple_animal/colossus/Destroy()
	QDEL_NULL(colossus_ambience)
	return ..()

/mob/living/simple_animal/colossus/on_update_icon()
	ClearOverlays()
	AddOverlays(list(
		overlay_image(icon, "vfx-bg"),
		emissive_appearance(icon, "vfx-bg"),
		overlay_image(icon, "colossus"),
		emissive_blocker(icon, "colossus"),
		overlay_image(icon, "vfx-fg"),
		emissive_appearance(icon, "vfx-fg")
	))

/mob/living/simple_animal/colossus/can_fall(anchor_bypass = FALSE, turf/location_override = loc)
	return !HAS_FLAGS(pass_flags, PASS_FLAG_TABLE)

/mob/living/simple_animal/colossus/can_overcome_gravity()
	return HAS_FLAGS(pass_flags, PASS_FLAG_TABLE)

/obj/item/natural_weapon/colossus
	name = "malign fists"
	attack_verb = list("smashed", "crushed", "pummeled")
	force = 20

	hitsound = 'sound/coscult/cosmic-sword-hit.ogg'
	hit_miss_sound = 'sound/coscult/cosmic-weapon-swing.ogg'
	hit_glance_sound = 'sound/coscult/cosmic-sword-glance.ogg'
	hit_sounds_override_target = TRUE

	var/knockback_strength = 8
	var/knockback_speed = 1
	var/structural_bonus = 2

/obj/item/natural_weapon/colossus/before_apply_hit_effect(atom/target, user)
	cosmic_cult_hit_vfx(target)

/obj/item/natural_weapon/colossus/apply_hit_effect(mob/living/target, mob/living/user, hit_zone)
	. = ..()
	if (!. || target.anchored)
		return
	if (target.mob_size > MOB_MEDIUM)
		return
	target.throw_at(get_edge_target_turf(target, get_dir(user, target)), knockback_strength, knockback_speed, user)

/obj/item/natural_weapon/colossus/use_before(atom/target, mob/living/user, click_params) // copied from the entropic blade because incompatible parent types. woe is me
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
