/obj/item/device/assembly_holder
	name = "Assembly frame"
	icon = 'icons/obj/assemblies/assembly_holders.dmi'
	icon_state = "box"
	item_state = "assembly"
	flags = CONDUCT
	throwforce = 5
	w_class = 2.0
	throw_speed = 3
	throw_range = 10

	var/list/premade_devices = list() // Used for type getting

	var/acting = 0
	var/stage = 0
	var/stage_name = "" // For future
	var/obj/item/device/assembly/removing // Multi-purpose var
	var/upgraded = list("cable" = 0, "steel" = 0, "rods" = 0, "plasteel" = 0, "power" = 0)

	var/max_weight = 25
	var/weight = 0 // >5:Cannot be put in storage >10:Cannot be picked up >20:Anchored

	//Connections
	var/list/connected_devices = list()
	var/max_connections = 5
	var/drawing_connection // Interface var
	//Examine
	var/list/examine_additions = list()
	//Debug | Admin
	var/debug_mode = 0
	var/list/recent_pulses = list() // To prevent infinite loops
	var/list/logs = list() // For debugging
	var/state = "HOME"
	//Clothing | Implants
	var/implantable = 0
	var/mob/living/carbon/human/owner // implanted or attached to
	var/implanted_in

	var/attachable = 0
	var/tmp/base_slot_flags = SLOT_BACK|SLOT_MASK // So we can easily apply these flags when we need them
	slot_flags = 0

	var/password = "admin"
	var/list/advanced_settings = list("forceprocess"=0,"disablepulse"=0,"noadmin"=0,"wiredetector"=0,"autoconnect"=1)
	var/admin_messages = 1

	var/pulse_chance = 50

	var/prespawned = 1 // Made "professionally"

/obj/item/device/assembly_holder/New(var/type_change = 0)
	..()
	create_reagents(1000)
	update_holder()

/obj/item/device/assembly_holder/Destroy()
	if(connected_devices.len)
		for(var/obj/O in connected_devices)
			qdel(O)
	processing_objects.Remove(src)
	return ..()

/obj/item/device/assembly_holder/proc/update_holder()
	weight = initial(weight)
	implantable = 0
	attachable = 0
	density = initial(density)
	examine_additions.Cut()
	var/list/calculated_names = list()
	for(var/i=1 to connected_devices.len)
		var/obj/item/device/assembly/A = connected_devices[i]
		examine_additions += A.examined_additions
		weight += A.weight
		if(weight <= 10)
			if(A.implantable)
				implantable = 1
			if(A.attachable)
				attachable = 1
		if(!calculated_names.len)
			calculated_names.Add(A.interface_name, 0) // Index-associative?
		else
			var/matched = 0
			for(var/n = 1 to calculated_names.len)
				if(A.interface_name == calculated_names[n])
					calculated_names[(n+1)] += 1
					matched = 1
					A.interface_name = "[initial(A.name)]([(calculated_names[(n+1)])])"
			if(!matched)
				calculated_names.Add(A.interface_name, 0)
	switch(weight)
		if(5 to 9)
			w_class = 3.0
		if(10 to 19)
			w_class = 4.0
		if(20 to INFINITY)
			w_class = 5.0
	if(attachable)
		slot_flags = base_slot_flags
	else
		slot_flags = 0
	get_type()
	update_icon()

