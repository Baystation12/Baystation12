#define BOLTS_FINE 0
#define BOLTS_EXPOSED 1
#define BOLTS_CUT 2

#define AIRLOCK_CLOSED	1
#define AIRLOCK_CLOSING	2
#define AIRLOCK_OPEN	3
#define AIRLOCK_OPENING	4
#define AIRLOCK_DENY	5
#define AIRLOCK_EMAG	6

#define AIRLOCK_PAINTABLE 1
#define AIRLOCK_STRIPABLE 2
#define AIRLOCK_DETAILABLE 4
#define AIRLOCK_WINDOW_PAINTABLE 8

var/list/airlock_overlays = list()

/obj/machinery/door/airlock
	name = "airlock"
	icon = 'icons/obj/doors/station/door.dmi'
	icon_state = "preview"
	power_channel = ENVIRON
	interact_offline = FALSE

	explosion_resistance = 10
	var/aiControlDisabled = 0 //If 1, AI control is disabled until the AI hacks back in and disables the lock. If 2, the AI has bypassed the lock. If -1, the control is enabled but the AI had bypassed it earlier, so if it is disabled again the AI would have no trouble getting back in.
	var/hackProof = 0 // if 1, this door can't be hacked by the AI
	var/electrified_until = 0			//World time when the door is no longer electrified. -1 if it is permanently electrified until someone fixes it.
	var/main_power_lost_until = 0	 	//World time when main power is restored.
	var/backup_power_lost_until = -1	//World time when backup power is restored.
	var/next_beep_at = 0				//World time when we may next beep due to doors being blocked by mobs
	var/spawnPowerRestoreRunning = 0
	var/welded = null
	var/locked = 0
	var/lock_cut_state = BOLTS_FINE
	var/lights = 1 // Lights show by default
	var/aiDisabledIdScanner = 0
	var/aiHacking = 0
	var/obj/machinery/door/airlock/closeOther = null
	var/closeOtherId = null
	var/lockdownbyai = 0
	autoclose = 1
	var/assembly_type = /obj/structure/door_assembly
	var/mineral = null
	var/justzap = FALSE
	var/safe = 1
	normalspeed = 1
	var/obj/item/airlock_electronics/electronics = null
	var/hasShocked = 0 //Prevents multiple shocks from happening
	var/secured_wires = 0

	var/open_sound_powered = 'sound/machines/airlock_open.ogg'
	var/open_sound_unpowered = 'sound/machines/airlock_open_force.ogg'
	var/open_failure_access_denied = 'sound/machines/buzz-two.ogg'

	var/close_sound_powered = 'sound/machines/airlock_close.ogg'
	var/close_sound_unpowered = 'sound/machines/airlock_close_force.ogg'
	var/close_failure_blocked = 'sound/machines/triple_beep.ogg'

	var/bolts_rising = 'sound/machines/bolts_up.ogg'
	var/bolts_dropping = 'sound/machines/bolts_down.ogg'

	var/door_crush_damage = DOOR_CRUSH_DAMAGE
	var/obj/item/airlock_brace/brace = null

	//Airlock 2.0 Aesthetics Properties
	//The variables below determine what color the airlock and decorative stripes will be -Cakey
	var/airlock_type = "Standard"
	var/global/list/airlock_icon_cache = list()
	var/paintable = AIRLOCK_PAINTABLE|AIRLOCK_STRIPABLE //0 = Not paintable, 1 = Paintable, 3 = Paintable and Stripable, 7 for Paintable, Stripable and Detailable.
	var/door_color = null
	var/stripe_color = null
	var/symbol_color = null
	var/window_color = null
	var/init_material_window = MATERIAL_GLASS
	var/material/window_material

	var/fill_file = 'icons/obj/doors/station/fill_steel.dmi'
	var/color_file = 'icons/obj/doors/station/color.dmi'
	var/color_fill_file = 'icons/obj/doors/station/fill_color.dmi'
	var/stripe_file = 'icons/obj/doors/station/stripe.dmi'
	var/stripe_fill_file = 'icons/obj/doors/station/fill_stripe.dmi'
	var/glass_file = 'icons/obj/doors/station/fill_glass.dmi'
	var/bolts_file = 'icons/obj/doors/station/lights_bolts.dmi'
	var/deny_file = 'icons/obj/doors/station/lights_deny.dmi'
	var/lights_file = 'icons/obj/doors/station/lights_green.dmi'
	var/panel_file = 'icons/obj/doors/station/panel.dmi'
	var/sparks_damaged_file = 'icons/obj/doors/station/sparks_damaged.dmi'
	var/sparks_broken_file = 'icons/obj/doors/station/sparks_broken.dmi'
	var/welded_file = 'icons/obj/doors/station/welded.dmi'
	var/emag_file = 'icons/obj/doors/station/emag.dmi'

	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver,
		/obj/item/stock_parts/power/apc
	)
	// To be fleshed out and moved to parent door, but staying minimal for now.
	public_methods = list(
		/decl/public_access/public_method/toggle_door,
		/decl/public_access/public_method/airlock_toggle_bolts
	)
	stock_part_presets = list(/decl/stock_part_preset/radio/receiver/airlock = 1)

/obj/machinery/door/airlock/get_material()
	return SSmaterials.get_material_by_name(mineral ? mineral : MATERIAL_STEEL)

//regular airlock presets

/obj/machinery/door/airlock/command
	door_color = COLOR_COMMAND_BLUE

/obj/machinery/door/airlock/security
	door_color = COLOR_NT_RED

/obj/machinery/door/airlock/security/research
	door_color = COLOR_WHITE
	stripe_color = COLOR_NT_RED

/obj/machinery/door/airlock/engineering
	name = "Maintenance Hatch"
	door_color = COLOR_AMBER

/obj/machinery/door/airlock/medical
	door_color = COLOR_WHITE
	stripe_color = COLOR_DEEP_SKY_BLUE

/obj/machinery/door/airlock/virology
	door_color = COLOR_WHITE
	stripe_color = COLOR_GREEN

/obj/machinery/door/airlock/mining
	name = "Mining Airlock"
	door_color = COLOR_PALE_ORANGE
	stripe_color = COLOR_BEASTY_BROWN

/obj/machinery/door/airlock/atmos
	door_color = COLOR_AMBER
	stripe_color = COLOR_CYAN

/obj/machinery/door/airlock/research
	door_color = COLOR_WHITE
	stripe_color = COLOR_BOTTLE_GREEN

/obj/machinery/door/airlock/science
	door_color = COLOR_WHITE
	stripe_color = COLOR_VIOLET

/obj/machinery/door/airlock/sol
	door_color = COLOR_BLUE_GRAY

/obj/machinery/door/airlock/civilian
	stripe_color = COLOR_CIVIE_GREEN

/obj/machinery/door/airlock/chaplain
	stripe_color = COLOR_GRAY20

/obj/machinery/door/airlock/freezer
	name = "Freezer Airlock"
	door_color = COLOR_WHITE

/obj/machinery/door/airlock/maintenance
	name = "Maintenance Access"
	stripe_color = COLOR_AMBER

//Glass airlock presets

/obj/machinery/door/airlock/glass
	name = "Glass Airlock"
	icon_state = "preview_glass"
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	glass = 1

