#define BOTTLE_SPRITES list("bottle-1", "bottle-2", "bottle-3", "bottle-4") //list of available bottle sprites

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/chem_master
	name = "\improper ChemMaster 3000"
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"
	idle_power_usage = 20
	clicksound = "button"
	clickvol = 20
	var/obj/item/weapon/reagent_containers/beaker = null
	var/obj/item/weapon/storage/pill_bottle/loaded_pill_bottle = null
	var/mode = 0
	var/useramount = 30 // Last used amount
	var/pillamount = 10
	var/bottlesprite = "bottle-1" //yes, strings
	var/pillsprite = "1"
	var/client/has_sprites = list()
	var/max_pill_count = 20
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	core_skill = SKILL_CHEMISTRY
	var/sloppy = 1 //Whether reagents will not be fully purified (sloppy = 1) or there will be reagent loss (sloppy = 0) on reagent add.

/obj/machinery/chem_master/New()
	create_reagents(120)
	..()

/obj/machinery/chem_master/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return

/obj/machinery/chem_master/attackby(var/obj/item/weapon/B as obj, var/mob/user as mob)

	if(istype(B, /obj/item/weapon/reagent_containers/glass))

		if(src.beaker)
			to_chat(user, "A beaker is already loaded into the machine.")
			return
		if(!user.unEquip(B, src))
			return
		src.beaker = B
		to_chat(user, "You add the beaker to the machine!")
		src.updateUsrDialog()
		icon_state = "mixer1"

	else if(istype(B, /obj/item/weapon/storage/pill_bottle))

		if(src.loaded_pill_bottle)
			to_chat(user, "A pill bottle is already loaded into the machine.")
			return
		if(!user.unEquip(B, src))
			return
		src.loaded_pill_bottle = B
		to_chat(user, "You add the pill bottle into the dispenser slot!")
		src.updateUsrDialog()

