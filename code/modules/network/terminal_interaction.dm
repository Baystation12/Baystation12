/obj/machinery/terminal/interact(mob/user)

	if(!buffer.len)
		terminal_output(get_prompt(),1)

	var/dat = "<body bgcolor='#000000'>"
	var/buffer_size = buffer.len
	for(var/x = buffer_size;x > 0;x--)
		dat += "[buffer[x]]</br>"
	dat += "<font color='#AAAAAA'>$</font><br>"
	dat += "<form action='byond://' method='get'>"
	dat += "<input type='hidden' name='src' value='\ref[src]'>"
	dat += "<input type='text' id='text_input' name='text_input' value='' style='width:75%;'>"
	dat += "<input type='submit' value='Enter' style='width:15%;'>"
	dat += "</form>"
	dat += "</body>"
	user << browse(dat, "window=terminal")
	onclose(user, "terminal")

/obj/machinery/terminal/proc/show_typing(var/mob/user, var/text_input)
	if(!user)
		return
	if(!Adjacent(user))
		user << "<font color='blue'>You enter '[text_input]' into \the [src].</font>"
		return
	user.visible_message(
		"<font color='blue'><b>\The [usr]</b> taps something out on [src]'s keyboard.</font>", \
		"<font color='blue'>You tap out '[text_input]' on [src]'s keyboard.</font>"
		)

/obj/machinery/terminal/verb/type_terminal(text_input as text)

	set name = "Type"
	set desc = "Type data into a nearby terminal."
	set category = "Object"
	set src in view(1)

	if(!text_input)
		text_input = input("Please enter the desired command.")
	if(!text_input)
		return

	show_typing(usr,text_input)

	process_input(text_input)

/obj/machinery/terminal/verb/toggle_terminal_power()

	set name = "Toggle Terminal Power"
	set desc = "Turn a terminal on or off."
	set category = "Object"
	set src in view(1)

	toggle_power(usr)

/obj/machinery/terminal/proc/toggle_power(var/mob/user)

	if(stat & (NOPOWER|BROKEN))
		user << "<span class='danger'>The terminal is nonfunctional.</span>"

	system_state = !system_state
	usr << "<font color='blue'>You [system_state ? "power up" : "power off"] the terminal.</font>"
	if(system_state)
		terminal_startup()
	else
		terminal_shutdown()

/obj/machinery/terminal/attack_hand(mob/user as mob)

	if(!system_state)
		toggle_power(user)
		return

	user.set_machine(src)
	interact(user)

/obj/machinery/terminal/attack_ai(mob/user as mob)
	attack_hand(user)