/obj/machinery/door/airlock/glass/command
	door_color = COLOR_COMMAND_BLUE
	stripe_color = COLOR_SKY_BLUE

/obj/machinery/door/airlock/glass/security
	door_color = COLOR_NT_RED
	stripe_color = COLOR_ORANGE

/obj/machinery/door/airlock/glass/engineering
	door_color = COLOR_AMBER
	stripe_color = COLOR_RED

/obj/machinery/door/airlock/glass/medical
	door_color = COLOR_WHITE
	stripe_color = COLOR_DEEP_SKY_BLUE

/obj/machinery/door/airlock/glass/virology
	door_color = COLOR_WHITE
	stripe_color = COLOR_GREEN

/obj/machinery/door/airlock/glass/mining
	door_color = COLOR_PALE_ORANGE
	stripe_color = COLOR_BEASTY_BROWN

/obj/machinery/door/airlock/glass/atmos
	door_color = COLOR_AMBER
	stripe_color = COLOR_CYAN

/obj/machinery/door/airlock/glass/research
	door_color = COLOR_WHITE
	stripe_color = COLOR_RESEARCH

/obj/machinery/door/airlock/glass/science
	door_color = COLOR_WHITE
	stripe_color = COLOR_VIOLET

/obj/machinery/door/airlock/glass/sol
	door_color = COLOR_BLUE_GRAY
	stripe_color = COLOR_AMBER

/obj/machinery/door/airlock/glass/freezer
	door_color = COLOR_WHITE

/obj/machinery/door/airlock/glass/maintenance
	name = "Maintenance Access"
	stripe_color = COLOR_AMBER

/obj/machinery/door/airlock/glass/civilian
	stripe_color = COLOR_CIVIE_GREEN

/obj/machinery/door/airlock/external
	airlock_type = "External"
	name = "External Airlock"
	icon = 'icons/obj/doors/external/door.dmi'
	fill_file = 'icons/obj/doors/external/fill_steel.dmi'
	color_file = 'icons/obj/doors/external/color.dmi'
	color_fill_file = 'icons/obj/doors/external/fill_color.dmi'
	glass_file = 'icons/obj/doors/external/fill_glass.dmi'
	bolts_file = 'icons/obj/doors/external/lights_bolts.dmi'
	deny_file = 'icons/obj/doors/external/lights_deny.dmi'
	lights_file = 'icons/obj/doors/external/lights_green.dmi'
	emag_file = 'icons/obj/doors/external/emag.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_ext
	door_color = COLOR_NT_RED
	paintable = AIRLOCK_PAINTABLE

/obj/machinery/door/airlock/external/inherit_access_from_area()
	..()
	if(is_station_area(get_area(src)))
		add_access_requirement(req_access, access_external_airlocks)

/obj/machinery/door/airlock/external/escapepod
	name = "Escape Pod"
	frequency =  1380
	locked = 1

/obj/machinery/door/airlock/external/escapepod/attackby(obj/item/C, mob/user)
	if(p_open && !arePowerSystemsOn())
		if(isWrench(C))
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			user.visible_message(SPAN_WARNING("[user.name] starts frantically pumping the bolt override mechanism!"), SPAN_WARNING("You start frantically pumping the bolt override mechanism!"))
			if(do_after(user, 160))
				visible_message("\The [src] bolts [locked ? "disengage" : "engage"]!")
				locked = !locked
				return
	..()

/obj/machinery/door/airlock/external/bolted
	locked = 1

/obj/machinery/door/airlock/external/bolted/cycling
	frequency = 1379

/obj/machinery/door/airlock/external/bolted_open
	density = FALSE
	locked = 1
	opacity = 0

/obj/machinery/door/airlock/external/glass
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	glass = 1

/obj/machinery/door/airlock/external/glass/bolted
	locked = 1

/obj/machinery/door/airlock/external/glass/bolted/cycling
	frequency = 1379

/obj/machinery/door/airlock/external/glass/bolted_open
	density = FALSE
	locked = 1
	opacity = 0

/obj/machinery/door/airlock/gold
	name = "Gold Airlock"
	door_color = COLOR_SUN
	mineral = MATERIAL_GOLD

/obj/machinery/door/airlock/crystal
	name = "Crystal Airlock"
	door_color = COLOR_CRYSTAL
	mineral = MATERIAL_CRYSTAL

/obj/machinery/door/airlock/silver
	name = "Silver Airlock"
	door_color = COLOR_SILVER
	mineral = MATERIAL_SILVER

/obj/machinery/door/airlock/diamond
	name = "Diamond Airlock"
	door_color = COLOR_CYAN_BLUE
	mineral = MATERIAL_DIAMOND

/obj/machinery/door/airlock/uranium
	name = "Uranium Airlock"
	desc = "And they said I was crazy."
	door_color = COLOR_PAKISTAN_GREEN
	mineral = MATERIAL_URANIUM
	var/last_event = 0
	var/rad_power = 7.5

/obj/machinery/door/airlock/sandstone
	name = "\improper Sandstone Airlock"
	door_color = COLOR_BEIGE
	mineral = MATERIAL_SANDSTONE

/obj/machinery/door/airlock/phoron
	name = "\improper Phoron Airlock"
	desc = "No way this can end badly."
	door_color = COLOR_PURPLE
	mineral = MATERIAL_PHORON

/obj/machinery/door/airlock/centcom
	airlock_type = "centcomm"
	name = "\improper Airlock"
	icon = 'icons/obj/doors/centcomm/door.dmi'
	fill_file = 'icons/obj/doors/centcomm/fill_steel.dmi'
	paintable = AIRLOCK_PAINTABLE|AIRLOCK_STRIPABLE

/obj/machinery/door/airlock/highsecurity
	airlock_type = "secure"
	name = "Secure Airlock"
	icon = 'icons/obj/doors/secure/door.dmi'
	fill_file = 'icons/obj/doors/secure/fill_steel.dmi'
	explosion_resistance = 20
	secured_wires = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity
	paintable = 0

/obj/machinery/door/airlock/highsecurity/bolted
	locked = 1

/obj/machinery/door/airlock/hatch
	airlock_type = "hatch"
	name = "\improper Airtight Hatch"
	icon = 'icons/obj/doors/hatch/door.dmi'
	fill_file = 'icons/obj/doors/hatch/fill_steel.dmi'
	stripe_file = 'icons/obj/doors/hatch/stripe.dmi'
	stripe_fill_file = 'icons/obj/doors/hatch/fill_stripe.dmi'
	bolts_file = 'icons/obj/doors/hatch/lights_bolts.dmi'
	deny_file = 'icons/obj/doors/hatch/lights_deny.dmi'
	lights_file = 'icons/obj/doors/hatch/lights_green.dmi'
	panel_file = 'icons/obj/doors/hatch/panel.dmi'
	welded_file = 'icons/obj/doors/hatch/welded.dmi'
	emag_file = 'icons/obj/doors/hatch/emag.dmi'
	explosion_resistance = 20
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_hatch
	paintable = AIRLOCK_STRIPABLE

/obj/machinery/door/airlock/hatch/maintenance
	name = "Maintenance Hatch"
	stripe_color = COLOR_AMBER

