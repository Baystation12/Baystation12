var/global/list/alphabet_uppercase = list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")
var/list/genome_prefixes = list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")

var/list/spawn_types_animal = list("/mob/living/carbon/slime",\
"/mob/living/simple_animal/hostile/alien",\
"/mob/living/simple_animal/hostile/alien/drone",\
"/mob/living/simple_animal/hostile/alien/sentinel",\
"/mob/living/simple_animal/hostile/giant_spider",\
"/mob/living/simple_animal/hostile/giant_spider/hunter",\
"/mob/living/simple_animal/hostile/giant_spider/nurse",\
"/mob/living/simple_animal/hostile/creature",\
"/mob/living/simple_animal/hostile/samak",\
"/mob/living/simple_animal/hostile/diyaab",\
"/mob/living/simple_animal/hostile/shantak",\
"/mob/living/simple_animal/tindalos",\
"/mob/living/simple_animal/yithian")

var/list/spawn_types_plant = list("/obj/item/seeds/walkingmushroommycelium",\
"/obj/item/seeds/killertomatoseed",\
"/obj/item/seeds/shandseed",
"/obj/item/seeds/mtearseed",
"/obj/item/seeds/thaadra",\
"/obj/item/seeds/telriis",\
"/obj/item/seeds/jurlmah",\
"/obj/item/seeds/amauri",\
"/obj/item/seeds/gelthi",\
"/obj/item/seeds/vale",\
"/obj/item/seeds/surik")

var/list/all_animal_genesequences = list()
var/list/all_plant_genesequences = list()

datum/genesequence
	var/spawned_type
	var/spawned_type_text
	var/list/full_genome_sequence = list()

/proc/create_all_genesequences()
	//create animal gene sequences
	while(spawn_types_animal.len && genome_prefixes.len)
		var/datum/genesequence/new_sequence = new/datum/genesequence()
		new_sequence.spawned_type_text = pick(spawn_types_animal)
		new_sequence.spawned_type = text2path(new_sequence.spawned_type_text)
		spawn_types_animal -= new_sequence.spawned_type

		var/prefixletter = pick(genome_prefixes)
		genome_prefixes -= prefixletter
		while(new_sequence.full_genome_sequence.len < 7)
			new_sequence.full_genome_sequence.Add("[prefixletter][pick(alphabet_uppercase)][pick(alphabet_uppercase)][pick(1,2,3,4,5,6,7,8,9,0)][pick(1,2,3,4,5,6,7,8,9,0)]")

		all_animal_genesequences.Add(new_sequence)

	//create plant gene sequences
	while(spawn_types_plant.len && genome_prefixes.len)
		var/datum/genesequence/new_sequence = new/datum/genesequence()
		new_sequence.spawned_type = pick(spawn_types_plant)
		spawn_types_plant -= new_sequence.spawned_type

		var/prefixletter = pick(genome_prefixes)
		genome_prefixes -= prefixletter
		while(new_sequence.full_genome_sequence.len < 7)
			new_sequence.full_genome_sequence.Add("[prefixletter][pick(1,2,3,4,5,6,7,8,9,0)][pick(1,2,3,4,5,6,7,8,9,0)][pick(alphabet_uppercase)][pick(alphabet_uppercase)]")

		all_plant_genesequences.Add(new_sequence)



/obj/machinery/computer/reconstitutor
	name = "Flora reconstitution console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "dna"
	circuit = "/obj/item/weapon/circuitboard/reconstitutor"
	req_access = list(access_heads) //Only used for record deletion right now.
	var/obj/machinery/clonepod/pod1 = null //Linked cloning pod.
	var/temp = ""
	var/menu = 1 //Which menu screen to display
	var/list/records = list()
	var/datum/dna2/record/active_record = null
	var/obj/item/weapon/disk/data/diskette = null //Mostly so the geneticist can steal everything.
	var/loading = 0 // Nice loading text
	var/list/undiscovered_genesequences = null
	var/list/discovered_genesequences = list()
	var/list/completed_genesequences = list()
	var/list/undiscovered_genomes = list()
	var/list/manually_placed_genomes = list()
	var/list/discovered_genomes = list("! Clear !")
	var/list/accepted_fossil_types = list(/obj/item/weapon/fossil/plant)

/obj/machinery/computer/reconstitutor/New()
	create_all_genesequences()
	if(!undiscovered_genesequences)
		undiscovered_genesequences = all_plant_genesequences.Copy()
	..()

/obj/machinery/computer/reconstitutor/animal
	name = "Fauna reconstitution console"
	accepted_fossil_types = list(/obj/item/weapon/fossil/bone,/obj/item/weapon/fossil/shell,/obj/item/weapon/fossil/skull)

/obj/machinery/computer/reconstitutor/animal/New()
	create_all_genesequences()
	undiscovered_genesequences = all_animal_genesequences.Copy()
	..()