/obj/machinery/chem_master/Topic(href, href_list, state)
	if(..())
		return 1
	var/mob/user = usr

	if (href_list["ejectp"])
		if(loaded_pill_bottle)
			loaded_pill_bottle.dropInto(loc)
			loaded_pill_bottle = null
	else if(href_list["close"])
		show_browser(user, null, "window=chemmaster")
		user.unset_machine()
		return

	if(beaker)
		var/datum/reagents/R = beaker.reagents
		if (href_list["analyze"])
			var/datum/reagent/reagent = locate(href_list["analyze"]) in R.reagent_list
			var/dat = get_chem_info(reagent)
			if(dat)
				show_browser(user, dat, "window=chem_master;size=575x400")
			return

		else if (href_list["add"])
			if(href_list["amount"])
				var/datum/reagent/their_reagent = locate(href_list["add"]) in R.reagent_list
				if(their_reagent)
					var/mult = 1
					var/amount = Clamp((text2num(href_list["amount"])), 0, 200)
					if(sloppy)
						var/contaminants = fetch_contaminants(user, R, their_reagent)
						for(var/datum/reagent/reagent in contaminants)
							R.trans_type_to(src, reagent.type, round(rand()*amount/5, 0.1))
					else
						mult -= 0.4 * (SKILL_MAX - user.get_skill_value(core_skill))/(SKILL_MAX-SKILL_MIN) //10% loss per skill level down from max
					R.trans_type_to(src, their_reagent.type, amount, mult)



		else if (href_list["addcustom"])
			var/datum/reagent/their_reagent = locate(href_list["addcustom"]) in R.reagent_list
			if(their_reagent)
				useramount = input("Select the amount to transfer.", 30, useramount) as null|num
				if(useramount)
					useramount = Clamp(useramount, 0, 200)
					src.Topic(href, list("amount" = "[useramount]", "add" = href_list["addcustom"]), state)

		else if (href_list["remove"])
			if(href_list["amount"])
				var/datum/reagent/my_reagents = locate(href_list["remove"]) in reagents.reagent_list
				if(my_reagents)
					var/amount = Clamp((text2num(href_list["amount"])), 0, 200)
					var/contaminants = fetch_contaminants(user, reagents, my_reagents)
					if(mode)
						reagents.trans_type_to(beaker, my_reagents.type, amount)
						for(var/datum/reagent/reagent in contaminants)
							reagents.trans_type_to(beaker, reagent.type, round(rand()*amount, 0.1))
					else
						reagents.remove_reagent(my_reagents.type, amount)
						for(var/datum/reagent/reagent in contaminants)
							reagents.remove_reagent(reagent.type, round(rand()*amount, 0.1))

		else if (href_list["removecustom"])
			var/datum/reagent/my_reagents = locate(href_list["removecustom"]) in reagents.reagent_list
			if(my_reagents)
				useramount = input("Select the amount to transfer.", 30, useramount) as null|num
				if(useramount)
					useramount = Clamp(useramount, 0, 200)
					src.Topic(href, list("amount" = "[useramount]", "remove" = href_list["removecustom"]), state)

		else if (href_list["toggle"])
			mode = !mode
		else if (href_list["toggle_sloppy"])
			sloppy = !sloppy

		else if (href_list["main"])
			attack_hand(user)
			return
		else if (href_list["eject"])
			beaker.forceMove(loc)
			beaker = null
			reagents.clear_reagents()
			icon_state = "mixer0"
		else if (href_list["createpill"] || href_list["createpill_multiple"])
			var/count = 1

			if(reagents.total_volume/count < 1) //Sanity checking.
				return

			if (href_list["createpill_multiple"])
				count = input("Select the number of pills to make.", "Max [max_pill_count]", pillamount) as num
				count = Clamp(count, 1, max_pill_count)

			if(reagents.total_volume/count < 1) //Sanity checking.
				return

			var/amount_per_pill = reagents.total_volume/count
			if (amount_per_pill > 60) amount_per_pill = 60

			var/name = sanitizeSafe(input(usr,"Name:","Name your pill!","[reagents.get_master_reagent_name()] ([amount_per_pill]u)"), MAX_NAME_LEN)

			if(reagents.total_volume/count < 1) //Sanity checking.
				return
			while (count-- && count >= 0)
				var/obj/item/weapon/reagent_containers/pill/P = new/obj/item/weapon/reagent_containers/pill(loc)
				if(!name) name = reagents.get_master_reagent_name()
				P.SetName("[name] pill")
				P.icon_state = "pill"+pillsprite
				if(P.icon_state in list("pill1", "pill2", "pill3", "pill4", "pill5")) // if using greyscale, take colour from reagent
					P.color = reagents.get_color()
				reagents.trans_to_obj(P,amount_per_pill)
				if(loaded_pill_bottle)
					if(loaded_pill_bottle.contents.len < loaded_pill_bottle.max_storage_space)
						P.forceMove(loaded_pill_bottle)

		else if (href_list["createbottle"])
			create_bottle(user)
		else if(href_list["change_pill"])
			#define MAX_PILL_SPRITE 25 //max icon state of the pill sprites
			var/dat = "<table>"
			for(var/i = 1 to MAX_PILL_SPRITE)
				dat += "<tr><td><a href=\"?src=\ref[src]&pill_sprite=[i]\"><img src=\"pill[i].png\" /></a></td></tr>"
			dat += "</table>"
			show_browser(user, dat, "window=chem_master")
			return
		else if(href_list["change_bottle"])
			var/dat = "<table>"
			for(var/sprite in BOTTLE_SPRITES)
				dat += "<tr><td><a href=\"?src=\ref[src]&bottle_sprite=[sprite]\"><img src=\"[sprite].png\" /></a></td></tr>"
			dat += "</table>"
			show_browser(user, dat, "window=chem_master")
			return
		else if(href_list["pill_sprite"])
			pillsprite = href_list["pill_sprite"]
		else if(href_list["bottle_sprite"])
			bottlesprite = href_list["bottle_sprite"]

	updateUsrDialog()

