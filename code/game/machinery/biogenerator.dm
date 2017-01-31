/obj/machinery/biogenerator
	name = "Biogenerator"
	desc = ""
	icon = 'icons/obj/biogenerator.dmi'
	icon_state = "biogen-stand"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 40
	var/processing = 0
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/points = 0
	var/menustat = "menu"
	var/build_eff = 1
	var/eat_eff = 1


/obj/machinery/biogenerator/New()
	..()
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src
	beaker = new /obj/item/weapon/reagent_containers/glass/bottle(src)

	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/biogenerator(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)

	RefreshParts()

/obj/machinery/biogenerator/on_reagent_change()			//When the reagents change, change the icon as well.
	update_icon()

/obj/machinery/biogenerator/update_icon()
	if(!beaker)
		icon_state = "biogen-empty"
	else if(!processing)
		icon_state = "biogen-stand"
	else
		icon_state = "biogen-work"
	return

/obj/machinery/biogenerator/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(istype(O, /obj/item/weapon/reagent_containers/glass))
		if(beaker)
			to_chat(user, "<span class='notice'>]The [src] is already loaded.</span>")
		else
			user.remove_from_mob(O)
			O.forceMove(src)
			beaker = O
			updateUsrDialog()
	else if(processing)
		to_chat(user, "<span class='notice'>\The [src] is currently processing.</span>")
	else if(istype(O, /obj/item/weapon/storage/plants))
		var/obj/item/weapon/storage/plants/P = O
		var/i = 0
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= 10)
			to_chat(user, "<span class='notice'>\The [src] is already full! Activate it.</span>")
		else
			var/hadPlants = 0
			for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in P.contents)
				hadPlants = 1
				P.remove_from_storage(G, src)
				i++
				if(i >= 10)
					to_chat(user, "<span class='notice'>You fill \the [src] to its capacity.</span>")
					break
			if(!hadPlants)
				to_chat(user, "<span class='notice'>\The [P] has no produce inside.</span>")
			else if(i < 10)
				to_chat(user, "<span class='notice'>You empty \the [P] into \the [src].</span>")


	else if(!istype(O, /obj/item/weapon/reagent_containers/food/snacks/grown))
		to_chat(user, "<span class='notice'>You cannot put this in \the [src].</span>")
	else
		var/i = 0
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= 10)
			to_chat(user, "<span class='notice'>\The [src] is full! Activate it.</span>")
		else
			user.remove_from_mob(O)
			O.forceMove(src)
			to_chat(user, "<span class='notice'>You put \the [O] in \the [src]</span>")
	update_icon()
	return

