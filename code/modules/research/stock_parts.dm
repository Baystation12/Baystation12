///////////////////////////////////////Stock Parts /////////////////////////////////

/obj/item/weapon/storage/part_replacer
	name = "rapid part exchange device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	icon_state = "RPED"
	item_state = "RPED"
	w_class = ITEM_SIZE_HUGE
	can_hold = list(/obj/item/weapon/stock_parts)
	storage_slots = 50
	use_to_pickup = 1
	allow_quick_gather = 1
	allow_quick_empty = 1
	collection_mode = 1
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 100

/obj/item/weapon/stock_parts
	name = "stock part"
	desc = "What?"
	gender = PLURAL
	icon = 'icons/obj/stock_parts.dmi'
	randpixel = 5
	w_class = ITEM_SIZE_SMALL
	var/rating = 1
	var/lazy_initialize = TRUE // Will defer init on stock parts until machine is destroyed or parts are otherwise queried.
	var/status = 0             // Flags using PART_STAT defines.
	var/base_type              // Type representing parent of category for replacer usage.
	var/can_be_uninstalled = TRUE // If false, will qdel on uninstall and should not be exposed to the user for uninstallation.

/obj/item/weapon/stock_parts/attack_hand(mob/user)
	if(istype(loc, /obj/machinery))
		return FALSE // Can potentially add uninstall code here, but not currently supported.
	return ..()

/obj/item/weapon/stock_parts/proc/set_status(var/obj/machinery/machine, var/flag)
	var/old_stat = status
	status |= flag
	if(old_stat != status)
		if(!machine)
			machine = loc
		if(istype(machine))
			machine.component_stat_change(src, old_stat, flag)

/obj/item/weapon/stock_parts/proc/unset_status(var/obj/machinery/machine, var/flag)
	var/old_stat = status
	status &= ~flag
	if(old_stat != status)
		if(!machine)
			machine = loc
		if(istype(machine))
			machine.component_stat_change(src, old_stat, flag)

/obj/item/weapon/stock_parts/proc/on_install(var/obj/machinery/machine)
	set_status(machine, PART_STAT_INSTALLED)

/obj/item/weapon/stock_parts/proc/on_uninstall(var/obj/machinery/machine)
	unset_status(machine, PART_STAT_INSTALLED)
	stop_processing(machine)
	if(!can_be_uninstalled)
		qdel(src)

// Use to process on the machine it's installed on.

/obj/item/weapon/stock_parts/proc/start_processing(var/obj/machinery/machine)
	LAZYDISTINCTADD(machine.processing_parts, src)
	set_status(machine, PART_STAT_PROCESSING)

/obj/item/weapon/stock_parts/proc/stop_processing(var/obj/machinery/machine)
	LAZYREMOVE(machine.processing_parts, src)
	unset_status(machine, PART_STAT_PROCESSING)

/obj/item/weapon/stock_parts/proc/machine_process(var/obj/machinery/machine)
	return PROCESS_KILL

// RefreshParts has been called, likely meaning other componenets were added/removed.
/obj/item/weapon/stock_parts/proc/on_refresh(var/obj/machinery/machine)

//Rank 1

/obj/item/weapon/stock_parts/console_screen
	name = "console screen"
	desc = "Used in the construction of computers and other devices with a interactive console."
	icon_state = "screen"
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MATERIAL_GLASS = 200)
	base_type = /obj/item/weapon/stock_parts/console_screen

/obj/item/weapon/stock_parts/scanning_module
	name = "scanning module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "scan_module"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(MATERIAL_STEEL = 50,MATERIAL_GLASS = 20)
	base_type = /obj/item/weapon/stock_parts/scanning_module

/obj/item/weapon/stock_parts/manipulator
	name = "micro-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "micro_mani"
	origin_tech = list(TECH_MATERIAL = 1, TECH_DATA = 1)
	matter = list(MATERIAL_STEEL = 30)
	base_type = /obj/item/weapon/stock_parts/manipulator

/obj/item/weapon/stock_parts/micro_laser
	name = "micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "micro_laser"
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(MATERIAL_STEEL = 10,MATERIAL_GLASS = 20)
	base_type = /obj/item/weapon/stock_parts/micro_laser

