/obj/structure/firedoor_assembly
	name = "\improper emergency shutter assembly"
	desc = "It can save lives."
	icon = 'icons/obj/doors/hazard/door.dmi'
	icon_state = "construction"
	anchored = FALSE
	opacity = 0
	density = TRUE
	var/wired = 0

//construction: wrenched > cables > electronics > screwdriver & open
//deconstruction: closed & welded > screwdriver > crowbar > wire cutters > wrench > welder

/obj/structure/firedoor_assembly/attackby(obj/item/C, mob/user)
	if(isCoil(C) && !wired && anchored)
		var/obj/item/stack/cable_coil/cable = C
		if (cable.get_amount() < 1)
			to_chat(user, SPAN_WARNING("You need one length of coil to wire \the [src]."))
			return
		user.visible_message("[user] wires \the [src].", "You start to wire \the [src].")
		if(do_after(user, 4 SECONDS, src, DO_REPAIR_CONSTRUCT) && !wired && anchored)
			if (cable.use(1))
				wired = 1
				to_chat(user, SPAN_NOTICE("You wire \the [src]."))

	else if(isWirecutter(C) && wired )
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		user.visible_message("[user] cuts the wires from \the [src].", "You start to cut the wires from \the [src].")

		if(do_after(user, 4 SECONDS, src, DO_REPAIR_CONSTRUCT))
			if(!src) return
			to_chat(user, SPAN_NOTICE("You cut the wires!"))
			new/obj/item/stack/cable_coil(src.loc, 1)
			wired = 0

	else if(istype(C, /obj/item/airalarm_electronics) && wired)
		if(anchored)
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			user.visible_message(SPAN_WARNING("[user] has inserted a circuit into \the [src]!"),
								  "You have inserted the circuit into \the [src]!")
			var/obj/machinery/door/firedoor/D = new(src.loc)
			D.hatch_open = 1
			D.close()
			qdel(C)
			qdel(src)
		else
			to_chat(user, SPAN_WARNING("You must secure \the [src] first!"))
	else if(isWrench(C) && !wired)
		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		user.visible_message(SPAN_WARNING("[user] has [anchored ? "" : "un" ]secured \the [src]!"),
							  "You have [anchored ? "" : "un" ]secured \the [src]!")
		update_icon()
	else if(!anchored && isWelder(C))
		var/obj/item/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			user.visible_message(SPAN_WARNING("[user] dissassembles \the [src]."),
			"You start to dissassemble \the [src].")
			if(do_after(user, 4 SECONDS, src, DO_REPAIR_CONSTRUCT))
				if(!src || !WT.isOn()) return
				user.visible_message(SPAN_WARNING("[user] has dissassembled \the [src]."),
									"You have dissassembled \the [src].")
				new /obj/item/stack/material/steel(src.loc, 4)
				qdel(src)
		else
			to_chat(user, SPAN_NOTICE("You need more welding fuel."))
	else
		..(C, user)
