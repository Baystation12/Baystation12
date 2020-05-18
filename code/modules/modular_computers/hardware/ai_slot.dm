// A wrapper that allows the computer to contain an inteliCard.
/obj/item/weapon/stock_parts/computer/ai_slot
	name = "inteliCard slot"
	desc = "An IIS interlink with connection uplinks that allow the device to interface with most common inteliCard models. Too large to fit into tablets. Uses a lot of power when active."
	icon_state = "aislot"
	hardware_size = 1
	critical = 0
	power_usage = 100
	origin_tech = list(TECH_POWER = 2, TECH_DATA = 3)
	external_slot = TRUE
	var/obj/item/weapon/aicard/stored_card
	var/power_usage_idle = 100
	var/power_usage_occupied = 2 KILOWATTS

/obj/item/weapon/stock_parts/computer/ai_slot/update_power_usage()
	if(!stored_card || !stored_card.carded_ai)
		power_usage = power_usage_idle
	else
		power_usage = power_usage_occupied
	..()

/obj/item/weapon/stock_parts/computer/ai_slot/attackby(var/obj/item/weapon/W, var/mob/user)
	if(..())
		return 1
	if(istype(W, /obj/item/weapon/aicard))
		if(stored_card)
			to_chat(user, "\The [src] is already occupied.")
			return
		if(!user.unEquip(W, src))
			return
		do_insert_ai(user, W)
		return TRUE
	if(isScrewdriver(W))
		to_chat(user, "You manually remove \the [stored_card] from \the [src].")
		do_eject_ai(user)

/obj/item/weapon/stock_parts/computer/ai_slot/Destroy()
	if(stored_card)
		do_eject_ai()
	return ..()

/obj/item/weapon/stock_parts/computer/ai_slot/verb/eject_ai(mob/user)
	set name = "Eject AI"
	set category = "Object"
	set src in view(1)

	if(!user)
		user = usr

	if(!CanPhysicallyInteract(user))
		to_chat(user, "<span class='warning'>You can't reach it.</span>")
		return

	var/obj/item/weapon/stock_parts/computer/ai_slot/device = src
	if (!istype(device))
		device = locate() in src

	if(!device.stored_card)
		to_chat(user, "There is no intellicard connected to \the [src].")
		return

	device.do_eject_ai(user)

/obj/item/weapon/stock_parts/computer/ai_slot/proc/do_eject_ai(mob/user)
	stored_card.dropInto(loc)
	stored_card = null

	loc.verbs -= /obj/item/weapon/stock_parts/computer/ai_slot/verb/eject_ai

	update_power_usage()

/obj/item/weapon/stock_parts/computer/ai_slot/proc/do_insert_ai(mob/user, obj/item/weapon/aicard/card)
	stored_card = card

	if(isobj(loc))
		loc.verbs += /obj/item/weapon/stock_parts/computer/ai_slot/verb/eject_ai

	update_power_usage()
