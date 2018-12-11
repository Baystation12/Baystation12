// Wires for airlocks

/datum/wires/airlock/secure
	random = 1
	wire_count = 14
	window_y = 680

/datum/wires/airlock
	holder_type = /obj/machinery/door/airlock
	wire_count = 12
	window_y = 570
	descriptions = list(
		new /datum/wire_description(AIRLOCK_WIRE_IDSCAN, "This wire is connected to the ID scanning panel.", SKILL_EXPERT),
		new /datum/wire_description(AIRLOCK_WIRE_MAIN_POWER1, "This wire seems to be carrying a heavy current."),
		new /datum/wire_description(AIRLOCK_WIRE_MAIN_POWER2, "This wire seems to be carrying a heavy current."),
		new /datum/wire_description(AIRLOCK_WIRE_DOOR_BOLTS, "This wire runs down to the very base of the airlock."),
		new /datum/wire_description(AIRLOCK_WIRE_BACKUP_POWER1, "This wire seems to be carrying a heavy current."),
		new /datum/wire_description(AIRLOCK_WIRE_BACKUP_POWER2, "This wire seems to be carrying a heavy current."),
		new /datum/wire_description(AIRLOCK_WIRE_OPEN_DOOR, "This wire connects to the door motors."),
		new /datum/wire_description(AIRLOCK_WIRE_AI_CONTROL, "This wire connects to automated control systems."),
		new /datum/wire_description(AIRLOCK_WIRE_ELECTRIFY, "This wire seems to be carrying a heavy current."),
		new /datum/wire_description(AIRLOCK_WIRE_SAFETY, "This wire connects to a safety override."),
		new /datum/wire_description(AIRLOCK_WIRE_SPEED, "This wire appears to connect to the airlock's proximity detector modules."),
		new /datum/wire_description(AIRLOCK_WIRE_LIGHT, "This wire powers the airlock's built-in lighting.", SKILL_EXPERT)
	)

var/const/AIRLOCK_WIRE_IDSCAN = 1
var/const/AIRLOCK_WIRE_MAIN_POWER1 = 2
var/const/AIRLOCK_WIRE_MAIN_POWER2 = 4
var/const/AIRLOCK_WIRE_DOOR_BOLTS = 8
var/const/AIRLOCK_WIRE_BACKUP_POWER1 = 16
var/const/AIRLOCK_WIRE_BACKUP_POWER2 = 32
var/const/AIRLOCK_WIRE_OPEN_DOOR = 64
var/const/AIRLOCK_WIRE_AI_CONTROL = 128
var/const/AIRLOCK_WIRE_ELECTRIFY = 256
var/const/AIRLOCK_WIRE_SAFETY = 512
var/const/AIRLOCK_WIRE_SPEED = 1024
var/const/AIRLOCK_WIRE_LIGHT = 2048

/datum/wires/airlock/CanUse(var/mob/living/L)
	var/obj/machinery/door/airlock/A = holder
	if(!istype(L, /mob/living/silicon))
		if(A.isElectrified())
			if(A.shock(L, 100))
				return 0
	if(A.p_open)
		return 1
	return 0

/datum/wires/airlock/GetInteractWindow(mob/user)
	var/obj/machinery/door/airlock/A = holder
	var/haspower = A.arePowerSystemsOn() //If there's no power, then no lights will be on.

	. += ..()
	. += text("<br>\n[]<br>\n[]<br>\n[]<br>\n[]<br>\n[]<br>\n[]<br>\n[]<br>\n[]",
	(A.locked ? "The door bolts have fallen!" : "The door bolts look up."),
	((A.lights && haspower) ? "The door bolt lights are on." : "The door bolt lights are off!"),
	((haspower) ? "The test light is on." : "The test light is off!"),
	((A.backup_power_lost_until) ? "The backup power light is off!" : "The backup power light is on."),
	((A.aiControlDisabled==0 && !A.emagged && haspower)? "The 'AI control allowed' light is on." : "The 'AI control allowed' light is off."),
	((A.safe==0 && haspower)? "The 'Check Wiring' light is on." : "The 'Check Wiring' light is off."),
	((A.normalspeed==0 && haspower)? "The 'Check Timing Mechanism' light is on." : "The 'Check Timing Mechanism' light is off."),
	((A.aiDisabledIdScanner==0 && haspower)? "The IDScan light is on." : "The IDScan light is off."))

