#define BOLTS_FINE 0
#define BOLTS_EXPOSED 1
#define BOLTS_CUT 2
/obj/machinery/door/airlock
	name = "airlock"
	icon = 'icons/obj/doors/Doorint.dmi'
	icon_state = "door_closed"
	power_channel = ENVIRON

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
	var/lights = 1 // bolt lights show by default
	var/aiDisabledIdScanner = 0
	var/aiHacking = 0
	var/obj/machinery/door/airlock/closeOther = null
	var/closeOtherId = null
	var/lockdownbyai = 0
	autoclose = 1
	var/assembly_type = /obj/structure/door_assembly
	var/mineral = null
	var/justzap = 0
	var/safe = 1
	normalspeed = 1
	var/obj/item/weapon/airlock_electronics/electronics = null
	var/hasShocked = 0 //Prevents multiple shocks from happening
	var/secured_wires = 0
	var/datum/wires/airlock/wires = null

	var/open_sound_powered = 'sound/machines/airlock.ogg'
	var/open_sound_unpowered = 'sound/machines/airlock_creaking.ogg'
	var/open_failure_access_denied = 'sound/machines/buzz-two.ogg'

	var/close_sound_powered = 'sound/machines/AirlockClose.ogg'
	var/close_sound_unpowered = 'sound/machines/airlock_creaking.ogg'
	var/close_failure_blocked = 'sound/machines/triple_beep.ogg'

	var/bolts_dropping = 'sound/machines/BoltsDown.ogg'
	var/bolts_rising = 'sound/machines/BoltsUp.ogg'

	var/door_crush_damage = DOOR_CRUSH_DAMAGE

	var/_wifi_id
	var/datum/wifi/receiver/button/door/wifi_receiver
	var/obj/item/weapon/airlock_brace/brace = null

/obj/machinery/door/airlock/attack_generic(var/mob/user, var/damage)
	if(stat & (BROKEN|NOPOWER))
		if(damage >= 10)
			if(src.density)
				visible_message("<span class='danger'>\The [user] forces \the [src] open!</span>")
				open(1)
			else
				visible_message("<span class='danger'>\The [user] forces \the [src] closed!</span>")
				close(1)
		else
			visible_message("<span class='notice'>\The [user] strains fruitlessly to force \the [src] [density ? "open" : "closed"].</span>")
		return
	..()

/obj/machinery/door/airlock/get_material()
	if(mineral)
		return get_material_by_name(mineral)
	return get_material_by_name(DEFAULT_WALL_MATERIAL)

/obj/machinery/door/airlock/command
	name = "Airlock"
	icon = 'icons/obj/doors/Doorcom.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_com

/obj/machinery/door/airlock/security
	name = "Airlock"
	icon = 'icons/obj/doors/Doorsec.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_sec

/obj/machinery/door/airlock/engineering
	name = "Airlock"
	icon = 'icons/obj/doors/Dooreng.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_eng

/obj/machinery/door/airlock/medical
	name = "Airlock"
	icon = 'icons/obj/doors/Doormed.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_med

/obj/machinery/door/airlock/virology
	name = "Airlock"
	icon = 'icons/obj/doors/Doorviro.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_viro

/obj/machinery/door/airlock/maintenance
	name = "Maintenance Access"
	icon = 'icons/obj/doors/Doormaint.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_mai

/obj/machinery/door/airlock/external
	name = "External Airlock"
	icon = 'icons/obj/doors/Doorext.dmi'
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_ext

/obj/machinery/door/airlock/external/bolted
	icon_state = "door_locked"
	locked = 1

/obj/machinery/door/airlock/external/bolted/cycling
	frequency = 1379

/obj/machinery/door/airlock/external/bolted_open
	icon_state = "door_open"
	density = 0
	locked = 1
	opacity = 0

/obj/machinery/door/airlock/sol
	name = "Airlock"
	icon = 'icons/obj/doors/Doorsol.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_sol