/obj/machinery/chem_master/proc/fetch_contaminants(mob/user, datum/reagents/reagents, datum/reagent/main_reagent)
	. = list()
	for(var/datum/reagent/reagent in reagents.reagent_list)
		if(reagent == main_reagent)
			continue
		if(prob(user.skill_fail_chance(core_skill, 100)))
			. += reagent

/obj/machinery/chem_master/proc/get_chem_info(datum/reagent/reagent, heading = "Chemical infos", detailed_blood = 1)
	if(!beaker || !reagent)
		return
	. = list()
	. += "<TITLE>[name]</TITLE>"
	. += "[heading]:<BR><BR>Name:<BR>[reagent.name]"
	. += "<BR><BR>Description:<BR>"
	if(detailed_blood && istype(reagent, /datum/reagent/blood))
		var/datum/reagent/blood/B = reagent
		. += "Blood Type: [B.data["blood_type"]]<br>DNA: [B.data["blood.DNA"]]"
	else
		. += "[reagent.description]"
	. += "<BR><BR><BR><A href='?src=\ref[src];main=1'>(Back)</A>"
	. = JOINTEXT(.)

/obj/machinery/chem_master/proc/create_bottle(mob/user)
	var/name = sanitizeSafe(input(usr,"Name:","Name your bottle!",reagents.get_master_reagent_name()), MAX_NAME_LEN)
	var/obj/item/weapon/reagent_containers/glass/bottle/P = new/obj/item/weapon/reagent_containers/glass/bottle(loc)
	if(!name)
		name = reagents.get_master_reagent_name()
	P.SetName("[name] bottle")
	P.icon_state = bottlesprite
	reagents.trans_to_obj(P,60)
	P.update_icon()

/obj/machinery/chem_master/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/chem_master/attack_hand(mob/user)
	if(inoperable())
		return
	user.set_machine(src)
	if(!(user.client in has_sprites))
		spawn()
			has_sprites += user.client
			for(var/i = 1 to MAX_PILL_SPRITE)
				usr << browse_rsc(icon('icons/obj/chemical.dmi', "pill" + num2text(i)), "pill[i].png")
			for(var/sprite in BOTTLE_SPRITES)
				usr << browse_rsc(icon('icons/obj/chemical.dmi', sprite), "[sprite].png")
	var/dat = list()
	dat += "<TITLE>[name]</TITLE>"
	dat += "[name] Menu:"
	if(!beaker)
		dat += "Please insert beaker.<BR>"
		if(loaded_pill_bottle)
			dat += "<A href='?src=\ref[src];ejectp=1'>Eject Pill Bottle \[[loaded_pill_bottle.contents.len]/[loaded_pill_bottle.max_storage_space]\]</A><BR><BR>"
		else
			dat += "No pill bottle inserted.<BR><BR>"
		dat += "<A href='?src=\ref[src];close=1'>Close</A>"
	else
		var/datum/reagents/R = beaker.reagents
		dat += "<A href='?src=\ref[src];eject=1'>Eject beaker and Clear Buffer</A><BR>"
		dat += "Toggle purification mode: <A href='?src=\ref[src];toggle_sloppy=1'>[sloppy ? "Quick" : "Thorough"]</A><BR>"
		if(loaded_pill_bottle)
			dat += "<A href='?src=\ref[src];ejectp=1'>Eject Pill Bottle \[[loaded_pill_bottle.contents.len]/[loaded_pill_bottle.max_storage_space]\]</A><BR><BR>"
		else
			dat += "No pill bottle inserted.<BR><BR>"
		if(!R.total_volume)
			dat += "Beaker is empty."
		else
			dat += "Add to buffer:<BR>"
			for(var/datum/reagent/G in R.reagent_list)
				dat += "[G.name], [G.volume] Units - "
				dat += "<A href='?src=\ref[src];analyze=\ref[G]'>(Analyze)</A> "
				dat += "<A href='?src=\ref[src];add=\ref[G];amount=1'>(1)</A> "
				dat += "<A href='?src=\ref[src];add=\ref[G];amount=5'>(5)</A> "
				dat += "<A href='?src=\ref[src];add=\ref[G];amount=10'>(10)</A> "
				dat += "<A href='?src=\ref[src];add=\ref[G];amount=[G.volume]'>(All)</A> "
				dat += "<A href='?src=\ref[src];addcustom=\ref[G]'>(Custom)</A><BR>"

		dat += "<HR>Transfer to <A href='?src=\ref[src];toggle=1'>[(!mode ? "disposal" : "beaker")]:</A><BR>"
		if(reagents.total_volume)
			for(var/datum/reagent/N in reagents.reagent_list)
				dat += "[N.name], [N.volume] Units - "
				dat += "<A href='?src=\ref[src];analyze=\ref[N]'>(Analyze)</A> "
				dat += "<A href='?src=\ref[src];remove=\ref[N];amount=1'>(1)</A> "
				dat += "<A href='?src=\ref[src];remove=\ref[N];amount=5'>(5)</A> "
				dat += "<A href='?src=\ref[src];remove=\ref[N];amount=10'>(10)</A> "
				dat += "<A href='?src=\ref[src];remove=\ref[N];amount=[N.volume]'>(All)</A> "
				dat += "<A href='?src=\ref[src];removecustom=\ref[N]'>(Custom)</A><BR>"
		else
			dat += "Empty<BR>"
		dat += extra_options()
	show_browser(user, strip_improper(JOINTEXT(dat)), "window=chem_master;size=575x400")
	onclose(user, "chem_master")

