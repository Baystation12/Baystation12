
/obj/item/weapon/gun
	var/overheat_fullclear_delay = 3 SECONDS
	var/overheat_fullclear_at = 0
	var/overheat_sfx = null
	var/overheat_capacity = -1
	var/heat_current = 0
	var/datum/progressbar/heat_bar
	var/heat_per_shot = 1

/obj/item/weapon/gun/process()

	if(process_heat())
		return

	return PROCESS_KILL

/obj/item/weapon/gun/proc/process_heat()
	if(heat_current > 0)
		//cool down slightly
		add_heat(-2) //using 2 because process ticks occur about every 2 seconds iirc

		//are we overheated?
		if(overheat_fullclear_at)
			if(heat_current <= 0)
				clear_overheat()
				color = initial(color)
			else
				//flash red and yellow
				if(color == "#ff0000")
					color = "#ffa500"
				else
					color = "#ff0000"

		//continue processing
		return 1

	//stop processing
	return 0

/obj/item/weapon/gun/proc/add_heat(var/new_val)
	heat_current = min(overheat_capacity,heat_current + new_val)

	if(heat_current > 0)
		if(!heat_bar)
			heat_bar = new (src.loc, overheat_capacity, src)
			GLOB.processing_objects.Add(src)
		heat_bar.update(heat_current)

		if(heat_current >= overheat_capacity)
			do_overheat()
	else
		qdel(heat_bar)
		heat_bar = null
		GLOB.processing_objects.Remove(src)

/obj/item/weapon/gun/proc/do_overheat()
	overheat_fullclear_at = world.time + overheat_fullclear_delay * 1.5
	var/mob/M = src.loc
	visible_message("\icon[src] <span class = 'warning'>[M]'s [src] overheats!</span>",\
		"\icon[src] <span class = 'warning'>Your [src] overheats!</span>",)
	if(overheat_sfx)
		playsound(M,overheat_sfx,100,1)

/obj/item/weapon/gun/proc/clear_overheat()
	overheat_fullclear_at = 0
	heat_current = 0
	if(heat_bar)
		qdel(heat_bar)
		heat_bar = null

/obj/item/weapon/gun/proc/check_overheat()
	if(overheat_fullclear_at)
		to_chat(src.loc,"\icon[src] <span class='warning'>[src] clunks as you pull the trigger, \
			it has overheated and needs to ventilate heat...</span>")
		return 1
	return 0
