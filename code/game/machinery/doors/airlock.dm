#define BOLTS_FINE 0
#define BOLTS_EXPOSED 1
#define BOLTS_CUT 2

#define AIRLOCK_CLOSED	1
#define AIRLOCK_CLOSING	2
#define AIRLOCK_OPEN	3
#define AIRLOCK_OPENING	4
#define AIRLOCK_DENY	5
#define AIRLOCK_EMAG	6

/obj/machinery/door/airlock
	name = "airlock"
	icon = 'icons/obj/doors/station/door.dmi'
	icon_state = "closed"
	power_channel = ENVIRON
	interact_offline = FALSE

	explosion_resistance = 10
	/// Boolean. Whether or not the AI control mechanism is disabled.
	var/ai_control_disabled = FALSE
	/// Boolean. Whether or not the AI has bypassed a disabled control mechanism.
	var/ai_control_bypassed = FALSE
	/// Integer. World time when the door is no longer electrified. -1 if it is permanently electrified until someone fixes it.
	var/electrified_until = 0
	/// Integer. World time when main power is restored.
	var/main_power_lost_until = 0
	/// Integer. World time when backup power is restored. -1 if not using backup power or disabled.
	var/backup_power_lost_until = -1
	/// Integer. World time when we may next beep due to doors being blocked by mobs. Spam prevention.
	var/next_beep_at = 0
	/// Boolean. Whether or not the door is welded shut.
	var/welded = FALSE
	/// Boolean. Whether or not the door is locked/bolted.
	var/locked = FALSE
	/// Integer (One of `BOLTS_*`). The door's current lock/bolt cutting state.
	var/lock_cut_state = BOLTS_FINE
	/// Boolean. Whether or not the airlock's lights are enabled. Tied to the bolt light wire.
	var/lights = TRUE
	/// Boolean. Whether or not the ID scanner is enabled. Tied to the ID scan wire.
	var/aiDisabledIdScanner = FALSE
	autoclose = TRUE
	/// Path. The assembly structure used to create this door. Used during disassembly steps.
	var/assembly_type = /obj/structure/door_assembly
	/// String (One of `MATERIAL_*`). The material the door is made from. If not set, defaults to steel.
	var/mineral = null
	/// Boolean. Whether or not the door's safeties are enabled. Tied to the safety wire.
	var/safe = TRUE
	var/obj/item/airlock_electronics/electronics = null
	/// Boolean. Whether or not the door has just electrocuted someone.
	var/hasShocked = FALSE
	/// Boolean. Whether or not the door has secure wiring that scrambles the wire panel.
	var/secured_wires = FALSE

	/// Soundfile. The sound played when opening the door while powered.
	var/open_sound_powered = 'sound/machines/airlock_open.ogg'
	/// Soundfile. The sound played when opening the door while unpowered.
	var/open_sound_unpowered = 'sound/machines/airlock_open_force.ogg'
	/// Soundfile. The sound played when the door refuses to open due to access.
	var/open_failure_access_denied = 'sound/machines/buzz-two.ogg'
	/// Soundfile. The sound played when the door closes while powered.
	var/close_sound_powered = 'sound/machines/airlock_close.ogg'
	/// Soundfile. The sound played when the door closes while unpowered.
	var/close_sound_unpowered = 'sound/machines/airlock_close_force.ogg'
	/// Soundfile. The sound played when the door is unlocked/unbolted.
	var/bolts_rising = 'sound/machines/bolts_up.ogg'
	/// Soundfile. The sound played when the door is locked/bolted.
	var/bolts_dropping = 'sound/machines/bolts_down.ogg'

	/// Integer. The amount of damage dealt by the door when it closes on someone or something.
	var/door_crush_damage = DOOR_CRUSH_DAMAGE
	/// Instance of an airlock brace currently attached to the door.
	var/obj/item/airlock_brace/brace = null

	//Airlock 2.0 Aesthetics Properties
	//The variables below determine what color the airlock and decorative stripes will be -Cakey
	/// String. Partial icon state for generating the airlock appearance overlay.
	var/airlock_type = "Standard"
	var/static/list/airlock_icon_cache = list()
	/// Bitflag (Any of `AIRLOCK_PAINTABLE_*`). Determines what parts of the airlock can be recolored with paint.
	var/paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE
	/// Color. The color of the main door body.
	var/door_color = null
	/// Color. The color of the stripe detail.
	var/stripe_color = null
	/// Color. The color of the symbol detail.
	var/symbol_color = null
	/// Color. The color of the window.
	var/window_color = null
	/// String (One of `MATERIAL_*`). The material used for the door's window if `glass` is set. Used to set `window_material` during init.
	var/init_material_window = MATERIAL_GLASS
	/// The material of the door's window.
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
		/singleton/public_access/public_method/toggle_door,
		/singleton/public_access/public_method/airlock_toggle_bolts
	)
	stock_part_presets = list(/singleton/stock_part_preset/radio/receiver/airlock = 1)

