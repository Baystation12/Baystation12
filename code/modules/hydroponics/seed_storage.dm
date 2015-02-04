/datum/seed_pile
	var/name
	var/amount
	var/datum/seed/seed_type // Keeps track of what our seed is
	var/list/obj/item/seeds/seeds = list() // Tracks actual objects contained in the pile
	var/ID

/datum/seed_pile/New(var/obj/item/seeds/O, var/ID)
	name = O.name
	amount = 1
	seed_type = O.seed
	seeds += O
	src.ID = ID

/datum/seed_pile/proc/matches(var/obj/item/seeds/O)
	if (O.seed == seed_type)
		return 1
	return 0

/obj/machinery/seed_storage
	name = "Seed storage"
	desc = "It stores, sorts, and dispenses seeds."
	icon = 'icons/obj/vending.dmi'
	icon_state = "seeds"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 100

	var/initialized = 0 // Map-placed ones break if seeds are loaded right at the start of the round, so we do it on the first interaction
	var/list/datum/seed_pile/piles = list()
	var/list/starting_seeds = list()
	var/list/scanner = list() // What properties we can view

/obj/machinery/seed_storage/random // This is mostly for testing, but I guess admins could spawn it
	name = "Random seed storage"
	scanner = list("stats", "produce", "soil", "temperature", "light", "mutants")
	starting_seeds = list(/obj/item/seeds/random = 50)

/obj/machinery/seed_storage/garden
	name = "Garden seed storage"
	scanner = list("stats")
	starting_seeds = list(/obj/item/seeds/appleseed = 3, /obj/item/seeds/bananaseed = 3, /obj/item/seeds/berryseed = 3, /obj/item/seeds/cabbageseed = 3, /obj/item/seeds/carrotseed = 3, /obj/item/seeds/chantermycelium = 3, /obj/item/seeds/cherryseed = 3, /obj/item/seeds/chiliseed = 3, /obj/item/seeds/cocoapodseed = 3, /obj/item/seeds/cornseed = 3, /obj/item/seeds/eggplantseed = 3, /obj/item/seeds/grapeseed = 3, /obj/item/seeds/grassseed = 3, /obj/item/seeds/lemonseed = 3, /obj/item/seeds/limeseed = 3, /obj/item/seeds/mtearseed = 2, /obj/item/seeds/orangeseed = 3, /obj/item/seeds/peanutseed = 3, /obj/item/seeds/plumpmycelium = 3, /obj/item/seeds/poppyseed = 3, /obj/item/seeds/potatoseed = 3, /obj/item/seeds/pumpkinseed = 3, /obj/item/seeds/riceseed = 3, /obj/item/seeds/soyaseed = 3, /obj/item/seeds/sugarcaneseed = 3, /obj/item/seeds/sunflowerseed = 3,  /obj/item/seeds/shandseed = 2, /obj/item/seeds/tomatoseed = 3, /obj/item/seeds/towermycelium = 3, /obj/item/seeds/watermelonseed = 3, /obj/item/seeds/wheatseed = 3, /obj/item/seeds/whitebeetseed = 3)

/obj/machinery/seed_storage/xenobotany
	name = "Xenobotany seed storage"
	scanner = list("stats", "produce", "soil", "temperature", "light", "mutants")
	starting_seeds = list(/obj/item/seeds/ambrosiavulgarisseed = 3, /obj/item/seeds/appleseed = 3, /obj/item/seeds/amanitamycelium = 2, /obj/item/seeds/bananaseed = 3, /obj/item/seeds/berryseed = 3, /obj/item/seeds/cabbageseed = 3, /obj/item/seeds/carrotseed = 3, /obj/item/seeds/chantermycelium = 3, /obj/item/seeds/cherryseed = 3, /obj/item/seeds/chiliseed = 3, /obj/item/seeds/cocoapodseed = 3, /obj/item/seeds/cornseed = 3, /obj/item/seeds/replicapod = 3, /obj/item/seeds/eggplantseed = 3, /obj/item/seeds/glowshroom = 2, /obj/item/seeds/grapeseed = 3, /obj/item/seeds/grassseed = 3, /obj/item/seeds/lemonseed = 3, /obj/item/seeds/libertymycelium = 2, /obj/item/seeds/limeseed = 3, /obj/item/seeds/mtearseed = 2, /obj/item/seeds/nettleseed = 2, /obj/item/seeds/orangeseed = 3, /obj/item/seeds/peanutseed = 3, /obj/item/seeds/plastiseed = 3, /obj/item/seeds/plumpmycelium = 3, /obj/item/seeds/poppyseed = 3, /obj/item/seeds/potatoseed = 3, /obj/item/seeds/pumpkinseed = 3, /obj/item/seeds/reishimycelium = 2, /obj/item/seeds/riceseed = 3, /obj/item/seeds/soyaseed = 3, /obj/item/seeds/sugarcaneseed = 3, /obj/item/seeds/sunflowerseed = 3, /obj/item/seeds/shandseed = 2, /obj/item/seeds/tomatoseed = 3, /obj/item/seeds/towermycelium = 3, /obj/item/seeds/watermelonseed = 3, /obj/item/seeds/wheatseed = 3, /obj/item/seeds/whitebeetseed = 3)

