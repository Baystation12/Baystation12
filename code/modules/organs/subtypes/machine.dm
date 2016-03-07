// IPC limbs.
/obj/item/organ/external/head/ipc
	dislocated = -1
	can_intake_reagents = 0
	vital = 0
	max_damage = 50 //made same as arm, since it is not vital
	min_broken_damage = 30
	encased = null

/obj/item/organ/external/head/ipc/New()
	robotize("Morpheus Cyberkinetics")
	..()

/obj/item/organ/external/chest/ipc
	dislocated = -1
	encased = null
/obj/item/organ/external/chest/ipc/New()
	robotize("Morpheus Cyberkinetics")
	..()

/obj/item/organ/external/groin/ipc
	dislocated = -1
/obj/item/organ/external/groin/ipc/New()
	robotize("Morpheus Cyberkinetics")
	..()

/obj/item/organ/external/arm/ipc
	dislocated = -1
/obj/item/organ/external/arm/ipc/New()
	robotize("Morpheus Cyberkinetics")
	..()

/obj/item/organ/external/arm/right/ipc
	dislocated = -1
/obj/item/organ/external/arm/right/ipc/New()
	robotize("Morpheus Cyberkinetics")
	..()

/obj/item/organ/external/leg/ipc
	dislocated = -1
/obj/item/organ/external/leg/ipc/New()
	robotize("Morpheus Cyberkinetics")
	..()

/obj/item/organ/external/leg/right/ipc
	dislocated = -1
/obj/item/organ/external/leg/right/ipc/New()
	robotize("Morpheus Cyberkinetics")
	..()

/obj/item/organ/external/foot/ipc
	dislocated = -1
/obj/item/organ/external/foot/ipc/New()
	robotize("Morpheus Cyberkinetics")
	..()

/obj/item/organ/external/foot/right/ipc
	dislocated = -1
/obj/item/organ/external/foot/right/ipc/New()
	robotize("Morpheus Cyberkinetics")
	..()

/obj/item/organ/external/hand/ipc
	dislocated = -1
/obj/item/organ/external/hand/ipc/New()
	robotize("Morpheus Cyberkinetics")
	..()

/obj/item/organ/external/hand/right/ipc
	dislocated = -1
/obj/item/organ/external/hand/right/ipc/New()
	robotize("Morpheus Cyberkinetics")
	..()

/obj/item/organ/cell
	name = "microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies."
	icon = 'icons/obj/power.dmi'
	icon_state = "scell"
	organ_tag = "cell"
	parent_organ = "chest"
	vital = 1

/obj/item/organ/cell/New()
	robotize()
	..()

/obj/item/organ/cell/replaced()
	..()
	// This is very ghetto way of rebooting an IPC. TODO better way.
	if(owner && owner.stat == DEAD)
		owner.stat = 0
		owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")

/obj/item/organ/optical_sensor
	name = "optical sensor"
	organ_tag = "optics"
	parent_organ = "head"
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "camera"
	dead_icon = "camera_broken"

/obj/item/organ/optical_sensor/New()
	robotize()
	..()

/obj/item/organ/cooler
	name = "cooler"
	organ_tag = "cooler"
	parent_organ = "chest"
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "motor"
	dead_icon = "motor_broken"

	var/max_hot_temperature = 2000
	var/max_cold_temperature = -1
	var/temp_cold = 7.5
	var/target_temp = 313
	var/enabled = 0

/obj/item/organ/cooler/New()
	robotize()
	..()

/obj/item/organ/cooler/process()
	..()
	if(owner.nutrition < 5) return //no cooling if charge is too low
	if(!enabled)
		if(owner.bodytemperature > owner.species.heat_level_1)
			enabled = 1
			owner << "Cooler enabled"
		return
	var/bt = owner.bodytemperature
	if(bt > max_hot_temperature || bt < max_cold_temperature)
		take_damage(0.1)
	if(!is_broken())
		if(!is_bruised())
			if(bt < target_temp)
				return
			else if(bt > owner.species.heat_level_1)
				bt -= temp_cold*2
				owner.nutrition -= 1
			else
				owner.nutrition -= 0.1
				if((bt - temp_cold) < target_temp)
					bt -= (bt - target_temp)
				else
					bt -= temp_cold
		else
			bt -= temp_cold/2
	owner.bodytemperature = bt

// Used for an MMI or posibrain being installed into a human.
/obj/item/organ/mmi_holder
	name = "brain"
	organ_tag = "brain"
	parent_organ = "chest"
	vital = 1
	var/obj/item/device/mmi/stored_mmi

/obj/item/organ/mmi_holder/proc/update_from_mmi()
	if(!stored_mmi)
		return
	name = stored_mmi.name
	desc = stored_mmi.desc
	icon = stored_mmi.icon
	icon_state = stored_mmi.icon_state

/obj/item/organ/mmi_holder/removed(var/mob/living/user)

	if(stored_mmi)
		stored_mmi.loc = get_turf(src)
		if(owner.mind)
			owner.mind.transfer_to(stored_mmi.brainmob)
	..()

	var/mob/living/holder_mob = loc
	if(istype(holder_mob))
		holder_mob.drop_from_inventory(src)
	qdel(src)

/obj/item/organ/mmi_holder/New()
	..()
	// This is very ghetto way of rebooting an IPC. TODO better way.
	spawn(1)
		if(owner && owner.stat == DEAD)
			owner.stat = 0
			owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")

/obj/item/organ/mmi_holder/posibrain/New()
	robotize()
	stored_mmi = new /obj/item/device/mmi/digital/posibrain(src)
	..()
	spawn(30)
		if(owner)
			stored_mmi.name = "positronic brain ([owner.name])"
			stored_mmi.brainmob.real_name = owner.name
			stored_mmi.brainmob.name = stored_mmi.brainmob.real_name
			stored_mmi.icon_state = "posibrain-occupied"
			update_from_mmi()
		else
			stored_mmi.loc = get_turf(src)
			qdel(src)
