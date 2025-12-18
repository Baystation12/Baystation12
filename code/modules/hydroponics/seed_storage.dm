/datum/seed_pile
	var/name
	var/amount
	var/datum/seed/seed_type // Keeps track of what our seed is
	var/list/obj/item/seeds/seeds = list() // Tracks actual objects contained in the pile
	var/ID

/datum/seed_pile/New(obj/item/seeds/O, ID)
	name = O.name
	amount = 1
	seed_type = O.seed
	seeds += O
	src.ID = ID

/datum/seed_pile/proc/matches(obj/item/seeds/O)
	if (O.seed == seed_type)
		return 1
	return 0

/obj/machinery/seed_storage
	name = "Seed storage"
	desc = "It stores, sorts, and dispenses seeds."
	icon = 'icons/obj/machines/vending.dmi'
	icon_state = "seeds"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 100
	obj_flags = OBJ_FLAG_ANCHORABLE

	var/list/datum/seed_pile/piles = list()
	var/list/starting_seeds = list(
		/obj/item/seeds/affelerin = 15,
		/obj/item/seeds/aghrassh = 15,
		/obj/item/seeds/algaeseed = 15,
		/obj/item/seeds/almondseed = 15,
		/obj/item/seeds/ambrosiavulgarisseed = 15,
		/obj/item/seeds/appleseed = 15,
		/obj/item/seeds/bamboo = 15,
		/obj/item/seeds/bananaseed = 15,
		/obj/item/seeds/berryseed = 15,
		/obj/item/seeds/blueberryseed = 15,
		/obj/item/seeds/cabbageseed = 15,
		/obj/item/seeds/cocoapodseed = 15,
		/obj/item/seeds/carrotseed = 15,
		/obj/item/seeds/chantermycelium = 15,
		/obj/item/seeds/cherryseed = 15,
		/obj/item/seeds/chiliseed = 15,
		/obj/item/seeds/cinnamon = 15,
		/obj/item/seeds/clam = 5,
		/obj/item/seeds/coconutseed = 15,
		/obj/item/seeds/coffeeseed = 15,
		/obj/item/seeds/cornseed = 15,
		/obj/item/seeds/crab = 5,
		/obj/item/seeds/replicapod = 15,
		/obj/item/seeds/eggplantseed = 15,
		/obj/item/seeds/amanitamycelium = 15,
		/obj/item/seeds/garlicseed = 15,
		/obj/item/seeds/glowshroom = 15,
		/obj/item/seeds/grapeseed = 15,
		/obj/item/seeds/grassseed = 15,
		/obj/item/seeds/greengrapeseed = 15,
		/obj/item/seeds/gukhe = 15,
		/obj/item/seeds/gummen = 15,
		/obj/item/seeds/harebell = 15,
		/obj/item/seeds/hrukhza = 15,
		/obj/item/seeds/iridast = 15,
		/obj/item/seeds/kudzuseed = 15,
		/obj/item/seeds/lavenderseed = 15,
		/obj/item/seeds/lemonseed = 15,
		/obj/item/seeds/lettuceseed = 15,
		/obj/item/seeds/libertymycelium = 15,
		/obj/item/seeds/limeseed = 15,
		/obj/item/seeds/melonseed = 15,
		/obj/item/seeds/mtearseed = 15,
		/obj/item/seeds/mussel = 5,
		/obj/item/seeds/nettleseed = 15,
		/obj/item/seeds/okrri = 15,
		/obj/item/seeds/olives = 15,
		/obj/item/seeds/onionseed = 15,
		/obj/item/seeds/orangeseed = 15,
		/obj/item/seeds/oyster = 5,
		/obj/item/seeds/peanutseed = 15,
		/obj/item/seeds/pearseed = 15,
		/obj/item/seeds/peppercornseed = 15,
		/obj/item/seeds/pineappleseed = 15,
		/obj/item/seeds/plastiseed = 15,
		/obj/item/seeds/plumpmycelium = 15,
		/obj/item/seeds/poppyseed = 15,
		/obj/item/seeds/potatoseed = 15,
		/obj/item/seeds/pumpkinseed = 15,
		/obj/item/seeds/qokkloa = 15,
		/obj/item/seeds/reishimycelium = 15,
		/obj/item/seeds/riceseed = 15,
		/obj/item/seeds/shandseed = 15,
		/obj/item/seeds/shrimp = 5,
		/obj/item/seeds/soyaseed = 15,
		/obj/item/seeds/sugarcaneseed = 15,
		/obj/item/seeds/sunflowerseed = 15,
		/obj/item/seeds/tobaccoseed = 15,
		/obj/item/seeds/tomatoseed = 15,
		/obj/item/seeds/towermycelium = 15,
		/obj/item/seeds/vanillaseed = 15,
		/obj/item/seeds/watermelonseed = 15,
		/obj/item/seeds/wheatseed = 15,
		/obj/item/seeds/whitebeetseed = 15,
		/obj/item/seeds/whitegrapeseed = 15,
		/obj/item/seeds/ximikoa = 15
	)
	var/list/scanner = list() // What properties we can view