/obj/machinery/biogenerator/interact(mob/user as mob)
	if(stat & BROKEN)
		return
	user.set_machine(src)
	var/dat = "<TITLE>Biogenerator</TITLE>Biogenerator:<BR>"
	if (processing)
		dat += "<FONT COLOR=red>Biogenerator is processing! Please wait...</FONT>"
	else
		dat += "Biomass: [points] points.<HR>"
		switch(menustat)
			if("menu")
				if (beaker)
					dat += "<A href='?src=\ref[src];action=activate'>Activate Biogenerator!</A><BR>"
					dat += "<A href='?src=\ref[src];action=detach'>Detach Container</A><BR><BR>"
					dat += "Food<BR>"
					dat += "<A href='?src=\ref[src];action=create;item=milk;cost=20'>10 milk</A> <FONT COLOR=blue>([round(20/build_eff)])</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=meat;cost=50'>Slab of meat</A> <FONT COLOR=blue>([round(50/build_eff)])</FONT><BR>"
					dat += "Nutrient<BR>"
					dat += "<A href='?src=\ref[src];action=create;item=ez;cost=60'>E-Z-Nutrient</A> <FONT COLOR=blue>([round(60/build_eff)])</FONT> | <A href='?src=\ref[src];action=create;item=ez5;cost=300'>x5</A><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=l4z;cost=120'>Left 4 Zed</A> <FONT COLOR=blue>([round(120/build_eff)])</FONT> | <A href='?src=\ref[src];action=create;item=l4z5;cost=600'>x5</A><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=rh;cost=150'>Robust Harvest</A> <FONT COLOR=blue>([round(150/build_eff)])</FONT> | <A href='?src=\ref[src];action=create;item=rh5;cost=750'>x5</A><BR>"
					dat += "Leather<BR>"
					dat += "<A href='?src=\ref[src];action=create;item=wallet;cost=100'>Wallet</A> <FONT COLOR=blue>([round(100/build_eff)])</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=gloves;cost=250'>Botanical gloves</A> <FONT COLOR=blue>([round(250/build_eff)])</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=tbelt;cost=300'>Utility belt</A> <FONT COLOR=blue>([round(300/build_eff)])</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=satchel;cost=400'>Leather Satchel</A> <FONT COLOR=blue>([round(400/build_eff)])</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=cashbag;cost=400'>Cash Bag</A> <FONT COLOR=blue>([round(400/build_eff)])</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=workboots;cost=400'>Workboots</A> <FONT COLOR=blue>([round(400/build_eff)])</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=leathershoes;cost=400'>Leather Shoes</A> <FONT COLOR=blue>([round(400/build_eff)])</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=dressshoes;cost=400'>Dress Shoes</A> <FONT COLOR=blue>([round(400/build_eff)])</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=leathercoat;cost=500'>Leather Coat</A> <FONT COLOR=blue>([round(500/build_eff)])</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=leatherjacket;cost=500'>Leather Jacket</A> <FONT COLOR=blue>([round(500/build_eff)])</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=bomberjacket;cost=500'>Bomber Jacket</A> <FONT COLOR=blue>([round(500/build_eff)])</FONT><BR>"
					dat += "<A href='?src=\ref[src];action=create;item=wintercoat;cost=500'>Winter Coat</A> <FONT COLOR=blue>([round(500/build_eff)])</FONT><BR>"
					//dat += "Other<BR>"
					//dat += "<A href='?src=\ref[src];action=create;item=monkey;cost=500'>Monkey</A> <FONT COLOR=blue>(500)</FONT><BR>"
				else
					dat += "<BR><FONT COLOR=red>No beaker inside. Please insert a beaker.</FONT><BR>"
			if("nopoints")
				dat += "You do not have biomass to create products.<BR>Please, put produce into reactor and activate it.<BR>"
				dat += "<A href='?src=\ref[src];action=menu'>Return to menu</A>"
			if("complete")
				dat += "Operation complete.<BR>"
				dat += "<A href='?src=\ref[src];action=menu'>Return to menu</A>"
			if("void")
				dat += "<FONT COLOR=red>Error: No produce inside.</FONT><BR>Please, put produce into reactor.<BR>"
				dat += "<A href='?src=\ref[src];action=menu'>Return to menu</A>"
	user << browse(dat, "window=biogenerator")
	onclose(user, "biogenerator")
	return

/obj/machinery/biogenerator/attack_hand(mob/user as mob)
	interact(user)

/obj/machinery/biogenerator/proc/activate()
	if (usr.stat)
		return
	if (stat) //NOPOWER etc
		return
	if(processing)
		to_chat(usr, "<span class='notice'>The biogenerator is in the process of working.</span>")
		return
	var/S = 0
	for(var/obj/item/weapon/reagent_containers/food/snacks/grown/I in contents)
		S += 5
		if(I.reagents.get_reagent_amount("nutriment") < 0.1)
			points += 1
		else points += I.reagents.get_reagent_amount("nutriment") * 10 * eat_eff
		qdel(I)
	if(S)
		processing = 1
		update_icon()
		updateUsrDialog()
		playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
		use_power(S * 30)
		sleep((S + 15) / eat_eff)
		processing = 0
		update_icon()
	else
		menustat = "void"
	return

