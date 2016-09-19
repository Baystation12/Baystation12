#define WIRE		"wire"
#define WIRING		"wiring"
#define UNWIRE		"unwire"
#define UNWIRING	"unwiring"


/obj/item/device/integrated_electronics/wirer
	name = "circuit wirer"
	desc = "It's a small wiring tool, with a wire roll, electric soldering iron, wire cutter, and more in one package. \
	The wires used are generally useful for small electronics, such as circuitboards and breadboards, as opposed to larger wires \
	used for power or data transmission."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "wirer-wire"
	flags = CONDUCT
	w_class = 2
	var/datum/integrated_io/selected_io = null
	var/mode = WIRE

/obj/item/device/integrated_electronics/wirer/New()
	..()

/obj/item/device/integrated_electronics/wirer/update_icon()
	icon_state = "wirer-[mode]"

/obj/item/device/integrated_electronics/wirer/proc/wire(var/datum/integrated_io/io, mob/user)
	if(mode == WIRE)
		selected_io = io
		user << "<span class='notice'>You attach a data wire to \the [selected_io.holder]'s [selected_io.name] data channel.</span>"
		mode = WIRING
		update_icon()
	else if(mode == WIRING)
		if(io == selected_io)
			user << "<span class='warning'>Wiring \the [selected_io.holder]'s [selected_io.name] into itself is rather pointless.</span>"
			return
		if(io.io_type != selected_io.io_type)
			user << "<span class='warning'>Those two types of channels are incompatable.  The first is a [selected_io.io_type], \
			while the second is a [io.io_type].</span>"
			return
		selected_io.linked |= io
		io.linked |= selected_io

		user << "<span class='notice'>You connect \the [selected_io.holder]'s [selected_io.name] to \the [io.holder]'s [io.name].</span>"
		mode = WIRE
		update_icon()
		//io.updateDialog()
		//selected_io.updateDialog()
		selected_io.holder.interact(user) // This is to update the UI.
		selected_io = null

	else if(mode == UNWIRE)
		selected_io = io
		if(!io.linked.len)
			user << "<span class='warning'>There is nothing connected to \the [selected_io] data channel.</span>"
			selected_io = null
			return
		user << "<span class='notice'>You prepare to detach a data wire from \the [selected_io.holder]'s [selected_io.name] data channel.</span>"
		mode = UNWIRING
		update_icon()
		return

	else if(mode == UNWIRING)
		if(io == selected_io)
			user << "<span class='warning'>You can't wire a pin into each other, so unwiring \the [selected_io.holder] from \
			the same pin is rather moot.</span>"
			return
		if(selected_io in io.linked)
			io.linked.Remove(selected_io)
			selected_io.linked.Remove(io)
			user << "<span class='notice'>You disconnect \the [selected_io.holder]'s [selected_io.name] from \
			\the [io.holder]'s [io.name].</span>"
			//io.updateDialog()
			//selected_io.updateDialog()
			selected_io.holder.interact(user) // This is to update the UI.
			selected_io = null
			mode = UNWIRE
			update_icon()
		else
			user << "<span class='warning'>\The [selected_io.holder]'s [selected_io.name] and \the [io.holder]'s \
			[io.name] are not connected.</span>"
			return
	return

/obj/item/device/integrated_electronics/wirer/attack_self(mob/user)
	switch(mode)
		if(WIRE)
			mode = UNWIRE
		if(WIRING)
			if(selected_io)
				user << "<span class='notice'>You decide not to wire the data channel.</span>"
			selected_io = null
			mode = UNWIRE
		if(UNWIRE)
			mode = WIRE
		if(UNWIRING)
			if(selected_io)
				user << "<span class='notice'>You decide not to disconnect the data channel.</span>"
			selected_io = null
			mode = UNWIRE
	update_icon()
	user << "<span class='notice'>You set \the [src] to [mode].</span>"

#undef WIRE
#undef WIRING
#undef UNWIRE
#undef UNWIRING

/obj/item/device/integrated_electronics/debugger
	name = "circuit debugger"
	desc = "This small tool allows one working with custom machinery to directly set data to a specific pin, useful for writing \
	settings to specific circuits, or for debugging purposes.  It can also pulse activation pins."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "debugger"
	flags = CONDUCT
	w_class = 2
	var/data_to_write = null
	var/accepting_refs = 0