/obj/machinery/door/airlock/get_material()
	return SSmaterials.get_material_by_name(mineral ? mineral : MATERIAL_STEEL)

//regular airlock presets

/obj/machinery/door/airlock/command
	door_color = COLOR_COMMAND_BLUE

/obj/machinery/door/airlock/security
	door_color = COLOR_NT_RED

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
	stripe_color = COLOR_RESEARCH

/obj/machinery/door/airlock/corporate
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
	damage_hitsound = 'sound/effects/Glasshit.ogg'
	explosion_resistance = 5
	opacity = 0
	glass = TRUE

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
	paintable = AIRLOCK_PAINTABLE_MAIN

/obj/machinery/door/airlock/external/inherit_access_from_area()
	..()
	if(is_station_area(get_area(src)))
		add_access_requirement(req_access, access_external_airlocks)

/obj/machinery/door/airlock/external/escapepod
	name = "Escape Pod"
	frequency =  1380
	locked = 1

/obj/machinery/door/airlock/external/escapepod/use_tool(obj/item/C, mob/living/user, list/click_params)
	if(p_open && !arePowerSystemsOn())
		if(isWrench(C))
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			user.visible_message(SPAN_WARNING("[user.name] starts frantically pumping the bolt override mechanism!"), SPAN_WARNING("You start frantically pumping the bolt override mechanism!"))
			if(do_after(user, 16 SECONDS, src, DO_REPAIR_CONSTRUCT))
				visible_message("\The [src] bolts [locked ? "disengage" : "engage"]!")
				locked = !locked
			return TRUE

	return ..()

/obj/machinery/door/airlock/external/bolted
	locked = 1

/obj/machinery/door/airlock/external/bolted/cycling
	frequency = 1379

/obj/machinery/door/airlock/external/bolted_open
	density = FALSE
	locked = 1
	opacity = 0

/obj/machinery/door/airlock/external/glass
	explosion_resistance = 5
	opacity = 0
	glass = TRUE

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

/obj/machinery/door/airlock/highsecurity
	airlock_type = "secure"
	name = "Secure Airlock"
	icon = 'icons/obj/doors/secure/door.dmi'
	fill_file = 'icons/obj/doors/secure/fill_steel.dmi'
	explosion_resistance = 20
	secured_wires = TRUE
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity
	paintable = EMPTY_BITFIELD

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
	paintable = AIRLOCK_PAINTABLE_STRIPE

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
	secured_wires = TRUE
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity //Until somebody makes better sprites.

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
		addtimer(new Callback(target_tile, /turf/proc/hotspot_expose, 400), 0)
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
*		one wire for AI control. Sending a pulse through this blocks AI control for a second or so (which is enough to see the AI control light on the panel dialog go off and back on again). Cutting this prevents the AI from controlling the door. If both main and backup power are cut, as well as this wire, then the AI cannot operate the door at all.
*		one wire for electrifying the door. Sending a pulse through this electrifies the door for 30 seconds. Cutting this wire electrifies the door, so that the next person to touch the door without insulated gloves gets electrocuted. (Currently it is also STAYING electrified until someone mends the wire)
*		one wire for controling door safetys.  When active, door does not close on someone.  When cut, door will ruin someone's shit.  When pulsed, door will immedately ruin someone's shit.
*		one wire for controlling door speed.  When active, dor closes at normal rate.  When cut, door does not close manually.  When pulsed, door attempts to close every tick.
*/

/obj/machinery/door/airlock/bumpopen(mob/living/user as mob) //Airlocks now zap you when you 'bump' them open when they're electrified. --NeoFite
	if(!issilicon(usr))
		if (isElectrified())
			if (shock(user, 100))
				return
		else if (prob(10) && operating == DOOR_OPERATING_NO)
			var/mob/living/carbon/C = user
			if(istype(C) && C.hallucination_power > 25)
				to_chat(user, SPAN_DANGER("You feel a powerful shock course through your body!"))
				user.adjustHalLoss(20)
				user.Stun(5)
				return
	..(user)