/obj/machinery/door/airlock/hatch/maintenance/bolted
	locked = 1

/obj/machinery/door/airlock/vault
	airlock_type = "vault"
	name = "Vault"
	icon = 'icons/obj/doors/vault/door.dmi'
	fill_file = 'icons/obj/doors/vault/fill_steel.dmi'
	explosion_resistance = 20
	opacity = 1
	secured_wires = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity //Until somebody makes better sprites.
	paintable = AIRLOCK_PAINTABLE|AIRLOCK_STRIPABLE

/obj/machinery/door/airlock/vault/bolted
	locked = 1

/obj/machinery/door/airlock/Process()
	if(main_power_lost_until > 0 && world.time >= main_power_lost_until)
		regainMainPower()

	if(backup_power_lost_until > 0 && world.time >= backup_power_lost_until)
		regainBackupPower()

	else if(electrified_until > 0 && world.time >= electrified_until)
		electrify(0)

	..()

/obj/machinery/door/airlock/uranium/Process()
	if(world.time > last_event+20)
		if(prob(50))
			SSradiation.radiate(src, rad_power)
		last_event = world.time
	..()

/obj/machinery/door/airlock/phoron/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		PhoronBurn(exposed_temperature)

/obj/machinery/door/airlock/phoron/proc/ignite(exposed_temperature)
	if(exposed_temperature > 300)
		PhoronBurn(exposed_temperature)

/obj/machinery/door/airlock/phoron/proc/PhoronBurn(temperature)
	for(var/turf/simulated/floor/target_tile in range(2,loc))
		target_tile.assume_gas(GAS_PHORON, 35, 400+T0C)
		addtimer(CALLBACK(target_tile, /turf/proc/hotspot_expose, 400), 0)
	for(var/turf/simulated/wall/W in range(3,src))
		W.burn((temperature/4))//Added so that you can't set off a massive chain reaction with a small flame
	for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
		D.ignite(temperature/4)
	new/obj/structure/door_assembly( src.loc )
	qdel(src)

/*
About the new airlock wires panel:
*	An airlock wire dialog can be accessed by the normal way or by using wirecutters or a multitool on the door while the wire-panel is open. This would show the following wires, which you can either wirecut/mend or send a multitool pulse through. There are 9 wires.
*		one wire from the ID scanner. Sending a pulse through this flashes the red light on the door (if the door has power). If you cut this wire, the door will stop recognizing valid IDs. (If the door has 0000 access, it still opens and closes, though)
*		two wires for power. Sending a pulse through either one causes a breaker to trip, disabling the door for 10 seconds if backup power is connected, or 1 minute if not (or until backup power comes back on, whichever is shorter). Cutting either one disables the main door power, but unless backup power is also cut, the backup power re-powers the door in 10 seconds. While unpowered, the door may be open, but bolts-raising will not work. Cutting these wires may electrocute the user.
*		one wire for door bolts. Sending a pulse through this drops door bolts (whether the door is powered or not) or raises them (if it is). Cutting this wire also drops the door bolts, and mending it does not raise them. If the wire is cut, trying to raise the door bolts will not work.
*		two wires for backup power. Sending a pulse through either one causes a breaker to trip, but this does not disable it unless main power is down too (in which case it is disabled for 1 minute or however long it takes main power to come back, whichever is shorter). Cutting either one disables the backup door power (allowing it to be crowbarred open, but disabling bolts-raising), but may electocute the user.
*		one wire for opening the door. Sending a pulse through this while the door has power makes it open the door if no access is required.
*		one wire for AI control. Sending a pulse through this blocks AI control for a second or so (which is enough to see the AI control light on the panel dialog go off and back on again). Cutting this prevents the AI from controlling the door unless it has hacked the door through the power connection (which takes about a minute). If both main and backup power are cut, as well as this wire, then the AI cannot operate or hack the door at all.
*		one wire for electrifying the door. Sending a pulse through this electrifies the door for 30 seconds. Cutting this wire electrifies the door, so that the next person to touch the door without insulated gloves gets electrocuted. (Currently it is also STAYING electrified until someone mends the wire)
*		one wire for controling door safetys.  When active, door does not close on someone.  When cut, door will ruin someone's shit.  When pulsed, door will immedately ruin someone's shit.
*		one wire for controlling door speed.  When active, dor closes at normal rate.  When cut, door does not close manually.  When pulsed, door attempts to close every tick.
*/

/obj/machinery/door/airlock/bumpopen(mob/living/user as mob) //Airlocks now zap you when you 'bump' them open when they're electrified. --NeoFite
	if(!issilicon(usr))
		if(src.isElectrified())
			if(!src.justzap)
				if(src.shock(user, 100))
					src.justzap = TRUE
					addtimer(CALLBACK(src, .proc/set_justzap, FALSE), 1 SECOND)
					return
			else
				return
		else if(prob(10) && src.operating == 0)
			var/mob/living/carbon/C = user
			if(istype(C) && C.hallucination_power > 25)
				to_chat(user, "<span class='danger'>You feel a powerful shock course through your body!</span>")
				user.adjustHalLoss(20)
				user.Stun(5)
				return
	..(user)

/obj/machinery/door/airlock/proc/set_justzap(val)
	justzap = val

/obj/machinery/door/airlock/bumpopen(mob/living/simple_animal/user as mob)
	..(user)

/obj/machinery/door/airlock/proc/isElectrified()
	if(src.electrified_until != 0)
		return 1
	return 0

/obj/machinery/door/airlock/proc/isWireCut(var/wireIndex)
	// You can find the wires in the datum folder.
	return wires.IsIndexCut(wireIndex)

/obj/machinery/door/airlock/proc/canAIControl()
	return ((src.aiControlDisabled!=1) && (!src.isAllPowerLoss()));

/obj/machinery/door/airlock/proc/canAIHack()
	return ((src.aiControlDisabled==1) && (!hackProof) && (!src.isAllPowerLoss()));

/obj/machinery/door/airlock/proc/arePowerSystemsOn()
	if (stat & (NOPOWER|BROKEN))
		return 0
	return (src.main_power_lost_until==0 || src.backup_power_lost_until==0)

/obj/machinery/door/airlock/requiresID()
	return !(src.isWireCut(AIRLOCK_WIRE_IDSCAN) || aiDisabledIdScanner)

/obj/machinery/door/airlock/check_access()
	if (isWireCut(AIRLOCK_WIRE_IDSCAN) || aiDisabledIdScanner)
		return !secured_wires
	return ..()


/obj/machinery/door/airlock/proc/isAllPowerLoss()
	if(stat & (NOPOWER|BROKEN))
		return 1
	if(mainPowerCablesCut() && backupPowerCablesCut())
		return 1
	return 0

/obj/machinery/door/airlock/proc/mainPowerCablesCut()
	return src.isWireCut(AIRLOCK_WIRE_MAIN_POWER1) || src.isWireCut(AIRLOCK_WIRE_MAIN_POWER2)

/obj/machinery/door/airlock/proc/backupPowerCablesCut()
	return src.isWireCut(AIRLOCK_WIRE_BACKUP_POWER1) || src.isWireCut(AIRLOCK_WIRE_BACKUP_POWER2)

