/obj/item/stock_parts/computer/
	name = "Hardware"
	desc = "Unknown Hardware."
	icon = 'icons/obj/modular_components.dmi'
	part_flags = PART_FLAG_HAND_REMOVE

	health_max = 100

	/// If the hardware uses extra power, change this.
	var/power_usage = 0
	/// If the hardware is turned off set this to FALSE.
	var/enabled = TRUE
	/// Prevent disabling for important component, like the HDD.
	var/critical = 1
	/// Limits which devices can contain this component. 1: All, 2: Laptops/Consoles, 3: Consoles only
	var/hardware_size = 1
	/// "Malfunction" damage threshold as a percentage of `health_max`. When damage exceeds this value the hardware piece will semi-randomly fail and do !!FUN!! things
	var/damage_malfunction = 20
	/// "Failure" threshold as a percentage of `health_max`. When damage exceeds this value the hardware piece will not work at all.
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
		if(!health_damaged())
			to_chat(user, SPAN_WARNING("\The [src] doesn't seem to require repairs."))
			return TRUE
		if(S.use(1))
			to_chat(user, SPAN_NOTICE("You apply a bit of \the [W] to \the [src]. It immediately repairs all damage."))
			revive_health()
		return TRUE
	// Cable coil. Works as repair method, but will probably require multiple applications and more cable.
	if(isCoil(S))
		if(!health_damaged())
			to_chat(user, SPAN_WARNING("\The [src] doesn't seem to require repairs."))
			return TRUE
		if(S.use(1))
			to_chat(user, SPAN_NOTICE("You patch up \the [src] with a bit of \the [W]."))
			restore_health(10)
		return TRUE
	return ..()


/// Returns a list of lines containing diagnostic information for display.
/obj/item/stock_parts/computer/proc/diagnostics()
	return list("Hardware Integrity Test... (Corruption: [get_damage_percentage()]%) [damage_failing() ? "FAIL" : damage_malfunctioning() ? "WARN" : "PASS"]")

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
	if (damage_failing())
		return FALSE
	// Still working. Well, sometimes...
	if (damage_malfunctioning())
		if(prob(malfunction_probability))
			return FALSE
	// Good to go.
	return TRUE

/// Called when component is disabled/enabled by the OS
/obj/item/stock_parts/computer/proc/on_disable()
/obj/item/stock_parts/computer/proc/on_enable(var/datum/extension/interactive/ntos/os)

/obj/item/stock_parts/computer/proc/update_power_usage()
	var/datum/extension/interactive/ntos/os = get_extension(loc, /datum/extension/interactive/ntos)
	if(os)
		os.recalc_power_usage()

/// Whether or not the component has received enough damage to be malfunctioning.
/obj/item/stock_parts/computer/proc/damage_malfunctioning()
	if (get_damage_percentage() >= damage_malfunction)
		return TRUE
	return FALSE

/// Whether or not the component has received enough damage to be failing.
/obj/item/stock_parts/computer/proc/damage_failing()
	if (get_damage_percentage() >= damage_failure)
		return TRUE
	return FALSE

/// Immediately sets the part's damage to the malfunction threshhold. If damage is already past this point, it will not be changed.
/obj/item/stock_parts/computer/proc/set_damage_malfunctioning()
	if (damage_malfunctioning())
		return
	var/max_health = get_max_health()
	set_health(max_health - ((damage_malfunction / 100) * max_health))

/// Immediately sets the part's damage to the failure threshhold. If damage is already past this point, it will not be changed.
/obj/item/stock_parts/computer/proc/set_damage_failing()
	if (damage_failing())
		return
	var/max_health = get_max_health()
	set_health(max_health - ((damage_failure / 100) * max_health))