/obj/machinery/door/airlock/bumpopen(mob/living/simple_animal/user as mob)
	..(user)

/obj/machinery/door/airlock/proc/isElectrified()
	if(src.electrified_until != 0)
		return 1
	return 0

/obj/machinery/door/airlock/proc/isWireCut(wireIndex)
	// You can find the wires in the datum folder.
	return wires.IsIndexCut(wireIndex)

/obj/machinery/door/airlock/proc/canAIControl()
	return ((!ai_control_disabled || ai_control_bypassed) && !isAllPowerLoss())

/obj/machinery/door/airlock/proc/arePowerSystemsOn()
	if (inoperable())
		return 0
	return (src.main_power_lost_until==0 || src.backup_power_lost_until==0)

/obj/machinery/door/airlock/requiresID()
	return !(src.isWireCut(AIRLOCK_WIRE_IDSCAN) || aiDisabledIdScanner)

/obj/machinery/door/airlock/check_access()
	if (isWireCut(AIRLOCK_WIRE_IDSCAN) || aiDisabledIdScanner)
		return !secured_wires
	return ..()


/obj/machinery/door/airlock/proc/isAllPowerLoss()
	if(inoperable())
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

/obj/machinery/door/airlock/proc/electrify(duration, feedback = 0)
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

/obj/machinery/door/airlock/proc/set_idscan(activate, feedback = 0)
	var/message = ""
	if(src.isWireCut(AIRLOCK_WIRE_IDSCAN))
		message = "The IdScan wire is cut - IdScan feature permanently disabled."
	else if(activate && src.aiDisabledIdScanner)
		aiDisabledIdScanner = FALSE
		message = "IdScan feature has been enabled."
	else if(!activate && !src.aiDisabledIdScanner)
		aiDisabledIdScanner = TRUE
		message = "IdScan feature has been disabled."

	if(feedback && message)
		to_chat(usr, message)

/obj/machinery/door/airlock/proc/set_safeties(activate, feedback = 0)
	var/message = ""
	// Safeties!  We don't need no stinking safeties!
	if (src.isWireCut(AIRLOCK_WIRE_SAFETY))
		message = text("The safety wire is cut - Cannot enable safeties.")
	else if (!activate && src.safe)
		safe = FALSE
	else if (activate && !src.safe)
		safe = TRUE

	if(feedback && message)
		to_chat(usr, message)

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise
// The preceding comment was borrowed from the grille's shock script
/obj/machinery/door/airlock/shock(mob/user, prb)
	if (!user)
		return FALSE
	if(!arePowerSystemsOn())
		return 0
	if(hasShocked)
		return 0	//Already shocked someone recently?
	if(..())
		hasShocked = TRUE
		sleep(10)
		hasShocked = FALSE
		return 1
	else
		return 0


/obj/machinery/door/airlock/on_update_icon(state = 0)
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
			icon_state = "blank"

	set_airlock_overlays(state)


