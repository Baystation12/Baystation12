/obj/item/weapon/implant/death_alarm
	name = "death alarm implant"
	desc = "An alarm which monitors host vital signs and transmits a radio message upon death."
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_DATA = 1)
	known = 1
	var/mobname = "John Doe"

/obj/item/weapon/implant/death_alarm/get_data()
	return {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> [GLOB.using_map.company_name] \"Profit Margin\" Class Employee Lifesign Sensor<BR>
	<b>Life:</b> Activates upon death.<BR>
	<b>Important Notes:</b> Alerts crew to crewmember death.<BR>
	<HR>
	<b>Implant Details:</b><BR>
	<b>Function:</b> Contains a compact radio signaler that triggers when the host's lifesigns cease.<BR>
	<b>Special Features:</b> Alerts crew to crewmember death.<BR>
	<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}

/obj/item/weapon/implant/death_alarm/islegal()
	return TRUE

/obj/item/weapon/implant/death_alarm/Process()
	if (!implanted) return
	var/mob/M = imp_in

	if(isnull(M)) // If the mob got gibbed
		activate(null)
	else if(M.stat == DEAD)
		activate("death")

/obj/item/weapon/implant/death_alarm/activate(var/cause = "emp")
	if(malfunction) return
	var/mob/M = imp_in
	var/area/t = get_area(M)
	var/location = t.name
	if (cause == "emp" && prob(50))
		location =  pick(teleportlocs)
	if(!t.requires_power) // We assume areas that don't use power are some sort of special zones
		var/area/default = world.area
		location = initial(default.name)
	var/death_message = "[mobname] has died in [location]!"
	if(!cause)
		death_message = "[mobname] has died-zzzzt in-in-in..."
	STOP_PROCESSING(SSobj, src)

	for(var/channel in list("Security", "Medical", "Command"))
		GLOB.global_headset.autosay(death_message, "[mobname]'s Death Alarm", channel)

/obj/item/weapon/implant/death_alarm/disable()
	. = ..()
	if(.)
		STOP_PROCESSING(SSobj, src)

/obj/item/weapon/implant/death_alarm/restore()
	. = ..()
	if(.)
		START_PROCESSING(SSobj, src)

/obj/item/weapon/implant/death_alarm/meltdown()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/weapon/implant/death_alarm/implanted(mob/source as mob)
	mobname = source.real_name
	START_PROCESSING(SSobj, src)
	return TRUE

/obj/item/weapon/implant/death_alarm/removed()
	..()
	STOP_PROCESSING(SSobj, src)

/obj/item/weapon/implantcase/death_alarm
	name = "glass case - 'death alarm'"
	imp = /obj/item/weapon/implant/death_alarm