/datum/map_template/ruin/exoplanet/crashed_probe
	name = "Expeditionary Probe"
	id = "crashed_probe"
	description = "An abandoned ancient STL automated survey drone."
	suffixes = list("crashed_probe/crashed_probe.dmm")
	spawn_cost = 0.5
	apc_test_exempt_areas = list(
		/area/map_template/ecprobe/solarsp = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/map_template/ecprobe/solarss = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/map_template/ecprobe/bridge = NO_SCRUBBER|NO_VENT,
		/area/map_template/ecprobe/engineering = NO_SCRUBBER|NO_VENT
	)
	ruin_tags = RUIN_HUMAN|RUIN_WRECK
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS

/area/map_template/ecprobe/bridge
	name = "\improper Crew Area"
	icon_state = "bridge"

/area/map_template/ecprobe/engineering
	name = "\improper Engineering"
	icon_state = "engineering_supply"

/area/map_template/ecprobe/solarsp
	name = "\improper Port Solars"
	icon_state = "panelsP"
	area_flags = AREA_FLAG_EXTERNAL

/area/map_template/ecprobe/solarss
	name = "\improper Starboard Solars"
	icon_state = "panelsA"
	area_flags = AREA_FLAG_EXTERNAL

/obj/item/paper/ecprobelog
        name = "blackbox log"
        info = {"
        <b>LOG</b>: Engine spool-up confirmed. Beginning flight data recording.
        <b>LOG</b>: Flight plan INVALIDVAR detected; automated flight in effect. Destination: INVALIDVAR; current ETA is: 2 months, 5 days, 17 hours and 21 minutes.
        <b>LOG</b>: Repeating logs saved to disk INVALIDVAR for memory optimization.
        <b>ADM</b>: Automated flight cancelled by operator override.
        <b>WARN</b>: No operators registered. Resetting SysAdmin subroutines...
        <b>ERR</b>: Modified subroutines detected. Resetting Security subrountines to base values...
        <b>ADM</b>: System state frozen via remote administrator privileges.
        <b>ADM</b>: System pre-established parameters updated.
        <b>WARN</b>: Insecure remote connection to vessel subroutines detected.
        <b>ADM</b>: Warning blocked by pre-established parameters..
        <b>WARN</b>: Damage to primary sensor array detected.
        <b>WARN</b>: Piloting subroutine unable to carry out automated orbit correction.
        <b>WARN</b>: Impact registered.
        <b>LOG</b>: Distress beacon enabled.
        <b>ERR</b>: Power to distress beacon lost!
        <b>WARN</b>: Vessel power status critical. Entering power-saving mode.
        <b>ERR</b>: Unable to interface with pilot controls.
        <b>WARN</b>: Security subroutine failure.
        <b>WARN</b>: Power outage imminent... Preparing blackbox backup...
        <b>LOG</b>: Now you can safely turn off your computer.
        "}