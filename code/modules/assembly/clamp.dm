/obj/item/device/assembly/clamp
	name = "clamp"
	desc = "A hydraulic clamp. For clamping stuff."
	icon_state = "clamp"
	item_state = "assembly"
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10
	flags = CONDUCT
	weight = 2

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_DIRECT_SEND | WIRE_PROCESS_SEND | WIRE_POWER_RECEIVE | WIRE_MISC_CONNECTION
	wire_num = 7

	var/list/modes = list("Anchor", "Lock in assemblies",  "Attach externally")
	var/mode = "Anchor"
	var/mob/living/carbon/human/remover
	var/being_removed = 0

	var/req_tick_delay = 0
	var/in_slot
	var/tick_delay = 1

	var/grip_strength = 10
	var/active = 0
	var/safety = 0

/obj/item/device/assembly/clamp/get_data()
	var/list/data = list()
	data.Add("Mode", mode, "Active", active, "Safety Enabled", safety)
	return data

/obj/item/device/assembly/clamp/anchored(var/on = 1, var/mob/user)
	if(mode == "Anchor" && !on && active && draw_power(100))
		user << "<span class='warning'><small>\The [src] beeps quietly as it draws power from within \the [holder].</small></span>"
		return 0
	return 1

/obj/item/device/assembly/clamp/holder_disconnect(mob/user)
	if(connects_to.len)
		if(user)
			user << "<span class='warning'>You have to disconnect \the [src] from the other devices first!</span>"
		return 0

/obj/item/device/assembly/clamp/holder_can_remove()
	if(mode == "Lock in assemblies" && active && draw_power(1))
		return 0
	return 1

/obj/item/device/assembly/clamp/activate()
	if(!safety)
		active = !active

/obj/item/device/assembly/clamp/wire_safety(var/index = 0, var/pulsed = 0)
	if(index == WIRE_POWER_RECEIVE || index == WIRE_PROCESS_SEND)
		misc_activate()

/obj/item/device/assembly/clamp/misc_activate()
	for(var/obj/item/device/assembly/A in get_holder_linked_devices())
		if(prob(80))
			A.receive_direct_pulse(src)

/obj/item/device/assembly/clamp/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Mode")
				if(mode == "Attach externally")
					attachable = 0
				var/i = modes.Find(mode)
				if(!i || i == modes.len) i = 1
				else i += 1
				mode = modes[i]
				switch(mode)
					if("Attach externally")
						attachable = 1
			if("Active")
				process_activation()
			if("Safety Enabled")
				if(!safety)
					safety = 1
				else
					if(!(active_wires & (WIRE_ASSEMBLY_PASSWORD|WIRE_PROCESS_ACTIVATE)))
						safety = 0
	if(holder)
		holder.update_holder()
	..()

/obj/item/device/assembly/clamp/mob_can_unequip(mob/M, slot, disable_warning = 0)
	if(!holder || !holder.attached_to)
		return ..()
	if(being_removed)
		M << "<span class='warning'>\The [src] is already being pulled off by \the [remover]!</span>"
		return 0
	if(active && src.draw_power((((initial(grip_strength) - grip_strength)) * 10) + 100))
		M << "<span class='warning'>You begin tugging on \the [src], but the hydraulic motors are resisting you! Stand still!</span>"
		remover = M
		being_removed = 1
		processing_objects.Add(src)
		in_slot = slot
		return 0
	else
		M << "<span class='notice'>You tug on \the [src] and it easily slides off!</span>"
		return 1

/obj/item/device/assembly/clamp/attached(var/mob/M)
	if(src.draw_power((((initial(grip_strength) - grip_strength)) * 10) + 20))
		M.visible_message("<span class='danger'>\The [src] clamps onto [M]!</span>", "<span class='danger'>\The [src] clamps onto you!</span>")
	return 1

/obj/item/device/assembly/clamp/process()
	if(holder && holder.attachable && attachable && holder.attached_to && grip_strength > 0)
		tick_delay++
		if(tick_delay >= req_tick_delay)
			if(do_after(remover, 1))
				req_tick_delay += rand(1,(150 * (initial(grip_strength) - grip_strength)))
				tick_delay = 0
				if(!src.draw_power((((initial(grip_strength) - grip_strength)) * 10) + 100))
					holder.attached_to.visible_message("<span class='notice'>\The [src] sighs mechanically and relaxes it's grip.</span>")
					active = 0
				else
					if(prob(grip_strength))
						switch(in_slot)
							if(slot_back)
								holder.attached_to << "<span class='danger'>You feel something tear the skin off of your back!</span>"
								holder.attached_to.emote("scream")
								if(prob(60))
									grip_strength -= 2
								holder.attached_to.visible_message("<span class='danger'>\The [src] slips slightly, tearing [holder.attached_to]'s skin!</span>")
							if(slot_wear_mask)
								holder.attached_to << "<span class='danger'>You feel something tear the skin off of your face!</span>"
								holder.attached_to.emote("scream")
								holder.attached_to.Weaken(15)
								if(prob(60))
									grip_strength -= 2
								holder.attached_to.visible_message("<span class='danger'>\The [src] slips slightly, tearing [holder.attached_to]'s skin!</span>")
					else if(prob(((initial(grip_strength) - grip_strength) * 5) + 30))
						if(grip_strength <= initial(grip_strength) / 4)
							holder.attached_to.visible_message("<span class='danger'>\The [src] is quickly losing it's grip on \the [holder.attached_to]!</span>")
						else if(grip_strength <= initial(grip_strength) / 3)
							holder.attached_to.visible_message("<span class='danger'>\The [src] is losing it's remaining grip on \the [holder.attached_to]!</span>")
						else if(grip_strength <= initial(grip_strength) / 2)
							holder.attached_to.visible_message("<span class='danger'>\The [src]'s grip on [holder.attached_to] is getting looser!</span>")
						else
							holder.attached_to.visible_message("<span class='danger'>[remover] tugs on \the [src] attached to [holder.attached_to], loosening it slightly!</span>")
						grip_strength -= rand(1, 3)
					else if(prob(grip_strength * 2))
						holder.attached_to.visible_message("<span class='danger'>\The [src] is tightening it's grip on [holder.attached_to]!</span>")
						grip_strength += rand(1, 3)
					else if(prob((80 - reliability) / 2))
						holder.attached_to.visible_message("<span class='danger'>\The [src] suddenly lets go of [holder.attached_to]!</span>")
						active = 0
					else
						holder.attached_to.visible_message("<span class='danger'>[remover] tugs on \the [src] attached to [holder.attached_to]!</span>")
				return 1
	processing_objects.Remove(src)
	being_removed = 0
	remover = null
	grip_strength = initial(grip_strength)
	in_slot = null


