#include "../../../../packs/factions/scgec/_pack.dm"

/singleton/map_template/ruin/exoplanet/crashed_probe
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
		<b>LOG</b>: Engine spool-up confirmed. Beginning flight data recording.<br/>
		<b>LOG</b>: Flight plan INVALIDVAR detected; automated flight in effect. Destination: INVALIDVAR; current ETA is: 2 months, 5 days, 17 hours and 21 minutes.<br/>
		<b>LOG</b>: Repeating logs saved to disk INVALIDVAR for memory optimization.<br/>
		<b>ADM</b>: Automated flight cancelled by operator override.<br/>
		<b>WARN</b>: No operators registered. Resetting SysAdmin subroutines...<br/>
		<b>ERR</b>: Modified subroutines detected. Resetting Security subrountines to base values...<br/>
		<b>ADM</b>: System state frozen via remote administrator privileges.<br/>
		<b>ADM</b>: System pre-established parameters updated.<br/>
		<b>WARN</b>: Insecure remote connection to vessel subroutines detected.<br/>
		<b>ADM</b>: Warning blocked by pre-established parameters..<br/>
		<b>WARN</b>: Damage to primary sensor array detected.<br/>
		<b>WARN</b>: Piloting subroutine unable to carry out automated orbit correction.<br/>
		<b>WARN</b>: Impact registered.<br/>
		<b>LOG</b>: Distress beacon enabled.<br/>
		<b>ERR</b>: Power to distress beacon lost!<br/>
		<b>WARN</b>: Vessel power status critical. Entering power-saving mode.<br/>
		<b>ERR</b>: Unable to interface with pilot controls.<br/>
		<b>WARN</b>: Security subroutine failure.<br/>
		<b>WARN</b>: Power outage imminent... Preparing blackbox backup...<br/>
		<b>LOG</b>: Now you can safely turn off your computer.<br/>
		"}