/obj/machinery/door/airlock/proc/loseMainPower()
	main_power_lost_until = mainPowerCablesCut() ? -1 : world.time + SecondsToTicks(60)

	// If backup power is permanently disabled then activate in 10 seconds if possible, otherwise it's already enabled or a timer is already running
	if(backup_power_lost_until == -1 && !backupPowerCablesCut())
		backup_power_lost_until = world.time + SecondsToTicks(10)

	// Disable electricity if required
	if(electrified_until && isAllPowerLoss())
		electrify(0)

	update_icon()

/obj/machinery/door/airlock/proc/loseBackupPower()
	backup_power_lost_until = backupPowerCablesCut() ? -1 : world.time + SecondsToTicks(60)

	// Disable electricity if required
	if(electrified_until && isAllPowerLoss())
		electrify(0)

	update_icon()

/obj/machinery/door/airlock/proc/regainMainPower()
	if(!mainPowerCablesCut())
		main_power_lost_until = 0
		// If backup power is currently active then disable, otherwise let it count down and disable itself later
		if(!backup_power_lost_until)
			backup_power_lost_until = -1

	update_icon()

/obj/machinery/door/airlock/proc/regainBackupPower()
	if(!backupPowerCablesCut())
		// Restore backup power only if main power is offline, otherwise permanently disable
		backup_power_lost_until = main_power_lost_until == 0 ? -1 : 0

	update_icon()

/obj/machinery/door/airlock/proc/electrify(var/duration, var/feedback = 0)
	var/message = ""
	if(src.isWireCut(AIRLOCK_WIRE_ELECTRIFY) && arePowerSystemsOn())
		message = text("The electrification wire is cut - Door permanently electrified.")
		src.electrified_until = -1
		. = 1
	else if(duration && !arePowerSystemsOn())
		message = text("The door is unpowered - Cannot electrify the door.")
		src.electrified_until = 0
	else if(!duration && electrified_until != 0)
		message = "The door is now un-electrified."
		src.electrified_until = 0
	else if(duration)	//electrify door for the given duration seconds
		if(usr)
			shockedby += text("\[[time_stamp()]\] - [key_name(usr)]")
			admin_attacker_log(usr, "electrified \the [name] [duration == -1 ? "permanently" : "for [duration] second\s"]")
		else
			shockedby += text("\[[time_stamp()]\] - EMP)")
		message = "The door is now electrified [duration == -1 ? "permanently" : "for [duration] second\s"]."
		src.electrified_until = duration == -1 ? -1 : world.time + SecondsToTicks(duration)
		. = 1

	if(feedback && message)
		to_chat(usr, message)
	if(.)
		playsound(src, 'sound/effects/sparks3.ogg', 30, 0, -6)

/obj/machinery/door/airlock/proc/set_idscan(var/activate, var/feedback = 0)
	var/message = ""
	if(src.isWireCut(AIRLOCK_WIRE_IDSCAN))
		message = "The IdScan wire is cut - IdScan feature permanently disabled."
	else if(activate && src.aiDisabledIdScanner)
		src.aiDisabledIdScanner = 0
		message = "IdScan feature has been enabled."
	else if(!activate && !src.aiDisabledIdScanner)
		src.aiDisabledIdScanner = 1
		message = "IdScan feature has been disabled."

	if(feedback && message)
		to_chat(usr, message)

/obj/machinery/door/airlock/proc/set_safeties(var/activate, var/feedback = 0)
	var/message = ""
	// Safeties!  We don't need no stinking safeties!
	if (src.isWireCut(AIRLOCK_WIRE_SAFETY))
		message = text("The safety wire is cut - Cannot enable safeties.")
	else if (!activate && src.safe)
		safe = 0
	else if (activate && !src.safe)
		safe = 1

	if(feedback && message)
		to_chat(usr, message)

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise
// The preceding comment was borrowed from the grille's shock script
/obj/machinery/door/airlock/shock(mob/user, prb)
	if(!arePowerSystemsOn())
		return 0
	if(hasShocked)
		return 0	//Already shocked someone recently?
	if(..())
		hasShocked = 1
		sleep(10)
		hasShocked = 0
		return 1
	else
		return 0


/obj/machinery/door/airlock/on_update_icon(state=0, override=0)
	if(connections in list(NORTH, SOUTH, NORTH|SOUTH))
		if(connections in list(WEST, EAST, EAST|WEST))
			set_dir(SOUTH)
		else
			set_dir(EAST)
	else
		set_dir(SOUTH)

	switch(state)
		if(0)
			if(density)
				icon_state = "closed"
				state = AIRLOCK_CLOSED
			else
				icon_state = "open"
				state = AIRLOCK_OPEN
		if(AIRLOCK_OPEN)
			icon_state = "open"
		if(AIRLOCK_CLOSED)
			icon_state = "closed"
		if(AIRLOCK_OPENING, AIRLOCK_CLOSING, AIRLOCK_EMAG, AIRLOCK_DENY)
			icon_state = ""

	set_airlock_overlays(state)

/obj/machinery/door/airlock/proc/set_airlock_overlays(state)
	var/icon/color_overlay
	var/icon/filling_overlay
	var/icon/stripe_overlay
	var/icon/stripe_filling_overlay
	var/icon/lights_overlay
	var/icon/panel_overlay
	var/icon/weld_overlay
	var/icon/damage_overlay
	var/icon/sparks_overlay
	var/icon/brace_overlay

	set_light(0)

	if(door_color && !(door_color == "none"))
		var/ikey = "[airlock_type]-[door_color]-color"
		color_overlay = airlock_icon_cache["[ikey]"]
		if(!color_overlay)
			color_overlay = new(color_file)
			color_overlay.Blend(door_color, ICON_MULTIPLY)
			airlock_icon_cache["[ikey]"] = color_overlay
	if(glass)
		if (window_color && window_color != "none")
			var/ikey = "[airlock_type]-[window_color]-windowcolor"
			filling_overlay = airlock_icon_cache["[ikey]"]
			if (!filling_overlay)
				filling_overlay = new(glass_file)
				filling_overlay.Blend(window_color, ICON_MULTIPLY)
				airlock_icon_cache["[ikey]"] = filling_overlay
		else
			filling_overlay = glass_file
	else
		if(door_color && !(door_color == "none"))
			var/ikey = "[airlock_type]-[door_color]-fillcolor"
			filling_overlay = airlock_icon_cache["[ikey]"]
			if(!filling_overlay)
				filling_overlay = new(color_fill_file)
				filling_overlay.Blend(door_color, ICON_MULTIPLY)
				airlock_icon_cache["[ikey]"] = filling_overlay
		else
			filling_overlay = fill_file
	if(stripe_color && !(stripe_color == "none"))
		var/ikey = "[airlock_type]-[stripe_color]-stripe"
		stripe_overlay = airlock_icon_cache["[ikey]"]
		if(!stripe_overlay)
			stripe_overlay = new(stripe_file)
			stripe_overlay.Blend(stripe_color, ICON_MULTIPLY)
			airlock_icon_cache["[ikey]"] = stripe_overlay
		if(!glass)
			var/ikey2 = "[airlock_type]-[stripe_color]-fillstripe"
			stripe_filling_overlay = airlock_icon_cache["[ikey2]"]
			if(!stripe_filling_overlay)
				stripe_filling_overlay = new(stripe_fill_file)
				stripe_filling_overlay.Blend(stripe_color, ICON_MULTIPLY)
				airlock_icon_cache["[ikey2]"] = stripe_filling_overlay

	if(arePowerSystemsOn())
		switch(state)
			if(AIRLOCK_CLOSED)
				if(lights && locked)
					lights_overlay = bolts_file
					set_light(0.25, 0.1, 1, 2, COLOR_RED_LIGHT)

			if(AIRLOCK_DENY)
				if(lights)
					lights_overlay = deny_file
					set_light(0.25, 0.1, 1, 2, COLOR_RED_LIGHT)

			if(AIRLOCK_EMAG)
				sparks_overlay = emag_file

			if(AIRLOCK_CLOSING)
				if(lights)
					lights_overlay = lights_file
					set_light(0.25, 0.1, 1, 2, COLOR_LIME)

			if(AIRLOCK_OPENING)
				if(lights)
					lights_overlay = lights_file
					set_light(0.25, 0.1, 1, 2, COLOR_LIME)

		if(stat & BROKEN)
			damage_overlay = sparks_broken_file
		else if(health < maxhealth * 3/4)
			damage_overlay = sparks_damaged_file

	if(welded)
		weld_overlay = welded_file

	if(p_open)
		panel_overlay = panel_file

	if(brace)
		brace.update_icon()
		brace_overlay += image(brace.icon, brace.icon_state)

	overlays.Cut()

	overlays += color_overlay
	overlays += filling_overlay
	overlays += stripe_overlay
	overlays += stripe_filling_overlay
	overlays += panel_overlay
	overlays += weld_overlay
	overlays += brace_overlay
	overlays += lights_overlay
	overlays += sparks_overlay
	overlays += damage_overlay

