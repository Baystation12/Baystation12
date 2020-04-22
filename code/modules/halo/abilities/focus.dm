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
	if(machine)
		to_chat(src,"<span class = 'notice'>You can't do that!</span>")
		return

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