/obj/item/device/assembly_holder/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	update_holder()
	var/list/data = list()
	var/list/devices = list()
	for(var/i=1,i<=connected_devices.len,i++)
		if(istype(connected_devices[i], /obj/item/device/assembly))
			var/obj/item/device/assembly/A = connected_devices[i]
			devices.Add(A.interface_name, i)

	data["connected"] = devices
	data["state"] = state
	data["logs"] = logs
	data["password"] = password

	if(drawing_connection)
		data["connecting"] = 1
	else
		data["connecting"] = 0

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "assembly_holder.tmpl", src.name, 440, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/item/device/assembly_holder/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["logs"])
		if(admin_access(usr))
			state = "LOGS"
			return 1
	if(href_list["disableadmin"])
		admin_messages = 0
	if(href_list["home"])
		state = "HOME"
		return 1
	if(href_list["admin"])
		if(admin_access(usr))
			state = "ADMIN"
			return 1
	if(href_list["advsettings"])
		var/inp = input(usr, "Enter advanced setting flag to toggle", "Assembly")
		if(inp in advanced_settings)
			advanced_settings[inp] = !advanced_settings[inp]
			usr << "<span class='notice'>You set \the setting [inp] to [(advanced_settings[inp])]</span>"
		else
			usr << "<span class='warning'>Invalid flag!</span>"
	if(href_list["password"])
		var/inp = input(usr, "Enter a new password", "Password")
		if(inp && istext(inp) && lentext(inp) <= 10)
			password = inp
			return 1
		else
			usr << "<span class='warning'>That password is invalid!</span>"
	if(href_list["settings"])
		if(usr)
			var/index = href_list["settings"]
			if(index % 2)
				add_debug_log("Settings unresponsive! \[[src]\]")
			else
				var/failed = 0
				var/obj/item/device/assembly/opened = connected_devices[text2num(index)]
				for(var/obj/item/device/assembly/A in connected_devices)
					if(!A.holder_interface())
						failed = 1
						break
				if(failed)
					usr << "<span class='warning'>That device's interface is electronically locked!</span>"
				else if(opened)
					if(!(opened.active_wires & WIRE_ASSEMBLY_PASSWORD) || admin_access(usr))
						opened.ui_interact(usr, state = interactive_state)
						return 1
					else
						usr << "<span class='warning'>Access denied!</span>"
	if(href_list["wiring"])
		var/index = href_list["wiring"]
		var/failed = 0
		var/list/failures = list()
		for(var/obj/item/device/assembly/A in connected_devices)
			if(!A.holder_interface())
				failed = 1
				failures += A
		if(index)
			var/obj/item/device/assembly/opened = connected_devices[text2num(index)]
			if(opened)
				if(failed && !(opened in failures))
					usr << "<span class='warning'>There is an electronic lock on the wiring!</span>"
				else if(opened.wire_holder)
					usr.set_machine(opened)
					opened.wire_holder.Interact(usr)
					return 1
	if(href_list["connect"])
		if(drawing_connection)
			usr << "<span class='noice'>You stop drawing connections!</span>"
			drawing_connection = null
		else
			if(admin_access(usr))
				usr << "<span class='notice'>You begin drawing connections!</span>"
				drawing_connection = href_list["connect"]
				add_debug_log("Drawing connection: [drawing_connection]")
				return 1
	if(href_list["connect_to"])
		var/index = href_list["connect_to"]
		var/obj/item/device/assembly/first = connected_devices[(text2num(drawing_connection))]
		var/obj/item/device/assembly/second = connected_devices[(text2num(index))]
		var/failed = 0 // Let us loop through everything.
		for(var/obj/item/device/assembly/A in connected_devices)
			if(!A.holder_interface())
				failed = 1
		if(failed)
			usr << "<span class='warning'>There is an electronic lock on the wiring!</span>"
		else if(!istype(first))
			add_debug_log("Error: connected_devices\[[drawing_connection]\] is invalid!(1)")
		else if(!istype(second))
			add_debug_log("Error: connected_devices\[[index]\] is invalid!(2)")
		else if(first == second)
			usr << "<span class='warning'>You cannot link an object to itself!</span>"
		else if(first.connects_to.Find(index) || first.connects_to.Find(index))
			usr << "<span class='warning'>They are already connected!</span>"
		else
			first.connects_to.Add(index)
			usr << "<span class='notice'>You successfully link [first] and [second]!</span>"
			return 1
		drawing_connection = null

/obj/item/device/assembly_holder/proc/wire_cut(var/obj/item/device/assembly/A, var/index)
	for(var/obj/item/device/assembly/B in connected_devices)
		B.holder_wire_safety(A, index, 0)
