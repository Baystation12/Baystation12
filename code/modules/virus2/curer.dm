/obj/machinery/computer/curer
	name = "cure research machine"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "med_key"
	icon_screen = "dna"
	idle_power_usage = 500
	var/curing
	var/virusing

	var/obj/item/weapon/reagent_containers/container = null

/obj/machinery/computer/curer/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I,/obj/item/weapon/reagent_containers))
		if(!container)
			if(!user.unEquip(I, src))
				return
			container = I
		return

/obj/machinery/computer/curer/interface_interact(var/mob/user)
	interact(user)
	return TRUE

/obj/machinery/computer/curer/interact(var/mob/user)
	user.machine = src
	var/dat
	if(curing)
		dat = "Antibody production in progress"
	else if(container)
		// check to see if we have the required reagents
		if(container.reagents.get_reagent_amount(/datum/reagent/blood) >= 15 && container.reagents.get_reagent_amount(/datum/reagent/radium) >= 15 && container.reagents.get_reagent_amount(/datum/reagent/nutriment/spaceacillin) >= 15)
			dat = "Blood sample inserted."
			dat += "<BR><A href='?src=\ref[src];antibody=1'>Begin antibody production</a>"
		else
			dat += "<BR>Please check container contents."
		dat += "<BR><A href='?src=\ref[src];eject=1'>Eject container</a>"
	else
		dat = "Please insert a container."

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/curer/Process()
	if(stat & (NOPOWER|BROKEN))
		return

	if(curing)
		curing -= 1
		if(curing == 0)
			if(container)
				createcure(container)
	return

/obj/machinery/computer/curer/OnTopic(user, href_list)
	if (href_list["antibody"])
		curing = 10
		. = TOPIC_REFRESH
	else if(href_list["eject"])
		container.dropInto(loc)
		container = null
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		attack_hand(user)

/obj/machinery/computer/curer/proc/createcure(var/obj/item/weapon/reagent_containers/container)
	var/obj/item/weapon/reagent_containers/C = container
	C.dropInto(loc)

	var/datum/reagent/blood/B = locate() in container.reagents.reagent_list

	var/list/data = list()
	data["antibodies"] = B.data["antibodies"]
	C.reagents.clear_reagents()
	C.reagents.add_reagent(/datum/reagent/antibodies, 10, data)

	state("\The [src.name] buzzes", "blue")
