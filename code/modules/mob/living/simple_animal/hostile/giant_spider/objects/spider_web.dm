/// Base spider web type. Uninstantiable.
/obj/spider_web
	name = "web"
	desc = "It's stringy and sticky."
	icon = 'icons/spider.dmi'
	icon_state = null
	anchored = TRUE
	health_max = 5

	var/static/const


/obj/spider_web/Initialize()
	. = ..()
	INIT_DISALLOW_TYPE(/obj/spider_web)


/obj/spider_web/handle_death_change(new_state)
	if (!new_state)
		return
	qdel(src)


/obj/spider_web/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if (exposed_temperature > T50C)
		if (exposed_temperature > T100C)
			damage_health(health_max, DAMAGE_FIRE)
		else
			damage_health(2, DAMAGE_FIRE)


/obj/spider_web/attackby(obj/item/item, mob/living/user)
	user.setClickCooldown(item.attack_cooldown || DEFAULT_ATTACK_COOLDOWN)
	var/visible = "uselessly swipe"
	var/audible = "soft swishing"
	if (!(item.item_flags & ITEM_FLAG_NO_BLUDGEON))
		var/force = is_hot(item)
		if (force >= 1000)
			damage_health(health_max, DAMAGE_FIRE)
			visible = "incinerate"
			audible = "the swoosh of a quick flame"
		else if (force >= 100)
			damage_health(health_max / 3, DAMAGE_FIRE)
			visible = "singe"
			audible = "sizzling"
		else if (item.damtype == DAMAGE_BRUTE)
			force = item.force
			if (!item.edge && !item.sharp)
				force = force * 0.5
			if (force > health_current)
				damage_health(health_max, DAMAGE_BRUTE)
				visible = "shred"
				audible = "violent tearing"
			else if (force >= 2)
				damage_health(force, DAMAGE_BRUTE)
				visible = "tear"
				audible = "soft splattering"
	user.do_attack_animation(src)
	user.visible_message(
		SPAN_WARNING("\The [user] [visible]s \a [src] with \a [item]."),
		SPAN_WARNING("You [visible] \the [src] with \the [item]."),
		SPAN_WARNING("You hear [audible].")
	)


// Mapped spider web, visually attached to the top left
/obj/spider_web/topleft
	icon_state = "cobweb1"


// Mapped spider web, visually attached to the top right
/obj/spider_web/topright
	icon_state = "cobweb2"


/// Giant spider webs, created by giant spiders
/obj/spider_web/giant
	desc = "It's ropey and gluey."
	icon_state = "stickyweb1"
	health_max = 20
	can_buckle = TRUE

/// The percent chance to block a living mob from moving through the web
	var/block_living_chance = 50

/// The percent chance to try to buckle a blocked living mob to the web
	var/tangle_living_chance = 50

/// The damage done to the web when a living mob's movement is blocked
	var/block_living_damage = 2

/// The percent chance to block a projectile from moving through the web
	var/block_projectile_chance = 70


/obj/spider_web/giant/Destroy()
	if (buckled_mob)
		buckled_mob.buckled = null
		buckled_mob = null
	return ..()


/obj/spider_web/giant/Initialize()
	. = ..()
	if (prob(50))
		icon_state = "stickyweb2"


/obj/spider_web/giant/CanPass(atom/movable/movable, turf/target, height, air_group)
	if (!loc)
		return FALSE
	if (air_group || !height)
		return TRUE
	if (isliving(movable))
		if (istype(movable, /mob/living/simple_animal/hostile/giant_spider))
			return TRUE
		if (prob(block_living_chance))
			return TRUE
		if (!movable.anchored && prob(tangle_living_chance) && Adjacent(movable) && buckle_mob(movable, TRUE))
			movable.visible_message(
				SPAN_WARNING("\The [movable] gets tangled in \a [src]!"),
				SPAN_WARNING("You get tangled in \the [src]!")
			)
		else
			movable.visible_message(
				SPAN_WARNING("\The [movable] struggles against \a [src]."),
				SPAN_WARNING("You struggle against \the [src].")
			)
		damage_health(block_living_damage, DAMAGE_BRUTE)
		return FALSE
	if (istype(movable, /obj/item/projectile) && prob(block_projectile_chance))
		return FALSE
	return TRUE