/obj/machinery/seed_storage/Initialize(mapload)
	. = ..()
	if (LAZYLEN(starting_seeds))
		for(var/typepath in starting_seeds)
			var/amount = starting_seeds[typepath]
			if(isnull(amount))
				amount = 1
			for (var/i = 1 to amount)
				var/O = new typepath
				add(O)
		sort_piles()

/obj/machinery/seed_storage/random // This is mostly for testing, but I guess admins could spawn it
	name = "Random seed storage"
	scanner = list("stats", "produce", "soil", "temperature", "light")
	starting_seeds = list(/obj/item/seeds/random = 50)

/obj/machinery/seed_storage/garden
	name = "Garden seed storage"
	scanner = list("stats")
	icon_state = "seeds_generic"

/obj/machinery/seed_storage/xenobotany
	name = "Xenobotany seed storage"
	scanner = list("stats", "produce", "soil", "temperature", "light")

/obj/machinery/seed_storage/xenobotany/Initialize()
	starting_seeds += list(/obj/item/seeds/random = 5)
	. = ..()

/obj/machinery/seed_storage/all
	name = "Debug seed storage"
	scanner = list("stats", "produce", "soil", "temperature", "light")
	starting_seeds = list()

/obj/machinery/seed_storage/all/Initialize(mapload)
	for (var/typepath in subtypesof(/obj/item/seeds))
		if (typepath == /obj/item/seeds/random || typepath == /obj/item/seeds/cutting)
			continue
		starting_seeds[typepath] = 5
	. = ..()