/datum/wires/airlock/UpdateCut(var/index, var/mended)

	var/obj/machinery/door/airlock/A = holder
	switch(index)
		if(AIRLOCK_WIRE_IDSCAN)
			A.aiDisabledIdScanner = !mended
		if(AIRLOCK_WIRE_MAIN_POWER1, AIRLOCK_WIRE_MAIN_POWER2)

			if(!mended)
				//Cutting either one disables the main door power, but unless backup power is also cut, the backup power re-powers the door in 10 seconds. While unpowered, the door may be crowbarred open, but bolts-raising will not work. Cutting these wires may electocute the user.
				A.loseMainPower()
				A.shock(usr, 50)
			else
				A.regainMainPower()
				A.shock(usr, 50)

		if(AIRLOCK_WIRE_BACKUP_POWER1, AIRLOCK_WIRE_BACKUP_POWER2)

			if(!mended)
				//Cutting either one disables the backup door power (allowing it to be crowbarred open, but disabling bolts-raising), but may electocute the user.
				A.loseBackupPower()
				A.shock(usr, 50)
			else
				A.regainBackupPower()
				A.shock(usr, 50)

		if(AIRLOCK_WIRE_DOOR_BOLTS)

			if(!mended)
				//Cutting this wire also drops the door bolts, and mending it does not raise them. (This is what happens now, except there are a lot more wires going to door bolts at present)
				A.lock(1)
				A.update_icon()

		if(AIRLOCK_WIRE_AI_CONTROL)

			if(!mended)
				//one wire for AI control. Cutting this prevents the AI from controlling the door unless it has hacked the door through the power connection (which takes about a minute). If both main and backup power are cut, as well as this wire, then the AI cannot operate or hack the door at all.
				//aiControlDisabled: If 1, AI control is disabled until the AI hacks back in and disables the lock. If 2, the AI has bypassed the lock. If -1, the control is enabled but the AI had bypassed it earlier, so if it is disabled again the AI would have no trouble getting back in.
				if(A.aiControlDisabled == 0)
					A.aiControlDisabled = 1
				else if(A.aiControlDisabled == -1)
					A.aiControlDisabled = 2
			else
				if(A.aiControlDisabled == 1)
					A.aiControlDisabled = 0
				else if(A.aiControlDisabled == 2)
					A.aiControlDisabled = -1

		if(AIRLOCK_WIRE_ELECTRIFY)
			if(!mended)
				//Cutting this wire electrifies the door, so that the next person to touch the door without insulated gloves gets electrocuted.
				A.electrify(-1)
			else
				A.electrify(0)
			return // Don't update the dialog.

		if (AIRLOCK_WIRE_SAFETY)
			A.safe = mended

		if(AIRLOCK_WIRE_SPEED)
			A.autoclose = mended
			if(mended)
				if(!A.density)
					A.close()

		if(AIRLOCK_WIRE_LIGHT)
			A.lights = mended
			A.update_icon()


/datum/wires/airlock/UpdatePulsed(var/index)

	var/obj/machinery/door/airlock/A = holder
	switch(index)
		if(AIRLOCK_WIRE_IDSCAN)
			//Sending a pulse through flashes the red light on the door (if the door has power).
			if(A.arePowerSystemsOn() && A.density)
				A.do_animate("deny")
		if(AIRLOCK_WIRE_MAIN_POWER1, AIRLOCK_WIRE_MAIN_POWER2)
			//Sending a pulse through either one causes a breaker to trip, disabling the door for 10 seconds if backup power is connected, or 1 minute if not (or until backup power comes back on, whichever is shorter).
			A.loseMainPower()
		if(AIRLOCK_WIRE_DOOR_BOLTS)
			//one wire for door bolts. Sending a pulse through this drops door bolts if they're not down (whether power's on or not),
			//raises them if they are down (only if power's on)
			if(!A.locked)
				A.lock()
			else
				A.unlock()

		if(AIRLOCK_WIRE_BACKUP_POWER1, AIRLOCK_WIRE_BACKUP_POWER2)
			//two wires for backup power. Sending a pulse through either one causes a breaker to trip, but this does not disable it unless main power is down too (in which case it is disabled for 1 minute or however long it takes main power to come back, whichever is shorter).
			A.loseBackupPower()
		if(AIRLOCK_WIRE_AI_CONTROL)
			if(A.aiControlDisabled == 0)
				A.aiControlDisabled = 1
			else if(A.aiControlDisabled == -1)
				A.aiControlDisabled = 2

			spawn(10)
				if(A)
					if(A.aiControlDisabled == 1)
						A.aiControlDisabled = 0
					else if(A.aiControlDisabled == 2)
						A.aiControlDisabled = -1

		if(AIRLOCK_WIRE_ELECTRIFY)
			//one wire for electrifying the door. Sending a pulse through this electrifies the door for 30 seconds.
			A.electrify(30)
		if(AIRLOCK_WIRE_OPEN_DOOR)
			//tries to open the door without ID
			//will succeed only if the ID wire is cut or the door requires no access and it's not emagged
			if(A.emagged)	return
			if(!A.requiresID() || A.check_access(null))
				if(A.density)	A.open()
				else			A.close()
		if(AIRLOCK_WIRE_SAFETY)
			A.safe = !A.safe
			if(!A.density)
				A.close()

		if(AIRLOCK_WIRE_SPEED)
			A.normalspeed = !A.normalspeed

		if(AIRLOCK_WIRE_LIGHT)
			A.lights = !A.lights
			A.update_icon()