/obj/machinery/door/airlock/proc/set_airlock_overlays(state)
	set_light(0)
	var/list/new_overlays = list()
	if(door_color && door_color != "none")
		var/ikey = "[airlock_type]-[door_color]-color"
		var/icon/color_overlay = airlock_icon_cache["[ikey]"]
		if(!color_overlay)
			color_overlay = new(color_file)
			color_overlay.Blend(door_color, ICON_MULTIPLY)
			airlock_icon_cache["[ikey]"] = color_overlay
		if (color_overlay)
			new_overlays += color_overlay
	var/icon/filling_overlay
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
		if(door_color && door_color != "none")
			var/ikey = "[airlock_type]-[door_color]-fillcolor"
			filling_overlay = airlock_icon_cache["[ikey]"]
			if(!filling_overlay)
				filling_overlay = new(color_fill_file)
				filling_overlay.Blend(door_color, ICON_MULTIPLY)
				airlock_icon_cache["[ikey]"] = filling_overlay
		else
			filling_overlay = fill_file
	if (filling_overlay)
		new_overlays += filling_overlay
	if(stripe_color && stripe_color != "none")
		var/icon/stripe_overlay
		var/ikey = "[airlock_type]-[stripe_color]-stripe"
		stripe_overlay = airlock_icon_cache["[ikey]"]
		if(!stripe_overlay)
			stripe_overlay = new(stripe_file)
			stripe_overlay.Blend(stripe_color, ICON_MULTIPLY)
			airlock_icon_cache["[ikey]"] = stripe_overlay
		if (stripe_overlay)
			new_overlays += stripe_overlay
		if(!glass)
			var/icon/stripe_filling_overlay
			var/ikey2 = "[airlock_type]-[stripe_color]-fillstripe"
			stripe_filling_overlay = airlock_icon_cache["[ikey2]"]
			if(!stripe_filling_overlay)
				stripe_filling_overlay = new(stripe_fill_file)
				stripe_filling_overlay.Blend(stripe_color, ICON_MULTIPLY)
				airlock_icon_cache["[ikey2]"] = stripe_filling_overlay
			if (stripe_filling_overlay)
				new_overlays += stripe_filling_overlay
	if(arePowerSystemsOn())
		switch(state)
			if(AIRLOCK_CLOSED)
				if(lights && locked)
					new_overlays += overlay_image(bolts_file, plane = EFFECTS_ABOVE_LIGHTING_PLANE, layer = ABOVE_LIGHTING_LAYER)
					set_light(2, 0.75, COLOR_RED_LIGHT)
			if(AIRLOCK_DENY)
				if(lights)
					new_overlays += overlay_image(deny_file, plane = EFFECTS_ABOVE_LIGHTING_PLANE, layer = ABOVE_LIGHTING_LAYER)
					set_light(2, 0.75, COLOR_RED_LIGHT)
			if(AIRLOCK_EMAG)
				new_overlays += overlay_image(emag_file, plane = EFFECTS_ABOVE_LIGHTING_PLANE, layer = ABOVE_LIGHTING_LAYER)
			if(AIRLOCK_CLOSING)
				if(lights)
					new_overlays += overlay_image(lights_file, plane = EFFECTS_ABOVE_LIGHTING_PLANE, layer = ABOVE_LIGHTING_LAYER)
					set_light(2, 0.75, COLOR_LIME)
			if(AIRLOCK_OPENING)
				if(lights)
					new_overlays += overlay_image(lights_file, plane = EFFECTS_ABOVE_LIGHTING_PLANE, layer = ABOVE_LIGHTING_LAYER)
					set_light(2, 0.75, COLOR_LIME)
		if(MACHINE_IS_BROKEN(src))
			new_overlays += overlay_image(sparks_broken_file, plane = EFFECTS_ABOVE_LIGHTING_PLANE, layer = ABOVE_LIGHTING_LAYER)
		else if (get_damage_percentage() >= 25)
			new_overlays += overlay_image(sparks_damaged_file, plane = EFFECTS_ABOVE_LIGHTING_PLANE, layer = ABOVE_LIGHTING_LAYER)
	if(welded)
		new_overlays += welded_file
	if(p_open)
		new_overlays += panel_file
	if(brace)
		brace.update_icon()
		new_overlays += image(brace.icon, brace.icon_state)
	SetOverlays(new_overlays)
	ImmediateOverlayUpdate()


/obj/machinery/door/airlock/do_animate(animation)
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


/obj/machinery/door/airlock/attack_robot(mob/user)
	ui_interact(user)

/obj/machinery/door/airlock/attack_ai(mob/user)
	ui_interact(user)

/obj/machinery/door/airlock/attack_ghost(mob/user)
	ui_interact(user)

/obj/machinery/door/airlock/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)
	var/data[0]

	data["main_power_loss"]		= round(main_power_lost_until 	> 0 ? max(main_power_lost_until - world.time,	0) / 10 : main_power_lost_until,	1)
	data["backup_power_loss"]	= round(backup_power_lost_until	> 0 ? max(backup_power_lost_until - world.time,	0) / 10 : backup_power_lost_until,	1)
	data["electrified"] 		= round(electrified_until		> 0 ? max(electrified_until - world.time, 	0) / 10 	: electrified_until,		1)
	data["open"] = !density

	// [SIERRA-ADD] - NTNet gimmics
	data["airlock_ntnet_id"]	= NTNet_id
	// [/SIERRA-ADD]

	var/commands[0]
	commands[LIST_PRE_INC(commands)] = list("name" = "IdScan",					"command"= "idscan",				"active" = !aiDisabledIdScanner,	"enabled" = "Enabled",	"disabled" = "Disable",		"danger" = 0, "act" = 1)
	commands[LIST_PRE_INC(commands)] = list("name" = "Bolts",					"command"= "bolts",					"active" = !locked,					"enabled" = "Raised ",	"disabled" = "Dropped",		"danger" = 0, "act" = 0)
	commands[LIST_PRE_INC(commands)] = list("name" = "Lights",					"command"= "lights",				"active" = lights,					"enabled" = "Enabled",	"disabled" = "Disable",		"danger" = 0, "act" = 1)
	commands[LIST_PRE_INC(commands)] = list("name" = "Safeties",				"command"= "safeties",				"active" = safe,					"enabled" = "Nominal",	"disabled" = "Overridden",	"danger" = 1, "act" = 0)
	commands[LIST_PRE_INC(commands)] = list("name" = "Timing",					"command"= "timing",				"active" = normalspeed,				"enabled" = "Nominal",	"disabled" = "Overridden",	"danger" = 1, "act" = 0)
	commands[LIST_PRE_INC(commands)] = list("name" = "Door State",				"command"= "open",					"active" = density,					"enabled" = "Closed",	"disabled" = "Opened", 		"danger" = 0, "act" = 0)

	data["commands"] = commands

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "door_control.tmpl", "Door Controls", 450, 350, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/door/airlock/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (src.isElectrified())
		if (istype(mover, /obj/item))
			var/obj/item/i = mover
			if (i.matter && (MATERIAL_STEEL in i.matter) && i.matter[MATERIAL_STEEL] > 0)
				var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
				s.set_up(5, 1, src)
				s.start()
	return ..()