// Leaving them as two different procs incase someone wants to make this a little better in future.
/obj/item/device/assembly_holder/proc/wire_pulsed(var/obj/item/device/assembly/A, var/index)
	for(var/obj/item/device/assembly/B in connected_devices)
		B.holder_wire_safety(A, index, 1)

/obj/item/device/assembly_holder/verb/hide_under()
	set src in view(2)
	set name = "Hide"
	set category = "Object"

	if(usr.stat)
		return

	if(weight <= 8)
		usr << "<span class='notice'>You hide \the [src].</span>"
		layer = TURF_LAYER+0.2
	else
		usr << "<span class='notice'>\The [src] is too big to hide!</span>"

/obj/item/device/assembly_holder/proc/attach_device(var/mob/user, var/obj/item/O)
	if(stage) return
	if(istype(O, /obj/item/device/assembly))
		var/obj/item/device/assembly/A = O
		if(weight + A.weight > max_weight) return
		else if(connected_devices.len < max_connections)
			connected_devices.Add(A)
			A.forceMove(src)
			A.holder = src
			prespawned = 0
			if(connected_devices.len > 1 && advanced_settings["autoconnect"] == 1)
				var/obj/item/device/assembly/prev = connected_devices[(connected_devices.len - 1)]
				if(prev && istype(prev))
					if(prev.wires & WIRE_DIRECT_SEND && A.wires & WIRE_DIRECT_RECEIVE)
						prev.connects_to += "[connected_devices.len]" // Connect to the device before it
						add_debug_log("Automatic connection established. \[[prev.interface_name] > [A.interface_name]\]")
					else if(prev.wires & WIRE_POWER_SEND && A.wires & WIRE_POWER_RECEIVE)
						prev.connects_to += "[connected_devices.len]" // Connect to the device before it
						add_debug_log("Automatic connection established. \[[prev.interface_name] > [A.interface_name]\]")
					else
						add_debug_log("Automatic connection unavailable. \[[prev.interface_name] > [A.interface_name]\]")
		if(!A in recent_pulses)
			recent_pulses.Add(A)
	update_holder()

/obj/item/device/assembly_holder/examine(mob/user)
	..(user)
	update_holder()
	if ((in_range(src, user) || src.loc == user))
		for(var/obj/O in connected_devices)
			user << "You can see \an [O.name] attached to \the [src]!"
	if(examine_additions.len)
		for(var/i=1,i<=examine_additions.len,i++)
			user << "<span class='notice'>[examine_additions[i]]</span>"
	return

/obj/item/device/assembly_holder/proc/remove_connected_device(var/obj/item/device/assembly/removed)
	if(istype(removed) && removed in connected_devices)
		if(!removed.holder_disconnect()) return
		var/removed_index = connected_devices.Find(removed)
		if(connected_devices[removed_index] != removed)
			add_debug_log("Error. No index found!")
		if(removed.connects_to.len) // Need to get rid of any old connections. Could leave it up to the player, but..
			for(var/obj/item/device/assembly/connected in removed.get_devices_connected_to())
				var/connected_removed_index = connected.connects_to.Find(removed_index)
				if(!connected_removed_index)
					add_debug_log("Error: No match found \[[connected]\], wiping connection data")
					connected.connects_to.Cut()
					continue
				if(connected_devices.Find(connected) + 1 > connected_devices.len) // If there is no object inserted after connected
					connected.connects_to.Cut(connected_removed_index, connected_removed_index)// then we just need to remove the connection.
				else // Otherwise we can add an automatic connection to the next device in the list
					var/next_index = connected_devices[(connected_devices.Find(connected) + 1)]
					connected.connects_to[connected_removed_index] = next_index

		connected_devices.Remove(removed)
		var/list/new_list = connected_devices.Copy()
		for(var/i=1,i<=new_list.len,i++) // Make sure there are no null references, just incase something went wrong.
			if(new_list[i] == null)
				new_list.Cut(i,i+1)
				connected_devices = new_list
		var/pulse_index = recent_pulses.Find(removed)
		if(pulse_index) recent_pulses.Cut(pulse_index, pulse_index+1)
		removed.holder = null
		removed.forceMove(get_turf(src))
		removed.connects_to.Cut()
		add_debug_log("Device removed: [removed]")
		update_holder()

