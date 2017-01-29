// Global var to track modular computers
var/list/global_modular_computers = list()

// Modular Computer - device that runs various programs and operates with hardware
// DO NOT SPAWN THIS TYPE. Use /laptop/ or /console/ instead.
/obj/machinery/modular_computer/
	name = "modular computer"
	desc = "An advanced computer."

	use_power = 0
	var/hardware_flag = 0											// A flag that describes this device type
	var/last_power_usage = 0										// Power usage during last tick

	// Modular computers can run on various devices. Each DEVICE (Laptop, Console, Tablet,..)
	// must have it's own DMI file. Icon states must be called exactly the same in all files, but may look differently
	// If you create a program which is limited to Laptops and Consoles you don't have to add it's icon_state overlay for Tablets too, for example.

	icon = null
	icon_state = null
	var/icon_state_unpowered = null									// Icon state when the computer is turned off
	var/screen_icon_state_menu = "menu"								// Icon state overlay when the computer is turned on, but no program is loaded that would override the screen.
	var/screen_icon_screensaver = "standby"							// Icon state overlay when the computer is powered, but not 'switched on'.
	var/max_hardware_size = 0										// Maximal hardware size. Currently, tablets have 1, laptops 2 and consoles 3. Limits what hardware types can be installed.
	var/steel_sheet_cost = 10										// Amount of steel sheets refunded when disassembling an empty frame of this computer.
	var/light_strength = 0											// Light luminosity when turned on
	var/base_active_power_usage = 100								// Power usage when the computer is open (screen is active) and can be interacted with. Remember hardware can use power too.
	var/base_idle_power_usage = 10									// Power usage when the computer is idle and screen is off (currently only applies to laptops)

	var/_max_damage = 100
	var/_break_damage = 50
	var/obj/item/modular_computer/processor/cpu = null				// CPU that handles most logic while this type only handles power and other specific things.

/obj/machinery/modular_computer/attack_ghost(var/mob/observer/ghost/user)
	if(cpu)
		cpu.attack_ghost(user)

/obj/machinery/modular_computer/emag_act(var/remaining_charges, var/mob/user)
	return cpu ? cpu.emag_act(remaining_charges, user) : NO_EMAG_ACT

/obj/machinery/modular_computer/update_icon()
	icon_state = icon_state_unpowered
	overlays.Cut()

	if(!cpu || !cpu.enabled)
		if (!(stat & NOPOWER))
			overlays.Add(screen_icon_screensaver)
		set_light(0)
		return
	set_light(light_strength)
	if(cpu.active_program)
		overlays.Add(cpu.active_program.program_icon_state ? cpu.active_program.program_icon_state : screen_icon_state_menu)
	else
		overlays.Add(screen_icon_state_menu)

// Eject ID card from computer, if it has ID slot with card inside.
/obj/machinery/modular_computer/verb/eject_id()
	set name = "Eject ID"
	set category = "Object"
	set src in view(1)

	if(cpu)
		cpu.eject_id()

// Eject ID card from computer, if it has ID slot with card inside.
/obj/machinery/modular_computer/verb/eject_usb()
	set name = "Eject Portable Storage"
	set category = "Object"
	set src in view(1)

	if(cpu)
		cpu.eject_usb()

// Eject AI Card
/obj/machinery/modular_computer/verb/eject_ai()
	set name = "Eject AI Storage"
	set category = "Object"
	set src in view(1)

	if(cpu)
		cpu.eject_ai()

/obj/machinery/modular_computer/New()
	..()
	cpu = new(src)
	global_modular_computers.Add(src)

/obj/machinery/modular_computer/Destroy()
	if(cpu)
		qdel(cpu)
		cpu = null
	return ..()

// On-click handling. Turns on the computer if it's off and opens the GUI.
/obj/machinery/modular_computer/attack_hand(mob/user)
	if(cpu)
		cpu.attack_self(user) // CPU is an item, that's why we route attack_hand to attack_self

/obj/machinery/modular_computer/examine(var/mob/user)
	. = ..()
	if(cpu)
		cpu.examine(user)

// Process currently calls handle_power(), may be expanded in future if more things are added.
/obj/machinery/modular_computer/process()
	if(cpu)
		// Keep names in sync.
		cpu.name = src.name
		cpu.process(1)

/obj/machinery/modular_computer/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(cpu)
		return cpu.attackby(W, user)
	return ..()


// Stronger explosions cause serious damage to internal components
// Minor explosions are mostly mitigitated by casing.
/obj/machinery/modular_computer/ex_act(var/severity)
	if(cpu)
		cpu.ex_act(severity)

// EMPs are similar to explosions, but don't cause physical damage to the casing. Instead they screw up the components
/obj/machinery/modular_computer/emp_act(var/severity)
	if(cpu)
		cpu.emp_act(severity)

// "Stun" weapons can cause minor damage to components (short-circuits?)
// "Burn" damage is equally strong against internal components and exterior casing
// "Brute" damage mostly damages the casing.
/obj/machinery/modular_computer/bullet_act(var/obj/item/projectile/Proj)
	if(cpu)
		cpu.bullet_act(Proj)

/obj/machinery/modular_computer/check_eye(var/mob/user)
	if(cpu)
		return cpu.check_eye(user)
	return -1

/obj/machinery/modular_computer/apply_visual(mob/M)
	if(cpu)
		cpu.apply_visual(M)

/obj/machinery/modular_computer/remove_visual(mob/M)
	if(cpu)
		cpu.remove_visual(M)