/obj/machinery/door/airlock/glass
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Doorglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'

	open_sound_powered = 'sound/machines/windowdoor.ogg'
	close_sound_powered = 'sound/machines/windowdoor.ogg'

	door_crush_damage = DOOR_CRUSH_DAMAGE*0.75
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	glass = 1

/obj/machinery/door/airlock/centcom
	name = "Airlock"
	icon = 'icons/obj/doors/Doorele.dmi'
	opacity = 0

/obj/machinery/door/airlock/vault
	name = "Vault"
	icon = 'icons/obj/doors/vault.dmi'
	explosion_resistance = 20
	opacity = 1
	secured_wires = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity //Until somebody makes better sprites.

/obj/machinery/door/airlock/vault/bolted
	icon_state = "door_locked"
	locked = 1

/obj/machinery/door/airlock/freezer
	name = "Freezer Airlock"
	icon = 'icons/obj/doors/Doorfreezer.dmi'
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_fre

/obj/machinery/door/airlock/hatch
	name = "Airtight Hatch"
	icon = 'icons/obj/doors/Doorhatchele.dmi'
	explosion_resistance = 20
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_hatch

/obj/machinery/door/airlock/maintenance_hatch
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doorhatchmaint2.dmi'
	explosion_resistance = 20
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_mhatch

/obj/machinery/door/airlock/maintenance_hatch/bolted
	locked = 1
	icon_state = "door_locked"

/obj/machinery/door/airlock/glass_command
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doorcomglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_com
	glass = 1

/obj/machinery/door/airlock/glass_external
	name = "External Airlock"
	icon = 'icons/obj/doors/Doorextglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_ext
	glass = 1

/obj/machinery/door/airlock/glass_external/bolted
	icon_state = "door_locked"
	locked = 1

/obj/machinery/door/airlock/glass_external/bolted/cycling
	frequency = 1379

/obj/machinery/door/airlock/glass_external/bolted_open
	icon_state = "door_open"
	density = 0
	locked = 1
	opacity = 0

/obj/machinery/door/airlock/glass_engineering
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doorengglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_eng
	glass = 1

/obj/machinery/door/airlock/glass_security
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doorsecglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_sec
	glass = 1

/obj/machinery/door/airlock/glass_medical
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doormedglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_med
	glass = 1

/obj/machinery/door/airlock/glass_virology
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doorviroglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_viro
	glass = 1

/obj/machinery/door/airlock/glass_sol
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doorsolglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_sol
	glass = 1

/obj/machinery/door/airlock/mining
	name = "Mining Airlock"
	icon = 'icons/obj/doors/Doormining.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_min

/obj/machinery/door/airlock/atmos
	name = "Atmospherics Airlock"
	icon = 'icons/obj/doors/Dooratmo.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_atmo

/obj/machinery/door/airlock/research
	name = "Airlock"
	icon = 'icons/obj/doors/Doorresearch.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_research

/obj/machinery/door/airlock/glass_research
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doorresearchglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_research
	glass = 1
	heat_proof = 1

/obj/machinery/door/airlock/glass_mining
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doorminingglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_min
	glass = 1

/obj/machinery/door/airlock/glass_atmos
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Dooratmoglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_atmo
	glass = 1

/obj/machinery/door/airlock/gold
	name = "Gold Airlock"
	icon = 'icons/obj/doors/Doorgold.dmi'
	mineral = "gold"

/obj/machinery/door/airlock/silver
	name = "Silver Airlock"
	icon = 'icons/obj/doors/Doorsilver.dmi'
	mineral = "silver"

/obj/machinery/door/airlock/diamond
	name = "Diamond Airlock"
	icon = 'icons/obj/doors/Doordiamond.dmi'
	mineral = "diamond"

