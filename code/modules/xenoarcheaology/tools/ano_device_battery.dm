/obj/item/weapon/anobattery
	name = "Anomaly power battery"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "anobattery0"
	var/datum/artifact_effect/battery_effect
	var/capacity = 300
	var/stored_charge = 0
	var/effect_id = ""

/obj/item/weapon/anobattery/proc/UpdateSprite()
	var/p = (stored_charge/capacity)*100
	p = min(p, 100)
	icon_state = "anobattery[round(p,25)]"

/obj/item/weapon/anobattery/proc/use_power(var/amount)
	stored_charge = max(0, stored_charge - amount)

/obj/item/weapon/anodevice
	name = "Anomaly power utilizer"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "anodev"
	var/activated = 0
	var/duration = 0
	var/interval = 0
	var/time_end = 0
	var/last_activation = 0
	var/last_process = 0
	var/obj/item/weapon/anobattery/inserted_battery
	var/turf/archived_loc
	var/energy_consumed_on_touch = 100

/obj/item/weapon/anodevice/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/weapon/anodevice/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/anobattery))
		if(!inserted_battery)
			if(!user.unEquip(I, src))
				return
			to_chat(user, "<span class='notice'>You insert the battery.</span>")
			inserted_battery = I
			UpdateSprite()
	else
		return ..()

/obj/item/weapon/anodevice/attack_self(var/mob/user as mob)
	return src.interact(user)

/obj/item/weapon/anodevice/interact(var/mob/user)
	var/dat = "<b>Anomalous Materials Energy Utiliser</b><br>"
	if(inserted_battery)
		if(activated)
			dat += "Device active.<br>"

		dat += "[inserted_battery] inserted, anomaly ID: [(inserted_battery.battery_effect?.artifact_id) ? inserted_battery.battery_effect.artifact_id : "NA"]<BR>"
		dat += "<b>Charge:</b> [inserted_battery.stored_charge] / [inserted_battery.capacity]<BR>"
		dat += "<b>Time left activated:</b> [round(max((time_end - last_process) / 10, 0))]<BR>"
		if(activated)
			dat += "<a href='?src=\ref[src];shutdown=1'>Shutdown</a><br>"
		else
			dat += "<A href='?src=\ref[src];startup=1'>Start</a><BR>"
		dat += "<BR>"

		dat += "<b>Activate duration (sec):</b> <A href='?src=\ref[src];changetime=-100;duration=1'>--</a> <A href='?src=\ref[src];changetime=-10;duration=1'>-</a> [duration/10] <A href='?src=\ref[src];changetime=10;duration=1'>+</a> <A href='?src=\ref[src];changetime=100;duration=1'>++</a><BR>"
		dat += "<b>Activate interval (sec):</b> <A href='?src=\ref[src];changetime=-100;interval=1'>--</a> <A href='?src=\ref[src];changetime=-10;interval=1'>-</a> [interval/10] <A href='?src=\ref[src];changetime=10;interval=1'>+</a> <A href='?src=\ref[src];changetime=100;interval=1'>++</a><BR>"
		dat += "<br>"
		dat += "<A href='?src=\ref[src];ejectbattery=1'>Eject battery</a><BR>"
	else
		dat += "Please insert battery<br>"

	dat += "<hr>"
	dat += "<a href='?src=\ref[src];refresh=1'>Refresh</a> <a href='?src=\ref[src];close=1'>Close</a>"

	show_browser(user, dat, "window=anodevice;size=400x500")
	onclose(user, "anodevice")

