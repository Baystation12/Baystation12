/obj/item/device/assembly/bomb
	name = "sphere"
	desc = "An unremarkable black sphere, with two metallic terminals."
	icon_state = "bomba"
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 1500)
	throw_range = 5
	origin_tech = list(TECH_ENGINEERING = 3, TECH_COMBAT = 2, TECH_ESOTERIC = 5)
	var/armed = FALSE
	var/devastation_range = -1
	var/heavy_range = -1
	var/light_range = 2
	var/flash_range = 6

	var/fragmentates = TRUE
	var/num_fragments = 72
	var/list/fragment_types = list(/obj/item/projectile/bullet/pellet/fragment = 3,
								   /obj/item/projectile/bullet/pellet/fragment/strong = 1)

/obj/item/device/assembly/bomb/attackby(obj/item/weapon/W, mob/user)
	..()
	if(isMultitool(W))
		toggle_arming(W, user)

/obj/item/device/assembly/bomb/activate()
	. = ..()
	if(armed)
		do_explosion()

/obj/item/device/assembly/bomb/emp_act(severity)
	. = ..()
	if(severity <= 2)
		do_explosion()

/obj/item/device/assembly/bomb/lava_act()
	. = ..()
	do_explosion()

/obj/item/device/assembly/bomb/proc/toggle_arming(var/obj/item/weapon/W, var/mob/user)
	to_chat(user, SPAN_NOTICE("You wave \the [W] over \the [src]."))
		armed = !armed
	if(armed)
		playsound(src, 'sound/machines/switch1.ogg', 5, FALSE)

/obj/item/device/assembly/bomb/proc/do_explosion()
	var/turf/T
	if(holder)
		T = get_turf(holder)
	else
		T = get_turf(src)
	if(!T)
		return
	visible_message("<span class='danger'>\The [src] explodes!</span>", "<span class='danger'>You hear an explosion!</span>")
	fragmentate(T, num_fragments, 7, fragment_types)
	explosion(T, devastation_range, heavy_range, light_range, flash_range, TRUE, null)
	if(holder)
		holder.disassemble_and_destroy()