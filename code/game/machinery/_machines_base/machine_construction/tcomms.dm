// Telecomms have lots of states.

/decl/machine_construction/tcomms
	needs_board = "machine"

/decl/machine_construction/tcomms/panel_closed/state_is_valid(obj/machinery/machine)
	return !machine.panel_open

/decl/machine_construction/tcomms/panel_closed/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, /decl/machine_construction/tcomms/panel_open)

/decl/machine_construction/tcomms/panel_closed/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	if(isScrewdriver(I))
		TRANSFER_STATE(/decl/machine_construction/tcomms/panel_open)
		machine.panel_open = TRUE
		to_chat(user, "You unfasten the bolts.")
		playsound(machine.loc, 'sound/items/Screwdriver.ogg', 50, 1)

/decl/machine_construction/tcomms/panel_closed/post_construct(obj/machinery/machine)
	try_change_state(machine, /decl/machine_construction/tcomms/panel_open/no_cable)
	machine.panel_open = TRUE
	machine.queue_icon_update()

/decl/machine_construction/tcomms/panel_closed/mechanics_info()
	. = list()
	. += "Use a screwdriver to open the panel."

/decl/machine_construction/tcomms/panel_closed/cannot_print
	cannot_print = TRUE

/decl/machine_construction/tcomms/panel_open/state_is_valid(obj/machinery/machine)
	return machine.panel_open

/decl/machine_construction/tcomms/panel_open/validate_state(obj/machinery/machine)
	. = ..()
	if(!.)
		try_change_state(machine, /decl/machine_construction/tcomms/panel_closed)

/decl/machine_construction/tcomms/panel_open/attackby(obj/item/I, mob/user, obj/machinery/machine)
	if((. = ..()))
		return
	return state_interactions(I, user, machine)

/decl/machine_construction/tcomms/panel_open/proc/state_interactions(obj/item/I, mob/user, obj/machinery/machine)
	if(isScrewdriver(I))
		TRANSFER_STATE(/decl/machine_construction/tcomms/panel_closed)
		machine.panel_open = FALSE
		to_chat(user, "You fasten the bolts.")
		playsound(machine.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		return
	if(isWrench(I))
		TRANSFER_STATE(/decl/machine_construction/tcomms/panel_open/unwrenched)
		to_chat(user, "You dislodge the external plating.")
		playsound(machine.loc, 'sound/items/Ratchet.ogg', 75, 1)

/decl/machine_construction/tcomms/panel_open/mechanics_info()
	. = list()
	. += "Use a screwdriver to close the panel."
	. += "Use a wrench to remove the external plating."

/decl/machine_construction/tcomms/panel_open/unwrenched/state_interactions(obj/item/I, mob/user, obj/machinery/machine)
	if(isWrench(I))
		TRANSFER_STATE(/decl/machine_construction/tcomms/panel_open)
		to_chat(user, "You secure the external plating.")
		playsound(machine.loc, 'sound/items/Ratchet.ogg', 75, 1)
		return
	if(isWirecutter(I))
		TRANSFER_STATE(/decl/machine_construction/tcomms/panel_open/no_cable)
		playsound(machine.loc, 'sound/items/Wirecutter.ogg', 50, 1)
		to_chat(user, "You remove the cables.")
		var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil( user.loc )
		A.amount = 5
		machine.set_broken(TRUE, TRUE) // the machine's been borked!

/decl/machine_construction/tcomms/panel_open/unwrenched/mechanics_info()
	. = list()
	. += "Use a wrench to secure the external plating."
	. += "Use wirecutters to remove the cabling."

/decl/machine_construction/tcomms/panel_open/no_cable/state_interactions(obj/item/I, mob/user, obj/machinery/machine)
	if(isCoil(I))
		var/obj/item/stack/cable_coil/A = I
		if (A.can_use(5))
			TRANSFER_STATE(/decl/machine_construction/tcomms/panel_open/unwrenched)
			A.use(5)
			to_chat(user, "<span class='notice'>You insert the cables.</span>")
			machine.set_broken(FALSE, TRUE) // the machine's not borked anymore!
			return
		else
			to_chat(user, "<span class='warning'>You need five coils of wire for this.</span>")
			return TRUE
	if(isCrowbar(I))
		TRANSFER_STATE(/decl/machine_construction/default/deconstructed)
		machine.dismantle()
		return

	if(istype(I, /obj/item/storage/part_replacer))
		return machine.part_replacement(I, user)

	if(isWrench(I))
		return machine.part_removal(user)

	if(istype(I))
		return machine.part_insertion(user, I)

/decl/machine_construction/tcomms/panel_open/no_cable/mechanics_info()
	. = list()
	. += "Attach cables to make the machine functional."
	. += "Use a parts replacer to upgrade some parts."
	. += "Use a crowbar to remove the circuit and deconstruct the machine"
	. += "Insert a new part to install it."
	. += "Remove installed parts with a wrench."