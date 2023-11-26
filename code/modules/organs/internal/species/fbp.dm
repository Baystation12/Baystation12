/obj/item/organ/internal/cell
	name = "microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies."
	icon_state = "cell"
	dead_icon = "cell_bork"
	organ_tag = BP_CELL
	parent_organ = BP_CHEST
	status = ORGAN_ROBOTIC
	vital = 1
	var/open
	var/obj/item/cell/cell = /obj/item/cell/high
	//at 0.26 completely depleted after 60ish minutes of constant walking or 130 minutes of standing still
	var/servo_cost = 0.26

/obj/item/organ/internal/cell/New()
	robotize()
	if(ispath(cell))
		cell = new cell(src)
	..()

/obj/item/organ/internal/cell/proc/percent()
	if(!cell)
		return 0
	return get_charge()/cell.maxcharge * 100

/obj/item/organ/internal/cell/proc/get_charge()
	if(!cell)
		return 0
	if(status & ORGAN_DEAD)
		return 0
	return round(cell.charge*(1 - damage/max_damage))

/obj/item/organ/internal/cell/proc/checked_use(amount)
	if(!is_usable())
		return FALSE
	return cell && cell.checked_use(amount)

/obj/item/organ/internal/cell/proc/use(amount)
	if(!is_usable())
		return 0
	return cell && cell.use(amount)

/obj/item/organ/internal/cell/proc/get_power_drain()
	var/damage_factor = 1 + 10 * damage/max_damage
	return servo_cost * damage_factor

/obj/item/organ/internal/cell/Process()
	..()
	if(!owner)
		return
	if(owner.stat == DEAD)	//not a drain anymore
		return
	var/cost = get_power_drain()
	if(world.time - owner.l_move_time < 15)
		cost *= 2
	if(!checked_use(cost) && owner.isSynthetic())
		if(!owner.lying && !owner.buckled)
			to_chat(owner, SPAN_WARNING("You don't have enough energy to function!"))
		owner.Weaken(3)
		owner.Paralyse(3)
	if(percent() < 10 && prob(1))
		to_chat(owner, SPAN_WARNING("Your internal battery beeps an alert code, it is low on charge!"))

/obj/item/organ/internal/cell/emp_act(severity)
	..()
	if(cell)
		cell.emp_act(severity)

/obj/item/organ/internal/cell/attackby(obj/item/W, mob/user)
	if(isScrewdriver(W))
		if(open)
			open = 0
			to_chat(user, SPAN_NOTICE("You screw the battery panel in place."))
		else
			open = 1
			to_chat(user, SPAN_NOTICE("You unscrew the battery panel."))

	if(isCrowbar(W))
		if(open)
			if(cell)
				user.put_in_hands(cell)
				to_chat(user, SPAN_NOTICE("You remove \the [cell] from \the [src]."))
				cell = null

	if (istype(W, /obj/item/cell))
		if(open)
			if(cell)
				to_chat(user, SPAN_WARNING("There is a power cell already installed."))
			else if(user.unEquip(W, src))
				cell = W
				to_chat(user, SPAN_NOTICE("You insert \the [cell]."))

/obj/item/organ/internal/cell/replaced()
	..()
	// This is very ghetto way of rebooting an IPC. TODO better way.
	if(owner && owner.stat == DEAD)
		owner.set_stat(CONSCIOUS)
		owner.visible_message(SPAN_DANGER("\The [owner] twitches visibly!"))

/obj/item/organ/internal/cell/listen()
	if(get_charge())
		return "faint hum of the power bank"

// Used for an MMI or posibrain being installed into a human.
/obj/item/organ/internal/mmi_holder
	name = "brain interface"
	icon_state = "mmi-empty"
	organ_tag = BP_BRAIN
	parent_organ = BP_HEAD
	vital = 1
	var/obj/item/device/mmi/stored_mmi
	var/datum/mind/persistantMind //Mind that the organ will hold on to after being removed, used for transfer_and_delete
	var/ownerckey // used in the event the owner is out of body

/obj/item/organ/internal/mmi_holder/Destroy()
	stored_mmi = null
	return ..()

/obj/item/organ/internal/mmi_holder/New(mob/living/carbon/human/new_owner, internal)
	..(new_owner, internal)
	if(!stored_mmi)
		stored_mmi = new(src)
	sleep(-1)
	update_from_mmi()
	persistantMind = owner.mind
	ownerckey = owner.ckey

/obj/item/organ/internal/mmi_holder/Process()
	..()
	if(owner?.is_asystole())
		take_internal_damage(0.5)

/obj/item/organ/internal/mmi_holder/handle_regeneration() // MMI will regenerate from small amounts of damage, e.g. damage that might occur when swapping a power cell
	if(!damage || !owner || owner.is_asystole())
		return
	if(damage < 0.1*max_damage)
		heal_damage(0.1)
		if(stored_mmi.brainobj)
			stored_mmi.brainobj.heal_damage(0.1)

/obj/item/organ/internal/mmi_holder/proc/update_from_mmi()

	if(!stored_mmi.brainmob)
		stored_mmi.brainmob = new(stored_mmi)
		stored_mmi.brainobj = new(stored_mmi)
		stored_mmi.brainmob.container = stored_mmi
		stored_mmi.brainmob.real_name = owner.real_name
		stored_mmi.brainmob.SetName(stored_mmi.brainmob.real_name)
		stored_mmi.SetName("[initial(stored_mmi.name)] ([owner.real_name])")

	if(!owner) return

	name = stored_mmi.name
	desc = stored_mmi.desc
	icon = stored_mmi.icon

	stored_mmi.update_icon()
	icon_state = stored_mmi.icon_state

	if(owner && owner.stat == DEAD)
		owner.set_stat(CONSCIOUS)
		owner.switch_from_dead_to_living_mob_list()
		owner.visible_message(SPAN_DANGER("\The [owner] twitches visibly!"))

/obj/item/organ/internal/mmi_holder/cut_away(mob/living/user)
	var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
	if(istype(parent))
		removed(user, 0)
		parent.implants += transfer_and_delete()

/obj/item/organ/internal/mmi_holder/removed()
	if(owner && owner.mind)
		persistantMind = owner.mind
		if(owner.ckey)
			ownerckey = owner.ckey
	..()

/obj/item/organ/internal/mmi_holder/proc/transfer_and_delete()
	if(stored_mmi)
		. = stored_mmi
		stored_mmi.forceMove(src.loc)
		if(persistantMind)
			persistantMind.transfer_to(stored_mmi.brainmob)
		else
			var/response = input(find_dead_player(ownerckey, 1), "Your [initial(stored_mmi.name)] has been removed from your body. Do you wish to return to life?", "Robotic Rebirth") as anything in list("Yes", "No")
			if(response == "Yes")
				persistantMind.transfer_to(stored_mmi.brainmob)
	qdel(src)

/obj/item/organ/internal/mmi_holder/take_internal_damage(amount, silent=FALSE)
	..()
	if(stored_mmi.brainobj)
		stored_mmi.brainobj.take_internal_damage(amount)

/obj/item/organ/internal/mmi_holder/die()
	..()
	if(stored_mmi.brainobj)
		stored_mmi.brainobj.die()