/obj/item/device/assembly_holder/afterattack(var/atom/target, var/atom/source, var/adjacent=0, var/params)
	if(!istype(source, /mob/living/carbon)) return
	var/mob/living/carbon/user = source
	if(implantable == 1 && istype(target, /mob/living/carbon/human) && adjacent)
		var/mob/living/carbon/human/M = target
		if(user == M)
			user.visible_message("<span class='danger'>[user] stabs \the [src] into themselves!</span>", "<span class='warning'>You stab \the [src] into yourself!</span>")
		else
			user.visible_message("<span class='danger'>[user] begins stabbing \the [src] into [M]!</span>")
			if(do_after(user, 60))
				user.visible_message("<span class='danger'>[user] stabs \the [src] into [M]!</span>", "<span class='warning'>You stab \the [src] into [M]!</span>")
		var/obj/item/organ/external/affected = M.get_organ(user.zone_sel.selecting)
		implanted(target, affected)
	else
		for(var/i=1,i<=connected_devices.len,i++)
			var/obj/item/device/assembly/A = connected_devices[i]
			if(A)
				A.holder_click(target, user, adjacent, params)
	return 1

// Honestly, I don't know what half of these do, but feel free to use them.
/obj/item/device/assembly_holder/HasProximity(atom/movable/AM as mob|obj)
	for(var/obj/O in connected_devices)
		O.HasProximity(AM)

/obj/item/device/assembly_holder/Crossed(atom/movable/AM as mob|obj)
	for(var/obj/O in connected_devices)
		O.Crossed(AM)


/obj/item/device/assembly_holder/on_found(mob/finder as mob)
	for(var/obj/item/device/assembly/O in connected_devices)
		O.on_found(finder)


/obj/item/device/assembly_holder/Move()
	..()
	for(var/obj/item/device/assembly/O in connected_devices)
		O.holder_movement()

/obj/item/device/assembly_holder/attack_hand(mob/user)
	for(var/obj/item/device/assembly/O in connected_devices)
		O.holder_attack_hand()
	if(weight >= 20)
		user << "<span class='warning'>\The [src] is too large and heavy!</span>"
		return 0
	if(anchored) // ?
		user << "<span class='warning'>\The [src] is anchored to the ground!</span>"
		return 0
	..()