/obj/item/weapon/anodevice/Process()
	if(activated)
		if(inserted_battery && inserted_battery.battery_effect && (inserted_battery.stored_charge > 0) )
			//make sure the effect is active
			if(!inserted_battery.battery_effect.activated)
				inserted_battery.battery_effect.ToggleActivate(1)

			//update the effect loc
			var/turf/T = get_turf(src)
			if(T != archived_loc)
				archived_loc = T
				inserted_battery.battery_effect.UpdateMove()

			//if someone is holding the device, do the effect on them
			var/mob/holder
			if(ismob(src.loc))
				holder = src.loc

			//handle charge
			if(world.time - last_activation > interval)
				if(inserted_battery.battery_effect.effect == EFFECT_TOUCH)
					if(interval > 0)
						//apply the touch effect to the holder
						if(holder)
							to_chat(holder, "The \icon[src] [src] held by [holder] shudders in your grasp.")
						else
							src.loc.visible_message("The \icon[src] [src] shudders.")
						inserted_battery.battery_effect.DoEffectTouch(holder)

						//consume power
						inserted_battery.use_power(energy_consumed_on_touch)
					else
						//consume power equal to time passed
						inserted_battery.use_power(world.time - last_process)

				else if(inserted_battery.battery_effect.effect == EFFECT_PULSE)
					inserted_battery.battery_effect.chargelevel = inserted_battery.battery_effect.chargelevelmax

					//consume power relative to the time the artifact takes to charge and the effect range
					inserted_battery.use_power(inserted_battery.battery_effect.effectrange * inserted_battery.battery_effect.effectrange * inserted_battery.battery_effect.chargelevelmax)

				else
					//consume power equal to time passed
					inserted_battery.use_power(world.time - last_process)

				last_activation = world.time

			//process the effect
			inserted_battery.battery_effect.process()

			//work out if we need to shutdown
			if(inserted_battery.stored_charge <= 0)
				src.loc.visible_message("<span class='notice'>\icon[src] [src] buzzes.</span>", "<span class='notice'>\icon[src] You hear something buzz.</span>")
				shutdown_emission()
			else if(world.time > time_end)
				src.loc.visible_message("<span class='notice'>\icon[src] [src] chimes.</span>", "<span class='notice'>\icon[src] You hear something chime.</span>")
				shutdown_emission()
		else
			src.visible_message("<span class='notice'>\icon[src] [src] buzzes.</span>", "<span class='notice'>\icon[src] You hear something buzz.</span>")
			shutdown_emission()
		last_process = world.time

/obj/item/weapon/anodevice/proc/shutdown_emission()
	if(activated)
		activated = 0
		if(inserted_battery.battery_effect.activated)
			inserted_battery.battery_effect.ToggleActivate(1)
		if(inserted_battery.stored_charge <= 0)
			inserted_battery.battery_effect = null

/obj/item/weapon/anodevice/Topic(user, href_list, state = GLOB.inventory_state)
	..()

/obj/item/weapon/anodevice/OnTopic(user, href_list)
	if(href_list["changetime"])
		var/timedif = text2num(href_list["changetime"])
		if(href_list["duration"])
			duration += timedif
			//max 30 sec duration
			duration = min(max(duration, 0), 300)
			if(activated)
				time_end += timedif
		else if(href_list["interval"])
			interval += timedif
			//max 10 sec interval
			interval = min(max(interval, 0), 100)
		. = TOPIC_REFRESH
	else if(href_list["startup"])
		if(inserted_battery && inserted_battery.battery_effect && (inserted_battery.stored_charge > 0) )
			activated = 1
			last_process = world.time
			src.visible_message("<span class='notice'>\icon[src] [src] whirrs.</span>", "<span class='notice'>\icon[src] You hear something whirr.</span>")
			if(!inserted_battery.battery_effect.activated)
				inserted_battery.battery_effect.ToggleActivate(1)
			time_end = world.time + duration
		. = TOPIC_REFRESH
	else if(href_list["shutdown"])
		activated = 0
		. = TOPIC_REFRESH
	else if(href_list["ejectbattery"])
		shutdown_emission()
		inserted_battery.dropInto(loc)
		inserted_battery = null
		UpdateSprite()
		. = TOPIC_REFRESH
	if(href_list["close"])
		close_browser(user, "window=anodevice")
		. = TOPIC_HANDLED

	if(. == TOPIC_REFRESH)
		interact(user)

/obj/item/weapon/anodevice/proc/UpdateSprite()
	if(!inserted_battery)
		icon_state = "anodev"
		return
	var/p = (inserted_battery.stored_charge/inserted_battery.capacity)*100
	p = min(p, 100)
	icon_state = "anodev[round(p,25)]"

/obj/item/weapon/anodevice/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/item/weapon/anodevice/attack(mob/living/M as mob, mob/living/user as mob, def_zone)
	if (!istype(M))
		return

	if(activated && inserted_battery.battery_effect.effect == EFFECT_TOUCH && !isnull(inserted_battery))
		inserted_battery.battery_effect.DoEffectTouch(M)
		inserted_battery.use_power(energy_consumed_on_touch)
		user.visible_message("<span class='notice'>[user] taps [M] with [src], and it shudders on contact.</span>")
	else
		user.visible_message("<span class='notice'>[user] taps [M] with [src], but nothing happens.</span>")

	if(inserted_battery.battery_effect)
		admin_attack_log(user, M, "Tapped their victim with \a [src] (EFFECT: [inserted_battery.battery_effect.name])", "Was tapped by \a [src] (EFFECT: [inserted_battery.battery_effect.name])", "used \a [src] (EFFECT: [inserted_battery.battery_effect.name]) to tap")
