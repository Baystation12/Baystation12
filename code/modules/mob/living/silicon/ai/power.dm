

// Resets passed APC so the AI may function again.
/mob/living/silicon/ai/proc/reset_apc(var/obj/machinery/power/apc/A)
	if(!istype(A))
		return

	A.operating = 1
	A.equipment = 3
	A.failure_timer = 0
	A.update()

	update_icon()


/mob/living/silicon/ai/proc/handle_power_oxyloss()
	// Powered, lose oxyloss
	if(has_power(0))
		// Self-shutdown mode uses only 10kW, so we don't have any spare power to charge.
		if(!self_shutdown || carded)
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
		to_chat(src, "You have enabled power override. Should you lose power you will remain normally operational, but your backup capacitor will run out much faster.")
	else
		to_chat(src, "You have disabled power override. Should you lose power you will enter diagnostics and low power mode, which will prolong the time for which you can remain operational.")

// This verb allows the AI to disable or enable the power override mode.
/mob/living/silicon/ai/proc/ai_shutdown()
	set category = "Silicon Commands"
	set name = "Shutdown"
	set desc = "Allows you to shut yourself down, sacrificing most functions for considerably reduced power usage."

	if(self_shutdown)
		to_chat(src, "<span class='notice'>System rebooted. Camera, communication and network systems operational.</span>")
		self_shutdown = 0
		return

	var/confirm = alert("Are you sure that you want to shut yourself down? You can reboot yourself later by using the \"Shutdown\" command again. This will put you into reduced power usage mode, at the cost of losing most functions.", "Confirm Shutdown", "Yes", "No")

	if(confirm == "Yes")
		to_chat(src, "<span class='notice'>Shutting down. Minimal power mode: Enabled. You may reboot yourself by using the \"Shutdown\" command again.</span>")
		self_shutdown = 1
		return


/mob/living/silicon/ai/proc/create_powersupply()
	if(psupply)
		qdel(psupply)
	psupply = new/obj/machinery/ai_powersupply(src)


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
	forceMove(powered_ai)
	..()

/obj/machinery/ai_powersupply/Destroy()
	. = ..()
	powered_ai = null

/obj/machinery/ai_powersupply/proc/update_power_state()
	use_power = get_power_state()

/obj/machinery/ai_powersupply/proc/get_power_state()
	// Dead, powered by APU, admin power, or inside an item (inteliCard/IIS). No power usage.
	if(!powered_ai.stat == DEAD || powered_ai.APU_power || powered_ai.admin_powered || istype(powered_ai.loc, /obj/item/))
		return 0
	// Normal power usage.
	return 2

/obj/machinery/ai_powersupply/powered(var/chan = -1)
	return ..(chan, get_area(powered_ai))