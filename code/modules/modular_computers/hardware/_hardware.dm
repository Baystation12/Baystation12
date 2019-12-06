/obj/item/weapon/stock_parts/computer/
	name = "Hardware"
	desc = "Unknown Hardware."
	icon = 'icons/obj/modular_components.dmi'
	part_flags = PART_FLAG_HAND_REMOVE
	var/power_usage = 0 			// If the hardware uses extra power, change this.
	var/enabled = 1					// If the hardware is turned off set this to 0.
	var/critical = 1				// Prevent disabling for important component, like the HDD.
	var/hardware_size = 1			// Limits which devices can contain this component. 1: Tablets/Laptops/Consoles, 2: Laptops/Consoles, 3: Consoles only
	var/damage = 0					// Current damage level
	var/max_damage = 100			// Maximal damage level.
	var/damage_malfunction = 20		// "Malfunction" threshold. When damage exceeds this value the hardware piece will semi-randomly fail and do !!FUN!! things
	var/damage_failure = 50			// "Failure" threshold. When damage exceeds this value the hardware piece will not work at all.
	var/malfunction_probability = 10// Chance of malfunction when the component is damaged
	var/usage_flags = PROGRAM_ALL
	var/external_slot				// Whether attackby will be passed on it even with a closed panel

/obj/item/weapon/stock_parts/computer/attackby(var/obj/item/W as obj, var/mob/living/user as mob)
	// Multitool. Runs diagnostics
	if(isMultitool(W))
		to_chat(user, "***** DIAGNOSTICS REPORT *****")
		to_chat(user, jointext(diagnostics(), "\n"))
		to_chat(user, "******************************")
		return 1
	// Nanopaste. Repair all damage if present for a single unit.
	var/obj/item/stack/S = W
	if(istype(S, /obj/item/stack/nanopaste))
		if(!damage)
			to_chat(user, "\The [src] doesn't seem to require repairs.")
			return 1
		if(S.use(1))
			to_chat(user, "You apply a bit of \the [W] to \the [src]. It immediately repairs all damage.")
			damage = 0
		return 1
	// Cable coil. Works as repair method, but will probably require multiple applications and more cable.
	if(isCoil(S))
		if(!damage)
			to_chat(user, "\The [src] doesn't seem to require repairs.")
			return 1
		if(S.use(1))
			to_chat(user, "You patch up \the [src] with a bit of \the [W].")
			take_damage(-10)
		return 1
	return ..()


// Called on multitool click, prints diagnostic information to the user.
/obj/item/weapon/stock_parts/computer/proc/diagnostics()
	return list("Hardware Integrity Test... (Corruption: [damage]/[max_damage]) [damage > damage_failure ? "FAIL" : damage > damage_malfunction ? "WARN" : "PASS"]")

/obj/item/weapon/stock_parts/computer/Initialize()
	. = ..()
	w_class = hardware_size

/obj/item/weapon/stock_parts/computer/Destroy()
	if(istype(loc, /obj/item/modular_computer))
		var/obj/item/modular_computer/C = loc
		C.uninstall_component(null, src)
	return ..()

// Handles damage checks
/obj/item/weapon/stock_parts/computer/proc/check_functionality()
	// Turned off
	if(!enabled)
		return 0
	// Too damaged to work at all.
	if(damage >= damage_failure)
		return 0
	// Still working. Well, sometimes...
	if(damage >= damage_malfunction)
		if(prob(malfunction_probability))
			return 0
	// Good to go.
	return 1

/obj/item/weapon/stock_parts/computer/examine(mob/user)
	. = ..()
	if(damage > damage_failure)
		to_chat(user, "<span class='danger'>It seems to be severely damaged!</span>")
	else if(damage > damage_malfunction)
		to_chat(user, "<span class='notice'>It seems to be damaged!</span>")
	else if(damage)
		to_chat(user, "It seems to be slightly damaged.")

// Damages the component. Contains necessary checks. Negative damage "heals" the component.
/obj/item/weapon/stock_parts/computer/proc/take_damage(var/amount)
	damage += round(amount) 					// We want nice rounded numbers here.
	damage = between(0, damage, max_damage)		// Clamp the value.

// Called when component is disabled/enabled by the OS
/obj/item/weapon/stock_parts/computer/proc/on_disable()
/obj/item/weapon/stock_parts/computer/proc/on_enable(var/datum/extension/interactive/ntos/os)

/obj/item/weapon/stock_parts/computer/proc/update_power_usage()
	var/datum/extension/interactive/ntos/os = get_extension(loc, /datum/extension/interactive/ntos)
	if(os)
		os.recalc_power_usage()