/obj/machinery/door/airlock/physical_attack_hand(mob/user)
	if(!istype(usr, /mob/living/silicon))
		if(src.isElectrified())
			if(src.shock(user, 100))
				return TRUE

/obj/machinery/door/airlock/CanUseTopic(mob/user)
	if (operating == DOOR_OPERATING_BROKEN) //emagged
		to_chat(user, SPAN_WARNING("Unable to interface: Internal error."))
		return STATUS_CLOSE
	if(issilicon(user) && !src.canAIControl())
		if (src.isAllPowerLoss()) //don't really like how this gets checked a second time, but not sure how else to do it.
			to_chat(user, SPAN_WARNING("Unable to interface: Connection timed out."))
		else
			to_chat(user, SPAN_WARNING("Unable to interface: Connection refused."))
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
				normalspeed = FALSE
			else if (!activate && !src.normalspeed)
				normalspeed = TRUE
		if("lights")
			// Lights
			if(src.isWireCut(AIRLOCK_WIRE_LIGHT))
				to_chat(usr, "The lights wire is cut - The door lights are permanently disabled.")
			else if (!activate && src.lights)
				lights = FALSE
				to_chat(usr, "The door lights have been disabled.")
			else if (activate && !src.lights)
				lights = TRUE
				to_chat(usr, "The door lights have been enabled.")

	update_icon()
	return 1

//returns 1 on success, 0 on failure
/obj/machinery/door/airlock/proc/cut_bolts(obj/item/item, mob/user)
	var/cut_delay = (15 SECONDS)
	var/cut_verb
	var/cut_sound

	if(isWelder(item))
		var/obj/item/weldingtool/WT = item
		if(!WT.remove_fuel(3,user))
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
			SPAN_DANGER("\The [user] smashes the bolt cover open!"),
			SPAN_WARNING("You smash the bolt cover open!")
			)
		playsound(src, 'sound/weapons/smash.ogg', 100, 1)
		src.lock_cut_state = BOLTS_EXPOSED
		return 0

	else
		// I guess you can't cut bolts with that item. Never mind then.
		return 0

	if (src.lock_cut_state == BOLTS_FINE)
		user.visible_message(
			SPAN_NOTICE("\The [user] begins [cut_verb] through the bolt cover on [src]."),
			SPAN_NOTICE("You begin [cut_verb] through the bolt cover.")
			)

		playsound(src, cut_sound, 100, 1)
		if (do_after(user, cut_delay, src, DO_REPAIR_CONSTRUCT))
			user.visible_message(
				SPAN_NOTICE("\The [user] removes the bolt cover from [src]"),
				SPAN_NOTICE("You remove the cover and expose the door bolts.")
				)
			src.lock_cut_state = BOLTS_EXPOSED
		return 1

	if (src.lock_cut_state == BOLTS_EXPOSED)
		user.visible_message(
			SPAN_NOTICE("\The [user] begins [cut_verb] through [src]'s bolts."),
			SPAN_NOTICE("You begin [cut_verb] through the door bolts.")
			)
		playsound(src, cut_sound, 100, 1)
		if (do_after(user, cut_delay, src, DO_REPAIR_CONSTRUCT))
			user.visible_message(
				SPAN_NOTICE("\The [user] severs the door bolts, unlocking [src]."),
				SPAN_NOTICE("You sever the door bolts, unlocking the door.")
				)
			src.lock_cut_state = BOLTS_CUT
			src.unlock(1) //force it
		return 1

