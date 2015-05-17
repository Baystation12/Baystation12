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


// HARDWARE DEFINITIONS
/datum/malf_hardware/apu_gen
	name = "APU Generator"
	desc = "Auxiliary Power Unit that will keep you operational even without external power. Has to be manually activated. When APU is operational most abilities will be unavailable, and ability research will temporarily stop."

/datum/malf_hardware/dual_cpu
	name = "Secondary Processor Unit"
	desc = "Secondary coprocessor that increases amount of generated CPU power by 50%"

/datum/malf_hardware/dual_ram
	name = "Secondary Memory Bank"
	desc = "Expanded memory cells which allow you to store double amount of CPU time."

/datum/malf_hardware/core_bomb
	name = "Self-Destruct Explosives"
	desc = "High yield explosives are attached to your physical mainframe. This hardware comes with special driver that allows activation of these explosives. Timer is set to 15 seconds after manual activation. This is a doomsday device that will destroy both you and any intruders in your core."

/datum/malf_hardware/strong_turrets
	name = "Turrets Focus Enhancer"
	desc = "Turrets are upgraded to have larger rate of fire and much larger damage. This however massively increases power usage when firing."