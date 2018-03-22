/obj/structure/closet/secure_closet/nuke_wall
	name = "nuclear cylinder closet"
	desc = "It's a secure wall-mounted storage unit for storing the nuclear cylinders."
	icon = 'icons/obj/machines/self_destruct.dmi'
	icon_state = "self_destruct_wall_locked"
	icon_closed = "self_destruct_wall_unlocked"
	icon_locked = "self_destruct_wall_locked"
	icon_opened = "self_destruct_wall_open"
	icon_broken = "self_destruct_wall_spark"
	icon_off = "self_destruct_wall_off"
	anchored = 1
	density = 0
	wall_mounted = 1
	req_access = list(access_heads_vault)
	storage_types = CLOSET_STORAGE_ITEMS

/obj/structure/closet/secure_closet/nuke_wall/WillContain()
	return list(
		/obj/item/weapon/nuclear_cylinder,
		/obj/item/weapon/nuclear_cylinder,
		/obj/item/weapon/nuclear_cylinder
	)
