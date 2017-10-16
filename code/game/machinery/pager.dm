/obj/machinery/pager
	name = "departmental pager button"
	icon = 'icons/obj/objects.dmi'
	icon_state = "doorbell"
	desc = "A button used to request the presence of anyone in the department."
	anchored = 1
	use_power = 1
	idle_power_usage = 2
	var/acknowledged = 0
	var/last_paged
	var/department = COM
	var/location

/obj/machinery/pager/Initialize()
	. = ..()
	if(!location)
		var/area/A = get_area(src)
		location = A.name

/obj/machinery/pager/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/pager/attackby(obj/item/weapon/W, mob/user as mob)
	return attack_hand(user)

/obj/machinery/pager/attack_hand(mob/living/user)
	if(..()) return 1
	if(istype(user, /mob/living/carbon))
		playsound(src, "button", 60)
	flick("doorbellpressed",src)
	activate(user)

/obj/machinery/pager/proc/activate(mob/living/user)
	if(!powered())
		return
	var/obj/machinery/message_server/MS = get_message_server(z)
	if(!MS)
		return
	if(world.time < last_paged + 5 SECONDS)
		return
	last_paged = world.time
	var/paged = MS.send_to_department(department,"Department page to <b>[location]</b> received. <a href='?src=\ref[src];ack=1'>Take</a>", "*page*")
	acknowledged = 0
	if(paged)
		playsound(src, 'sound/machines/ping.ogg', 60)
		to_chat(user,"<span class='notice'>Page received by [paged] devices.</span>")
	else
		to_chat(user,"<span class='warning'>No valid destinations were found for the page.</span>")

/obj/machinery/pager/Topic(href, href_list)
	if(..())
		return 1
	if(!powered())
		return
	if(!acknowledged && href_list["ack"])
		playsound(src, 'sound/machines/ping.ogg', 60)
		visible_message("<span class='notice'>Page acknowledged.</span>")
		acknowledged = 1
		var/obj/machinery/message_server/MS = get_message_server(z)
		if(!MS)
			return
		MS.send_to_department(department,"Page to <b>[location]</b> was acknowledged.", "*ack*")

/obj/machinery/pager/medical
	department = MED

/obj/machinery/pager/cargo //supply
	department = SUP