/obj/machinery/door/airlock/uranium
	name = "Uranium Airlock"
	desc = "And they said I was crazy."
	icon = 'icons/obj/doors/Dooruranium.dmi'
	mineral = "uranium"
	var/last_event = 0
	var/rad_power = 7.5

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
			radiation_repository.radiate(src, rad_power)
		last_event = world.time
	..()

/obj/machinery/door/airlock/phoron
	name = "Phoron Airlock"
	desc = "No way this can end badly."
	icon = 'icons/obj/doors/Doorphoron.dmi'
	mineral = "phoron"

/obj/machinery/door/airlock/phoron/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		PhoronBurn(exposed_temperature)

/obj/machinery/door/airlock/phoron/proc/ignite(exposed_temperature)
	if(exposed_temperature > 300)
		PhoronBurn(exposed_temperature)

/obj/machinery/door/airlock/phoron/proc/PhoronBurn(temperature)
	for(var/turf/simulated/floor/target_tile in range(2,loc))
		target_tile.assume_gas("phoron", 35, 400+T0C)
		spawn (0) target_tile.hotspot_expose(temperature, 400)
	for(var/turf/simulated/wall/W in range(3,src))
		W.burn((temperature/4))//Added so that you can't set off a massive chain reaction with a small flame
	for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
		D.ignite(temperature/4)
	new/obj/structure/door_assembly( src.loc )
	qdel(src)

/obj/machinery/door/airlock/sandstone
	name = "Sandstone Airlock"
	icon = 'icons/obj/doors/Doorsand.dmi'
	mineral = "sandstone"

/obj/machinery/door/airlock/science
	name = "Airlock"
	icon = 'icons/obj/doors/Doorsci.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_science

/obj/machinery/door/airlock/glass_science
	name = "Glass Airlocks"
	icon = 'icons/obj/doors/Doorsciglass.dmi'
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_science
	glass = 1

/obj/machinery/door/airlock/highsecurity
	name = "Secure Airlock"
	icon = 'icons/obj/doors/hightechsecurity.dmi'
	explosion_resistance = 20
	secured_wires = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity

/obj/machinery/door/airlock/highsecurity/bolted

	icon_state = "door_locked"
	locked = 1

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
					src.justzap = 1
					spawn (10)
						src.justzap = 0
					return
			else /*if(src.justzap)*/
				return
		else if(user.hallucination > 50 && prob(10) && src.operating == 0)
			to_chat(user, "<span class='danger'>You feel a powerful shock course through your body!</span>")
			user.adjustHalLoss(10)
			user.Stun(10)
			return
	..(user)

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


/obj/machinery/door/airlock/update_icon()
	set_light(0)
	if(overlays) overlays.Cut()
	if(density)
		if(locked && lights && src.arePowerSystemsOn())
			icon_state = "door_locked"
			set_light(2, 0.75, COLOR_RED_LIGHT)
		else
			icon_state = "door_closed"
		if(p_open || welded)
			overlays = list()
			if(p_open)
				overlays += image(icon, "panel_open")
			if (!(stat & NOPOWER))
				if(stat & BROKEN)
					overlays += image(icon, "sparks_broken")
				else if (health < maxhealth * 3/4)
					overlays += image(icon, "sparks_damaged")
			if(welded)
				overlays += image(icon, "welded")
		else if (health < maxhealth * 3/4 && !(stat & NOPOWER))
			overlays += image(icon, "sparks_damaged")
	else
		icon_state = "door_open"
		if(src.arePowerSystemsOn())
			set_light(2, 0.75, COLOR_LIME)
		if((stat & BROKEN) && !(stat & NOPOWER))
			overlays += image(icon, "sparks_open")

	if(brace)
		brace.update_icon()
		overlays += image(brace.icon, brace.icon_state)