/obj/item/weapon/stock_parts/matter_bin
	name = "matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "matter_bin"
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(MATERIAL_STEEL = 80)
	base_type = /obj/item/weapon/stock_parts/matter_bin

//Rank 2

/obj/item/weapon/stock_parts/scanning_module/adv
	name = "advanced scanning module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "scan_module"
	origin_tech = list(TECH_MAGNET = 3)
	rating = 2
	matter = list(MATERIAL_STEEL = 50,MATERIAL_GLASS = 20)

/obj/item/weapon/stock_parts/manipulator/nano
	name = "nano-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "nano_mani"
	origin_tech = list(TECH_MATERIAL = 3, TECH_DATA = 2)
	rating = 2
	matter = list(MATERIAL_STEEL = 30)

/obj/item/weapon/stock_parts/micro_laser/high
	name = "high-power micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "high_micro_laser"
	origin_tech = list(TECH_MAGNET = 3)
	rating = 2
	matter = list(MATERIAL_STEEL = 10,MATERIAL_GLASS = 20)

/obj/item/weapon/stock_parts/matter_bin/adv
	name = "advanced matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "advanced_matter_bin"
	origin_tech = list(TECH_MATERIAL = 3)
	rating = 2
	matter = list(MATERIAL_STEEL = 80)

//Rating 3

/obj/item/weapon/stock_parts/scanning_module/phasic
	name = "phasic scanning module"
	desc = "A compact, high resolution phasic scanning module used in the construction of certain devices."
	origin_tech = list(TECH_MAGNET = 5)
	rating = 3
	matter = list(MATERIAL_STEEL = 50,MATERIAL_GLASS = 20)

/obj/item/weapon/stock_parts/manipulator/pico
	name = "pico-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "pico_mani"
	origin_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	rating = 3
	matter = list(MATERIAL_STEEL = 30)

/obj/item/weapon/stock_parts/micro_laser/ultra
	name = "ultra-high-power micro-laser"
	icon_state = "ultra_high_micro_laser"
	desc = "A tiny laser used in certain devices."
	origin_tech = list(TECH_MAGNET = 5)
	rating = 3
	matter = list(MATERIAL_STEEL = 10,MATERIAL_GLASS = 20)

/obj/item/weapon/stock_parts/matter_bin/super
	name = "super matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "super_matter_bin"
	origin_tech = list(TECH_MATERIAL = 5)
	rating = 3
	matter = list(MATERIAL_STEEL = 80)

// Subspace stock parts

/obj/item/weapon/stock_parts/subspace/ansible
	name = "subspace ansible"
	icon_state = "subspace_ansible"
	desc = "A compact module capable of sensing extradimensional activity."
	origin_tech = list(TECH_DATA = 3, TECH_MAGNET = 5 ,TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_STEEL = 30,MATERIAL_GLASS = 10)

/obj/item/weapon/stock_parts/subspace/filter
	name = "hyperwave filter"
	icon_state = "hyperwave_filter"
	desc = "A tiny device capable of filtering and converting super-intense radiowaves."
	origin_tech = list(TECH_DATA = 4, TECH_MAGNET = 2)
	matter = list(MATERIAL_STEEL = 30,MATERIAL_GLASS = 10)

/obj/item/weapon/stock_parts/subspace/amplifier
	name = "subspace amplifier"
	icon_state = "subspace_amplifier"
	desc = "A compact micro-machine capable of amplifying weak subspace transmissions."
	origin_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_STEEL = 30,MATERIAL_GLASS = 10)

/obj/item/weapon/stock_parts/subspace/treatment
	name = "subspace treatment disk"
	icon_state = "treatment_disk"
	desc = "A compact micro-machine capable of stretching out hyper-compressed radio waves."
	origin_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_MATERIAL = 5, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_STEEL = 30,MATERIAL_GLASS = 10)

/obj/item/weapon/stock_parts/subspace/analyzer
	name = "subspace wavelength analyzer"
	icon_state = "wavelength_analyzer"
	desc = "A sophisticated analyzer capable of analyzing cryptic subspace wavelengths."
	origin_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_STEEL = 30,MATERIAL_GLASS = 10)