/obj/machinery/door/airlock/use_tool(obj/item/C, mob/living/user, list/click_params)
	// Brace is considered installed on the airlock, so interacting with it is protected from electrification.
	if(brace && C && (istype(C.GetIdCard(), /obj/item/card/id) || istype(C, /obj/item/material/twohanded/jack)))
		return brace.attackby(C, user)

	if(!brace && istype(C, /obj/item/airlock_brace))
		var/obj/item/airlock_brace/A = C
		if(!density)
			to_chat(user, SPAN_WARNING("You must close \the [src] before installing \the [A]!"))
			return TRUE

		if(!length(A.req_access) && (alert("\the [A]'s 'Access Not Set' light is flashing. Install it anyway?", "Access not set", "Yes", "No") == "No"))
			return TRUE

		playsound(user, 'sound/machines/lockreset.ogg', 50, 1)
		if(do_after(user, 6 SECONDS, src, DO_REPAIR_CONSTRUCT) && density && A && user.unEquip(A, src))
			to_chat(user, SPAN_NOTICE("You successfully install \the [A]."))
			brace = A
			brace.airlock = src
			update_icon()
		return TRUE

	if(!istype(user, /mob/living/silicon))
		if(isElectrified())
			if(shock(user, 75))
				return TRUE

	if (!repairing && MACHINE_IS_BROKEN(src) && locked) //bolted and broken
		if (cut_bolts(C,user))
			return TRUE

	if (!repairing && isWelder(C) && operating != DOOR_OPERATING_YES && density)
		var/obj/item/weldingtool/W = C
		if(!W.can_use(1, user))
			return TRUE
		playsound(src, 'sound/items/Welder.ogg', 50, 1)
		user.visible_message(SPAN_WARNING("\The [user] begins welding \the [src] [welded ? "open" : "closed"]!"),
							SPAN_NOTICE("You begin welding \the [src] [welded ? "open" : "closed"]."))
		if(do_after(user, (rand(3,5)) SECONDS, src, DO_REPAIR_CONSTRUCT))
			if (density && operating != DOOR_OPERATING_YES && !repairing && W.remove_fuel(1, user))
				playsound(src, 'sound/items/Welder2.ogg', 50, 1)
				welded = !welded
				update_icon()
				return TRUE
		else
			to_chat(user, SPAN_NOTICE("You must remain still to complete this task."))
			return TRUE

	if (isScrewdriver(C))
		if (p_open)
			if (MACHINE_IS_BROKEN(src))
				to_chat(user, SPAN_WARNING("The panel is broken, and cannot be closed."))
				return TRUE
			else
				p_open = FALSE
				user.visible_message(SPAN_NOTICE("[user.name] closes the maintenance panel on \the [src]."), SPAN_NOTICE("You close the maintenance panel on \the [src]."))
				playsound(src.loc, "sound/items/Screwdriver.ogg", 20)
				update_icon()
				return TRUE
		else
			p_open = TRUE
			user.visible_message(SPAN_NOTICE("[user.name] opens the maintenance panel on \the [src]."), SPAN_NOTICE("You open the maintenance panel on \the [src]."))
			playsound(src.loc, "sound/items/Screwdriver.ogg", 20)
			update_icon()
			return TRUE

	if (isWirecutter(C) || isMultitool(C) || istype(C, /obj/item/device/assembly/signaler))
		return attack_hand(user)

	if (istype(C, /obj/item/pai_cable))
		var/obj/item/pai_cable/cable = C
		cable.resolve_attackby(src, user)

	if (!repairing && isCrowbar(C))
		if (p_open && (operating == DOOR_OPERATING_BROKEN || (!operating && welded && !arePowerSystemsOn() && density && !locked)) && !brace)
			playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
			user.visible_message("\The [user] starts removing the electronics from the airlock assembly.", "You start to remove electronics from the airlock assembly.")
			if(do_after(user, 4 SECONDS, src, DO_REPAIR_CONSTRUCT))
				to_chat(user, SPAN_NOTICE("You've removed the airlock electronics!"))
				deconstruct(user)
				return TRUE
		else if(arePowerSystemsOn())
			to_chat(user, SPAN_NOTICE("The airlock's motors resist your efforts to force it."))
			return TRUE
		else if(locked)
			to_chat(user, SPAN_NOTICE("The airlock's bolts prevent it from being forced."))
			return TRUE
		else if(brace)
			to_chat(user, SPAN_NOTICE("The airlock's brace holds it firmly in place."))
			return TRUE
		else
			if(density)
				spawn(0)	open(1)
				return TRUE
			else
				spawn(0)	close(1)
				return TRUE

			//if door is unbroken, hit with fire axe using harm intent
	if (istype(C, /obj/item/material/twohanded/fireaxe) && !MACHINE_IS_BROKEN(src) && user.a_intent == I_HURT)
		var/obj/item/material/twohanded/fireaxe/F = C
		if (F.wielded)
			playsound(src, 'sound/weapons/smash.ogg', 100, 1)
			if (damage_health(F.force_wielded * 2, F.damtype))
				user.visible_message(SPAN_DANGER("[user] smashes \the [C] into the airlock's control panel! It explodes in a shower of sparks!"), SPAN_DANGER("You smash \the [C] into the airlock's control panel! It explodes in a shower of sparks!"))
			else
				user.visible_message(SPAN_DANGER("[user] smashes \the [C] into the airlock's control panel!"))
			return TRUE

	if (istype(C, /obj/item/material/twohanded/fireaxe) && !arePowerSystemsOn())
		if(locked)
			to_chat(user, SPAN_NOTICE("The airlock's bolts prevent it from being forced."))
			return TRUE
		else if(!welded && !operating )
			if(density)
				var/obj/item/material/twohanded/fireaxe/F = C
				if(F.wielded)
					spawn(0)	open(1)
				else
					to_chat(user, SPAN_WARNING("You need to be wielding \the [C] to do that."))
				return TRUE
			else
				var/obj/item/material/twohanded/fireaxe/F = C
				if(F.wielded)
					spawn(0)	close(1)
				else
					to_chat(user, SPAN_WARNING("You need to be wielding \the [C] to do that."))
				return TRUE

	return ..()

