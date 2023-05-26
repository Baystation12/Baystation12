/datum/wires/transfer_valve
	random = TRUE
	holder_type = /obj/item/device/transfer_valve
	wire_count = 5
	descriptions = list(
		new /datum/wire_description(TTV_WIRE_TOGGLEVALVE, "This wire is connected to the valve latch controllers.", SKILL_EXPERIENCED),
		new /datum/wire_description(TTV_WIRE_GASRELEASE, "This wire seems to be connected directly to the tank latch.", SKILL_TRAINED),
		new /datum/wire_description(TTV_WIRE_DISARM, "This wire seems to be connected to the internal structural controller.", SKILL_TRAINED),
		new /datum/wire_description(TTV_WIRE_DEVICECHANGE, "This wire seems to be connected to the attached mechanism.", SKILL_TRAINED),
		new /datum/wire_description(TTV_WIRE_RNG, "This red wire seems to go over every little nook and cranny of the bomb.")
	)

var/global/const/TTV_WIRE_TOGGLEVALVE =  FLAG(0)
var/global/const/TTV_WIRE_GASRELEASE =   FLAG(1)
var/global/const/TTV_WIRE_DISARM =       FLAG(2)
var/global/const/TTV_WIRE_RNG =          FLAG(3)
var/global/const/TTV_WIRE_DEVICECHANGE = FLAG(4)

/datum/wires/transfer_valve/UpdatePulsed(index)
	var/obj/item/device/transfer_valve/T = holder
	switch(index)
		if (TTV_WIRE_TOGGLEVALVE)
			T.toggle_valve()
		if (TTV_WIRE_GASRELEASE)
			T.split_gases()
		if (TTV_WIRE_RNG)
			T.toggle_valve()
		if (TTV_WIRE_DEVICECHANGE)
			if (istype(T.attached_device, /obj/item/device/assembly/signaler))
				var/obj/item/device/assembly/signaler/sig = T.attached_device
				sig.set_frequency(rand(RADIO_LOW_FREQ, RADIO_HIGH_FREQ))
			else if (istype(T.attached_device, /obj/item/device/assembly/prox_sensor))
				var/obj/item/device/assembly/prox_sensor/prox = T.attached_device
				prox.scanning = !prox.scanning
			else if (istype(T.attached_device, /obj/item/device/assembly/timer))
				var/obj/item/device/assembly/timer/tmr = T.attached_device
				tmr.time = max(tmr.time + rand(-100, 100), 1)

/datum/wires/transfer_valve/UpdateCut(index, mended)
	var/obj/item/device/transfer_valve/T = holder
	var/timer = rand(3,5)
	switch(index)
		if (TTV_WIRE_TOGGLEVALVE)
			if (!mended)
				T.toggle_valve()
		if (TTV_WIRE_DISARM)
			if (!mended)
				T.toggle_armed()
		if (TTV_WIRE_RNG)
			if (prob(70))
				T.toggle_valve()
			else
				T.toggle_armed()
		if (TTV_WIRE_DEVICECHANGE)
			if (!mended)
				if (prob(40))
					T.visible_message(SPAN_DANGER("\The [T] beeps defeatedly!"))
					playsound(T, 'sound/items/timer.ogg', 50)
					T.toggle_armed()
				else
					T.visible_message(SPAN_WARNING("\The [T] starts beeping angrily!"))
					while (timer > 0)
						playsound(T, 'sound/items/timer.ogg', 50)
						timer--
					T.toggle_valve()

/datum/wires/transfer_valve/CanUse(mob/living/L)
	var/obj/item/device/transfer_valve/T = holder
	if(T.armed)
		return TRUE
	return FALSE