/obj/machinery/door/airlock/do_animate(animation)
	if(overlays)
		overlays.Cut()

	switch(animation)
		if("opening")
			set_airlock_overlays(AIRLOCK_OPENING)
			flick("opening", src)//[stat ? "_stat":]
			update_icon(AIRLOCK_OPEN)
		if("closing")
			set_airlock_overlays(AIRLOCK_CLOSING)
			flick("closing", src)
			update_icon(AIRLOCK_CLOSED)
		if("deny")
			set_airlock_overlays(AIRLOCK_DENY)
			if(density && arePowerSystemsOn())
				flick("deny", src)
				if(secured_wires && world.time > next_clicksound)
					next_clicksound = world.time + CLICKSOUND_INTERVAL
					playsound(loc, open_failure_access_denied, 50, 0)
			update_icon(AIRLOCK_CLOSED)
		if("emag")
			set_airlock_overlays(AIRLOCK_EMAG)
			if(density && arePowerSystemsOn())
				flick("deny", src)
		else
			update_icon()
	return

/obj/machinery/door/airlock/attack_robot(mob/user)
	ui_interact(user)

/obj/machinery/door/airlock/attack_ai(mob/user)
	ui_interact(user)

/obj/machinery/door/airlock/attack_ghost(mob/user)
	ui_interact(user)

