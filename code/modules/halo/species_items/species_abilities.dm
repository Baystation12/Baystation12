#define ONETILE 32 //A single normal tile in pixels

/mob/living/carbon/human/proc/focus_view()
	set category = "Abilities"
	set name = "Focus View"
	set desc = "Focus your eyes on distant objects."

	if(last_special > world.time)
		return

	if((src.client.pixel_y != 0)||(src.client.pixel_x != 0))
		src.client.pixel_y = 0
		src.client.pixel_x = 0
		return

	src.reset_view(src)

	switch(src.dir)
		if(NORTH)
			src.client.pixel_y = ONETILE * 10
		if(SOUTH)
			src.client.pixel_y = ONETILE * -10
		if(EAST)
			src.client.pixel_x = ONETILE * 10
		if(WEST)
			src.client.pixel_x = ONETILE * -10

#undef ONETILE

/mob/living/carbon/human/proc/take_flight()
	set category = "Abilities"
	set name = "Toggle Flight"
	set desc = "Toggles your flight"

	if(elevation == 0)
		visible_message("[src.name] takes flight!")
		change_elevation(1)
	else
		visible_message("[src.name] slows, then stops flapping their wings, bringing them to the ground.")
		change_elevation(-1)