/obj/machinery/seed_storage/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/machinery/seed_storage/interact(mob/user as mob)
	if (..())
		return

	if (!initialized)
		for(var/typepath in starting_seeds)
			var/amount = starting_seeds[typepath]
			if(isnull(amount)) amount = 1

			for (var/i = 1 to amount)
				var/O = new typepath
				add(O)
		initialized = 1

	var/dat = "<center><h1>Seed storage contents</h1></center>"
	if (piles.len == 0)
		dat += "<font color='red'>No seeds</font>"
	else
		dat += "<table style='text-align:center;'><tr><td>Name</td>"
		dat += "<td>Variety</td>"
		if ("stats" in scanner)
			dat += "<td>E</td><td>Y</td><td>L</td><td>M</td><td>Pr</td><td>Pt</td><td>Harvest</td>"
		if ("produce" in scanner)
			dat += "<td>Produce</td>"
		if ("temperature" in scanner)
			dat += "<td>Temp</td>"
		if ("light" in scanner)
			dat += "<td>Light</td>"
		if ("soil" in scanner)
			dat += "<td>Nutri</td><td>Water</td>"
		dat += "<td>Notes</td><td>Amount</td><td></td></tr>"
		for (var/datum/seed_pile/S in piles)
			var/datum/seed/seed = S.seed_type
			dat += "<tr>"
			dat += "<td>[S.name]</td>"
			dat += "<td>#[seed.uid]</td>"
			if ("stats" in scanner)
				dat += "<td>[seed.endurance]</td><td>[seed.yield]</td><td>[seed.lifespan]</td><td>[seed.maturation]</td><td>[seed.production]</td><td>[seed.potency]</td>"
				if(seed.harvest_repeat)
					dat += "<td>Multiple</td>"
				else
					dat += "<td>Single</td>"
			if ("produce" in scanner)
				if (seed.products && seed.products.len)
					dat += "<td>Fruit: [seed.products.len]</td>"
				else
					dat += "<td>N/A</td>"
			if ("temperature" in scanner)
				dat += "<td>[seed.ideal_heat] K</td>"
			if ("light" in scanner)
				dat += "<td>[seed.ideal_light] L</td>"
			if ("soil" in scanner)
				if(seed.requires_nutrients)
					if(seed.nutrient_consumption < 0.05)
						dat += "<td>Low</td>"
					else if(seed.nutrient_consumption > 0.2)
						dat += "<td>High</td>"
					else
						dat += "<td>Norm</td>"
				else
					dat += "<td>No</td>"
				if(seed.requires_water)
					if(seed.water_consumption < 1)
						dat += "<td>Low</td>"
					else if(seed.water_consumption > 5)
						dat += "<td>High</td>"
					else
						dat += "<td>Norm</td>"
				else
					dat += "<td>No</td>"

			dat += "<td>"
			if ("mutants" in scanner)
				if(seed.mutants && seed.mutants.len)
					dat += "SUBSP "
				if(seed.immutable == -1)
					dat += "MUT "
				else if(seed.immutable > 0)
					dat += "NOMUT "
			switch(seed.carnivorous)
				if(1)
					dat += "CARN "
				if(2)
					dat	+= "<font color='red'>CARN </font>"
			switch(seed.spread)
				if(1)
					dat += "VINE "
				if(2)
					dat	+= "<font color='red'>VINE </font>"
			if ("pressure" in scanner)
				if(seed.lowkpa_tolerance < 20)
					dat += "LP "
				if(seed.highkpa_tolerance > 220)
					dat += "HP "
			if ("temperature" in scanner)
				if(seed.heat_tolerance > 30)
					dat += "TEMRES "
				else if(seed.heat_tolerance < 10)
					dat += "TEMSEN "
			if ("light" in scanner)
				if(seed.light_tolerance > 10)
					dat += "LIGRES "
				else if(seed.light_tolerance < 3)
					dat += "LIGSEN "
			if(seed.toxins_tolerance < 3)
				dat += "TOXSEN "
			else if(seed.toxins_tolerance > 6)
				dat += "TOXRES "
			if(seed.pest_tolerance < 3)
				dat += "PESTSEN "
			else if(seed.pest_tolerance > 6)
				dat += "PESTRES "
			if(seed.weed_tolerance < 3)
				dat += "WEEDSEN "
			else if(seed.weed_tolerance > 6)
				dat += "WEEDRES "
			if(seed.parasite)
				dat += "PAR "
			if ("temperature" in scanner)
				if(seed.alter_temp > 0)
					dat += "TEMP+ "
				if(seed.alter_temp < 0)
					dat += "TEMP- "
			if(seed.biolum)
				dat += "LUM "
			if(seed.flowers)
				dat += "<br>[seed.flower_colour ? "<font color='[seed.flower_colour]'>FLOW</font>" : "FLOW"]."
			dat += "</td>"
			dat += "<td>[S.amount]</td>"
			dat += "<td><a href='byond://?src=\ref[src];task=vend;id=[S.ID]'>Vend</a> <a href='byond://?src=\ref[src];task=purge;id=[S.ID]'>Purge</a></td>"
			dat += "</tr>"
		dat += "</table>"

	user << browse(dat, "window=seedstorage")
	onclose(user, "seedstorage")

