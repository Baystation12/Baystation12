/datum/malf_hardware
	var/name = ""								// Hardware name
	var/desc = ""
	var/driver = null							// Driver - if not null this verb is given to the AI to control hardware
	var/mob/living/silicon/ai/owner = null		// AI which owns this.

/datum/malf_hardware/proc/install()
	if(owner && istype(owner))
		owner.hardware = src
		if(driver)
			owner.verbs += driver

/datum/malf_hardware/proc/get_examine_desc()
	return "It has some sort of hardware attached to its core"



// HARDWARE DEFINITIONS
/datum/malf_hardware/apu_gen
	name = "APU Generator"
	desc = "Auxiliary Power Unit that will keep you operational even without external power. Has to be manually activated. When APU is operational most abilities will be unavailable, and ability research will temporarily stop."
	driver = /datum/game_mode/malfunction/verb/ai_toggle_apu

/datum/malf_hardware/apu_gen/get_examine_desc()
	var/msg = "It seems to have some sort of power generator attached to its core."
	if(owner.hardware_integrity() < 50)
		msg += "<span class='warning'> It seems to be too damaged to function properly.</span>"
	else if(owner.APU_power)
		msg += " The generator appears to be active."
	return msg

/datum/malf_hardware/dual_cpu
	name = "Secondary Processor Unit"
	desc = "Secondary coprocessor that increases amount of generated CPU power by 50%"

/datum/malf_hardware/dual_cpu/get_examine_desc()
	return "It seems to have an additional CPU connected to it's core."

/datum/malf_hardware/dual_ram
	name = "Secondary Memory Bank"
	desc = "Expanded memory cells which allow you to store double amount of CPU time."

/datum/malf_hardware/dual_ram/get_examine_desc()
	return "It seems to have additional memory blocks connected to it's core."

/datum/malf_hardware/core_bomb
	name = "Self-Destruct Explosives"
	desc = "High yield explosives are attached to your physical mainframe. This hardware comes with special driver that allows activation of these explosives. Timer is set to 15 seconds after manual activation. This is a doomsday device that will destroy both you and any intruders in your core."
	driver = /datum/game_mode/malfunction/verb/ai_self_destruct

/datum/malf_hardware/core_bomb/get_examine_desc()
	return "<span class='warning'>It seems to have grey blocks of unknown substance and some circuitry connected to it's core. [owner.bombing_core ? "A red light is blinking on the circuit." : ""]</span>"

/datum/malf_hardware/strong_turrets
	name = "Turrets Focus Enhancer"
	desc = "Turrets are upgraded to have larger rate of fire and much larger damage. This however massively increases power usage when firing."

/datum/malf_hardware/strong_turrets/get_examine_desc()
	return "It seems to have extra wiring running from it's core to nearby turrets."

/datum/malf_hardware/strong_turrets/install()
	..()
	for(var/obj/machinery/turret/T in machines)
		T.maxhealth = round(initial(T.maxhealth) * 1.4)
		T.shot_delay = round(initial(T.shot_delay) / 2)
		T.auto_repair = 1
		T.active_power_usage = round(initial(T.active_power_usage) * 5)
	for(var/obj/machinery/porta_turret/T in machines)
		T.maxhealth = round(initial(T.maxhealth) * 1.4)
		T.shot_delay = round(initial(T.shot_delay) / 2)
		T.auto_repair = 1
		T.active_power_usage = round(initial(T.active_power_usage) * 5)