/obj/machinery/door/airlock/deconstruct(mob/user, moved = FALSE)
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
		var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
		s.set_up(5, 1, src)
		s.start()
	else
		da.anchored = TRUE
	da.state = 1
	da.created_name = src.name
	da.update_state()

	if (operating == DOOR_OPERATING_BROKEN || MACHINE_IS_BROKEN(src))
		new /obj/item/stock_parts/circuitboard/broken(src.loc)
		operating = DOOR_OPERATING_NO
	else
		if (!electronics)
			create_electronics()

		electronics.dropInto(loc)
		electronics = null

	qdel(src)

	return da
/obj/machinery/door/airlock/phoron/use_tool(obj/item/C, mob/living/user, list/click_params)
	ignite(C.IsHeatSource())
	..()

/obj/machinery/door/airlock/set_broken(new_state)
	. = ..()
	if(. && new_state)
		p_open = TRUE
		if (secured_wires)
			lock()
		visible_message("\The [src]'s control panel bursts open, sparks spewing out!")
		var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
		s.set_up(5, 1, src)
		s.start()

/obj/machinery/door/airlock/open(forced=0)
	if(!can_open(forced))
		return 0
	use_power_oneoff(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people

	//if the door is unpowered then it doesn't make sense to hear the woosh of a pneumatic actuator
	if(arePowerSystemsOn())
		playsound(src.loc, open_sound_powered, 100, 1)
	else
		playsound(src.loc, open_sound_unpowered, 100, 1)

	return ..()

/obj/machinery/door/airlock/can_open(forced=0)
	if(brace)
		return 0

	if(!forced)
		if(!arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_OPEN_DOOR))
			return 0

	if(locked || welded)
		return 0
	return ..()

/obj/machinery/door/airlock/can_close(forced=0)
	if(locked || welded)
		return 0

	if(!forced)
		//despite the name, this wire is for general door control.
		if(!arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_OPEN_DOOR))
			return	0

	return ..()