//Use to add extra stuff to the end of the menu.
/obj/machinery/chem_master/proc/extra_options()
	. = list()
	. += "<HR><BR><A href='?src=\ref[src];createpill=1'>Create pill (60 units max)</A><a href=\"?src=\ref[src]&change_pill=1\"><img src=\"pill[pillsprite].png\" /></a><BR>"
	. += "<A href='?src=\ref[src];createpill_multiple=1'>Create multiple pills</A><BR>"
	. += "<A href='?src=\ref[src];createbottle=1'>Create bottle (60 units max)<a href=\"?src=\ref[src]&change_bottle=1\"><img src=\"[bottlesprite].png\" /></A>"
	return JOINTEXT(.)

/obj/machinery/chem_master/condimaster
	name = "\improper CondiMaster 3000"
	core_skill = SKILL_COOKING

/obj/machinery/chem_master/condimaster/get_chem_info(datum/reagent/reagent)
	return ..(reagent, "Condiment infos", 0)

/obj/machinery/chem_master/condimaster/create_bottle(mob/user)
	var/obj/item/weapon/reagent_containers/food/condiment/P = new/obj/item/weapon/reagent_containers/food/condiment(src.loc)
	reagents.trans_to_obj(P,50)

/obj/machinery/chem_master/condimaster/extra_options()
	return "<A href='?src=\ref[src];createbottle=1'>Create bottle (50 units max)</A>"
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/obj/machinery/reagentgrinder

	name = "\improper All-In-One Grinder"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "juicer1"
	layer = BELOW_OBJ_LAYER
	density = 0
	anchored = 0
	idle_power_usage = 5
	active_power_usage = 100
	var/inuse = 0
	var/obj/item/weapon/reagent_containers/beaker = null
	var/limit = 10
	var/list/holdingitems = list()
	var/list/bag_whitelist = list(
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/weapon/storage/plants
	) // These bags will fast-empty into the grinder.

/obj/machinery/reagentgrinder/New()
	..()
	beaker = new /obj/item/weapon/reagent_containers/glass/beaker/large(src)

/obj/machinery/reagentgrinder/on_update_icon()
	icon_state = "juicer"+num2text(!isnull(beaker))

