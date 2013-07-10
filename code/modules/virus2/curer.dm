/obj/machinery/computer/curer
	name = "Cure Research Machine"
	icon = 'icons/obj/computer.dmi'
	icon_state = "dna"
	var/curing
	var/virusing

	var/obj/item/weapon/reagent_containers/container = null

/obj/machinery/computer/curer/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		return ..(I,user)
	if(istype(I,/obj/item/weapon/reagent_containers))
		var/mob/living/carbon/C = user
		if(!container)
			container = I
			C.drop_item()
			I.loc = src
	if(istype(I,/obj/item/weapon/virusdish))
		if(virusing)
			user << "<b>The pathogen materializer is still recharging.."
			return
		var/obj/item/weapon/reagent_containers/glass/beaker/product = new(src.loc)

		var/list/data = list("donor"=null,"viruses"=null,"blood_DNA"=null,"blood_type"=null,"resistances"=null,"trace_chem"=null,"virus2"=list(),"antibodies"=0)
		data["virus2"] |= I:virus2
		product.reagents.add_reagent("blood",30,data)

		virusing = 1
		spawn(1200) virusing = 0

		state("The [src.name] Buzzes", "blue")
		return
	src.attack_hand(user)
	return

/obj/machinery/computer/curer/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/curer/attack_paw(var/mob/user as mob)

	return src.attack_hand(user)
	return

/obj/machinery/computer/curer/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.machine = src
	var/dat
	if(curing)
		dat = "Antibody production in progress"
	else if(virusing)
		dat = "Virus production in progress"
	else if(container)
		// see if there's any blood in the container
		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in container.reagents.reagent_list

		if(B)
			dat = "Blood sample inserted."
			var/code = ""
			for(var/V in ANTIGENS) if(text2num(V) & B.data["antibodies"]) code += ANTIGENS[V]
			dat += "<BR>Antibodies: [code]"
			dat += "<BR><A href='?src=\ref[src];antibody=1'>Begin antibody production</a>"
		else
			dat += "<BR>Please check container contents."
		dat += "<BR><A href='?src=\ref[src];eject=1'>Eject container</a>"
	else
		dat = "Please insert a container."

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/curer/process()
	..()

	if(stat & (NOPOWER|BROKEN))
		return
	use_power(500)

	if(curing)
		curing -= 1
		if(curing == 0)
			if(container)
				createcure(container)
	return

/obj/machinery/computer/curer/Topic(href, href_list)
	if(..())
		return
	usr.machine = src

	if (href_list["antibody"])
		curing = 10
	else if(href_list["eject"])
		container.loc = src.loc
		container = null

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return


/obj/machinery/computer/curer/proc/createcure(var/obj/item/weapon/reagent_containers/container)
	var/obj/item/weapon/reagent_containers/glass/beaker/product = new(src.loc)

	var/datum/reagent/blood/B = locate() in container.reagents.reagent_list

	var/list/data = list()
	data["antibodies"] = B.data["antibodies"]
	product.reagents.add_reagent("antibodies",30,data)

	state("\The [src.name] buzzes", "blue")