/obj/machinery/door/airlock/do_animate(animation)
	switch(animation)
		if("opening")
			if(overlays) overlays.Cut()
			if(p_open)
				spawn(2) // The only work around that works. Downside is that the door will be gone for a millisecond.
					flick("o_door_opening", src)  //can not use flick due to BYOND bug updating overlays right before flicking
					update_icon()
			else
				flick("door_opening", src)//[stat ? "_stat":]
				update_icon()
		if("closing")
			if(overlays) overlays.Cut()
			if(p_open)
				spawn(2)
					flick("o_door_closing", src)
					update_icon()
			else
				flick("door_closing", src)
				update_icon()
		if("spark")
			if(density)
				flick("door_spark", src)
		if("deny")
			if(density && src.arePowerSystemsOn())
				flick("door_deny", src)
				if(secured_wires)
					playsound(src.loc, open_failure_access_denied, 50, 0)
	return

/obj/machinery/door/airlock/attack_ai(mob/user as mob)
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
	commands[++commands.len] = list("name" = "Bolt Lights",				"command"= "lights",				"active" = lights,					"enabled" = "Enabled",	"disabled" = "Disable",		"danger" = 0, "act" = 1)
	commands[++commands.len] = list("name" = "Safeties",				"command"= "safeties",				"active" = safe,					"enabled" = "Nominal",	"disabled" = "Overridden",	"danger" = 1, "act" = 0)
	commands[++commands.len] = list("name" = "Timing",					"command"= "timing",				"active" = normalspeed,				"enabled" = "Nominal",	"disabled" = "Overridden",	"danger" = 1, "act" = 0)
	commands[++commands.len] = list("name" = "Door State",				"command"= "open",					"active" = density,					"enabled" = "Closed",	"disabled" = "Opened", 		"danger" = 0, "act" = 0)

	data["commands"] = commands

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
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
			if (i.matter && (DEFAULT_WALL_MATERIAL in i.matter) && i.matter[DEFAULT_WALL_MATERIAL] > 0)
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()
	return ..()

/obj/machinery/door/airlock/attack_hand(mob/user as mob)
	if(!istype(usr, /mob/living/silicon))
		if(src.isElectrified())
			if(src.shock(user, 100))
				return

	if(src.p_open)
		user.set_machine(src)
		wires.Interact(user)
	else
		..(user)
	return

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
			// Bolt lights
			if(src.isWireCut(AIRLOCK_WIRE_LIGHT))
				to_chat(usr, "The bolt lights wire is cut - The door bolt lights are permanently disabled.")
			else if (!activate && src.lights)
				lights = 0
				to_chat(usr, "The door bolt lights have been disabled.")
			else if (activate && !src.lights)
				lights = 1
				to_chat(usr, "The door bolt lights have been enabled.")

	update_icon()
	return 1