/obj/machinery/reagentgrinder/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if (istype(O,/obj/item/weapon/reagent_containers/glass) || \
		istype(O,/obj/item/weapon/reagent_containers/food/drinks/glass2) || \
		istype(O,/obj/item/weapon/reagent_containers/food/drinks/shaker))

		if (beaker)
			return 1
		else
			if(!user.unEquip(O, src))
				return
			src.beaker =  O
			update_icon()
			src.updateUsrDialog()
			return 0

	if(holdingitems && holdingitems.len >= limit)
		to_chat(usr, "The machine cannot hold anymore items.")
		return 1

	if(!istype(O))
		return

	if(is_type_in_list(O, bag_whitelist))
		var/obj/item/weapon/storage/bag = O
		var/failed = 1
		for(var/obj/item/G in O)
			if(!G.reagents || !G.reagents.total_volume)
				continue
			failed = 0
			bag.remove_from_storage(G, src, 1)
			holdingitems += G
			if(holdingitems && holdingitems.len >= limit)
				break

		if(failed)
			to_chat(user, "Nothing in \the [O] is usable.")
			return 1
		bag.finish_bulk_removal()

		if(!O.contents.len)
			to_chat(user, "You empty \the [O] into \the [src].")
		else
			to_chat(user, "You fill \the [src] from \the [O].")

		src.updateUsrDialog()
		return 0

	if(istype(O,/obj/item/stack/material))
		var/obj/item/stack/material/stack = O
		var/material/material = stack.material
		if(!length(material.chem_products))
			to_chat(user, "\The [material.name] is unable to produce any usable reagents.")
			return 1

	else if(!O.reagents || !O.reagents.total_volume)
		to_chat(user, "\The [O] is not suitable for blending.")
		return 1

	if(!user.unEquip(O, src))
		return
	holdingitems += O
	src.updateUsrDialog()
	return 0

/obj/machinery/reagentgrinder/attack_ai(mob/user as mob)
	return 0

/obj/machinery/reagentgrinder/attack_hand(mob/user as mob)
	interact(user)

/obj/machinery/reagentgrinder/attack_robot(var/mob/user)
	//Calling for adjacency as I don't think grinders are wireless.
	if(Adjacent(user))
		//Calling attack_hand(user) to make ensure no functionality is missed.
		//If attack_hand is updated, this segment won't have to be updated as well.
		return attack_hand(user)

