/obj/structure/mantid
	icon = 'icons/obj/mantid.dmi'
	light_power = 0
	density = TRUE

/obj/structure/mantid/chair
	name = "mantid chair"
	icon_state = "chair"
	density = FALSE
	anchored = TRUE
	can_buckle = TRUE

/obj/structure/mantid/Initialize()
	..()
	set_light()

/obj/structure/mantid/proc/check_user(var/mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species.get_bodytype(H) == SPECIES_MANTID_ALATE || H.species.get_bodytype(H) == SPECIES_MANTID_GYNE)
			return 1
	return 0

/obj/structure/mantid/light
	name = "light pod"
	icon_state = "light_on"
	light_power = 3
	light_range = 3
	light_color = "#00FFFF"
	anchored = TRUE
	density = FALSE
	var/on

/obj/structure/mantid/light/proc/toggle(var/mob/user)
	if(on)
		set_light(0)
	else
		set_light()
	on = !on
	if(user)
		user.visible_message("<span class='notice'>\The [user] taps \the [src], and it [on ? "brightens" : "goes dark"].</span>")
	update_icon()

/obj/structure/mantid/light/update_icon()
	. = ..()
	if(on)
		icon_state = "light_on"
	else
		icon_state = "light_off"

/obj/structure/mantid/light/attack_hand(var/mob/user)
	if(check_user(user))
		toggle(user)
		return
	. = ..()

/obj/structure/mantid/console
	name = "mantid console"
	icon_state = "console_on"
	light_power = 1
	light_range = 2
	light_color = "#00FFFF"
	anchored = TRUE

/obj/structure/mantid/door
	name = "composite airlock"
	icon_state = "door"
	anchored = TRUE
	opacity = TRUE

/obj/structure/mantid/door/Bumped(atom/user)
	if(density && check_user(user))
		toggle()
	. = ..()

/obj/structure/mantid/door/attack_hand(var/mob/user)
	if(check_user(user))
		toggle(user)
		return
	. = ..()

/obj/structure/mantid/door/update_icon()
	. = ..()
	if(density)
		icon_state = "door_open"
	else
		icon_state = "door"

/obj/structure/mantid/door/proc/toggle(var/mob/user)
	if(density)
		set_density(0)
		set_opacity(0)
	else
		set_density(1)
		set_opacity(1)
	if(user)
		user.visible_message("<span class='notice'>\The [user] taps \the [src], and it [density ? "closes" : "opens"].</span>")
	update_icon()
	sleep(1)
	update_nearby_tiles()