/obj/item/device/integrated_electronics/debugger/attack_self(mob/user)
	var/type_to_use = input("Please choose a type to use.","[src] type setting") as null|anything in list("string","number","ref", "null")
	var/new_data = null
	switch(type_to_use)
		if("string")
			accepting_refs = 0
			new_data = input("Now type in a string.","[src] string writing") as null|text
			if(istext(new_data))
				data_to_write = new_data
				user << "<span class='notice'>You set \the [src]'s memory to \"[new_data]\".</span>"
		if("number")
			accepting_refs = 0
			new_data = input("Now type in a number.","[src] number writing") as null|num
			if(isnum(new_data))
				data_to_write = new_data
				user << "<span class='notice'>You set \the [src]'s memory to [new_data].</span>"
		if("ref")
			accepting_refs = 1
			user << "<span class='notice'>You turn \the [src]'s ref scanner on.  Slide it across \
			an object for a ref of that object to save it in memory.</span>"
		if("null")
			data_to_write = null
			user << "<span class='notice'>You set \the [src]'s memory to absolutely nothing.</span>"

/obj/item/device/integrated_electronics/debugger/afterattack(atom/target, mob/living/user, proximity)
	if(accepting_refs && proximity)
		data_to_write = target
		visible_message("<span class='notice'>[user] slides \a [src]'s over \the [target].</span>")
		user << "<span class='notice'>You set \the [src]'s memory to a reference to [target.name] \[Ref\].  The ref scanner is \
		now off.</span>"
		accepting_refs = 0

/obj/item/device/integrated_electronics/debugger/proc/write_data(var/datum/integrated_io/io, mob/user)
	if(io.io_type == DATA_CHANNEL)
		io.write_data_to_pin(data_to_write)
		user << "<span class='notice'>You write [data_to_write] to \the [io.holder]'s [io].</span>"
	else if(io.io_type == PULSE_CHANNEL)
		io.holder.work()
		user << "<span class='notice'>You pulse \the [io.holder]'s [io].</span>"

	io.holder.interact(user) // This is to update the UI.

/obj/item/weapon/storage/bag/circuits
	name = "circuit kit"
	desc = "This kit's essential for any circuitry projects."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "circuit_kit"
	w_class = 3
	storage_slots = 200
	max_storage_space = 400
	max_w_class = 3
	display_contents_with_number = 1
	can_hold = list(/obj/item/integrated_circuit, /obj/item/device/integrated_electronics, /obj/item/device/electronic_assembly,
	/obj/item/weapon/screwdriver, /obj/item/weapon/crowbar)

/obj/item/weapon/storage/bag/circuits/basic/New()
	..()
	var/list/types_to_spawn = typesof(/obj/item/integrated_circuit/arithmetic,
		/obj/item/integrated_circuit/logic,
		/obj/item/integrated_circuit/memory,
		) - list(/obj/item/integrated_circuit/arithmetic,
		/obj/item/integrated_circuit/memory,
		/obj/item/integrated_circuit/logic,
		)

	types_to_spawn.Add(/obj/item/integrated_circuit/input/numberpad,
		/obj/item/integrated_circuit/input/textpad,
		/obj/item/integrated_circuit/input/button,
		/obj/item/integrated_circuit/input/signaler,
		/obj/item/integrated_circuit/input/local_locator,
		/obj/item/integrated_circuit/output/screen,
		/obj/item/integrated_circuit/converter/num2text,
		/obj/item/integrated_circuit/converter/text2num,
		/obj/item/integrated_circuit/converter/uppercase,
		/obj/item/integrated_circuit/converter/lowercase,
		/obj/item/integrated_circuit/time/delay/five_sec,
		/obj/item/integrated_circuit/time/delay/one_sec,
		/obj/item/integrated_circuit/time/delay/half_sec,
		/obj/item/integrated_circuit/time/delay/tenth_sec,
		/obj/item/integrated_circuit/time/ticker/slow,
		/obj/item/integrated_circuit/time/clock
		)

	for(var/thing in types_to_spawn)
		var/i = 3
		while(i)
			new thing(src)
			i--

	new /obj/item/device/electronic_assembly(src)
	new /obj/item/device/integrated_electronics/wirer(src)
	new /obj/item/device/integrated_electronics/debugger(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/weapon/screwdriver(src)

/obj/item/weapon/storage/bag/circuits/all/New()
	..()
	var/list/types_to_spawn = typesof(/obj/item/integrated_circuit)

	for(var/thing in types_to_spawn)
		var/i = 10
		while(i)
			new thing(src)
			i--

	new /obj/item/device/electronic_assembly(src)
	new /obj/item/device/integrated_electronics/wirer(src)
	new /obj/item/device/integrated_electronics/debugger(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/weapon/screwdriver(src)