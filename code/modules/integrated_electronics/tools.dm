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
	w_class = ITEM_SIZE_SMALL
	var/datum/integrated_io/selected_io = null
	var/mode = WIRE

/obj/item/device/integrated_electronics/wirer/update_icon()
	icon_state = "wirer-[mode]"

/obj/item/device/integrated_electronics/wirer/proc/wire(var/datum/integrated_io/io, mob/user)
	if(mode == WIRE)
		selected_io = io
		to_chat(user, "<span class='notice'>You attach a data wire to \the [selected_io.holder]'s [selected_io.name] data channel.</span>")
		mode = WIRING
		update_icon()
	else if(mode == WIRING)
		if(selected_io && selected_io.link_io(io, user))
			to_chat(user, "<span class='notice'>You connect \the [selected_io.holder]'s [selected_io.name] to \the [io.holder]'s [io.name].</span>")
			mode = WIRE
			update_icon()
			io.holder.interact(user)
			selected_io.holder.interact(user) // This is to update the UI.
			selected_io = null

	else if(mode == UNWIRE)
		selected_io = io
		if(!io.linked.len)
			to_chat(user, "<span class='warning'>There is nothing connected to \the [selected_io] data channel.</span>")
			selected_io = null
			return
		to_chat(user, "<span class='notice'>You prepare to detach a data wire from \the [selected_io.holder]'s [selected_io.name] data channel.</span>")
		mode = UNWIRING
		update_icon()
		return

	else if(mode == UNWIRING)
		if(io == selected_io)
			to_chat(user, "<span class='warning'>You can't wire a pin into each other, so unwiring \the [selected_io.holder] from \
			the same pin is rather moot.</span>")
			return
		if(selected_io in io.linked)
			io.linked.Remove(selected_io)
			selected_io.linked.Remove(io)
			to_chat(user, "<span class='notice'>You disconnect \the [selected_io.holder]'s [selected_io.name] from \
			\the [io.holder]'s [io.name].</span>")
			selected_io.holder.interact(user) // This is to update the UI.
			selected_io = null
			mode = UNWIRE
			update_icon()
		else
			to_chat(user, "<span class='warning'>\The [selected_io.holder]'s [selected_io.name] and \the [io.holder]'s \
			[io.name] are not connected.</span>")
			return
	return

/obj/item/device/integrated_electronics/wirer/attack_self(mob/user)
	switch(mode)
		if(WIRE)
			mode = UNWIRE
		if(WIRING)
			if(selected_io)
				to_chat(user, "<span class='notice'>You decide not to wire the data channel.</span>")
			selected_io = null
			mode = WIRE
		if(UNWIRE)
			mode = WIRE
		if(UNWIRING)
			if(selected_io)
				to_chat(user, "<span class='notice'>You decide not to disconnect the data channel.</span>")
			selected_io = null
			mode = UNWIRE
	update_icon()
	to_chat(user, "<span class='notice'>You set \the [src] to [mode].</span>")
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
	w_class = ITEM_SIZE_SMALL
	var/weakref/data_to_write = null
	var/accepting_refs = 0
	var/available_types = list("string","number","null")

/obj/item/device/integrated_electronics/debugger/admin
	description_info = "Ref scanning is done by click-drag-dropping the debugger unto an adjacent object that you wish to scan."
	available_types = list("string","number","ref","null")

/obj/item/device/integrated_electronics/debugger/attack_self(mob/user)
	var/type_to_use = input("Please choose a type to use.","[src] type setting") as null|anything in available_types
	if(!type_to_use || !CanInteract(user, physical_state))
		return

	var/new_data = null
	switch(type_to_use)
		if("string")
			accepting_refs = 0
			new_data = sanitize(input("Now type in a string.","[src] string writing") as null|text, trim = 0)
			if(istext(new_data) && CanInteract(user, physical_state))
				data_to_write = new_data
				to_chat(user, "<span class='notice'>You set \the [src]'s memory to \"[new_data]\".</span>")
		if("number")
			accepting_refs = 0
			new_data = input("Now type in a number.","[src] number writing") as null|num
			if(isnum(new_data) && CanInteract(user, physical_state))
				data_to_write = new_data
				to_chat(user, "<span class='notice'>You set \the [src]'s memory to [new_data].</span>")
		if("ref")
			accepting_refs = 1
			to_chat(user, "<span class='notice'>You turn \the [src]'s ref scanner on.  Slide it across \
			an object for a ref of that object to save it in memory.</span>")
		if("null")
			data_to_write = null
			to_chat(user, "<span class='notice'>You set \the [src]'s memory to absolutely nothing.</span>")