/obj/item/device/assembly_holder/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/reagent_containers/glass/paint))
		paint_assembly(user, O)
	if(stage)
		if(acting) return
		if(istype(O, /obj/item/weapon/wrench))
			if(stage == 2)
				acting = 1
				user << "<span class='notice'>You start securing \the [stage_name]!</span>"
				if(do_after(user, rand(20, 60)))
					playsound(src.loc, 'sound/items/Ratchet.ogg', 25, -3)
					user << "<span class='notice'>You secure \the [stage_name] to \the [src]!</span>"
					stage = 3
					acting = 0
				else
					acting = 0

		else if(istype(O, /obj/item/stack/cable_coil))
			if(stage == 3)
				var/obj/item/stack/cable_coil/C = O
				if(C.use(5*weight))
					user << "<span class='notice'>You start wiring \the [stage_name]!</span>"
					acting = 1
					if(do_after(user, rand(20, 60)))
						user.visible_message("<span class='notice'>\The [user] has installed \the [stage_name] into [src]!</span>", "<span class='notice'>You've successfully installed \the [stage_name]!</span>")
						stage_name = ""
						stage = 0
						attach_device(user, removing)
						removing = null
						acting = 0
						playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, -3)
					else
						acting = 0
				else
					user << "<span class='warning'>You need atleast [5*weight] units of cable to do that!</span>"
		else if(istype(O, /obj/item/weapon/screwdriver))
			if(stage == 3)
				acting = 1
				user << "<span class='notice'>You start unsecuring \the [stage_name] from \the [src]..</span>"
				if(do_after(user, rand(20,60)))
					user << "<span class='notice'>You unsecure \the [stage_name]!</span>"
					stage = 2
					acting = 0
					playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, -3)
				else
					acting = 0
		else if(istype(O, /obj/item/weapon/crowbar))
			if(stage == 2)
				user << "<span class='notice'>You begin prying \the [stage_name] out of \the [src]!</span>"
				acting = 1
				if(do_after(user, rand(20,60)))
					playsound(src.loc, 'sound/items/Crowbar.ogg', 25, -3)
					user.visible_message("<span class='notice'>\The [user] removes \the [stage_name] from \the [src]!</span>", "<span class='notice'>You remove \the [stage_name] from \the [src]</span>")
					stage = 0
					stage_name = ""
					acting = 0
					if(remove_connected_device(removing))
						if(!user.put_in_hands(removing))
							removing.forceMove(get_turf(src))
					else
						removing.forceMove(get_turf(src))
					removing = null
		else
			user << "<span class='warning'>You cannot do that while modifying \the [stage_name]!</span>"
		return
	if(istype(O, /obj/item/weapon/wirecutters))
		if(acting) return
		var/list/choices = list()
		for(var/i=1,i<=connected_devices.len,i++)
			var/obj/item/device/assembly/A = connected_devices[i]
			if(A)
				choices.Add(A.interface_name)
		var/obj/item/device/assembly/removed
		var/choice = input(user, "What device would you like to fetch data from?", "Data") in choices
		var/failed = 0
		for(var/i=1,i<=connected_devices.len,i++)
			var/obj/item/device/assembly/A = connected_devices[i]
			if(A.interface_name == choice)
				removed = A
			if(!A.holder_can_remove())
				failed = 1
		if(!istype(removed)) return
		if(failed)
			user << "<span class='warning'>That device is locked in place!</span>"
			return 0
		if(!removed.holder_disconnect(user))
			return 0
		user.visible_message("<span class='notice'>\The [user] starts cutting \the [removed]'s wiring..</span>", "<span class='notice'>You begin cutting the wires from \the [removed]..</span>")
		acting = 1
		if(!do_after(user, rand(20, 60)))
			acting = 0
			return
		acting = 0
		user << "<span class='notice'>You cut the wire connections in \the [src]!</span>"
		stage = 3
		stage_name = removed.name
		removing = removed
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, -3)
	if(istype(O, /obj/item/weapon/wrench))
		var/failed = 0
		for(var/obj/item/device/assembly/A in connected_devices)
			if(!A.anchored(!anchored, user))
				failed = 1
		if(failed)
			user << "<span class='warning'>You're unable to do that!</span>"
		else
			user.remove_from_mob(src)
			anchored = !anchored
			user.visible_message("<span class='notice'>\The [user] [anchored ? "" : "un"]anchored \the [src] [anchored ? "to" : "from"] \the [get_turf(src)]</span>", "<span class='notice'>You [anchored ? "" : "un"]anchor \the [src] [anchored ? "to" : "from"] \the [get_turf(src)]</span>")
	if(istype(O, /obj/item/device/assembly))
		var/obj/item/device/assembly/A = O
		if(debug_mode)
			user.drop_item()
			attach_device(user, A)
			return
		if(!stage)
			if(!A.holder_attach(user)) return
			if(weight + A.weight > max_weight)
				user << "<span class='warning'>\The [src] cannot support the weight of \the [A]!</span>"
				return
			if(connected_devices.len >= max_connections)
				user << "<span class='warning'>\The [src] has no space to fit \the [A] onto!</span>"
				return
			stage = 1
			acting = 1
			user << "<span class='notice'>You begin installing \the [A.name]..</span>"
			if(!do_after(user, rand((A.weight * 30) / 1.5, (A.weight * 30) * 1.5)))
				stage = 0
				acting = 0
				return
			stage = 1
			user.visible_message("<span class='notice'>\The [user] attaches \the [A] to \the [src]!</span>", "<span class='notice'>You attach \the [A] to \the [src].</span>")
			stage = 2
			user.drop_item()
			A.forceMove(src)
			stage_name = A.name
			removing = A
			acting = 0

	//UPRADING
	//Note: No items are consumed except matter bins and materials.
	//This is so individual devices still interact with them.
	//TODO: Modular way to do this. This is hideous.
	if(istype(O, /obj/item/stack/) || istype(O, /obj/item/weapon/module/power_control))
		var/obj/item/stack/S = O
		if(istype(O, /obj/item/stack/material/steel))
			if(upgraded["steel"] < 15)
				if(S.can_use(5))
					S.use(5)
					user << "<span class='notice'>You expand \the [src]'s frame!</span>"
					upgraded["steel"] += 5
		else if(istype(O, /obj/item/stack/cable_coil))
			if(upgraded["cable"] < 10)
				if(S.can_use(5))
					S.use(5)
					user << "<span class='notice'>You expand \the [src]'s circuitry!</span>"
					upgraded["cable"] += 5
		else if(istype(O, /obj/item/stack/rods))
			if(upgraded["rods"] < 5)
				if(S.can_use(5))
					S.use(5)
					user << "<span class='notice'>You expand \the [src]'s internal support!</span>"
					upgraded["rods"] = 5
		else if(istype(O, /obj/item/stack/material/plasteel))
			if(upgraded["plasteel"] < 1)
				if(S.can_use(1))
					S.use(1)
					user << "<span class='notice'>You reinforce \the [src]'s frame!</span>"
					upgraded["plasteel"] = 1
		else if(istype(O, /obj/item/weapon/module/power_control))
			if(upgraded["power"] < 1)
				user << "<span class='notice'>You upgrade the circuitry within \the [src]!</span>"
				user.drop_item(O)
				qdel(O)
				upgraded["power"] = 1
		else
			user << "<span class='warning'>\The [src] doesn't need that!</span>"
			return
		switch(max_connections)
			if(2)
				if(upgraded["steel"] > 5 && upgraded["cable"] > 0)
					name = "big metal frame"
					desc = "A metal frame capable of holding four devices"
					icon_state = "4frame"
					max_connections = 4
			if(4)
				if(upgraded["steel"] > 10 && upgraded["cable"] > 5 && upgraded["rods"] > 0)
					name = "metal box"
					desc = "A metal box with fittings for up to five devices."
					icon_state = "smallbox"
					throwforce = 3
					w_class = 3.0
					throw_speed = 2
					throw_range = 5
					max_connections = 5
			if(5)
				if(upgraded["steel"] > 10 && upgraded["cable"] > 5 && upgraded["rods"] > 0 && upgraded["plasteel"] > 0)
					name = "large metal box"
					desc = "A large metal box with fittings for up to seven devices."
					icon_state = "box"
					throwforce = 3
					w_class = 4.0
					throw_speed = 2
					throw_range = 3
					max_connections = 7
			if(7)
				if(upgraded["steel"] > 10 && upgraded["cable"] > 5 && upgraded["rods"] > 0 && upgraded["plasteel"] > 0 && upgraded["power"] > 1)
					if(pulse_chance == 95)
						name = "server frame"
						desc = "A large, metal box with complicated circuitry, capable of fitting up to 10 devices into it."
						icon_state = "box"
						w_class = 5.0
						density = 1
						max_connections = 10
						pulse_chance = 100
						max_weight = 100 // Infinite, I should hope.




	if(istype(O, /obj/item/weapon/flame/lighter))
		if(pulse_chance == 50)
			user.visible_message("<span class='notice'>[user] solders \the [src] together!</span>", "<span class='notice'>You solder \the [src] together!</span>")
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			pulse_chance = 60
		else
			user << "<span class='notice'>\The [src] has already been soldered!</span>"
	if(istype(O, /obj/item/weapon/paper))
		if(pulse_chance == 60)
			user.visible_message("<span class='notice'>[user] cushions \the [src] with \the [O].</span>", "<span class='notice'>You cushion \the [src] with \the [O].</span>")
			pulse_chance = 70
		else if(pulse_chance > 60)
			user << "<span class='notice'>\The [src] is already cushioned!</span>"
		else
			user << "<span class='notice'>\The [src] is not sufficiently secured!</span>"
	if(istype(O, /obj/item/stack/medical/ointment))
		if(pulse_chance == 70) // Not really big enough to use some of it
			user.visible_message("<span class='notice'>[user] applies some sticky ointment to \the [src].</span>", "<span class='notice'>You apply some sticky ointment to \the [src].</span>")
			pulse_chance = 75
		else if(pulse_chance > 70)
			user << "<span class='notice'>\The [src] has already been stuck together</span>"
		else
			user << "<span class='notice'>\The [src] needs to be cushioned first!</span>"
	if(istype(O, /obj/item/weapon/stock_parts/manipulator))
		if(pulse_chance == 75)
			user.visible_message("<span class='notice'>[user] calibrates the circuitry within \the [src].</span>", "<span class='notice'>You calibrate the circuitry within \the [src].</span>")
			pulse_chance = 80
		else if(pulse_chance > 75)
			user << "<span class='notice'>\The [src] has already been calibrated!</span>"
		else
			user << "<span class='notice'>\The [src] needs to be stuck together first!</span>"
	if(istype(O, /obj/item/weapon/stock_parts/matter_bin))
		if(pulse_chance == 80)
			user.visible_message("<span class='notice'>[user] neatly cleans up \the [src]'s internals with \the [O].</span>", "<span class='notice'>You neatly clean up \the [src]'s internals with \the [O].</span>")
			pulse_chance = 85
			user.drop_item()
			qdel(O)
		else if(pulse_chance > 85)
			user << "<span class='notice'>\The [src]'s internals are already neat and tidy!</span>"
		else
			user << "<span class='notice'>\The [src] needs to be calibrated first!</span>"
	if(istype(O, /obj/item/weapon/reagent_containers/) && O.reagents.has_reagent("lube", 1))
		if(pulse_chance == 85)
			user.visible_message("<span class='notice'>[user] applies the contents of [O] onto \the [src]</span>", "<span class='notice'>You apply some lubricant to the components within \the [src].</span>")
			pulse_chance = 95
		else if(pulse_chance < 85)
			user << "<span class='notice'>\The [src] needs it's insides contained securely first!</span>"
	if(istype(O, /obj/item/device/multitool))
		ui_interact(user)

