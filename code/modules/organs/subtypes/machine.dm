/obj/item/organ/internal/cell
	name = "microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies."
	icon = 'icons/obj/power.dmi'
	icon_state = "scell"
	organ_tag = BP_CELL
	parent_organ = BP_CHEST
	vital = 1

/obj/item/organ/internal/cell/New()
	robotize()
	..()

/obj/item/organ/internal/cell/replaced()
	..()
	// This is very ghetto way of rebooting an IPC. TODO better way.
	if(owner && owner.stat == DEAD)
		owner.stat = 0
		owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")

// Used for an MMI or posibrain being installed into a human.
/obj/item/organ/internal/mmi_holder
	name = "brain interface"
	organ_tag = BP_BRAIN
	parent_organ = BP_HEAD
	vital = 1
	var/obj/item/device/mmi/stored_mmi

/obj/item/organ/internal/mmi_holder/Destroy()
	stored_mmi = null
	return ..()

/obj/item/organ/internal/mmi_holder/New(var/mob/living/carbon/human/new_owner, var/internal)
	..(new_owner, internal)
	if(!stored_mmi)
		stored_mmi = new(src)
	sleep(-1)
	update_from_mmi()

/obj/item/organ/internal/mmi_holder/proc/update_from_mmi()

	if(!stored_mmi.brainmob)
		stored_mmi.brainmob = new(stored_mmi)
		stored_mmi.brainobj = new(stored_mmi)
		stored_mmi.brainmob.container = stored_mmi
		stored_mmi.brainmob.real_name = owner.real_name
		stored_mmi.brainmob.name = stored_mmi.brainmob.real_name
		stored_mmi.name = "[initial(stored_mmi.name)] ([owner.real_name])"

	if(!owner) return

	name = stored_mmi.name
	desc = stored_mmi.desc
	icon = stored_mmi.icon

	stored_mmi.icon_state = "mmi_full"
	icon_state = stored_mmi.icon_state

	if(owner && owner.stat == DEAD)
		owner.stat = 0
		owner.switch_from_dead_to_living_mob_list()
		owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")

/obj/item/organ/internal/mmi_holder/removed(var/mob/living/user)

	if(stored_mmi)
		stored_mmi.forceMove(src.loc)
		if(owner.mind)
			owner.mind.transfer_to(stored_mmi.brainmob)
	..()
	var/mob/living/holder_mob = loc
	if(istype(holder_mob))
		holder_mob.drop_from_inventory(src)
		holder_mob.put_in_hands(src)
	qdel(src)

/obj/item/organ/internal/mmi_holder/posibrain
	name = "positronic brain interface"
	parent_organ = BP_CHEST

/obj/item/organ/internal/mmi_holder/posibrain/New()
	stored_mmi = new /obj/item/device/mmi/digital/posibrain(src)
	..()

/obj/item/organ/internal/mmi_holder/posibrain/update_from_mmi()
	..()
	stored_mmi.icon_state = "posibrain-occupied"
	icon_state = stored_mmi.icon_state
