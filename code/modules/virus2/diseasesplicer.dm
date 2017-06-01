/obj/machinery/computer/diseasesplicer
	name = "disease splicer"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "med_key"
	icon_screen = "crew"

	var/datum/disease2/effect/memorybank = null
	var/list/species_buffer = null
	var/analysed = 0
	var/obj/item/weapon/virusdish/dish = null
	var/burning = 0
	var/splicing = 0
	var/scanning = 0

/obj/machinery/computer/diseasesplicer/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		return ..(I,user)

	if(istype(I,/obj/item/weapon/virusdish))
		var/mob/living/carbon/c = user
		if (dish)
			to_chat(user, "\The [src] is already loaded.")
			return

		dish = I
		c.drop_item()
		I.loc = src

	if(istype(I,/obj/item/weapon/diseasedisk))
		to_chat(user, "You upload the contents of the disk onto the buffer.")
		var/obj/item/weapon/diseasedisk/disk = I
		memorybank = disk.effect
		species_buffer = disk.species
		analysed = disk.analysed

	src.attack_hand(user)

/obj/machinery/computer/diseasesplicer/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/diseasesplicer/attack_hand(var/mob/user as mob)
	if(..()) return
	ui_interact(user)

/obj/machinery/computer/diseasesplicer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/data[0]
	data["dish_inserted"] = !!dish
	data["growth"] = 0
	data["affected_species"] = null

	if (memorybank)
		data["buffer"] = list("name" = (analysed ? memorybank.name : "Unknown Symptom"), "stage" = memorybank.stage)
	if (species_buffer)
		data["species_buffer"] = analysed ? jointext(species_buffer, ", ") : "Unknown Species"

	if (splicing)
		data["busy"] = "Splicing..."
	else if (scanning)
		data["busy"] = "Scanning..."
	else if (burning)
		data["busy"] = "Copying data to disk..."
	else if (dish)
		data["growth"] = min(dish.growth, 100)

		if (dish.virus2)
			if (dish.virus2.affected_species)
				data["affected_species"] = dish.analysed ? jointext(dish.virus2.affected_species, ", ") : "Unknown"

			if (dish.growth >= 50)
				var/list/effects[0]
				for (var/datum/disease2/effect/e in dish.virus2.effects)
					effects.Add(list(list("name" = (dish.analysed ? e.name : "Unknown"), "stage" = (e.stage), "reference" = "\ref[e]")))
				data["effects"] = effects
			else
				data["info"] = "Insufficient cell growth for gene splicing."
		else
			data["info"] = "No virus detected."
	else
		data["info"] = "No dish loaded."

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "disease_splicer.tmpl", src.name, 400, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/computer/diseasesplicer/process()
	if(stat & (NOPOWER|BROKEN))
		return

	if(scanning)
		scanning -= 1
		if(!scanning)
			ping("\The [src] pings, \"Analysis complete.\"")
			nanomanager.update_uis(src)
	if(splicing)
		splicing -= 1
		if(!splicing)
			ping("\The [src] pings, \"Splicing operation complete.\"")
			nanomanager.update_uis(src)
	if(burning)
		burning -= 1
		if(!burning)
			var/obj/item/weapon/diseasedisk/d = new /obj/item/weapon/diseasedisk(src.loc)
			d.analysed = analysed
			if(analysed)
				if (memorybank)
					d.name = "[memorybank.name] GNA disk (Stage: [memorybank.stage])"
					d.effect = memorybank
				else if (species_buffer)
					d.name = "[jointext(species_buffer, ", ")] GNA disk"
					d.species = species_buffer
			else
				if (memorybank)
					d.name = "Unknown GNA disk (Stage: [memorybank.stage])"
					d.effect = memorybank
				else if (species_buffer)
					d.name = "Unknown Species GNA disk"
					d.species = species_buffer

			ping("\The [src] pings, \"Backup disk saved.\"")
			nanomanager.update_uis(src)

/obj/machinery/computer/diseasesplicer/Topic(href, href_list)
	if(..()) return 1

	var/mob/user = usr
	var/datum/nanoui/ui = nanomanager.get_open_ui(user, src, "main")

	src.add_fingerprint(user)

	if (href_list["close"])
		user.unset_machine()
		ui.close()
		return 0

	if (href_list["grab"])
		if (dish)
			memorybank = locate(href_list["grab"])
			species_buffer = null
			analysed = dish.analysed
			dish = null
			scanning = 10
		return 1

	if (href_list["affected_species"])
		if (dish)
			memorybank = null
			species_buffer = dish.virus2.affected_species
			analysed = dish.analysed
			dish = null
			scanning = 10
		return 1

	if(href_list["eject"])
		if (dish)
			dish.loc = src.loc
			dish = null
		return 1

	if(href_list["splice"])
		if(dish)
			var/target = text2num(href_list["splice"]) // target = 1 to 4 for effects, 5 for species
			if(memorybank && 0 < target && target <= 4)
				if(target < memorybank.stage) return // too powerful, catching this for href exploit prevention

				var/datum/disease2/effect/target_effect
				var/list/illegal_types = list()
				for(var/datum/disease2/effect/e in dish.virus2.effects)
					if(e.stage == target)
						target_effect = e
					else
						illegal_types += e.type
				if(memorybank.type in illegal_types) return
				dish.virus2.effects -= target_effect
				dish.virus2.effects += memorybank
				qdel(target_effect)

			else if(species_buffer && target == 5)
				dish.virus2.affected_species = species_buffer

			else
				return

			splicing = 10
			dish.virus2.uniqueID = rand(0,10000)
		return 1

	if(href_list["disk"])
		burning = 10
		return 1

	return 0