/obj/machinery/seed_storage/Topic(var/href, var/list/href_list)
	if (..())
		return
	var/task = href_list["task"]
	var/ID = text2num(href_list["id"])

	for (var/datum/seed_pile/N in piles)
		if (N.ID == ID)
			if (task == "vend")
				var/obj/O = pick(N.seeds)
				if (O)
					--N.amount
					N.seeds -= O
					if (N.amount <= 0 || N.seeds.len <= 0)
						piles -= N
						del(N)
					O.loc = src.loc
				else
					piles -= N
					del(N)
			else if (task == "purge")
				for (var/obj/O in N.seeds)
					del(O)
					piles -= N
					del(N)
			break
	updateUsrDialog()

/obj/machinery/seed_storage/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (istype(O, /obj/item/seeds))
		add(O)
		user.visible_message("[user] puts \the [O.name] into \the [src].", "You put \the [O] into \the [src].")
		return
	else if (istype(O, /obj/item/weapon/storage/bag/plants))
		var/obj/item/weapon/storage/P = O
		var/loaded = 0
		for(var/obj/item/seeds/G in P.contents)
			++loaded
			add(G)
		if (loaded)
			user.visible_message("[user] puts the seeds from \the [O.name] into \the [src].", "You put the seeds from \the [O.name] into \the [src].")
		else
			user << "<span class='notice'>There are no seeds in \the [O.name].</span>"
		return
	else if(istype(O, /obj/item/weapon/wrench))
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		anchored = !anchored
		user << "You [anchored ? "wrench" : "unwrench"] \the [src]."

/obj/machinery/seed_storage/proc/add(var/obj/item/seeds/O as obj)
	if (istype(O.loc, /mob))
		var/mob/user = O.loc
		user.drop_item(O)
	else if(istype(O.loc,/obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = O.loc
		S.remove_from_storage(O, src)

	O.loc = src

	for (var/datum/seed_pile/N in piles)
		if (N.matches(O))
			++N.amount
			N.seeds += (O)
			return

	piles += new /datum/seed_pile(O, piles.len)
	return
