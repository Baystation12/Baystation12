
/obj/overmap_weapon_ammo
	name = "Ammo"
	desc = "Ammo"
	icon = null
	icon_state = ""

/obj/overmap_weapon_ammo/mac
	name = "MAC Slug"
	desc = "A tungsten slug designed to be accelerated by a MAC"
	icon = 'code/modules/halo/machinery/mac_ammo.dmi'
	icon_state = "slug"

/obj/overmap_weapon_ammo/mac/Move()
	.=..()
	if(dir == NORTH || SOUTH)
		bounds = "32,288"
	if(dir == EAST || WEST)
		bounds = "288,32"