/obj/machinery/door/airlock/close(forced=0)
	if(!can_close(forced))
		return 0

	if(safe)
		for(var/turf/turf in locs)
			for(var/atom/movable/AM in turf)
				if(AM.blocks_airlock())
					close_door_at = world.time + 6
					return

	var/crushed = FALSE
	for(var/turf/turf in locs)
		for(var/atom/movable/AM in turf)
			if (AM != src && AM.airlock_can_crush())
				AM.airlock_crush(door_crush_damage)
				crushed = TRUE
	if (crushed)
		damage_health(door_crush_damage, DAMAGE_BRUTE)
		use_power_oneoff(door_crush_damage * 100)		// Uses bunch extra power for crushing the target.

	use_power_oneoff(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people
	if(arePowerSystemsOn())
		playsound(src.loc, close_sound_powered, 100, 1)
	else
		playsound(src.loc, close_sound_unpowered, 100, 1)

	..()

/obj/machinery/door/airlock/proc/lock(forced=0)
	if(locked)
		return 0

	if (operating && !forced) return 0

	if (lock_cut_state == BOLTS_CUT) return 0 //what bolts?

	locked = TRUE
	playsound(src, bolts_dropping, 30, 0, -6)
	audible_message("You hear a click from the bottom of the door.", hearing_distance = 1)
	update_icon()
	return 1

/obj/machinery/door/airlock/proc/unlock(forced=0)
	if(!src.locked)
		return

	if (!forced)
		if(operating || !src.arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_DOOR_BOLTS))
			return

	locked = FALSE
	playsound(src, bolts_rising, 30, 0, -6)
	audible_message("You hear a click from the bottom of the door.", hearing_distance = 1)
	update_icon()
	return 1

/obj/machinery/door/airlock/proc/toggle_lock(forced = 0)
	return locked ? unlock() : lock()

/obj/machinery/door/airlock/allowed(mob/M)
	if(locked)
		return 0
	if (issilicon(M))
		if (ai_control_disabled)
			return FALSE
	return ..(M)

/obj/machinery/door/airlock/New(newloc, obj/structure/door_assembly/assembly=null)
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
		secured_wires = TRUE
	if (secured_wires)
		wires = new/datum/wires/airlock/secure(src)
	else
		wires = new/datum/wires/airlock(src)

/obj/machinery/door/airlock/Initialize()
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
		paintable |= AIRLOCK_PAINTABLE_WINDOW
		window_material = SSmaterials.get_material_by_name(init_material_window)
		if (!window_color)
			window_color = window_material.icon_colour
	. = ..()

/obj/machinery/door/airlock/Destroy()
	if(brace)
		qdel(brace)
	return ..()

/obj/machinery/door/airlock/create_electronics(electronics_type = /obj/item/airlock_electronics)
	if (secured_wires)
		electronics_type = /obj/item/airlock_electronics/secure
	electronics = ..()
	return electronics

/obj/machinery/door/airlock/power_change() //putting this is obj/machinery/door itself makes non-airlock doors turn invisible for some reason
	. = ..()
	if(!is_powered())
		// If we lost power, disable electrification
		electrified_until = 0

/obj/machinery/door/airlock/proc/prison_open()
	if (!arePowerSystemsOn())
		return
	unlock(TRUE)
	open(TRUE)
	lock(TRUE)

/obj/machinery/door/airlock/get_material_melting_point()
	. = ..()
	if (window_material)
		. = round((. + window_material.melting_point) / 2)

// Braces can act as an extra layer of armor - they will take damage first.
/obj/machinery/door/airlock/damage_health(damage, damage_type, damage_flags, severity, skip_can_damage_check)
	if (brace)
		brace.damage_health(damage, damage_type, damage_flags, severity, skip_can_damage_check)
		return FALSE
	return ..()

/obj/machinery/door/airlock/examine(mob/user)
	. = ..()
	if (lock_cut_state == BOLTS_EXPOSED)
		to_chat(user, "The bolt cover has been cut open.")
	if (lock_cut_state == BOLTS_CUT)
		to_chat(user, "The door bolts have been cut.")
	if(brace)
		to_chat(user, "\The [brace] is installed on \the [src], preventing it from opening.")
		brace.examine_damage_state(user)

/obj/machinery/door/airlock/autoname

/obj/machinery/door/airlock/autoname/New()
	var/area/A = get_area(src)
	name = A.name
	..()

/obj/machinery/door/airlock/proc/paint_airlock(paint_color)
	door_color = paint_color
	update_icon()

/obj/machinery/door/airlock/proc/stripe_airlock(paint_color)
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

/singleton/public_access/public_method/airlock_toggle_bolts
	name = "toggle bolts"
	desc = "Toggles whether the airlock is bolted or not, if possible."
	call_proc = /obj/machinery/door/airlock/proc/toggle_lock

/singleton/stock_part_preset/radio/receiver/airlock
	frequency = AIRLOCK_FREQ
	receive_and_call = list(
		"toggle_door" = /singleton/public_access/public_method/toggle_door,
		"toggle_bolts" = /singleton/public_access/public_method/airlock_toggle_bolts
	)
