/obj/structure/stage_curtain
	opacity = 1
	icon = 'icons/obj/curtains.dmi'
	icon_state = "c_close"

/obj/structure/stage_curtain/open
	icon_state = "c_drawn"
	layer = OBJ_LAYER

/obj/structure/stage_curtain/bullet_act(obj/item/projectile/P, def_zone)
	if(!P.nodamage)
		visible_message("<span class='warning'>[P] tears [src] down!</span>")
		del(src)
	else
		..(P, def_zone)

/obj/structure/stage_curtain/attack_hand(mob/user)
	toggle()
	..()

/obj/structure/stage_curtain/proc/toggle()
	opacity = !opacity
	if(opacity)
		icon_state = "c_close"
		layer = MOB_LAYER + 0.1
	else
		icon_state = "c_drawn"
		layer = OBJ_LAYER