//	if(istype(O, /obj/item/device/assembly_holder))
//		merge(O)
	for(var/obj/item/device/assembly/A in connected_devices)
		if(!A.holder_interface())
			user << "<span class='warning'>The device is locked shut!</span>"
			return
//	if(is_type_in_list(O, attachable_devices)) // Non-assembly devices for special holders.
//		attach_device(user, O)
	var/list/L = list()
	for(var/obj/item/device/assembly/A in connected_devices)
		if(is_type_in_list(O, A.holder_attackby) && istype(A))
			L += A
	if(L.len)
		if(L.len == 1)
			var/obj/object = L[1]
			object.attackby(O, user)
		else
			var/obj/item/device/assembly/modify = input("Which device would you like to modify?", "Assembly", "Cancel") in L
			if(istype(modify))
				modify.attackby(O, user)

/obj/item/device/assembly_holder/attack_self(mob/user as mob)
	src.add_fingerprint(user)
	for(var/obj/item/device/assembly/A in connected_devices)
		A.holder_attack_self(user)

/obj/item/device/assembly_holder/hear_talk(mob/living/M as mob, msg, verb, datum/language/speaking)
	for(var/obj/item/device/assembly/A in connected_devices)
		A.holder_hear_talk(M, msg)

/obj/item/device/assembly_holder/emp_act(severity)
	for(var/obj/O in connected_devices)
		O.emp_act(severity)

