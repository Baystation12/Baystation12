/*************************
sierra specific ammo types
**************************/

/*
Manstopper Rounds - Shotgun
*/

/obj/item/storage/box/ammo/manstoppershells
	name = "box of manstopper shells"
	startswith = list(/obj/item/ammo_magazine/shotholder/manstopper = 2)

/obj/item/ammo_magazine/shotholder/manstopper
	name = "manstopper shell holder"
	ammo_type = /obj/item/ammo_casing/shotgun/manstopper
	marking_color = COLOR_SURGERY_BLUE

/obj/item/ammo_casing/shotgun/manstopper
	name = "shotgun shell"
	desc = "A manstopper shell."
	icon = 'maps/sierra/icons/obj/ammo.dmi'
	icon_state = "mnshell"
	spent_icon = "mnshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/manstopper
	matter = list(MATERIAL_STEEL = 360)

/obj/item/projectile/bullet/shotgun/manstopper
	name = "manstopper"
	damage = 50
	agony = 30
	armor_penetration = 0
