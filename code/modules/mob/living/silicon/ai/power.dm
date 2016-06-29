#define POWER_RESTORE_MAX_ATTEMPTS 3

// Values represented as Oxyloss. Can be tweaked, but make sure to use integers only.
#define AI_POWERUSAGE_LOWPOWER 1
#define AI_POWERUSAGE_RESTORATION 2
#define AI_POWERUSAGE_NORMAL 5
#define AI_POWERUSAGE_RECHARGING 7

// Above values get multiplied by this when converting oxyloss -> watts.
// For now, one oxyloss point equals 10kJ of energy, so normal AI uses 5 oxyloss per tick (50kW or 70kW if charging)
#define AI_POWERUSAGE_OXYLOSS_TO_WATTS_MULTIPLIER 10000

// This is the main power restoration sequence. Only one sequence per AI can exist.
/mob/living/silicon/ai/proc/handle_power_failure()
	// Power restoration routine already running in other spawn(). Don't start it again.
	if(aiRestorePowerRoutine != 1)
		return

	src << "<span class='danger'>Main power lost. System switched to internal capacitor. Beginning diagnostics.</span>"
	var/obj/machinery/power/apc/theAPC = null
	var/connection_failures = 0
	while(aiRestorePowerRoutine)
		if(aiRestorePowerRoutine > -1)
			aiRestorePowerRoutine++

		sleep(5 SECONDS)

		if(has_power(0))
			src << "<span class='notice'>Main power restored. All systems returning to normal mode.</span>"
			aiRestorePowerRoutine = 0
			updateicon()
			return

		if(aiRestorePowerRoutine == -1)
			continue

		switch(aiRestorePowerRoutine)
			// 1 and 2 are fluff only things.
			if(2)
				src << "<span class='notice'>Diagnostics completed. Failure confirmed: Main power connection nonfunctional.</span>"
				continue
			if(3)
				src << "<span class='notice'>Attempting to connect to area power controller.</span>"
				continue
			// step 3 tries to locate an APC. It tries up to three times before failing, relying on external influence to restore power only.
			if(4)
				var/area/A = get_area(src)
				theAPC = A.get_apc()

				if(!istype(theAPC))
					src << "<span class='notice'>Error processing connection to APC: Attempt [connection_failures+1]/[POWER_RESTORE_MAX_ATTEMPTS]</span>"
					connection_failures++
					if(connection_failures == POWER_RESTORE_MAX_ATTEMPTS)
						aiRestorePowerRoutine = -1
						src << "<span class='danger'>Unable to connect to APC after [POWER_RESTORE_MAX_ATTEMPTS] attempts. Aborting power restoration sequence.</span>"
						continue
					aiRestorePowerRoutine--
					continue
				src << "<span class='notice'>APC connection confirmed: [theAPC]. Sending emergency reset signal...</span>"
				continue
			// step 4 tries to reset the APC, if we still have connection to it.
			if(5)
				// The APC was destroyed since last step
				if(!istype(theAPC))
					src << "<span class='danger'>Connection to APC lost. Attempting to re-connect.</span>"
					aiRestorePowerRoutine = 2
					connection_failures = 0
					continue
				// Our area has changed.
				if(get_area(src) != get_area(theAPC))
					src << "<span class='danger'>APC change detected. Attempting to locate new APC.</span>"
					aiRestorePowerRoutine = 2
					connection_failures = 0
					continue
				// The APC is damaged
				if(theAPC.stat & BROKEN)
					src << "<span class='danger'>APC internal diagnostics reports hardware failure. Unable to reset. Aborting power restoration sequence.</span>"
					aiRestorePowerRoutine = -1
					continue
				// APC's cell is removed and/or below 1% charge. This prevents the AI from briefly regaining power as we force the APC on, only to lose it again next tick due to 0% cell charge.
				if(theAPC.cell && theAPC.cell.percent() < 1)
					src << "<span class='danger'>APC internal power reserves are critical. Unable to restore main power.</span>"
					aiRestorePowerRoutine = -1
					continue
				// Success!
				src << "<span class='notice'>Reset signal successfully transmitted. Sequence completed.</span>"
				reset_apc(theAPC)



// Handles all necessary power checks: Area power, Intellicard and Malf AI APU power and manual override.
/mob/living/silicon/ai/proc/has_power(var/respect_override = 1)
	var/area/current_area = get_area(src)
	if(current_area && (current_area.power_equip || current_area.requires_power == 0))
		return 1
	if(istype(src.loc,/obj/item))
		return 1
	if(APU_power || admin_powered)
		return 1
	if(respect_override && power_override_active)
		return 1
	return 0

