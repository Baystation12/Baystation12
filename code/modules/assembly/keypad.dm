/obj/item/device/assembly/keypad
	name = "keypad"
	desc = "A worn-down keypad."
	icon_state = "keypad"
	item_state = "assembly"
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10
	weight = 2

	wires = WIRE_PROCESS_ACTIVATE | WIRE_DIRECT_SEND | WIRE_PROCESS_SEND | WIRE_MISC_ACTIVATE
	wire_num = 3

	var/password = ""
	var/alt_connected_to = -1
	var/alt_connected_to_name = "NULL"

/obj/item/device/assembly/keypad/get_data()
	var/list/data = list("Password", password, "Alt.Connection", alt_connected_to_name)
	return data

/obj/item/device/assembly/keypad/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Password")
				usr << "<span class='notice'>Please enter up to 4 digits to make a new password</span>"
				var/newpass = text2num(input(usr, "What would you like to set the password to?", "Keypad Password"))
				if(newpass && isnum(newpass) && newpass <= 9999 && newpass >= 0)
					password = newpass
				else
					usr << "<span class='warning'>That password is invalid!</span>"
			if("Alt.Connection")
				if(!holder)
					usr << "There's nothing you can connect \the [src] to!"
				else
					var/list/devices = list()
					for(var/i=1,i<=holder.connected_devices.len,i++)
						var/obj/item/device/assembly/A = holder.connected_devices[i]
						if(A == src) continue
						if(i in connects_to || i == alt_connected_to) continue
						devices.Add(A)
					var/obj/item/device/assembly/connect_to = input(usr, "What device would you like to connect to?", "Connection") in devices
					var/index = get_device_index(connect_to)
					add_debug_log("Got: [connect_to.name] Index: [index] \[[src]\]")
					if(num2text(index) == alt_connected_to || num2text(index) in connects_to)
						usr << "<span class='warning'>\The [src] is already connected to \the [connect_to.name]</span>"
					else if(!index)
						add_debug_log("Index does not exist! \[[src]\]")
					else if(index)
						if(connect_to != src)
							alt_connected_to = text2num(index)
							usr << "<span class='notice'>You set \the [src]'s alternate connection to [connect_to.name]!</span>"
							alt_connected_to_name = connect_to.name
						else
							usr << "<span class='warning'>You cannot connect \the [src] to itself!</span>"
	..()

/obj/item/device/assembly/keypad/holder_attack_self(var/mob/user)
	user.visible_message("<span class='notice'>\The [user] begins inspecting \the [holder] carefully..</span>")
	sleep(10)
	if(istype(user, /mob/living/carbon/human))
		var/entered = text2num(input(user, "Please enter up to a 4 digit password."))
		if(entered == password)
			user << "<span class='notice'>Access Granted!</span>"
			process_activation()
		else
			user << "<span class='warning'>Access Denied!</span>"
			misc_activate()

/obj/item/device/assembly/keypad/misc_activate()
	if(alt_connected_to)
		var/obj/item/device/assembly/A = holder.connected_devices[alt_connected_to]
		if(A && istype(A))
			send_direct_pulse(A)


