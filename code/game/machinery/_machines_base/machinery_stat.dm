/// Bitflag. Machine's base status. Can include `MACHINE_STAT_BROKEN`, `MACHINE_STAT_NOPOWER`, etc.
/obj/machinery/var/stat = EMPTY_BITFIELD

/// Bitflag. Reason the machine is 'broken'. Can be any combination of `MACHINE_BROKEN_*`. Do not modify directly - Use `set_broken()` instead.
/obj/machinery/var/reason_broken = EMPTY_BITFIELD

/// Bitflag. The machine will never set stat to these flags.
/obj/machinery/var/stat_immune = MACHINE_STAT_NOSCREEN | MACHINE_STAT_NOINPUT


/// Toggles the `MACHINE_STAT_BROKEN` flag on the machine's `stat` variable. Includes immunity and other checks. `cause` can be any of `MACHINE_BROKEN_*`.
/obj/machinery/proc/set_broken(new_state, cause = MACHINE_BROKEN_GENERIC)
	if(stat_immune & MACHINE_STAT_BROKEN)
		return FALSE
	if(!new_state == !(reason_broken & cause))
		return FALSE
	reason_broken ^= cause

	if(!reason_broken != !(stat & MACHINE_STAT_BROKEN))
		stat ^= MACHINE_STAT_BROKEN
		queue_icon_update()
		return TRUE


/// Toggles the `MACHINE_STAT_NOSCREEN` flag on the machine's `stat` variable. Includes immunity checks.
/obj/machinery/proc/set_noscreen(new_state)
	if(stat_immune & MACHINE_STAT_NOSCREEN)
		return FALSE
	if(!new_state != !(stat & MACHINE_STAT_NOSCREEN))// new state is different from old
		stat ^= MACHINE_STAT_NOSCREEN                // so flip it
		return TRUE


/// Toggles the `MACHINE_STAT_NOINPUT` flag on the machine's `stat` variable. Includes immunity checks.
/obj/machinery/proc/set_noinput(new_state)
	if(stat_immune & MACHINE_STAT_NOINPUT)
		return FALSE
	if(!new_state != !(stat & MACHINE_STAT_NOINPUT))
		stat ^= MACHINE_STAT_NOINPUT
		return TRUE


/// Checks whether or not the machine's stat variable has the `MACHINE_STAT_BROKEN` flag, or any of the provided `additional_flags`. Returns `TRUE` if any of the flags match.
/obj/machinery/proc/is_broken(additional_flags = EMPTY_BITFIELD)
	return (stat & (MACHINE_STAT_BROKEN|additional_flags))


/// Checks whether or not the machine's stat variable has the `MACHINE_STAT_NOPOWER` flag, or any of the provided `additional_flags`. Returns `FALSE` if any of the flags match.
/obj/machinery/proc/is_powered(additional_flags = EMPTY_BITFIELD)
	return !(stat & (MACHINE_STAT_NOPOWER|additional_flags))


/// Inverse of `inoperable()`.
/obj/machinery/proc/operable(additional_flags = EMPTY_BITFIELD)
	return !inoperable(additional_flags)


/// Checks whether or not the machine's state variable has the `MACHINE_STAT_BROKEN` or `MACHINE_STAT_NOPOWER` flags, or any of the provided `additional_flags`. Returns `TRUE` if any of the flags match.
/obj/machinery/proc/inoperable(additional_flags = EMPTY_BITFIELD)
	return (stat & (MACHINE_STAT_NOPOWER|MACHINE_STAT_BROKEN|additional_flags))
