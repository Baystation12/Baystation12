/obj/structure/chorus
	var/health = 10
	var/datum/chorus/owner
	icon = 'icons/obj/cult.dmi'
	var/last_click = 0
	var/click_cooldown = 10
	var/activation_cost_resource
	var/activation_cost_amount
	density = TRUE
	anchored = TRUE
	var/death_message = "crumbles!"
	var/death_sound = 'sound/effects/splat.ogg'

/obj/structure/chorus/Initialize(var/maploading, var/o)
	. = ..()
	if(o)
		owner = o
		owner.add_building(src)

/obj/structure/chorus/Destroy()
	if(owner)
		owner.remove_building(src)
	. = ..()

/obj/structure/chorus/examine(mob/user, distance)
	. = ..()
	if (distance < 4 || ischorus(user))
		var/message
		switch(PERCENT(health, initial(health), 0))
			if (75 to INFINITY)
				message = "It is intact."
			if (50 to 75)
				message = "It is damaged."
			if (25 to 50)
				message = "It is heavily damaged."
			else
				message = "It is nearly destroyed."
		to_chat(user, SPAN_WARNING(message))
/obj/structure/chorus/proc/chorus_click(var/mob/living/carbon/alien/chorus/C)
	if(can_activate(C))
		activate(C)
		last_click = world.time

/obj/structure/chorus/proc/has_resources(mob/living/carbon/alien/chorus/C, warning = TRUE)
	if(!owner)
		return FALSE
	if(activation_cost_resource && !owner.has_enough_resource(activation_cost_resource, activation_cost_amount))
		if(warning && C)
			var/datum/chorus_resource/cr = activation_cost_resource
			to_chat(C, SPAN_WARNING("You need more [initial(cr.name)] to activate \the [src]."))
		return FALSE
	return TRUE

/obj/structure/chorus/proc/can_activate(var/mob/living/carbon/alien/chorus/C, var/warning = TRUE)
	if(!owner)
		return FALSE
	if(last_click + click_cooldown < world.time && (!C || C.chorus_type == owner && get_dist(C, src) <= 1))
		if(activation_cost_resource && !owner.use_resource(activation_cost_resource, activation_cost_amount))
			if(warning && C)
				var/datum/chorus_resource/cr = activation_cost_resource
				to_chat(C, SPAN_WARNING("You need more [initial(cr.name)] to activate \the [src]."))
			return FALSE
		return TRUE
	return FALSE

/obj/structure/chorus/proc/activate(mob/living/carbon/alien/chorus/C)
	return

/obj/structure/chorus/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	playsound(get_turf(src), "swing_hit", 50, 1)
	user.visible_message(
		SPAN_DANGER("[user] hits \the [src] with \the [W]!"),
		SPAN_DANGER("You hit \the [src] with \the [W]!"),
		SPAN_DANGER("You hear something breaking!")
		)
	take_damage(W.force)

/obj/structure/chorus/take_damage(var/amount)
	health -= amount
	if(health < 0)
		crumble()

/obj/structure/chorus/proc/crumble()
	visible_message(SPAN_WARNING("\The [src] [death_message]"))
	playsound(loc, death_sound, 50, TRUE)
	qdel(src)

/obj/structure/chorus/bullet_act(var/obj/item/projectile/P)
	take_damage(P.damage)