//returns 1 on success, 0 on failure
/obj/machinery/door/airlock/proc/cut_bolts(item, var/mob/user)
	var/cut_delay = (15 SECONDS)
	var/cut_verb
	var/cut_sound

	if(istype(item,/obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = item
		if(!WT.isOn())
			return 0
		if(!WT.remove_fuel(0,user))
			to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
			return 0
		cut_verb = "cutting"
		cut_sound = 'sound/items/Welder.ogg'
	else if(istype(item,/obj/item/weapon/pickaxe/plasmacutter))
		cut_verb = "cutting"
		cut_sound = 'sound/items/Welder.ogg'
		cut_delay *= 0.66
	else if(istype(item,/obj/item/weapon/melee/energy/blade) || istype(item,/obj/item/weapon/melee/energy/sword))
		cut_verb = "slicing"
		cut_sound = "sparks"
		cut_delay *= 0.66
	else if(istype(item,/obj/item/weapon/circular_saw))
		cut_verb = "sawing"
		cut_sound = 'sound/weapons/circsawhit.ogg'
		cut_delay *= 1.5

	else if(istype(item,/obj/item/weapon/material/twohanded/fireaxe))
		//special case - zero delay, different message
		if (src.lock_cut_state == BOLTS_EXPOSED)
			return 0 //can't actually cut the bolts, go back to regular smashing
		var/obj/item/weapon/material/twohanded/fireaxe/F = item
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
	if(brace && (istype(C.GetIdCard(), /obj/item/weapon/card/id/) || istype(C, /obj/item/weapon/crowbar/brace_jack)))
		return brace.attackby(C, user)

	if(!brace && istype(C, /obj/item/weapon/airlock_brace))
		var/obj/item/weapon/airlock_brace/A = C
		if(!density)
			to_chat(user, "You must close \the [src] before installing \the [A]!")
			return

		if((!A.req_access.len && !A.req_one_access) && (alert("\the [A]'s 'Access Not Set' light is flashing. Install it anyway?", "Access not set", "Yes", "No") == "No"))
			return

		if(do_after(user, 50, src) && density)
			to_chat(user, "You successfully install \the [A]. \The [src] has been locked.")
			brace = A
			brace.airlock = src
			user.drop_from_inventory(brace)
			brace.forceMove(src)
			update_icon()
		return

	if(!istype(usr, /mob/living/silicon))
		if(src.isElectrified())
			if(src.shock(user, 75))
				return
	if(istype(C, /obj/item/taperoll))
		return

	src.add_fingerprint(user)

	if (!repairing && (stat & BROKEN) && src.locked) //bolted and broken
		if (!cut_bolts(C,user))
			..()
		return

	if(!repairing && (istype(C, /obj/item/weapon/weldingtool) && !( src.operating > 0 ) && src.density))
		var/obj/item/weapon/weldingtool/W = C
		if(W.remove_fuel(0,user))
			if(!src.welded)
				src.welded = 1
			else
				src.welded = null
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			src.update_icon()
			return
		else
			return
	else if(istype(C, /obj/item/weapon/screwdriver))
		if (src.p_open)
			if (stat & BROKEN)
				to_chat(usr, "<span class='warning'>The panel is broken and cannot be closed.</span>")
			else
				src.p_open = 0
		else
			src.p_open = 1
		src.update_icon()
	else if(istype(C, /obj/item/weapon/wirecutters))
		return src.attack_hand(user)
	else if(istype(C, /obj/item/device/multitool))
		return src.attack_hand(user)
	else if(istype(C, /obj/item/device/assembly/signaler))
		return src.attack_hand(user)
	else if(istype(C, /obj/item/weapon/pai_cable))	// -- TLE
		var/obj/item/weapon/pai_cable/cable = C
		cable.plugin(src, user)
	else if(!repairing && istype(C, /obj/item/weapon/crowbar))
		if(src.p_open && (operating < 0 || (!operating && welded && !src.arePowerSystemsOn() && density && !src.locked)) && !brace)
			playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
			user.visible_message("[user] removes the electronics from the airlock assembly.", "You start to remove electronics from the airlock assembly.")
			if(do_after(user,40,src))
				to_chat(user, "<span class='notice'>You removed the airlock electronics!</span>")
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

			//if door is unbroken, but at half health or less, hit with fire axe using harm intent
	else if (istype(C, /obj/item/weapon/material/twohanded/fireaxe) && !(stat & BROKEN) && (src.health <= src.maxhealth / 2) && user.a_intent == I_HURT)
		var/obj/item/weapon/material/twohanded/fireaxe/F = C
		if (F.wielded)
			playsound(src, 'sound/weapons/smash.ogg', 100, 1)
			user.visible_message("<span class='danger'>[user] smashes \the [C] into the airlock's control panel! It explodes in a shower of sparks!</span>", "<span class='danger'>You smash \the [C] into the airlock's control panel! It explodes in a shower of sparks!</span>")
			src.health = 0
			src.set_broken()
		else
			..()
			return

	else if(istype(C, /obj/item/weapon/material/twohanded/fireaxe) && !arePowerSystemsOn())
		if(locked)
			to_chat(user, "<span class='notice'>The airlock's bolts prevent it from being forced.</span>")
		else if( !welded && !operating )
			if(density)
				var/obj/item/weapon/material/twohanded/fireaxe/F = C
				if(F.wielded)
					spawn(0)	open(1)
				else
					to_chat(user, "<span class='warning'>You need to be wielding \the [C] to do that.</span>")
			else
				var/obj/item/weapon/material/twohanded/fireaxe/F = C
				if(F.wielded)
					spawn(0)	close(1)
				else
					to_chat(user, "<span class='warning'>You need to be wielding \the [C] to do that.</span>")

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

	if(moved)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
	else
		da.anchored = 1
	da.state = 1
	da.created_name = src.name
	da.update_state()

	if(operating == -1 || (stat & BROKEN))
		new /obj/item/weapon/circuitboard/broken(src.loc)
		operating = 0
	else
		if (!electronics) create_electronics()

		electronics.dropInto(loc)
		electronics = null

	qdel(src)

	return da
/obj/machinery/door/airlock/phoron/attackby(C as obj, mob/user as mob)
	if(C)
		ignite(is_hot(C))
	..()

/obj/machinery/door/airlock/set_broken()
	src.p_open = 1
	stat |= BROKEN
	if (secured_wires)
		lock()
	for (var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message("[src.name]'s control panel bursts open, sparks spewing out!")

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()

	update_icon()
	return

/obj/machinery/door/airlock/open(var/forced=0)
	if(!can_open(forced))
		return 0
	use_power(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people

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
				use_power(door_crush_damage * 100)		// Uses bunch extra power for crushing the target.

	use_power(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people
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
		secured_wires = electronics.secure
		if(electronics.one_access)
			req_access.Cut()
			req_one_access = src.electronics.conf_access
		else
			req_one_access.Cut()
			req_access = src.electronics.conf_access

		//get the name from the assembly
		if(assembly.created_name)
			name = assembly.created_name
		else
			name = "[istext(assembly.glass) ? "[assembly.glass] airlock" : assembly.base_name]"

		//get the dir from the assembly
		set_dir(assembly.dir)

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
	var/obj/item/weapon/airlock_brace/A = locate(/obj/item/weapon/airlock_brace) in T
	if(!brace && A)
		brace = A
		brace.airlock = src
		brace.forceMove(src)
		update_icon()
	. = ..()

/obj/machinery/door/airlock/Destroy()
	qdel(wires)
	wires = null
	qdel(wifi_receiver)
	wifi_receiver = null
	if(brace)
		qdel(brace)
	return ..()

// Most doors will never be deconstructed over the course of a round,
// so as an optimization defer the creation of electronics until
// the airlock is deconstructed
/obj/machinery/door/airlock/proc/create_electronics()
	//create new electronics
	if (secured_wires)
		src.electronics = new/obj/item/weapon/airlock_electronics/secure( src.loc )
	else
		src.electronics = new/obj/item/weapon/airlock_electronics( src.loc )

	//update the electronics to match the door's access
	if(!src.req_access)
		src.check_access()
	if(src.req_access.len)
		electronics.conf_access = src.req_access
	else if (src.req_one_access.len)
		electronics.conf_access = src.req_one_access
		electronics.one_access = 1

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

/obj/machinery/door/airlock/examine()
	. = ..()
	if (lock_cut_state == BOLTS_EXPOSED)
		to_chat(usr, "The bolt cover has been cut open.")
	if (lock_cut_state == BOLTS_CUT)
		to_chat(usr, "The door bolts have been cut.")
	if(brace)
		to_chat(usr, "\The [brace] is installed on \the [src], preventing it from opening.")
		to_chat(usr, brace.examine_health())

/obj/machinery/door/airlock/autoname
	name = "hatch"
	icon = 'icons/obj/doors/Doorhatchmaint2.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_mhatch

/obj/machinery/door/airlock/autoname/New()
	var/area/A = get_area(src)
	name = A.name
	..()