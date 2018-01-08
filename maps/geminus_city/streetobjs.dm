// beautiful lighting because fabulous

/obj/machinery/light/colored
	name = "light fixture"
	icon = 'maps/geminus_city/citymap_icons/coloredlights.dmi'
	base_state = "yellow"		// base description and icon_state
	icon_state = "yellow1"
	desc = "A lighting fixture."
	brightness_range = 9
	brightness_power = 10

/obj/machinery/light/colored/orange
	base_state = "orange"		// base description and icon_state
	icon_state = "orange1"
	light_type = /obj/item/weapon/light/tube/large/neon/orange

/obj/machinery/light/colored/purple
	base_state = "purple"		// base description and icon_state
	icon_state = "purple1"
	light_type = /obj/item/weapon/light/tube/large/neon/purple

/obj/machinery/light/colored/red
	base_state = "red"		// base description and icon_state
	icon_state = "red1"
	light_type = /obj/item/weapon/light/tube/large/neon/red


/obj/machinery/light/colored/pink
	base_state = "pink"		// base description and icon_state
	icon_state = "pink1"
	light_type = /obj/item/weapon/light/tube/large/neon/pink

/obj/machinery/light/colored/blue
	base_state = "blue"		// base description and icon_state
	icon_state = "blue1"
	light_type = /obj/item/weapon/light/tube/large/neon/blue

/obj/machinery/light/colored/green
	base_state = "green"		// base description and icon_state
	icon_state = "green1"
	light_type = /obj/item/weapon/light/tube/large/neon/green


//colored bulbs

/obj/item/weapon/light/tube/large/neon/red
	color = "#feebeb"
	brightness_color = "#feebeb"
	light_color = "#feebeb"

/obj/item/weapon/light/tube/large/neon/orange
	color = "#fef9eb"
	brightness_color = "#fef9eb"
	light_color = "#fef9eb"

/obj/item/weapon/light/tube/large/neon/purple
	color = "#fcebfe"
	brightness_color = "#fcebfe"
	light_color = "#fcebfe"

/obj/item/weapon/light/tube/large/neon/pink
	color = "#fff9f9"
	brightness_color = "#fff9f9"
	light_color = "#fff9f9"

/obj/item/weapon/light/tube/large/neon/blue
	color = "#ebf7fe"
	brightness_color = "#ebf7fe"
	light_color = "#ebf7fe"

/obj/item/weapon/light/tube/large/neon/green
	color = "#ebfeec"
	brightness_color = "#ebfeec"
	light_color = "#ebfeec"

/obj/machinery/light/floor
	icon_state = "floor1"
	base_state = "floor"
	layer = BELOW_OBJ_LAYER
	plane = HIDING_MOB_PLANE
	light_type = /obj/item/weapon/light/bulb
	brightness_range = 4
	brightness_power = 2
	brightness_color = "#a0a080"

/obj/machinery/light/overhead_blue
	icon = 'maps/geminus_city/citymap_icons/floorlights.dmi'
	icon_state = "inv1"
	base_state = "inv"
	brightness_range = 10
	brightness_power = 1.5
	brightness_color = "#0080ff"

/obj/machinery/light/street
	icon = 'maps/geminus_city/citymap_icons/street.dmi'
	icon_state = "streetlamp1"
	base_state = "streetlamp"
	desc = "A street lighting fixture."
	brightness_range = 10
	brightness_color = "#0080ff"
	density = 1

/obj/machinery/light/invis
	icon = 'maps/geminus_city/citymap_icons/floorlights.dmi'
	icon_state = "inv1"
	base_state = "inv"
	brightness_range = 8

/obj/structure/grille/smallfence/
	icon = 'maps/geminus_city/citymap_icons/structures.dmi'
	name = "small fence"
	icon_state = "fence"
	health = 10

/obj/structure/grille/frame
	icon = 'maps/geminus_city/citymap_icons/structures.dmi'
	name = "frame"
	icon_state = "frame"
	health = 10


//BILLBOARDS

/obj/structure/billboard
	name = "billboard"
	desc = "A billboard"
	icon = 'maps/geminus_city/citymap_icons/billboards.dmi'
	icon_state = "billboard"
	light_range = 4
	light_power = 2
	light_color = "#ebf7fe"  //white blue
	density = 1
	anchored = 1
	layer = ABOVE_HUMAN_LAYER
	plane = ABOVE_HUMAN_PLANE
	bounds = "64,32"
	pixel_y = 10

/obj/structure/billboard/Destroy()
	set_light(0)
	return ..()

/obj/structure/billboard/New()
	..()
	icon_state = pick("ssl","ntbuilding","keeptidy")

/obj/structure/billboard/city
	name = "city billboard"
	desc = "A billboard"
	icon_state = "welcome"
	light_range = 4
	light_power = 5
	light_color = "#bbfcb6"  //watered lime

/obj/structure/billboard/city/Destroy()
	set_light(0)
	return ..()

/obj/structure/billboard/city/New()
	..()
	icon_state = "welcome"