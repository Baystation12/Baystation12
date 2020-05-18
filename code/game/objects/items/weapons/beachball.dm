/obj/item/weapon/beach_ball
	icon = 'icons/misc/beach.dmi'
	icon_state = "ball"
	name = "beach ball"
	item_state = "beachball"
	density = 0
	anchored = 0
	w_class = ITEM_SIZE_HUGE
	force = 0.0
	throwforce = 0.0
	throw_speed = 1
	throw_range = 20
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/weapon/beach_ball/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	if(user.unequip_item())
		src.throw_at(target, throw_range, throw_speed, user)