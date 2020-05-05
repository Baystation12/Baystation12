
/obj/item/weapon/pickaxe/plasma_drill
	name = "plasma drill"
	icon = 'plasma_drill.dmi'
	icon_state = "plasma04"
	item_state = "ionrifle"
	digspeed = 0
	desc = "An advanced tool for cutting through metals."
	excavation_amount = 200
	drill_sound = 'sound/effects/teleport.ogg'
	drill_verb = "burning"
	damtype = "brute"
	sharp = 0
	edge = 0
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_BACK|SLOT_BELT
	var/charge_level = 100
	var/charge_max = 100
	var/charge_per_hit = 1
	var/active = 0
	repair_material = /obj/item/stack/material/nanolaminate
	repair_name = "nanolaminate"
	durability = 200
	max_durability = 200
	var/image_overlay = null

/obj/item/weapon/pickaxe/plasma_drill/New()
	. = ..()
	image_overlay = image('plasma_drill.dmi', "plasma_sparks")

/obj/item/weapon/pickaxe/plasma_drill/update_icon()
	var/charge_increment = charge_max / 4
	var/meter_level = 4
	if(charge_level <= 0)
		meter_level = 0
	else if(charge_level < charge_increment)
		meter_level = 1
	else if(charge_level < charge_increment * 2)
		meter_level = 2
	else if(charge_level < charge_increment * 3)
		meter_level = 3
	icon_state = "plasma[active][meter_level]"

/obj/item/weapon/pickaxe/plasma_drill/attack_self(var/mob/user)
	set_active(!active, user)

/obj/item/weapon/pickaxe/plasma_drill/proc/set_active(var/new_active, var/mob/user)
	if(active != new_active)
		if(new_active)
			if(charge_level <= 0)
				if(user)
					to_chat(user, "\icon[src] <span class='notice'>[src] is out of charge</span>")
			else
				var/atom/source = src
				if(user)
					to_chat(user, "<span class='info'>You activate [src]. It has [100*charge_level/charge_max]% charge remaining.</span>")
					source = user
				source.visible_message("\icon[src] The tip of [src] lights up with a bright hot glow.")
				set_light(3, 3, "6600FF")
				force = 35
				sharp = 1
				edge = 1
				damtype = "fire"

				active = 1
		else
			var/atom/source = src
			if(user)
				to_chat(user, "<span class='info'>You deactivate [src].</span>")
				source = user
			source.visible_message("\icon[src] The glowing tip of [src] fades away.")
			set_light(0, 0, "6600FF")
			force = 5
			sharp = 0
			edge = 0
			damtype = "brute"

			active = 0

		update_icon()

/obj/item/weapon/pickaxe/plasma_drill/resolve_attackby(atom/A, mob/user, var/click_params)

	if(active)
		if(charge_level > 0)

			if(istype(A, /turf/simulated/mineral))
				. = ..()

			else if(istype(A, /obj/machinery/door/airlock))
				charge_level -= charge_per_hit
				update_icon()
				to_chat(user, "<span class='info'>Cutting door...</span>")
				user.do_attack_animation(A)
				A.overlays += image_overlay
				playsound(src, 'sound/weapons/blade1.ogg', 100, 1)
				if(do_after(user, 40, A) && in_range(user, A))
					var/obj/machinery/door/airlock/D = A
					D.take_damage(D.maxhealth * 0.34)

				A.overlays -= image_overlay

			if(charge_level <= 0)
				set_active(!active, user)

	else
		. = ..()

/obj/item/weapon/pickaxe/plasma_drill/proc/cov_plasma_recharge_tick()
	if(charge_level < charge_max)
		charge_level += charge_per_hit
		update_icon()
		return 1

/obj/item/weapon/pickaxe/plasma_drill/examine(mob/user)
	. = ..()
	to_chat(user,"<span class='info'>It has [charge_level]/[charge_max] battery charge remaining.</span>")