/obj/machinery/computer/reconstitutor/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/weapon/fossil))
		user.drop_item()
		W.loc = src.loc
		switch(scan_fossil(W))
			if(1)
				src.visible_message("\red \icon[src] [src] scans the fossil and rejects it.")
			if(2)
				visible_message("\red \icon[src] can not extract any more genetic data from new fossils.")
			if(4)
				src.visible_message("\blue \icon[src] [user] inserts [W] into [src], the fossil is consumed.")
				del(W)
				updateDialog()
	else if (istype(W, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = W
		S.hide_from(usr)
		var/numaccepted = 0
		var/numrejected = 0
		var/full = 0
		for(var/obj/item/weapon/fossil/F in S.contents)
			switch(scan_fossil(F))
				if(1)
					numrejected += 1
				if(2)
					full = 1
				if(4)
					numaccepted += 1
					S.remove_from_storage(F, src) //This will move the item to this item's contents
					del(F)
					updateDialog()
		var/outmsg = "\blue You empty all the fossils from [S] into [src]."
		if(numaccepted)
			outmsg += " \blue[numaccepted] fossils were accepted."
		if(numrejected)
			outmsg += " \red[numrejected] fossils were rejected."
		if(full)
			outmsg += " \red[src] can not extract any more genetic data from new fossils."
		visible_message(outmsg)

	else
		..()

/obj/machinery/computer/reconstitutor/attack_hand(var/mob/user as mob)
	src.add_fingerprint(user)
	interact(user)

/obj/machinery/computer/reconstitutor/interact(mob/user)
	if(stat & (NOPOWER|BROKEN) || get_dist(src, user) > 1)
		user.unset_machine(src)
		return

	var/dat = "<B>Garland Corp genetic reconstitutor</B><BR>"
	dat += "<HR>"
	if(!pod1)
		pod1 = locate() in orange(1, src)

	if(!pod1)
		dat += "<b><font color=red>Unable to locate cloning pod.</font></b><br>"
	else
		dat += "<b><font color=green>Cloning pod connected.</font></b><br>"

	dat += "<table border=1>"
	dat += "<tr>"
	dat += "<td><b>GENE1</b></td>"
	dat += "<td><b>GENE2</b></td>"
	dat += "<td><b>GENE3</b></td>"
	dat += "<td><b>GENE4</b></td>"
	dat += "<td><b>GENE5</b></td>"
	dat += "<td><b>GENE6</b></td>"
	dat += "<td><b>GENE7</b></td>"
	dat += "<td></td>"
	dat += "<td></td>"
	dat += "</tr>"

	//WIP gene sequences
	for(var/sequence_num = 1, sequence_num <= discovered_genesequences.len, sequence_num += 1)
		var/datum/genesequence/cur_genesequence = discovered_genesequences[sequence_num]
		dat += "<tr>"
		var/num_correct = 0
		for(var/curindex = 1, curindex <= 7, curindex++)
			var/bgcolour = "#ffffff"//white ffffff, red ff0000

			//background colour hints at correct positioning
			if(manually_placed_genomes[sequence_num][curindex])
				//green background if slot is correctly filled
				if(manually_placed_genomes[sequence_num][curindex] == cur_genesequence.full_genome_sequence[curindex])
					bgcolour = "#008000"
					num_correct += 1
					if(num_correct == 7)
						discovered_genesequences -= cur_genesequence
						completed_genesequences += cur_genesequence
						manually_placed_genomes[sequence_num] = new/list(7)
						interact(user)
						return
				//yellow background if adjacent to correct slot
				if(curindex > 1 && manually_placed_genomes[sequence_num][curindex] == cur_genesequence.full_genome_sequence[curindex - 1])
					bgcolour = "#ffff00"
				else if(curindex < 7 && manually_placed_genomes[sequence_num][curindex] == cur_genesequence.full_genome_sequence[curindex + 1])
					bgcolour = "#ffff00"

			var/this_genome_slot = manually_placed_genomes[sequence_num][curindex]
			if(!this_genome_slot)
				this_genome_slot = "- - - - -"
			dat += "<td><a href='?src=\ref[src];sequence_num=[sequence_num];insertpos=[curindex]' style='background-color:[bgcolour]'>[this_genome_slot]</a></td>"
		dat += "<td><a href='?src=\ref[src];reset=1;sequence_num=[sequence_num]'>Reset</a></td>"
		//dat += "<td><a href='?src=\ref[src];clone=1;sequence_num=[sequence_num]'>Clone</a></td>"
		dat += "</tr>"

	//completed gene sequences
	for(var/sequence_num = 1, sequence_num <= completed_genesequences.len, sequence_num += 1)
		var/datum/genesequence/cur_genesequence = completed_genesequences[sequence_num]
		dat += "<tr>"
		for(var/curindex = 1, curindex <= 7, curindex++)
			var/this_genome_slot = cur_genesequence.full_genome_sequence[curindex]
			dat += "<td style='background-color:#008000'>[this_genome_slot]</td>"
		dat += "<td><a href='?src=\ref[src];wipe=1;sequence_num=[sequence_num]'>Wipe</a></td>"
		dat += "<td><a href='?src=\ref[src];clone=1;sequence_num=[sequence_num]'>Clone</a></td>"
		dat += "</tr>"

	dat += "</table>"

	dat += "<br>"
	dat += "<hr>"
	dat += "<a href='?src=\ref[src];close=1'>Close</a>"
	user << browse(dat, "window=reconstitutor;size=600x500")
	user.set_machine(src)
	onclose(user, "reconstitutor")

/obj/machinery/computer/reconstitutor/animal/Topic(href, href_list)
	if(href_list["clone"])
		var/sequence_num = text2num(href_list["sequence_num"])
		var/datum/genesequence/cloned_genesequence = completed_genesequences[sequence_num]
		if(pod1)
			if(pod1.occupant)
				visible_message("\red \icon[src] The cloning pod is currently occupied.")
			else if(pod1.biomass < CLONE_BIOMASS)
				visible_message("\red \icon[src] Not enough biomass in the cloning pod.")
			else if(pod1.mess)
				visible_message("\red \icon[src] Error: clonepod malfunction.")
			else
				visible_message("\blue \icon[src] [src] clones something from a reconstituted gene sequence!")
				playsound(src.loc, 'sound/effects/screech.ogg', 50, 1, -3)
				pod1.occupant = new cloned_genesequence.spawned_type(pod1)
				pod1.locked = 1
				pod1.icon_state = "pod_1"
				//pod1.occupant.name = "[pod1.occupant.name] ([rand(0,999)])"
				pod1.biomass -= CLONE_BIOMASS
		else
			usr << "\red \icon[src] Unable to locate cloning pod!"
	else
		..()

/obj/machinery/computer/reconstitutor/Topic(href, href_list)
	if(href_list["insertpos"])
		//world << "inserting gene for genesequence [href_list["insertgenome"]] at pos [text2num(href_list["insertpos"])]"
		var/sequence_num = text2num(href_list["sequence_num"])
		var/insertpos = text2num(href_list["insertpos"])

		var/old_genome = manually_placed_genomes[sequence_num][insertpos]
		discovered_genomes = sortList(discovered_genomes)
		var/new_genome = input(usr, "Which genome do you want to insert here?") as null|anything in discovered_genomes
		if(new_genome == "! Clear !")
			manually_placed_genomes[sequence_num][insertpos] = null
		else if(new_genome)
			manually_placed_genomes[sequence_num][insertpos] = new_genome
			discovered_genomes.Remove(new_genome)
		if(old_genome)
			discovered_genomes.Add(old_genome)
		updateDialog()

	else if(href_list["reset"])
		var/sequence_num = text2num(href_list["sequence_num"])
		for(var/curindex = 1, curindex <= 7, curindex++)
			var/old_genome = manually_placed_genomes[sequence_num][curindex]
			manually_placed_genomes[sequence_num][curindex] = null
			if(old_genome)
				discovered_genomes.Add(old_genome)
		updateDialog()

	else if(href_list["wipe"])
		var/sequence_num = text2num(href_list["sequence_num"])
		var/datum/genesequence/wiped_genesequence = completed_genesequences[sequence_num]
		completed_genesequences.Remove(wiped_genesequence)
		discovered_genesequences.Add(wiped_genesequence)

		discovered_genomes.Add(wiped_genesequence.full_genome_sequence)
		discovered_genomes = sortList(discovered_genomes)
		updateDialog()

	else if(href_list["clone"])
		var/sequence_num = text2num(href_list["sequence_num"])
		var/datum/genesequence/cloned_genesequence = completed_genesequences[sequence_num]
		visible_message("\blue \icon[src] [src] clones a packet of seeds from a reconstituted gene sequence!")
		playsound(src.loc, 'sound/effects/screech.ogg', 50, 1, -3)
		new cloned_genesequence.spawned_type(src.loc)

	else if(href_list["close"])
		usr.unset_machine(src)
		usr << browse(null, "window=reconstitutor")

	else
		..()

/obj/machinery/computer/reconstitutor/proc/scan_fossil(var/obj/item/weapon/fossil/scan_fossil)
	//see whether we accept these kind of fossils
	if(accepted_fossil_types.len && !accepted_fossil_types.Find(scan_fossil.type))
		return 1

	//see whether we are going to discover a new sequence, new genome for existing sequence or nothing
	var/new_genome_prob = discovered_genesequences.len * 50

	if( (new_genome_prob >= 100 || prob(new_genome_prob)) && undiscovered_genomes.len)
		//create a new genome for an existing gene sequence
		var/newly_discovered_genome = pick(undiscovered_genomes)
		undiscovered_genomes -= newly_discovered_genome
		discovered_genomes.Add(newly_discovered_genome)

	else if(undiscovered_genesequences.len)
		//discover new gene sequence
		var/datum/genesequence/newly_discovered_genesequence = pick(undiscovered_genesequences)
		undiscovered_genesequences -= newly_discovered_genesequence
		discovered_genesequences += newly_discovered_genesequence
		//add genomes for new gene sequence to pool of discoverable genomes
		undiscovered_genomes.Add(newly_discovered_genesequence.full_genome_sequence)
		manually_placed_genomes.Add(null)
		manually_placed_genomes[manually_placed_genomes.len] = new/list(7)

	else
		//there's no point scanning any more fossils, we've already discovered everything
		return 2

	return 4
