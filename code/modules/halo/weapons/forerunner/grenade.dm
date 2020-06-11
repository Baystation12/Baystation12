
#define SPLINTER_FIELD_DECAY_TIME 15 SECONDS

/obj/effect/splinter_field
	name = "Splinter Field"
	desc = "Crossing this would be ill-advised..."
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites.dmi'
	icon_state = "splinterfield"

	var/die_at = 0

/obj/effect/splinter_field/Initialize()
	. = ..()
	GLOB.processing_objects += src

/obj/effect/splinter_field/process()
	if(world.time >= die_at)
		qdel(src)

/obj/effect/splinter_field/Crossed(var/mob/living/crosser)
	. = ..()
	if(istype(crosser))
		visible_message("<span class = 'danger'>Shards within [src] track [crosser], and explode!</span>")
		crosser.adjustFireLoss(100)

/obj/item/weapon/grenade/splinter
	name = "Z-400 Pursuit Disruption Grid Generator"
	desc = "On explosion, deploys a field of lingering shards that chase and explode nearby hostiles."
	icon = 'code/modules/halo/weapons/icons/forerunner_sprites.dmi'
	icon_state = "splinternade"
	can_adjust_timer = 0
	det_time = 50
	alt_explosion_range = 2
	alt_explosion_damage_max = 50

/obj/item/weapon/grenade/splinter/detonate()
	for(var/t in trange(1,loc))
		var/obj/effect/splinter_field/f = new (t)
		f.die_at = world.time + SPLINTER_FIELD_DECAY_TIME
	do_alt_explosion()
	qdel(src)

#undef SPLINTER_FIELD_DECAY_TIME
