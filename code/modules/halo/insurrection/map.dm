
/obj/effect/zlevelinfo/innie_base
	name = "Insurrection Asteroid Base"
	icon = 'code/modules/overmap/ships/sector_icons.dmi'
	icon_state = "listening_post"
	faction = "Insurrection"
	sensor_icon_state = "rebelfist"

/obj/effect/overmapobj/innie_base
	 init_sensors = 1

/obj/effect/overmapobj/innie_base/overmap_init()
	..()
	tag = "Insurrection Asteroid Base"