/obj/machinery/door/airlock/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/data[0]

	data["main_power_loss"]		= round(main_power_lost_until 	> 0 ? max(main_power_lost_until - world.time,	0) / 10 : main_power_lost_until,	1)
	data["backup_power_loss"]	= round(backup_power_lost_until	> 0 ? max(backup_power_lost_until - world.time,	0) / 10 : backup_power_lost_until,	1)
	data["electrified"] 		= round(electrified_until		> 0 ? max(electrified_until - world.time, 	0) / 10 	: electrified_until,		1)
	data["open"] = !density

	var/commands[0]
	commands[++commands.len] = list("name" = "IdScan",					"command"= "idscan",				"active" = !aiDisabledIdScanner,	"enabled" = "Enabled",	"disabled" = "Disable",		"danger" = 0, "act" = 1)
	commands[++commands.len] = list("name" = "Bolts",					"command"= "bolts",					"active" = !locked,					"enabled" = "Raised ",	"disabled" = "Dropped",		"danger" = 0, "act" = 0)
	commands[++commands.len] = list("name" = "Lights",					"command"= "lights",				"active" = lights,					"enabled" = "Enabled",	"disabled" = "Disable",		"danger" = 0, "act" = 1)
	commands[++commands.len] = list("name" = "Safeties",				"command"= "safeties",				"active" = safe,					"enabled" = "Nominal",	"disabled" = "Overridden",	"danger" = 1, "act" = 0)
	commands[++commands.len] = list("name" = "Timing",					"command"= "timing",				"active" = normalspeed,				"enabled" = "Nominal",	"disabled" = "Overridden",	"danger" = 1, "act" = 0)
	commands[++commands.len] = list("name" = "Door State",				"command"= "open",					"active" = density,					"enabled" = "Closed",	"disabled" = "Opened", 		"danger" = 0, "act" = 0)

	data["commands"] = commands

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "door_control.tmpl", "Door Controls", 450, 350, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/door/airlock/proc/hack(mob/user as mob)
	if(src.aiHacking==0)
		src.aiHacking=1
		spawn(20)
			//TODO: Make this take a minute
			to_chat(user, "Airlock AI control has been blocked. Beginning fault-detection.")
			sleep(50)
			if(src.canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				src.aiHacking=0
				return
			else if(!src.canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				src.aiHacking=0
				return
			to_chat(user, "Fault confirmed: airlock control wire disabled or cut.")
			sleep(20)
			to_chat(user, "Attempting to hack into airlock. This may take some time.")
			sleep(200)
			if(src.canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				src.aiHacking=0
				return
			else if(!src.canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				src.aiHacking=0
				return
			to_chat(user, "Upload access confirmed. Loading control program into airlock software.")
			sleep(170)
			if(src.canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				src.aiHacking=0
				return
			else if(!src.canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				src.aiHacking=0
				return
			to_chat(user, "Transfer complete. Forcing airlock to execute program.")
			sleep(50)
			//disable blocked control
			src.aiControlDisabled = 2
			to_chat(user, "Receiving control information from airlock.")
			sleep(10)
			//bring up airlock dialog
			src.aiHacking = 0
			if (user)
				src.attack_ai(user)

/obj/machinery/door/airlock/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (src.isElectrified())
		if (istype(mover, /obj/item))
			var/obj/item/i = mover
			if (i.matter && (MATERIAL_STEEL in i.matter) && i.matter[MATERIAL_STEEL] > 0)
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()
	return ..()

/obj/machinery/door/airlock/physical_attack_hand(mob/user)
	if(!istype(usr, /mob/living/silicon))
		if(src.isElectrified())
			if(src.shock(user, 100))
				return TRUE

/obj/machinery/door/airlock/CanUseTopic(var/mob/user)
	if(operating < 0) //emagged
		to_chat(user, "<span class='warning'>Unable to interface: Internal error.</span>")
		return STATUS_CLOSE
	if(issilicon(user) && !src.canAIControl())
		if(src.canAIHack(user))
			src.hack(user)
		else
			if (src.isAllPowerLoss()) //don't really like how this gets checked a second time, but not sure how else to do it.
				to_chat(user, "<span class='warning'>Unable to interface: Connection timed out.</span>")
			else
				to_chat(user, "<span class='warning'>Unable to interface: Connection refused.</span>")
		return STATUS_CLOSE

	return ..()

/obj/machinery/door/airlock/Topic(href, href_list)
	if(..())
		return 1

	var/activate = text2num(href_list["activate"])
	switch (href_list["command"])
		if("idscan")
			set_idscan(activate, 1)
		if("main_power")
			if(!main_power_lost_until)
				src.loseMainPower()
		if("backup_power")
			if(!backup_power_lost_until)
				src.loseBackupPower()
		if("bolts")
			if(src.isWireCut(AIRLOCK_WIRE_DOOR_BOLTS))
				to_chat(usr, "The door bolt control wire is cut - Door bolts permanently dropped.")
			else if(activate && src.lock())
				to_chat(usr, "The door bolts have been dropped.")
			else if(!activate && src.unlock())
				to_chat(usr, "The door bolts have been raised.")
		if("electrify_temporary")
			electrify(30 * activate, 1)
		if("electrify_permanently")
			electrify(-1 * activate, 1)
		if("open")
			if(src.welded)
				to_chat(usr, text("The airlock has been welded shut!"))
			else if(src.locked)
				to_chat(usr, text("The door bolts are down!"))
			else if(activate && density)
				open()
			else if(!activate && !density)
				close()
		if("safeties")
			set_safeties(!activate, 1)
		if("timing")
			// Door speed control
			if(src.isWireCut(AIRLOCK_WIRE_SPEED))
				to_chat(usr, text("The timing wire is cut - Cannot alter timing."))
			else if (activate && src.normalspeed)
				normalspeed = 0
			else if (!activate && !src.normalspeed)
				normalspeed = 1
		if("lights")
			// Lights
			if(src.isWireCut(AIRLOCK_WIRE_LIGHT))
				to_chat(usr, "The lights wire is cut - The door lights are permanently disabled.")
			else if (!activate && src.lights)
				lights = 0
				to_chat(usr, "The door lights have been disabled.")
			else if (activate && !src.lights)
				lights = 1
				to_chat(usr, "The door lights have been enabled.")

	update_icon()
	return 1

//returns 1 on success, 0 on failure
/obj/machinery/door/airlock/proc/cut_bolts(var/obj/item/item, var/mob/user)
	var/cut_delay = (15 SECONDS)
	var/cut_verb
	var/cut_sound

	if(isWelder(item))
		var/obj/item/weldingtool/WT = item
		if(!WT.remove_fuel(0,user))
			return 0
		cut_verb = "cutting"
		cut_sound = 'sound/items/Welder.ogg'
	else if(istype(item,/obj/item/gun/energy/plasmacutter)) //They could probably just shoot them out, but who cares!
		var/obj/item/gun/energy/plasmacutter/cutter = item
		if(!cutter.slice(user))
			return 0
		cut_verb = "cutting"
		cut_sound = 'sound/items/Welder.ogg'
		cut_delay *= 0.66
	else if(istype(item,/obj/item/melee/energy/blade) || istype(item,/obj/item/melee/energy/sword))
		cut_verb = "slicing"
		cut_sound = "sparks"
		cut_delay *= 0.66
	else if(istype(item,/obj/item/circular_saw))
		cut_verb = "sawing"
		cut_sound = 'sound/weapons/circsawhit.ogg'
		cut_delay *= 1.5

	else if(istype(item,/obj/item/material/twohanded/fireaxe))
		//special case - zero delay, different message
		if (src.lock_cut_state == BOLTS_EXPOSED)
			return 0 //can't actually cut the bolts, go back to regular smashing
		var/obj/item/material/twohanded/fireaxe/F = item
		if (!F.wielded)
			return 0
		user.visible_message(
			"<span class='danger'>\The [user] smashes the bolt cover open!</span>",
			"<span class='warning'>You smash the bolt cover open!</span>"
			)
		playsound(src, 'sound/weapons/smash.ogg', 100, 1)
		src.lock_cut_state = BOLTS_EXPOSED
		return 0

	else
		// I guess you can't cut bolts with that item. Never mind then.
		return 0

	if (src.lock_cut_state == BOLTS_FINE)
		user.visible_message(
			"<span class='notice'>\The [user] begins [cut_verb] through the bolt cover on [src].</span>",
			"<span class='notice'>You begin [cut_verb] through the bolt cover.</span>"
			)

		playsound(src, cut_sound, 100, 1)
		if (do_after(user, cut_delay, src))
			user.visible_message(
				"<span class='notice'>\The [user] removes the bolt cover from [src]</span>",
				"<span class='notice'>You remove the cover and expose the door bolts.</span>"
				)
			src.lock_cut_state = BOLTS_EXPOSED
		return 1

	if (src.lock_cut_state == BOLTS_EXPOSED)
		user.visible_message(
			"<span class='notice'>\The [user] begins [cut_verb] through [src]'s bolts.</span>",
			"<span class='notice'>You begin [cut_verb] through the door bolts.</span>"
			)
		playsound(src, cut_sound, 100, 1)
		if (do_after(user, cut_delay, src))
			user.visible_message(
				"<span class='notice'>\The [user] severs the door bolts, unlocking [src].</span>",
				"<span class='notice'>You sever the door bolts, unlocking the door.</span>"
				)
			src.lock_cut_state = BOLTS_CUT
			src.unlock(1) //force it
		return 1

/obj/machinery/door/airlock/attackby(var/obj/item/C, var/mob/user)
	// Brace is considered installed on the airlock, so interacting with it is protected from electrification.
	if(brace && C && (istype(C.GetIdCard(), /obj/item/card/id/) || istype(C, /obj/item/crowbar/brace_jack)))
		return brace.attackby(C, user)

	if(!brace && istype(C, /obj/item/airlock_brace))
		var/obj/item/airlock_brace/A = C
		if(!density)
			to_chat(user, "<span class='warning'>You must close \the [src] before installing \the [A]!</span>")
			return

		if(!length(A.req_access) && (alert("\the [A]'s 'Access Not Set' light is flashing. Install it anyway?", "Access not set", "Yes", "No") == "No"))
			return

		playsound(user, 'sound/machines/lockreset.ogg', 50, 1)
		if(do_after(user, 6 SECONDS, src) && density && A && user.unEquip(A, src))
			to_chat(user, "<span class='notice'>You successfully install \the [A].</span>")
			brace = A
			brace.airlock = src
			update_icon()
		return

	if(!istype(usr, /mob/living/silicon))
		if(src.isElectrified())
			if(src.shock(user, 75))
				return
	if(istype(C, /obj/item/taperoll))
		return

	if (!repairing && (stat & BROKEN) && src.locked) //bolted and broken
		if (!cut_bolts(C,user))
			..()
		return

	if(!repairing && isWelder(C) && !( operating > 0 ) && density)
		var/obj/item/weldingtool/W = C
		if(!W.remove_fuel(0,user))
			to_chat(user, SPAN_NOTICE("Your [W.name] doesn't have enough fuel."))
			return
		playsound(src, 'sound/items/Welder.ogg', 50, 1)
		user.visible_message(SPAN_WARNING("\The [user] begins welding \the [src] [welded ? "open" : "closed"]!"),
							SPAN_NOTICE("You begin welding \the [src] [welded ? "open" : "closed"]."))
		if(do_after(user, (rand(3,5)) SECONDS, src))
			if(density && !(operating > 0) && !repairing)
				playsound(src, 'sound/items/Welder2.ogg', 50, 1)
				welded = !welded
				update_icon()
				return
		else
			to_chat(user, SPAN_NOTICE("You must remain still to complete this task."))
			return
	else if(isScrewdriver(C))
		if (src.p_open)
			if (stat & BROKEN)
				to_chat(user, "<span class='warning'>The panel is broken, and cannot be closed.</span>")
			else
				src.p_open = 0
				user.visible_message(SPAN_NOTICE("[user.name] closes the maintenance panel on \the [src]."), SPAN_NOTICE("You close the maintenance panel on \the [src]."))
				playsound(src.loc, "[GLOB.machinery_exposed_sound[1]]", 20)
		else
			src.p_open = 1
			user.visible_message(SPAN_NOTICE("[user.name] opens the maintenance panel on \the [src]."), SPAN_NOTICE("You open the maintenance panel on \the [src]."))
			playsound(src.loc, "[GLOB.machinery_exposed_sound[1]]", 20)
		src.update_icon()
	else if(isWirecutter(C))
		return src.attack_hand(user)
	else if(isMultitool(C))
		return src.attack_hand(user)
	else if(istype(C, /obj/item/device/assembly/signaler))
		return src.attack_hand(user)
	else if(istype(C, /obj/item/pai_cable))	// -- TLE
		var/obj/item/pai_cable/cable = C
		cable.plugin(src, user)
	else if(!repairing && isCrowbar(C))
		if(src.p_open && (operating < 0 || (!operating && welded && !src.arePowerSystemsOn() && density && !src.locked)) && !brace)
			playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
			user.visible_message("[user] removes the electronics from the airlock assembly.", "You start to remove electronics from the airlock assembly.")
			if(do_after(user,40,src))
				to_chat(user, "<span class='notice'>You've removed the airlock electronics!</span>")
				deconstruct(user)
				return
		else if(arePowerSystemsOn())
			to_chat(user, "<span class='notice'>The airlock's motors resist your efforts to force it.</span>")
		else if(locked)
			to_chat(user, "<span class='notice'>The airlock's bolts prevent it from being forced.</span>")
		else if(brace)
			to_chat(user, "<span class='notice'>The airlock's brace holds it firmly in place.</span>")
		else
			if(density)
				spawn(0)	open(1)
			else
				spawn(0)	close(1)

			//if door is unbroken, hit with fire axe using harm intent
	else if (istype(C, /obj/item/material/twohanded/fireaxe) && !(stat & BROKEN) && user.a_intent == I_HURT)
		var/obj/item/material/twohanded/fireaxe/F = C
		if (F.wielded)
			playsound(src, 'sound/weapons/smash.ogg', 100, 1)
			health -= F.force_wielded * 2
			if(health <= 0)
				user.visible_message(SPAN_DANGER("[user] smashes \the [C] into the airlock's control panel! It explodes in a shower of sparks!"), SPAN_DANGER("You smash \the [C] into the airlock's control panel! It explodes in a shower of sparks!"))
				health = 0
				set_broken(TRUE)
			else
				user.visible_message(SPAN_DANGER("[user] smashes \the [C] into the airlock's control panel!"))
		else
			..()
			return

	else if(istype(C, /obj/item/material/twohanded/fireaxe) && !arePowerSystemsOn())
		if(locked)
			to_chat(user, "<span class='notice'>The airlock's bolts prevent it from being forced.</span>")
		else if( !welded && !operating )
			if(density)
				var/obj/item/material/twohanded/fireaxe/F = C
				if(F.wielded)
					spawn(0)	open(1)
				else
					to_chat(user, "<span class='warning'>You need to be wielding \the [C] to do that.</span>")
			else
				var/obj/item/material/twohanded/fireaxe/F = C
				if(F.wielded)
					spawn(0)	close(1)
				else
					to_chat(user, "<span class='warning'>You need to be wielding \the [C] to do that.</span>")

	else if(istype(C, /obj/item/device/paint_sprayer))
		return
	else if((stat & (BROKEN|NOPOWER)) && istype(user, /mob/living/simple_animal))
		var/mob/living/simple_animal/A = user
		var/obj/item/I = A.get_natural_weapon()
		if(I.force >= 10)
			if(density)
				visible_message(SPAN_DANGER("\The [A] forces \the [src] open!"))
				open(1)
			else
				visible_message(SPAN_DANGER("\The [A] forces \the [src] closed!"))
				close(1)
		else
			visible_message(SPAN_NOTICE("\The [A] strains fruitlessly to force \the [src] [density ? "open" : "closed"]."))
		return
	else
		..()
	return

/obj/machinery/door/airlock/deconstruct(mob/user, var/moved = FALSE)
	var/obj/structure/door_assembly/da = new assembly_type(src.loc)
	if (istype(da, /obj/structure/door_assembly/multi_tile))
		da.set_dir(src.dir)
	if(mineral)
		da.glass = mineral
	//else if(glass)
	else if(glass && !da.glass)
		da.glass = 1

	da.paintable = paintable
	da.door_color = door_color
	da.stripe_color = stripe_color
	da.symbol_color = symbol_color

	if(moved)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
	else
		da.anchored = TRUE
	da.state = 1
	da.created_name = src.name
	da.update_state()

	if(operating == -1 || (stat & BROKEN))
		new /obj/item/stock_parts/circuitboard/broken(src.loc)
		operating = 0
	else
		if (!electronics)
			create_electronics()

		electronics.dropInto(loc)
		electronics = null

	qdel(src)

	return da
/obj/machinery/door/airlock/phoron/attackby(C as obj, mob/user as mob)
	if(C)
		ignite(is_hot(C))
	..()

/obj/machinery/door/airlock/set_broken(new_state)
	. = ..()
	if(. && new_state)
		p_open = 1
		if (secured_wires)
			lock()
		visible_message("\The [src]'s control panel bursts open, sparks spewing out!")
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()

/obj/machinery/door/airlock/open(var/forced=0)
	if(!can_open(forced))
		return 0
	use_power_oneoff(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people

	//if the door is unpowered then it doesn't make sense to hear the woosh of a pneumatic actuator
	if(arePowerSystemsOn())
		playsound(src.loc, open_sound_powered, 100, 1)
	else
		playsound(src.loc, open_sound_unpowered, 100, 1)

	if(src.closeOther != null && istype(src.closeOther, /obj/machinery/door/airlock/) && !src.closeOther.density)
		src.closeOther.close()
	return ..()

/obj/machinery/door/airlock/can_open(var/forced=0)
	if(brace)
		return 0

	if(!forced)
		if(!arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_OPEN_DOOR))
			return 0

	if(locked || welded)
		return 0
	return ..()

/obj/machinery/door/airlock/can_close(var/forced=0)
	if(locked || welded)
		return 0

	if(!forced)
		//despite the name, this wire is for general door control.
		if(!arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_OPEN_DOOR))
			return	0

	return ..()

/obj/machinery/door/airlock/close(var/forced=0)
	if(!can_close(forced))
		return 0

	if(safe)
		for(var/turf/turf in locs)
			for(var/atom/movable/AM in turf)
				if(AM.blocks_airlock())
					if(world.time > next_beep_at)
						playsound(src.loc, close_failure_blocked, 30, 0, -3)
						next_beep_at = world.time + SecondsToTicks(10)
					close_door_at = world.time + 6
					return

	for(var/turf/turf in locs)
		for(var/atom/movable/AM in turf)
			if(AM.airlock_crush(door_crush_damage))
				take_damage(door_crush_damage)
				use_power_oneoff(door_crush_damage * 100)		// Uses bunch extra power for crushing the target.

	use_power_oneoff(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people
	if(arePowerSystemsOn())
		playsound(src.loc, close_sound_powered, 100, 1)
	else
		playsound(src.loc, close_sound_unpowered, 100, 1)

	..()

/obj/machinery/door/airlock/proc/lock(var/forced=0)
	if(locked)
		return 0

	if (operating && !forced) return 0

	if (lock_cut_state == BOLTS_CUT) return 0 //what bolts?

	src.locked = 1
	playsound(src, bolts_dropping, 30, 0, -6)
	audible_message("You hear a click from the bottom of the door.", hearing_distance = 1)
	update_icon()
	return 1

/obj/machinery/door/airlock/proc/unlock(var/forced=0)
	if(!src.locked)
		return

	if (!forced)
		if(operating || !src.arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_DOOR_BOLTS))
			return

	src.locked = 0
	playsound(src, bolts_rising, 30, 0, -6)
	audible_message("You hear a click from the bottom of the door.", hearing_distance = 1)
	update_icon()
	return 1

/obj/machinery/door/airlock/proc/toggle_lock(var/forced = 0)
	return locked ? unlock() : lock()

/obj/machinery/door/airlock/allowed(mob/M)
	if(locked)
		return 0
	return ..(M)

/obj/machinery/door/airlock/New(var/newloc, var/obj/structure/door_assembly/assembly=null)
	..()

	//if assembly is given, create the new door from the assembly
	if (assembly && istype(assembly))
		assembly_type = assembly.type

		electronics = assembly.electronics
		electronics.forceMove(src)

		//update the door's access to match the electronics'
		if(electronics.autoset)
			autoset_access = TRUE
		else
			req_access = electronics.conf_access
			if(electronics.one_access)
				req_access = list(req_access)
			autoset_access = FALSE // We just set it, so don't try and do anything fancy later.
		secured_wires = electronics.secure

		//get the name from the assembly
		if(assembly.created_name)
			SetName(assembly.created_name)
		else
			SetName("[istext(assembly.glass) ? "[assembly.glass] airlock" : assembly.base_name]")

		//get the dir from the assembly
		set_dir(assembly.dir)

		if(assembly)
			paintable = assembly.paintable
			door_color = assembly.door_color
			stripe_color = assembly.stripe_color
			symbol_color = assembly.symbol_color
		queue_icon_update()

	//wires
	var/turf/T = get_turf(newloc)
	if(T && (T.z in GLOB.using_map.admin_levels))
		secured_wires = 1
	if (secured_wires)
		wires = new/datum/wires/airlock/secure(src)
	else
		wires = new/datum/wires/airlock(src)

/obj/machinery/door/airlock/Initialize()
	if(src.closeOtherId != null)
		for (var/obj/machinery/door/airlock/A in world)
			if(A.closeOtherId == src.closeOtherId && A != src)
				src.closeOther = A
				break
	var/turf/T = loc
	var/obj/item/airlock_brace/A = locate(/obj/item/airlock_brace) in T
	if(!brace && A)
		brace = A
		brace.airlock = src
		brace.forceMove(src)
		if(brace.electronics && !length(brace.req_access))
			brace.electronics.set_access(src)
			brace.update_access()
		update_icon()
	if (glass)
		paintable |= AIRLOCK_WINDOW_PAINTABLE
		window_material = SSmaterials.get_material_by_name(init_material_window)
		if (!window_color)
			window_color = window_material.icon_colour
	. = ..()

/obj/machinery/door/airlock/Destroy()
	if(brace)
		qdel(brace)
	return ..()

/obj/machinery/door/airlock/create_electronics(var/electronics_type = /obj/item/airlock_electronics)
	if (secured_wires)
		electronics_type = /obj/item/airlock_electronics/secure
	electronics = ..()
	return electronics

/obj/machinery/door/airlock/emp_act(var/severity)
	if(prob(20/severity))
		spawn(0)
			open()
	if(prob(40/severity))
		var/duration = SecondsToTicks(30 / severity)
		if(electrified_until > -1 && (duration + world.time) > electrified_until)
			electrify(duration)
	..()

/obj/machinery/door/airlock/power_change() //putting this is obj/machinery/door itself makes non-airlock doors turn invisible for some reason
	. = ..()
	if(stat & NOPOWER)
		// If we lost power, disable electrification
		electrified_until = 0

/obj/machinery/door/airlock/proc/prison_open()
	if(arePowerSystemsOn())
		src.unlock()
		src.open()
		src.lock()
	return

// Braces can act as an extra layer of armor - they will take damage first.
/obj/machinery/door/airlock/take_damage(var/amount)
	if(brace)
		brace.take_damage(amount)
	else
		..(amount)
	update_icon()

/obj/machinery/door/airlock/examine(mob/user)
	. = ..()
	if (lock_cut_state == BOLTS_EXPOSED)
		to_chat(user, "The bolt cover has been cut open.")
	if (lock_cut_state == BOLTS_CUT)
		to_chat(user, "The door bolts have been cut.")
	if(brace)
		to_chat(user, "\The [brace] is installed on \the [src], preventing it from opening.")
		to_chat(user, brace.examine_health())

/obj/machinery/door/airlock/autoname

/obj/machinery/door/airlock/autoname/New()
	var/area/A = get_area(src)
	name = A.name
	..()

/obj/machinery/door/airlock/proc/paint_airlock(var/paint_color)
	door_color = paint_color
	update_icon()

/obj/machinery/door/airlock/proc/stripe_airlock(var/paint_color)
	stripe_color = paint_color
	update_icon()

/obj/machinery/door/airlock/proc/paint_window(paint_color)
	if (paint_color)
		window_color = paint_color
	else if (window_material?.icon_colour)
		window_color = window_material.icon_colour
	else
		window_color = GLASS_COLOR
	update_icon()

// Public access

/decl/public_access/public_method/airlock_toggle_bolts
	name = "toggle bolts"
	desc = "Toggles whether the airlock is bolted or not, if possible."
	call_proc = /obj/machinery/door/airlock/proc/toggle_lock

/decl/stock_part_preset/radio/receiver/airlock
	frequency = AIRLOCK_FREQ
	receive_and_call = list(
		"toggle_door" = /decl/public_access/public_method/toggle_door,
		"toggle_bolts" = /decl/public_access/public_method/airlock_toggle_bolts
	)