/obj/item/weapon/stock_parts/subspace/crystal
	name = "ansible crystal"
	icon_state = "ansible_crystal"
	desc = "A crystal made from pure glass used to transmit laser databursts to subspace."
	origin_tech = list(TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_GLASS = 50)

/obj/item/weapon/stock_parts/subspace/transmitter
	name = "subspace transmitter"
	icon_state = "subspace_transmitter"
	desc = "A large piece of equipment used to open a window into the subspace dimension."
	origin_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5, TECH_BLUESPACE = 3)
	matter = list(MATERIAL_STEEL = 50)
/obj/item/weapon/stock_parts/capacitor
	name = "capacitor"
	desc = "A basic capacitor used in the construction of a variety of devices."
	icon_state = "capacitor"
	origin_tech = list(TECH_POWER = 1)
	matter = list(MATERIAL_STEEL = 50,MATERIAL_GLASS = 50)
	var/charge = 0
	var/max_charge = 1000
	base_type = /obj/item/weapon/stock_parts/capacitor

/obj/item/weapon/stock_parts/capacitor/Initialize()
	. = ..()
	max_charge *= rating

/obj/item/weapon/stock_parts/capacitor/proc/charge(var/amount)
	charge += amount
	if(charge > max_charge)
		charge = max_charge

/obj/item/weapon/stock_parts/capacitor/proc/use(var/amount)
	if(charge)
		charge -= amount
		if(charge < 0)
			charge = 0

/obj/item/weapon/stock_parts/capacitor/adv
	name = "advanced capacitor"
	desc = "An advanced capacitor used in the construction of a variety of devices."
	origin_tech = list(TECH_POWER = 3)
	rating = 2

/obj/item/weapon/stock_parts/capacitor/super
	name = "super capacitor"
	desc = "A super-high capacity capacitor used in the construction of a variety of devices."
	origin_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	rating = 3

/obj/item/weapon/research
	name = "research debugging device"
	desc = "Instant research tool. For testing purposes only."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "smes_coil"
	origin_tech = list(TECH_MATERIAL = 19, TECH_ENGINEERING = 19, TECH_PHORON = 19, TECH_POWER = 19, TECH_BLUESPACE = 19, TECH_BIO = 19, TECH_COMBAT = 19, TECH_MAGNET = 19, TECH_DATA = 19, TECH_ILLEGAL = 19, TECH_ARCANE = 19)

// Shim for non-stock_parts machine components
/obj/item/weapon/stock_parts/building_material
	name = "building materials"
	desc = "Various standard wires, pipes, and other materials."
	icon = 'icons/obj/power.dmi'
	icon_state = "coil"
	lazy_initialize = FALSE
	var/list/materials

/obj/item/weapon/stock_parts/building_material/Destroy()
	QDEL_NULL_LIST(materials)
	. = ..()

/obj/item/weapon/stock_parts/building_material/proc/add_material(var/obj/item/new_material)
	if(istype(new_material, /obj/item/stack))
		var/obj/item/stack/stack = new_material
		for(var/obj/item/stack/old_stack in materials)
			if(old_stack.stacktype == stack.stacktype)
				stack.transfer_to(old_stack, stack.amount)
				if(QDELETED(stack))
					return
	LAZYADD(materials, new_material)
	new_material.forceMove(null)

// amount will cap the amount given in a stack, but may return less than amount specified.
/obj/item/weapon/stock_parts/building_material/proc/remove_material(material_type, amount)
	if(ispath(material_type, /obj/item/stack))
		for(var/obj/item/stack/stack in materials)
			if(stack.stacktype == material_type)
				var/stack_amount = stack.get_amount()
				if(stack_amount <= amount)
					materials -= stack
					stack.dropInto(loc)
					amount -= stack_amount
					return stack
				var/obj/item/stack/new_stack = stack.split(amount)
				new_stack.dropInto(loc)
				return new_stack
	for(var/obj/item/item in materials)
		if(istype(item, material_type))
			materials -= item
			item.dropInto(loc)
			return item

/obj/item/weapon/stock_parts/building_material/on_uninstall(var/obj/machinery/machine)
	..()
	for(var/obj/item/I in materials)
		I.dropInto(loc)
	materials = null
	qdel(src)