/obj/machinery/seed_storage/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/seed_storage/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = TRUE)
	user.set_machine(src)

	var/list/data = list()
	var/list/seeds = list()

	data["scanner"] = scanner
	for (var/datum/seed_pile/S in piles)
		var/datum/seed/seed = S.seed_type
		if (!seed)
			continue

		var/list/seed_data = list()

		seed_data["name"] = seed.seed_name
		seed_data["variety"] = seed.uid

		var/list/traits = list()

		if ("stats" in scanner)
			traits["endurance"] = seed.get_trait(TRAIT_ENDURANCE)
			traits["yield"] = seed.get_trait(TRAIT_YIELD)
			traits["maturation"] = seed.get_trait(TRAIT_MATURATION)
			traits["production"] = seed.get_trait(TRAIT_PRODUCTION)
			traits["potency"] = seed.get_trait(TRAIT_POTENCY)
			traits["harvest"] = seed.get_trait(TRAIT_HARVEST_REPEAT)

		if ("temperature" in scanner)
			traits["ideal_heat"] = seed.get_trait(TRAIT_IDEAL_HEAT)
			traits["ideal_light"] = seed.get_trait(TRAIT_IDEAL_LIGHT)

		if ("soil" in scanner)
			if(seed.get_trait(TRAIT_REQUIRES_NUTRIENTS))
				if(seed.get_trait(TRAIT_NUTRIENT_CONSUMPTION) < 0.05)
					traits["nutrient_consumption"] = "Low"
				else if(seed.get_trait(TRAIT_NUTRIENT_CONSUMPTION) > 0.2)
					traits["nutrient_consumption"] = "High"
				else
					traits["nutrient_consumption"] = "Normal"
			else
				traits["nutrient_consumption"] = "None"
			if(seed.get_trait(TRAIT_REQUIRES_WATER))
				if(seed.get_trait(TRAIT_WATER_CONSUMPTION) < 1)
					traits["water_consumption"] = "Low"
				else if(seed.get_trait(TRAIT_WATER_CONSUMPTION) > 5)
					traits["water_consumption"] = "High"
				else
					traits["water_consumption"] = "Normal"
			else
				traits["water_consumption"] = "None"

		var/binary_traits = ""

		switch(seed.get_trait(TRAIT_CARNIVOROUS))
			if(1)
				binary_traits += "<span>Carnivorous</span>"
			if(2)
				binary_traits += SPAN_WARNING("Carnivorous!")
		switch(seed.get_trait(TRAIT_SPREAD))
			if(1)
				binary_traits += "<span>Vine</span>"
			if(2)
				binary_traits += SPAN_WARNING("Vine!")

		if ("pressure" in scanner)
			if(seed.get_trait(TRAIT_LOWKPA_TOLERANCE) < 20)
				binary_traits += "<span>Low pressure tolerant</span>"
			if(seed.get_trait(TRAIT_HIGHKPA_TOLERANCE) > 220)
				binary_traits += "<span>High pressure tolerant</span>"
		if ("temperature" in scanner)
			if(seed.get_trait(TRAIT_HEAT_TOLERANCE) > 30)
				binary_traits += "<span>Temperature tolerant</span>"
			else if(seed.get_trait(TRAIT_HEAT_TOLERANCE) < 10)
				binary_traits += "<span>Temperature sensitive</span>"

		if ("light" in scanner)
			if(seed.get_trait(TRAIT_LIGHT_TOLERANCE) > 10)
				binary_traits += "<span>Light tolerant</span>"
			else if(seed.get_trait(TRAIT_LIGHT_TOLERANCE) < 3)
				binary_traits += "<span>Light sensitive</span>"

		if(seed.get_trait(TRAIT_TOXINS_TOLERANCE) < 3)
			binary_traits += "<span>Toxin sensitive</span>"
		else if(seed.get_trait(TRAIT_TOXINS_TOLERANCE) > 6)
			binary_traits += "<span>Toxin tolerant</span>"

		if(seed.get_trait(TRAIT_PEST_TOLERANCE) < 3)
			binary_traits += "<span>Pest sensitive</span>"
		else if(seed.get_trait(TRAIT_PEST_TOLERANCE) > 6)
			binary_traits += "<span>Pest tolerant</span>"

		if(seed.get_trait(TRAIT_WEED_TOLERANCE) < 3)
			binary_traits += "<span>Weed sensitive</span>"
		else if(seed.get_trait(TRAIT_WEED_TOLERANCE) > 6)
			binary_traits += "<span>Weed tolerant</span>"
		if(seed.get_trait(TRAIT_PARASITE))
			binary_traits += "<span>Parasitic</span>"

		if ("temperature" in scanner)
			if(seed.get_trait(TRAIT_ALTER_TEMP) > 0)
				binary_traits += "<span>Warming</span>"
			if(seed.get_trait(TRAIT_ALTER_TEMP) < 0)
				binary_traits += "<span>Cooling</span>"
		if(seed.get_trait(TRAIT_BIOLUM))
			binary_traits += "<span>Bioluminescent</span>"

		seed_data["traits"] = traits
		seed_data["binary_traits"] = binary_traits
		seed_data["amount"] = S.amount
		seed_data["id"] = S.ID

		seeds.Add(list(seed_data))

	data["seeds"] = seeds

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (isnull(ui))
		ui = new(user, src, ui_key, "seed_storage.tmpl", "Seed Storage", 900, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/seed_storage/OnTopic(mob/user, href_list, datum/topic_state/state)
	for (var/datum/seed_pile/N in piles)
		if (href_list["vend"] && text2num(href_list["vend"]) == N.ID)
			var/obj/O = pick(N.seeds)
			if (O)
				--N.amount
				N.seeds -= O
				if (N.amount <= 0 || length(N.seeds) <= 0)
					piles -= N
					qdel(N)
				flick("[initial(icon_state)]-vend", src)
				O.dropInto(loc)
			else
				piles -= N
				qdel(N)
			return TOPIC_REFRESH
		else if (href_list["purge"] && text2num(href_list["purge"]) == N.ID && (alert("Are you sure you want to purge all of \the [N.seed_type?.seed_name] seeds?", "Are you sure?", "No", "Yes") == "Yes"))
			for (var/obj/O in N.seeds)
				qdel(O)
				piles -= N
				qdel(N)
			return TOPIC_REFRESH
	return TOPIC_HANDLED

/obj/machinery/seed_storage/use_tool(obj/item/O, mob/living/user, list/click_params)
	if (istype(O, /obj/item/seeds))
		add(O)
		sort_piles()
		user.visible_message("[user] puts \the [O.name] into \the [src].", "You put \the [O] into \the [src].")
		SSnano.update_uis(src)
		return TRUE

	if (istype(O, /obj/item/storage/plants))
		var/obj/item/storage/P = O
		var/loaded = 0
		for(var/obj/item/seeds/G in P.contents)
			++loaded
			P.remove_from_storage(G, src, 1)
			add(G, 1)
		P.finish_bulk_removal()
		if (loaded)
			sort_piles()
			user.visible_message("[user] puts the seeds from \the [O.name] into \the [src].", "You put the seeds from \the [O.name] into \the [src].")
		else
			to_chat(user, SPAN_NOTICE("There are no seeds in \the [O.name]."))
		SSnano.update_uis(src)
		return TRUE
	return ..()

/obj/machinery/seed_storage/proc/add(obj/item/seeds/O, bypass_removal = 0)
	if(!bypass_removal)
		if (ismob(O.loc))
			var/mob/user = O.loc
			if(!user.unEquip(O, src))
				return
		else if(istype(O.loc,/obj/item/storage))
			var/obj/item/storage/S = O.loc
			S.remove_from_storage(O, src)

	O.forceMove(src)
	var/newID = 0

	for (var/datum/seed_pile/N in piles)
		if (N.matches(O))
			++N.amount
			N.seeds += (O)
			return
		else if(N.ID >= newID)
			newID = N.ID + 1

	piles += new /datum/seed_pile(O, newID)
	flick("[initial(icon_state)]-vend", src)
	return


/// Handles sorting of the `piles` list.
/obj/machinery/seed_storage/proc/sort_piles()
	piles = sortAtom(piles)
