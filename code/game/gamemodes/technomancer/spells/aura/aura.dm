/obj/item/weapon/spell/aura
	name = "aura template"
	desc = "If you can read me, the game broke!  Yay!"
	icon_state = "generic"
	cast_methods = null
	aspect = null
	var/glow_color = "#FFFFFF"

/obj/item/weapon/spell/aura/New()
	..()
	set_light(7, 4, l_color = glow_color)
	processing_objects |= src

/obj/item/weapon/spell/aura/Destroy()
	processing_objects -= src
	return ..()

/obj/item/weapon/spell/aura/process()
	return
