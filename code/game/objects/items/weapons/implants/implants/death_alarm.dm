/obj/item/weapon/implant/death_alarm
	name = "death alarm implant"
	desc = "An alarm which monitors host vital signs and transmits a radio message upon death."
	known = 1
	var/mobname = "Will Robinson"

/obj/item/weapon/implant/death_alarm/get_data()
	return {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> [using_map.company_name] \"Profit Margin\" Class Employee Lifesign Sensor<BR>
	<b>Life:</b> Activates upon death.<BR>
	<b>Important Notes:</b> Alerts crew to crewmember death.<BR>
	<HR>
	<b>Implant Details:</b><BR>
	<b>Function:</b> Contains a compact radio signaler that triggers when the host's lifesigns cease.<BR>
	<b>Special Features:</b> Alerts crew to crewmember death.<BR>
	<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}

/obj/item/weapon/implant/death_alarm/islegal()
	return TRUE

/obj/item/weapon/implant/death_alarm/process()
	if (!implanted) return
	var/mob/M = imp_in

	if(isnull(M)) // If the mob got gibbed
		activate()
	else if(M.stat == DEAD)
		activate("death")

/obj/item/weapon/implant/death_alarm/activate(var/cause)
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
	processing_objects.Remove(src)

	for(var/channel in list("Security", "Medical", "Command"))
		global_headset.autosay(death_message, "[mobname]'s Death Alarm", channel)

/obj/item/weapon/implant/death_alarm/emp_act(severity)			//for some reason alarms stop going off in case they are emp'd, even without this
	if (malfunction)		//so I'm just going to add a meltdown chance here
		return
	malfunction = MALFUNCTION_TEMPORARY

	if(prob(20))
		activate("emp")	//let's shout that this dude is dead
	if(severity == 1)
		if(prob(40))	//small chance of obvious meltdown
			meltdown()
		else if (prob(60))	//but more likely it will just quietly die
			malfunction = MALFUNCTION_PERMANENT
		processing_objects.Remove(src)

	spawn(20)
		malfunction = 0

/obj/item/weapon/implant/death_alarm/implanted(mob/source as mob)
	mobname = source.real_name
	processing_objects.Add(src)
	return TRUE

/obj/item/weapon/implant/death_alarm/removed()
	..()
	processing_objects.Remove(src)

/obj/item/weapon/implantcase/death_alarm
	name = "glass case - 'death alarm'"
	imp = /obj/item/weapon/implant/death_alarm