/obj/item/device/assembly_holder/ex_act(severity)
	switch(severity)
		if(1) // Errything dies
			qdel(src)
		if(2) // A few things get destroyed, everything else gets scattered.
			for(var/obj/O in connected_devices)
				if(prob(33))
					qdel(O)
				else
					var/turf/T = pick(get_turf(view(5)))
					if(T)
						remove_connected_device(O)
						sleep(0)
						step_to(O, T)
						O.ex_act(severity)
		if(3) // Some things get thrown out.
			for(var/obj/O in connected_devices)
				if(prob(50))
					var/turf/T = pick(get_turf(view(3)))
					if(T)
						remove_connected_device(O)
						sleep(0)
						step_to(O, T)
						if(prob(50))
							O.ex_act(severity)

/obj/item/device/assembly_holder/proc/implanted(var/mob/living/carbon/target, var/obj/item/organ/external/affected)
	for(var/obj/item/device/assembly/A in connected_devices)
		A.implanted(target)
	if(!(src in affected.implants))
		affected.implants.Add(src)
	src.forceMove(affected)
	owner = target
	implanted_in = affected
	processing_objects.Add(src)
	return 1

/obj/item/device/assembly_holder/mob_can_unequip(mob/M, slot, disable_warning = 0)
	var/failed = 0
	if(attachable)
		for(var/obj/item/device/assembly/A in connected_devices)
			if(A.attachable)
				if(!A.mob_can_unequip(M, slot, disable_warning)) failed = 1
	if(failed)
		return 0
	return 1

