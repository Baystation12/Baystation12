/obj/item/stock_parts/computer/
	name = "Hardware"
	desc = "Unknown Hardware."
	icon = 'icons/obj/modular_components.dmi'
	part_flags = PART_FLAG_HAND_REMOVE

	/// If the hardware uses extra power, change this.
	var/power_usage = 0
	/// If the hardware is turned off set this to FALSE.
	var/enabled = TRUE
	/// Prevent disabling for important component, like the HDD.
	var/critical = 1
	/// Limits which devices can contain this component. 1: All, 2: Laptops/Consoles, 3: Consoles only
	var/hardware_size = 1
	/// Current damage level
	var/damage = 0
	/// Maximum damage level.
	var/max_damage = 100
	/// "Malfunction" threshold. When damage exceeds this value the hardware piece will semi-randomly fail and do !!FUN!! things
	var/damage_malfunction = 20
	/// "Failure" threshold. When damage exceeds this value the hardware piece will not work at all.
	var/damage_failure = 50
	/// Chance of malfunction when the component is damaged
	var/malfunction_probability = 10
	var/usage_flags = PROGRAM_ALL
	/// Whether attackby will be passed on it even with a closed panel
	var/external_slot

/obj/item/stock_parts/computer/attackby(obj/item/W as obj, mob/living/user as mob)
	// Multitool. Runs diagnostics
	if(isMultitool(W))
		to_chat(user, "***** DIAGNOSTICS REPORT *****")
		to_chat(user, jointext(diagnostics(), "\n"))
		to_chat(user, "******************************")
		return TRUE
	// Nanopaste. Repair all damage if present for a single unit.
	var/obj/item/stack/S = W
	if(istype(S, /obj/item/stack/nanopaste))
		if(!damage)
			to_chat(user, "\The [src] doesn't seem to require repairs.")
			return TRUE
		if(S.use(1))
			to_chat(user, "You apply a bit of \the [W] to \the [src]. It immediately repairs all damage.")
			damage = 0
		return TRUE
	// Cable coil. Works as repair method, but will probably require multiple applications and more cable.
	if(isCoil(S))
		if(!damage)
			to_chat(user, "\The [src] doesn't seem to require repairs.")
			return TRUE
		if(S.use(1))
			to_chat(user, "You patch up \the [src] with a bit of \the [W].")
			take_damage(-10)
		return TRUE
	return ..()


/// Returns a list of lines containing diagnostic information for display.
/obj/item/stock_parts/computer/proc/diagnostics()
	return list("Hardware Integrity Test... (Corruption: [damage]/[max_damage]) [damage > damage_failure ? "FAIL" : damage > damage_malfunction ? "WARN" : "PASS"]")

/obj/item/stock_parts/computer/Initialize()
	. = ..()
	w_class = hardware_size

/obj/item/stock_parts/computer/Destroy()
	if(istype(loc, /obj/item/modular_computer))
		var/obj/item/modular_computer/C = loc
		C.uninstall_component(null, src)
	return ..()

/// Handles damage checks
/obj/item/stock_parts/computer/proc/check_functionality()
	// Turned off
	if(!enabled)
		return FALSE
	// Too damaged to work at all.
	if(damage >= damage_failure)
		return FALSE
	// Still working. Well, sometimes...
	if(damage >= damage_malfunction)
		if(prob(malfunction_probability))
			return FALSE
	// Good to go.
	return TRUE

/obj/item/stock_parts/computer/examine(mob/user)
	. = ..()
	if(damage > damage_failure)
		to_chat(user, "<span class='danger'>It seems to be severely damaged!</span>")
	else if(damage > damage_malfunction)
		to_chat(user, "<span class='notice'>It seems to be damaged!</span>")
	else if(damage)
		to_chat(user, "It seems to be slightly damaged.")

/// Damages the component. Contains necessary checks. Negative damage "heals" the component.
/obj/item/stock_parts/computer/proc/take_damage(var/amount)
	damage += round(amount) 					// We want nice rounded numbers here.
	damage = clamp(damage, 0, max_damage)		// Clamp the value.

/// Called when component is disabled/enabled by the OS
/obj/item/stock_parts/computer/proc/on_disable()
/obj/item/stock_parts/computer/proc/on_enable(var/datum/extension/interactive/ntos/os)

/obj/item/stock_parts/computer/proc/update_power_usage()
	var/datum/extension/interactive/ntos/os = get_extension(loc, /datum/extension/interactive/ntos)
	if(os)
		os.recalc_power_usage()