/obj/item/device/integrated_electronics/debugger/admin/MouseDrop(var/atom/over_object)
	if(!accepting_refs)
		return ..()

	if(!CanMouseDrop(over_object))
		return
	data_to_write = weakref(over_object)
	visible_message("<span class='notice'>\The [usr] slides \a [src]'s over \the [over_object].</span>")
	to_chat(usr, "<span class='notice'>You set \the [src]'s memory to a reference to \the [over_object.name]. The ref scanner is now off.</span>")
	accepting_refs = 0

/obj/item/device/integrated_electronics/debugger/proc/write_data(var/datum/integrated_io/io, mob/user)
	if(io.io_type == DATA_CHANNEL)
		io.write_data_to_pin(data_to_write)
		var/data_to_show = data_to_write
		if(isweakref(data_to_write))
			var/atom/A = data_to_write.resolve()
			data_to_show = A.name
		to_chat(user, "<span class='notice'>You write '[data_to_show ? data_to_show : "NULL"]' to the '[io]' pin of \the [io.holder].</span>")
	else if(io.io_type == PULSE_CHANNEL)
		io.holder.check_then_do_work(io)
		to_chat(user, "<span class='notice'>You pulse \the [io.holder]'s [io].</span>")
	io.holder.interact(user) // This is to update the UI.

/obj/item/device/integrated_electronics/analyzer
	name = "circuit analuzer"
	desc = "This tool allows one to analyze custom assemblies and their components from a distance."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "analyzer"
	flags = CONDUCT
	w_class = 2
	var/last_scan = ""

/obj/item/device/integrated_electronics/analyzer/examine(var/mob/user)
	. = ..(user, 1)
	if(.)
		if(last_scan)
			to_chat(user, last_scan)
		else
			to_chat(user, "\The [src] has not yet been used to analyze any assemblies.")
/obj/item/device/integrated_electronics/analyzer/afterattack(var/obj/item/device/electronic_assembly/assembly, var/mob/user)
	if(!istype(assembly))
		return ..()

	user.visible_message("<span class='notify'>\The [user] begins to scan \the [assembly].</span>", "<span class='notify'>You begin to scan \the [assembly].</span>")
	if(!do_after(user, assembly.get_part_complexity(), assembly))
		return

	playsound(src.loc, 'sound/piano/A#6.ogg', 25, 0, -3)

	last_scan = list()
	last_scan += "Results from the scan of \the [assembly]:"
	var/found_parts = FALSE
	for(var/obj/item/integrated_circuit/part in assembly)
		found_parts = TRUE
		last_scan += "\t [initial(part.name)]"
	if(!found_parts)
		last_scan += "*No Components Found*"
	last_scan = jointext(last_scan,"\n")
	to_chat(user, last_scan)
/obj/item/weapon/storage/bag/circuits
	name = "circuit kit"
	desc = "This kit's essential for any circuitry projects."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "circuit_kit"
	w_class = ITEM_SIZE_NORMAL

	storage_ui = /datum/storage_ui/tgui
	allow_quick_empty = FALSE

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
		var/obj/item/integrated_circuit/ic = thing
		if(initial(ic.category) == thing)
			continue

		for(var/i = 1 to 4)
			new thing(src)

	new /obj/item/device/electronic_assembly(src)
	new /obj/item/device/integrated_electronics/wirer(src)
	new /obj/item/device/integrated_electronics/debugger(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/weapon/screwdriver(src)
	make_exact_fit()

/obj/item/weapon/storage/bag/circuits/debug/New()
	..()
	name = "[name] - not intended for general use"
	desc = "[desc] - not intended for general use"
	for(var/subtype in subtypesof(/obj/item/integrated_circuit))
		var/obj/item/integrated_circuit/ic = subtype
		if(initial(ic.category) == subtype)
			continue
		for(var/i = 1 to 10)
			new subtype(src)

	new /obj/item/device/electronic_assembly(src)
	new /obj/item/device/integrated_electronics/wirer(src)
	new /obj/item/device/integrated_electronics/debugger/admin(src)
	new /obj/item/device/integrated_electronics/analyzer(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/weapon/screwdriver(src)
	make_exact_fit()
