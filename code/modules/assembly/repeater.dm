/obj/item/device/assembly/timer/repeater
	name = "modified timer"
	desc = "A timer. This one seems to have a few messy wires poking out."
	icon_state = "repeater"
	matter = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 50, "waste" = 25)

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND | WIRE_MISC_CONNECTION | WIRE_MISC_ACTIVATE
	wire_num = 7
	var/repeat_cycles = 0
	var/init_cycles = 0
	var/delay = 0

/obj/item/device/assembly/timer/repeater/process()
	if(timing)
		time--
	if(timing && time <= 0)
		timing = 0
		timer_end()
		sleep(0)
		if(repeat_cycles)
			add_debug_log("Cycles Remaining: [repeat_cycles]")
			repeat_cycles--
			spawn(delay*10)
				time = time_to_set // Keeps repeating itself.
				timing = 1
		else
			repeat_cycles =	init_cycles
	return

/obj/item/device/assembly/timer/repeater/proc/change_repeat_cycles(var/amount)
	repeat_cycles = min(10, amount)
	repeat_cycles = max(0, amount)
	init_cycles = repeat_cycles

/obj/item/device/assembly/timer/repeater/get_data()
	var/list/data = ..()
	data.Add("Repeats", repeat_cycles, "Delay", time_to_set)
	return data

/obj/item/device/assembly/timer/repeater/get_buttons()
	var/list/data = list()
	data.Add("Start Cycle")
	return data

/obj/item/device/assembly/timer/repeater/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Repeats")
				var/num = input(usr, "How many repeat cycles would you like to set?", "Repeater")
				if(num)
					change_repeat_cycles(text2num(num))
			if("Delay")
				var/num = input(usr, "What would you like to set the delay to?", "Repeater")
				if(num)
					delay = min(120, num)
					delay = max(0, num)

			if("Start Cycle")
				activate()
	..()





