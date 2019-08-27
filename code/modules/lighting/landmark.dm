
/obj/effect/landmark/light_marker
	name = "light marker"
	light_power = 4
	light_range = 4
	light_color = "#FFFFEE"

/obj/effect/landmark/light_marker/New()
	set_light(light_power, light_range, light_color)

/obj/effect/landmark/light_marker/weak
	light_power = 2
	light_range = 3

/obj/effect/landmark/light_marker/strong
	light_power = 10
	light_range = 7