/obj/machinery/reagentgrinder/interact(mob/user as mob) // The microwave Menu
	if(inoperable())
		return
	user.set_machine(src)
	var/is_chamber_empty = 0
	var/is_beaker_ready = 0
	var/processing_chamber = ""
	var/beaker_contents = ""
	var/dat = list()

	if(!inuse)
		for (var/obj/item/O in holdingitems)
			processing_chamber += "\A [O.name]<BR>"

		if (!processing_chamber)
			is_chamber_empty = 1
			processing_chamber = "Nothing."
		if (!beaker)
			beaker_contents = "<B>No beaker attached.</B><br>"
		else
			is_beaker_ready = 1
			beaker_contents = "<B>The beaker contains:</B><br>"
			var/anything = 0
			for(var/datum/reagent/R in beaker.reagents.reagent_list)
				anything = 1
				beaker_contents += "[R.volume] - [R.name]<br>"
			if(!anything)
				beaker_contents += "Nothing<br>"


		dat += {"
	<b>Processing chamber contains:</b><br>
	[processing_chamber]<br>
	[beaker_contents]<hr>
	"}
		if (is_beaker_ready && !is_chamber_empty && !(stat & (NOPOWER|BROKEN)))
			dat += "<A href='?src=\ref[src];action=grind'>Process the reagents</a><BR>"
		if(holdingitems && holdingitems.len > 0)
			dat += "<A href='?src=\ref[src];action=eject'>Eject the reagents</a><BR>"
		if (beaker)
			dat += "<A href='?src=\ref[src];action=detach'>Detach the beaker</a><BR>"
	else
		dat += "Please wait..."
	dat = "<HEAD><TITLE>[name]</TITLE></HEAD><TT>[JOINTEXT(dat)]</TT>"
	show_browser(user, strip_improper(dat), "window=reagentgrinder")
	onclose(user, "reagentgrinder")

/obj/machinery/reagentgrinder/OnTopic(user, href_list)
	if(href_list["action"])
		switch(href_list["action"])
			if ("grind")
				grind(user)
			if("eject")
				eject()
			if ("detach")
				detach()
		interact(user)
		return TOPIC_REFRESH

/obj/machinery/reagentgrinder/proc/detach()
	if (!beaker)
		return
	beaker.dropInto(loc)
	beaker = null
	update_icon()

/obj/machinery/reagentgrinder/proc/eject()
	if (!holdingitems || holdingitems.len == 0)
		return

	for(var/obj/item/O in holdingitems)
		O.dropInto(loc)
		holdingitems -= O
	holdingitems.Cut()

/obj/machinery/reagentgrinder/proc/grind(mob/user)

	power_change()
	if(stat & (NOPOWER|BROKEN))
		return

	// Sanity check.
	if (!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return

	hurt_hand(user)
	playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
	inuse = 1

	// Reset the machine.
	spawn(60)
		inuse = 0
		interact(user)

	var/skill_factor = CLAMP01(1 + 0.3*(user.get_skill_value(SKILL_CHEMISTRY) - SKILL_EXPERT)/(SKILL_EXPERT - SKILL_MIN))
	// Process.
	for (var/obj/item/O in holdingitems)

		var/remaining_volume = beaker.reagents.maximum_volume - beaker.reagents.total_volume
		if(remaining_volume <= 0)
			break

		var/obj/item/stack/material/stack = O
		if(istype(stack))
			var/material/material = stack.material
			if(!material.chem_products.len)
				break

			var/list/chem_products = material.chem_products
			var/sheet_volume = 0
			for(var/chem in chem_products)
				sheet_volume += chem_products[chem]

			var/amount_to_take = max(0,min(stack.amount,round(remaining_volume/sheet_volume)))
			if(amount_to_take)
				stack.use(amount_to_take)
				if(QDELETED(stack))
					holdingitems -= stack
				for(var/chem in chem_products)
					beaker.reagents.add_reagent(chem, (amount_to_take*chem_products[chem]*skill_factor))
				continue

		if(O.reagents)
			O.reagents.trans_to(beaker, O.reagents.total_volume, skill_factor)
			if(O.reagents.total_volume == 0)
				holdingitems -= O
				qdel(O)
			if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break

/obj/machinery/reagentgrinder/proc/hurt_hand(mob/living/carbon/human/user)
	var/skill_to_check = SKILL_CHEMISTRY
	if(user.get_skill_value(SKILL_COOKING) > user.get_skill_value(SKILL_CHEMISTRY))
		skill_to_check = SKILL_COOKING
	if(!istype(user) || !prob(user.skill_fail_chance(skill_to_check, 50, SKILL_BASIC)))
		return
	var/hand = pick(BP_L_HAND, BP_R_HAND)
	var/obj/item/organ/external/hand_organ = user.get_organ(hand)
	if(!hand_organ)
		return

	var/dam = rand(10, 15)
	user.visible_message("<span class='danger'>\The [user]'s hand gets caught in \the [src]!</span>", "<span class='danger'>Your hand gets caught in \the [src]!</span>")
	user.apply_damage(dam, BRUTE, hand, damage_flags = DAM_SHARP, used_weapon = "grinder")
	if(BP_IS_ROBOTIC(hand_organ))
		beaker.reagents.add_reagent(/datum/reagent/iron, dam)
	else
		user.take_blood(beaker, dam)
	user.Stun(2)
	addtimer(CALLBACK(src, .proc/shake, user, 40), 0)

/obj/machinery/reagentgrinder/proc/shake(mob/user, duration)
	for(var/i = 1, i<=duration, i++)
		sleep(1)
		if(!user || !Adjacent(user))
			break
		if(user.is_jittery)
			continue
		user.do_jitter(4)

	if(user && !user.is_jittery)
		user.do_jitter(0) //resets the icon.
