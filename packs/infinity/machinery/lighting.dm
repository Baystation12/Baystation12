#define LIGHT_DEFAULT_LED_NEON	"#ffffff"

/obj/item/light/led_neon
	name = "neon tube"
	desc = "A LED neon tape."
	matter = list(MATERIAL_GLASS = 100, MATERIAL_ALUMINIUM = 20)
	icon = 'packs/infinity/icons/obj/machinery/neon.dmi'
	icon_state = "big_tape"
	base_state = "big_tape"
	item_state = null

	b_inner_range = 1
	b_outer_range = 2
	b_colour = LIGHT_DEFAULT_LED_NEON

	random_tone = FALSE

/obj/item/light/led_neon/attackby(obj/item/I, mob/user)
	. = ..()
	if(user)
		if(isMultitool(I))
			var/c = input("You are changing diode frequency.", "Input", b_colour) as color|null
			if(c)
				set_color(c)

/obj/item/light/led_neon/large
	base_state = "big_tape"
	icon_state = "big_tape_preset"
	b_inner_range = 2
	b_outer_range = 4

/obj/item/light/led_neon/small
	base_state = "small_tape"
	icon_state = "small_tape_preset"

/obj/item/light/led_neon/small/attackby(obj/item/I, mob/user)
	. = ..()
	if(istype(I, type))
		var/turf/T = get_turf(user)
		if(isturf(T))
			user.drop_from_inventory(src, T)
			user.drop_from_inventory(I, T)
			qdel(I)
			qdel(src)
			user.put_in_any_hand_if_possible(new /obj/item/light/led_neon/large(T))

/obj/machinery/light/led
	name = "neon tube"
	desc = "A tape of LEDs. Not actually neon, but THIS is FUTURE."
	light_type = /obj/item/light/led_neon/large
	icon = 'packs/infinity/icons/obj/machinery/neon.dmi'
	icon_state = "tube_maped"
	layer = BELOW_DOOR_LAYER

/obj/machinery/light/led/small
	name = "small neon tube"
	base_state = "tube_border"
	icon_state = "tube_border_maped"
	light_type = /obj/item/light/led_neon/small

/obj/machinery/light/led/on_update_icon()
	. = ..()
	pixel_x = 0
	pixel_y = 0
