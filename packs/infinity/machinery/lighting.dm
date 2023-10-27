#define LIGHT_DEFAULT_LED_NEON	"#ffffff"

/obj/item/light/led_neon
	name = "neon tube"
	desc = "A LED neon tape."
	matter = list(MATERIAL_GLASS = 100, MATERIAL_ALUMINIUM = 20)
	icon = 'packs/infinity/icons/obj/machinery/neon.dmi'
	icon_state = "big_tape"
	base_state = "big_tape"
	item_state = null

	b_range = 4
	b_colour = LIGHT_DEFAULT_LED_NEON

	random_tone = FALSE

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


/obj/item/light/led_neon/use_tool(obj/item/tool, mob/user, list/click_params)
	if(user)
		if(isMultitool(tool))
			var/c = input("You are changing diode frequency.", "Input", b_colour) as color|null
			if(c)
				set_color(c)
			return TRUE
	return ..()

/obj/item/light/led_neon/large
	base_state = "big_tape"
	icon_state = "big_tape_preset"
	b_range = 7

/obj/item/light/led_neon/small
	base_state = "small_tape"
	icon_state = "small_tape_preset"

/obj/item/light/led_neon/small/use_tool(obj/item/tool, mob/user, list/click_params)
	if(istype(tool, type))
		var/turf/T = get_turf(user)
		if(isturf(T))
			user.drop_from_inventory(src, T)
			user.drop_from_inventory(tool, T)
			qdel(tool)
			qdel(src)
			user.put_in_any_hand_if_possible(new /obj/item/light/led_neon/large(T))
			return TRUE
	return ..()

/obj/item/storage/box/lights/led_neon
	name = "box of neon leds"
	startswith = list(/obj/item/light/led_neon/small = 7)