/obj/machinery/biogenerator/proc/create_product(var/item, var/cost)
	cost = round(cost/build_eff)
	if(cost > points)
		menustat = "nopoints"
		return 0
	processing = 1
	update_icon()
	updateUsrDialog()
	points -= cost
	sleep(30)
	switch(item)
		if("milk")
			beaker.reagents.add_reagent("milk", 10)
		if("meat")
			new/obj/item/weapon/reagent_containers/food/snacks/meat(loc)
		if("ez")
			new/obj/item/weapon/reagent_containers/glass/bottle/eznutrient(loc)
		if("l4z")
			new/obj/item/weapon/reagent_containers/glass/bottle/left4zed(loc)
		if("rh")
			new/obj/item/weapon/reagent_containers/glass/bottle/robustharvest(loc)
		if("ez5") //It's not an elegant method, but it's safe and easy. -Cheridan
			new/obj/item/weapon/reagent_containers/glass/bottle/eznutrient(loc)
			new/obj/item/weapon/reagent_containers/glass/bottle/eznutrient(loc)
			new/obj/item/weapon/reagent_containers/glass/bottle/eznutrient(loc)
			new/obj/item/weapon/reagent_containers/glass/bottle/eznutrient(loc)
			new/obj/item/weapon/reagent_containers/glass/bottle/eznutrient(loc)
		if("l4z5")
			new/obj/item/weapon/reagent_containers/glass/bottle/left4zed(loc)
			new/obj/item/weapon/reagent_containers/glass/bottle/left4zed(loc)
			new/obj/item/weapon/reagent_containers/glass/bottle/left4zed(loc)
			new/obj/item/weapon/reagent_containers/glass/bottle/left4zed(loc)
			new/obj/item/weapon/reagent_containers/glass/bottle/left4zed(loc)
		if("rh5")
			new/obj/item/weapon/reagent_containers/glass/bottle/robustharvest(loc)
			new/obj/item/weapon/reagent_containers/glass/bottle/robustharvest(loc)
			new/obj/item/weapon/reagent_containers/glass/bottle/robustharvest(loc)
			new/obj/item/weapon/reagent_containers/glass/bottle/robustharvest(loc)
			new/obj/item/weapon/reagent_containers/glass/bottle/robustharvest(loc)
		if("wallet")
			new/obj/item/weapon/storage/wallet/leather(loc)
		if("gloves")
			new/obj/item/clothing/gloves/thick/botany(loc)
		if("tbelt")
			new/obj/item/weapon/storage/belt/utility(loc)
		if("satchel")
			new/obj/item/weapon/storage/backpack/satchel(loc)
		if("cashbag")
			new/obj/item/weapon/storage/bag/cash(loc)
		if("monkey")
			new/mob/living/carbon/human/monkey(loc)
		if("workboots")
			new/obj/item/clothing/shoes/workboots(loc)
		if("leathershoes")
			new/obj/item/clothing/shoes/leather(loc)
		if("dressshoes")
			new/obj/item/clothing/shoes/dress(loc)
		if("leathercoat")
			new/obj/item/clothing/suit/leathercoat(loc)
		if("leatherjacket")
			new/obj/item/clothing/suit/storage/toggle/brown_jacket(loc)
		if("bomberjacket")
			new/obj/item/clothing/suit/storage/toggle/bomber(loc)
		if("wintercoat")
			new/obj/item/clothing/suit/storage/hooded/wintercoat(loc)
	processing = 0
	menustat = "complete"
	update_icon()
	return 1

/obj/machinery/biogenerator/Topic(href, href_list)
	if(stat & BROKEN) return
	if(usr.stat || usr.restrained()) return
	if(!in_range(src, usr)) return

	usr.set_machine(src)

	switch(href_list["action"])
		if("activate")
			activate()
		if("detach")
			if(beaker)
				beaker.dropInto(src.loc)
				beaker = null
				update_icon()
		if("create")
			create_product(href_list["item"], text2num(href_list["cost"]))
		if("menu")
			menustat = "menu"
	updateUsrDialog()

/obj/machinery/biogenerator/RefreshParts()
	..()
	var/man_rating = 0
	var/bin_rating = 0

	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(istype(P, /obj/item/weapon/stock_parts/matter_bin))
			bin_rating += P.rating
		if(istype(P, /obj/item/weapon/stock_parts/manipulator))
			man_rating += P.rating

	build_eff = man_rating
	eat_eff = bin_rating
