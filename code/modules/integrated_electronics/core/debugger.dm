/obj/item/device/integrated_electronics/debugger
	name = "circuit debugger"
	desc = "This small tool allows one working with custom machinery to directly set data to a specific pin, useful for writing \
	settings to specific circuits, or for debugging purposes.  It can also pulse activation pins."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "debugger"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	item_flags = ITEM_FLAG_NO_BLUDGEON
	w_class = ITEM_SIZE_SMALL
	var/data_to_write = null
	var/accepting_refs = FALSE
	matter = list(MATERIAL_ALUMINIUM = 1500, MATERIAL_STEEL = 1000, MATERIAL_GLASS = 500, MATERIAL_PLASTIC = 500)

/obj/item/device/integrated_electronics/debugger/attack_self(mob/user)
	var/type_to_use = input("Please choose a type to use.","[src] type setting") as null|anything in list("string","number","ref", "null")

	var/new_data = null
	switch(type_to_use)
		if("string")
			accepting_refs = FALSE
			new_data = user.get_input("Now type in a string", "[src] string writing", null, MOB_INPUT_TEXT, src)
			new_data = sanitize(new_data,trim = 0)
			if(istext(new_data) && user.IsAdvancedToolUser())
				data_to_write = new_data
				to_chat(user, SPAN_NOTICE("You set \the [src]'s memory to \"[new_data]\"."))
		if("number")
			accepting_refs = FALSE
			new_data = user.get_input("Now type in a number", "[src] number writing", null, MOB_INPUT_NUM, src)
			if(isnum(new_data) && user.IsAdvancedToolUser())
				data_to_write = new_data
				to_chat(user, SPAN_NOTICE("You set \the [src]'s memory to [new_data]."))
		if("ref")
			accepting_refs = TRUE
			to_chat(user, SPAN_NOTICE("You turn \the [src]'s ref scanner on.  Slide it across \
			an object for a ref of that object to save it in memory."))
		if("null")
			data_to_write = null
			to_chat(user, SPAN_NOTICE("You set \the [src]'s memory to absolutely nothing."))

/obj/item/device/integrated_electronics/debugger/use_after(atom/target, mob/living/user, click_parameters)
	if (accepting_refs)
		data_to_write = weakref(target)
		visible_message(SPAN_NOTICE("[user] slides \a [src]'s over \the [target]."))
		to_chat(user, SPAN_NOTICE("You set \the [src]'s memory to a reference to [target.name] \[Ref\].  The ref scanner is \
		now off."))
		accepting_refs = FALSE
		return TRUE

/obj/item/device/integrated_electronics/debugger/proc/write_data(datum/integrated_io/io, mob/user)
	if(io.io_type == DATA_CHANNEL)
		io.write_data_to_pin(data_to_write)
		var/data_to_show = data_to_write
		if(isweakref(data_to_write))
			var/weakref/w = data_to_write
			var/atom/A = w.resolve()
			if(!A)
				to_chat(user, SPAN_WARNING("\The [src]'s reference is stale and won't transfer to \the [io.holder]'s pin."))
				return
			data_to_show = A.name
		to_chat(user, SPAN_NOTICE("You write '[data_to_write ? data_to_show : "NULL"]' to the '[io]' pin of \the [io.holder]."))
	else if(io.io_type == PULSE_CHANNEL)
		io.holder.check_then_do_work(io.ord,ignore_power = TRUE)
		to_chat(user, SPAN_NOTICE("You pulse \the [io.holder]'s [io]."))

	io.holder.interact(user) // This is to update the UI.
