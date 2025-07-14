/obj/spinning_light
	var/spin_rate = 1 SECOND
	var/_size = 48
	var/_factor = 0.5
	var/_density = 4
	var/_offset = 30
	var/_color = COLOR_ORANGE
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	layer = EYE_GLOW_LAYER
	mouse_opacity = 0


/obj/spinning_light/Initialize()
	. = ..()
	filters = filter(type="rays", size = _size, color = _color, factor = _factor, density = _density, flags = FILTER_OVERLAY, offset = _offset)

	alpha = 200

	//Rays start rotated which made synchronizing the scaling a bit difficult, so let's move it 45 degrees
	var/matrix/m = new
	var/matrix/test = new
	test.Turn(-45)
	var/matrix/squished = new
	squished.Scale(1, 0.5)
	animate(src, transform = test * m.Turn(90), spin_rate / 4, loop = -1)
	animate(transform = test * m.Turn(90), spin_rate / 4, loop = -1)
	animate(transform = test * m.Turn(90), spin_rate / 4, loop = -1)
	animate(transform = test * matrix(),   spin_rate / 4, loop = -1)


/obj/spinning_light/set_color(_color)
	filters = filter(type="rays", size = _size, color = _color, factor = _factor, density = _density, flags = FILTER_OVERLAY, offset = _offset)


/obj/machinery/rotating_alarm
	name = "industrial alarm"
	desc = "An industrial rotating alarm light."
	icon = 'icons/obj/structures/rotating_alarm.dmi'
	icon_state = "alarm"
	idle_power_usage = 0
	active_power_usage = 0
	anchored = TRUE

	var/on = FALSE
	var/low_alarm = FALSE
	var/construct_type = /obj/machinery/light_construct

	var/obj/spinning_light/spin_effect = null

	var/alarm_light_color = COLOR_ORANGE
	/// This is an angle to rotate the colour of alarm and its light. Default is orange, so, a 45 degree angle clockwise will make it green
	var/angle = 0

	var/static/list/spinning_lights_cache = list()

	/// Reference to the sound player looping sound instance.
	var/sound_loop
	/// Sound file to loop when turned on.
	var/sound_file


/obj/machinery/rotating_alarm/Initialize()
	. = ..()

	//Setup colour
	var/list/color_matrix = color_rotation(angle)

	color = color_matrix

	set_color(alarm_light_color)

	set_dir(dir) //Set dir again so offsets update correctly


/obj/machinery/rotating_alarm/Destroy()
	set_off()
	return ..()


/obj/machinery/rotating_alarm/start_on/Initialize()
	. = ..()
	if (. == INITIALIZE_HINT_QDEL)
		return
	set_on()


/obj/machinery/rotating_alarm/set_dir(ndir) //Due to effect, offsets cannot be part of sprite, so need to set it for each dir
	. = ..()
	if(dir == NORTH)
		pixel_y = -13
	if(dir == SOUTH)
		pixel_y = 28
	if(dir == WEST)
		pixel_x = 20
	if(dir == EAST)
		pixel_x = -20


/obj/machinery/rotating_alarm/set_color(color)
	if (on)
		remove_vis_contents(spin_effect)
	if (isnull(spinning_lights_cache["[color]"]))
		spinning_lights_cache["[color]"] = new /obj/spinning_light()
	spin_effect = spinning_lights_cache["[color]"]
	alarm_light_color = color
	var/HSV = RGBtoHSV(alarm_light_color)
	var/RGB = HSVtoRGB(RotateHue(HSV, angle))
	alarm_light_color = RGB
	spin_effect.set_color(color)
	if (on)
		add_vis_contents(spin_effect)


/obj/machinery/rotating_alarm/proc/set_alarm_sound(new_sound)
	if (new_sound == sound_file)
		return
	QDEL_NULL(sound_loop)
	sound_file = new_sound
	if (!sound_file || !on)
		return
	start_alarm_sound()


/obj/machinery/rotating_alarm/proc/start_alarm_sound()
	if (sound_loop)
		return
	sound_loop = GLOB.sound_player.PlayLoopingSound(
		src,
		"\ref[src]",
		sound_file,
		50,
		7
	)


/obj/machinery/rotating_alarm/proc/set_on()
	if (on)
		return
	add_vis_contents(spin_effect)
	set_light(2, 0.5, alarm_light_color)
	on = TRUE
	low_alarm = FALSE
	start_alarm_sound()


/obj/machinery/rotating_alarm/proc/set_off()
	if (!on)
		return
	remove_vis_contents(spin_effect)
	set_light(0)
	on = FALSE
	low_alarm = FALSE
	QDEL_NULL(sound_loop)