// Resets passed APC so the AI may function again.
/mob/living/silicon/ai/proc/reset_apc(var/obj/machinery/power/apc/A)
	if(!istype(A))
		return

	A.operating = 1
	A.equipment = 3
	A.failure_timer = 0
	A.update()

	updateicon()

/mob/living/silicon/ai/proc/calculate_power_usage()
	if(admin_powered)
		return 0

	if(self_shutdown)
		return AI_POWERUSAGE_LOWPOWER

	if(aiRestorePowerRoutine && power_override_active)
		return AI_POWERUSAGE_NORMAL
	else if(aiRestorePowerRoutine == -1)
		return AI_POWERUSAGE_LOWPOWER
	else if(aiRestorePowerRoutine)
		return AI_POWERUSAGE_RESTORATION

	if(oxyloss)
		return AI_POWERUSAGE_RECHARGING
	return AI_POWERUSAGE_NORMAL

/mob/living/silicon/ai/proc/update_power_usage()
	var/newusage = calculate_power_usage()
	newusage *= AI_POWERUSAGE_OXYLOSS_TO_WATTS_MULTIPLIER
	if(psupply)
		psupply.active_power_usage = newusage

/mob/living/silicon/ai/proc/handle_power_oxyloss()
	// Powered, lose oxyloss
	if(has_power(0))
		// Self-shutdown mode uses only 10kW, so we don't have any spare power to charge.
		if(!self_shutdown)
			adjustOxyLoss(AI_POWERUSAGE_NORMAL - AI_POWERUSAGE_RECHARGING)
		return

	// Not powered. Gain oxyloss depeding on our power usage.
	adjustOxyLoss(calculate_power_usage())

// This verb allows the AI to disable or enable the power override mode.
/mob/living/silicon/ai/proc/ai_power_override()
	set category = "Silicon Commands"
	set name = "Toggle Power Override"
	set desc = "Allows you to enable or disable power override, which lets you function without external power, at the cost of quickly expending your internal battery charge."

	power_override_active = !power_override_active

	if(power_override_active)
		src << "You have enabled power override. Should you lose power you will remain normally operational, but your backup capacitor will run out much faster."
	else
		src << "You have disabled power override. Should you lose power you will enter diagnostics and low power mode, which will prolong the time for which you can remain operational."

// This verb allows the AI to disable or enable the power override mode.
/mob/living/silicon/ai/proc/ai_shutdown()
	set category = "Silicon Commands"
	set name = "Shutdown"
	set desc = "Allows you to shut yourself down, sacrificing most functions for considerably reduced power usage."

	if(self_shutdown)
		src << "<span class='notice'>System rebooted. Camera, communication and network systems operational.</span>"
		self_shutdown = 0
		return

	var/confirm = alert("Are you sure that you want to shut yourself down? You can reboot yourself later by using the \"Shutdown\" command again. This will put you into reduced power usage mode, at the cost of losing most functions.", "Confirm Shutdown", "Yes", "No")

	if(confirm == "Yes")
		src << "<span class='notice'>Shutting down. Minimal power mode: Enabled. You may reboot yourself by using the \"Shutdown\" command again.</span>"
		self_shutdown = 1
		return




/*
	The AI Power supply is a dummy object used for powering the AI since only machinery should be using power.
	The alternative was to rewrite a bunch of AI code instead here we are.
*/
/obj/machinery/ai_powersupply
	name="Power Supply"
	active_power_usage = AI_POWERUSAGE_NORMAL * AI_POWERUSAGE_OXYLOSS_TO_WATTS_MULTIPLIER
	use_power = 2
	power_channel = EQUIP
	var/mob/living/silicon/ai/powered_ai = null
	invisibility = 100

/obj/machinery/ai_powersupply/New(var/mob/living/silicon/ai/ai=null)
	powered_ai = ai
	powered_ai.psupply = src
	forceMove(powered_ai.loc)

	..()

/obj/machinery/ai_powersupply/Destroy()
	. = ..()
	powered_ai = null

/obj/machinery/ai_powersupply/process()
	if(!powered_ai || powered_ai.stat == DEAD)
		qdel(src)
		return
	if(powered_ai.psupply != src) // For some reason, the AI has different powersupply object. Delete this one, it's no longer needed.
		qdel(src)
		return
	if(powered_ai.loc != src.loc)
		forceMove(powered_ai.loc)
	if(powered_ai.APU_power || powered_ai.admin_powered || istype(powered_ai.loc, /obj/item/))
		use_power = 0
		return
	use_power = 2