/obj/item/device/assembly_holder/mob_can_equip(M as mob, slot, disable_warning = 0)
	if(..())
		owner = M
		for(var/obj/item/device/assembly/A in connected_devices)
			A.attached(M)
		return 1


/obj/item/device/assembly_holder/process()
	if(!owner || !src in owner.contents)
		owner = null
		implanted_in = null
		processing_objects.Remove(src)
		return
	for(var/obj/item/device/assembly/A in connected_devices)
		A.implant_process()

/obj/item/device/assembly_holder/frame
	name = "assembly frame"
	desc = "A metal frame capable of holding two devices"
	icon = 'icons/obj/assemblies/assembly_holders.dmi'
	icon_state = "2frame"
	item_state = "assembly"
	throwforce = 5
	w_class = 2.0
	throw_speed = 3
	throw_range = 10
	upgraded = list("cable" = 0, "steel" = 5, "rods" = 0, "plasteel" = 0, "power" = 0)
	max_connections = 2

/obj/item/device/assembly_holder/frame/four
	name = "big metal frame"
	desc = "A metal frame capable of holding four devices"
	icon = 'icons/obj/assemblies/assembly_holders.dmi'
	icon_state = "4frame"
	item_state = "assembly"
	throwforce = 4
	w_class = 3.0
	throw_speed = 2
	throw_range = 7
	upgraded = list("cable" = 5, "steel" = 10, "rods" = 0, "plasteel" = 0, "power" = 0)

	max_connections = 4

/obj/item/device/assembly_holder/box
	name = "metal box"
	desc = "A metal box with fittings for up to five devices."
	icon = 'icons/obj/assemblies/assembly_holders.dmi'
	icon_state = "smallbox"
	item_state = "assembly"
	throwforce = 3
	w_class = 3.0
	throw_speed = 2
	throw_range = 5
	upgraded = list("cable" = 10, "steel" = 15, "rods" = 5, "plasteel" = 0, "power" = 0)

	max_connections = 5

/obj/item/device/assembly_holder/box
	name = "large metal box"
	desc = "A large metal box with fittings for up to seven devices."
	icon_state = "box"
	item_state = "assembly"
	throwforce = 3
	w_class = 4.0
	throw_speed = 2
	throw_range = 3
	upgraded = list("cable" = 10, "steel" = 15, "rods" = 5, "plasteel" = 1, "power" = 0)

	max_connections = 7

/obj/item/device/assembly_holder/server
	name = "server frame"
	desc = "A large, metal box with complicated circuitry, capable of fitting up to 10 devices into it."
	icon_state = "box"
	item_state = "assembly"
	w_class = 5.0
	upgraded = list("cable" = 10, "steel" = 15, "rods" = 5, "plasteel" = 1, "power" = 1)

	max_connections = 10
	pulse_chance = 100
	max_weight = 100 // Infinite, I should hope.
