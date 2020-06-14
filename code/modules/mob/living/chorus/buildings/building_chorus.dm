/obj/structure/chorus
	var/health = 10
	var/mob/living/chorus/owner
	icon = 'icons/obj/cult.dmi'
	var/gives_sight = TRUE
	var/last_click = 0
	var/click_cooldown = 10
	var/activation_cost_resource
	var/activation_cost_amount
	density = 1
	anchored = 1

/obj/structure/chorus/Initialize(var/maploading, var/o)
	. = ..()
	if(o)
		owner = o
		owner.add_building(src)

/obj/structure/chorus/Destroy()
	owner.remove_building(src)
	. = ..()

/obj/structure/chorus/proc/chorus_click(var/mob/living/chorus/C)
	if(can_activate(C))
		activate()
		last_click = world.time

/obj/structure/chorus/proc/can_activate(var/mob/living/chorus/C, var/warning = TRUE)
	if(last_click + click_cooldown < world.time && C == owner)
		if(activation_cost_resource && !owner.use_resource(activation_cost_resource, activation_cost_amount))
			if(warning)
				var/datum/chorus_resource/cr = activation_cost_resource
				to_chat(owner, "<span class='warning'>You need more [initial(cr.name)] to activate \the [src]</span>")
			return FALSE
		return TRUE
	return FALSE

/obj/structure/chorus/proc/activate()
	return

/obj/structure/chorus/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	playsound(get_turf(src), 'sound/effects/Glasshit.ogg', 50, 1)
	user.visible_message(
		"<span class='danger'>[user] hits \the [src] with \the [W]!</span>",
		"<span class='danger'>You hit \the [src] with \the [W]!</span>",
		"<span class='danger'>You hear something breaking!</span>"
		)
	take_damage(W.force)

/obj/structure/chorus/take_damage(var/amount)
	health -= amount
	if(health < 0)
		src.visible_message("\The [src] crumbles!")
		qdel(src)

/obj/structure/chorus/bullet_act(var/obj/item/projectile/P)
	take_damage(P.damage)