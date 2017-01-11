// Held by /obj/machinery/modular_computer to reduce amount of copy-pasted code.
/obj/item/modular_computer/processor
	name = "processing unit"
	desc = "You shouldn't see this. If you do, report it."
	icon = null
	icon_state = null
	icon_state_unpowered = null
	icon_state_menu = null
	hardware_flag = 0

	var/obj/machinery/modular_computer/machinery_computer = null

/obj/item/modular_computer/processor/Destroy()
	. = ..()
	if(machinery_computer && (machinery_computer.cpu == src))
		machinery_computer.cpu = null
	machinery_computer = null

/obj/item/modular_computer/processor/nano_host()
	return machinery_computer.nano_host()

// Due to how processes work, we'd receive two process calls - one from machinery type and one from our own type.
// Since we want this to be in-sync with machinery (as it's hidden type for machinery-based computers) we'll ignore
// non-relayed process calls.
/obj/item/modular_computer/processor/process(var/relayed = 0)
	if(relayed)
		..()
	else
		return

/obj/item/modular_computer/processor/examine(var/mob/user)
	if(damage > broken_damage)
		to_chat(user, "<span class='danger'>It is heavily damaged!</span>")
	else if(damage)
		to_chat(user, "It is damaged.")

/obj/item/modular_computer/processor/New(var/comp)
	if(!comp || !istype(comp, /obj/machinery/modular_computer))
		CRASH("Inapropriate type passed to obj/item/modular_computer/processor/New()! Aborting.")
		return
	// Obtain reference to machinery computer
	machinery_computer = comp
	machinery_computer.cpu = src
	hardware_flag = machinery_computer.hardware_flag
	max_hardware_size = machinery_computer.max_hardware_size
	steel_sheet_cost = machinery_computer.steel_sheet_cost
	max_damage = machinery_computer._max_damage
	broken_damage = machinery_computer._break_damage

/obj/item/modular_computer/processor/relay_qdel()
	qdel(machinery_computer)

/obj/item/modular_computer/processor/update_icon()
	if(machinery_computer)
		return machinery_computer.update_icon()

// This thing is not meant to be used on it's own, get topic data from our machinery owner.
/obj/item/modular_computer/processor/CanUseTopic(user, state)
	if(!machinery_computer)
		return 0
	return machinery_computer.CanUseTopic(user, state)

/obj/item/modular_computer/processor/shutdown_computer()
	if(!machinery_computer)
		return
	..()
	machinery_computer.update_icon()
	machinery_computer.use_power = 0
	return

// Perform adjacency checks on our machinery counterpart, rather than on ourselves.
/obj/item/modular_computer/processor/Adjacent(var/atom/neighbor)
	if(!machinery_computer)
		return 0
	return machinery_computer.Adjacent(neighbor)