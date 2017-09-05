
/datum/event/economic_event
	endWhen = 50			//this will be set randomly, later
	announceWhen = 15
	var/event_type = 0
	var/list/cheaper_goods = list()
	var/list/dearer_goods = list()
	var/datum/trade_destination/affected_dest

/datum/event/economic_event/start()
	affected_dest = pickweight(weighted_randomevent_locations)
	if(affected_dest.viable_random_events.len)
		endWhen = rand(60,300)
		event_type = pick(affected_dest.viable_random_events)

		if(!event_type)
			return

		switch(event_type)
			if(RIOTS)
				dearer_goods = list(SECURITY)
				cheaper_goods = list(MINERALS, FOOD)
			if(WILD_ANIMAL_ATTACK)
				cheaper_goods = list(ANIMALS)
				dearer_goods = list(FOOD, BIOMEDICAL)
			if(INDUSTRIAL_ACCIDENT)
				dearer_goods = list(EMERGENCY, BIOMEDICAL, ROBOTICS)
			if(BIOHAZARD_OUTBREAK)
				dearer_goods = list(BIOMEDICAL, GAS)
			if(PIRATES)
				dearer_goods = list(SECURITY, MINERALS)
			if(CORPORATE_ATTACK)
				dearer_goods = list(SECURITY, MAINTENANCE)
			if(ALIEN_RAIDERS)
				dearer_goods = list(BIOMEDICAL, ANIMALS)
				cheaper_goods = list(GAS, MINERALS)
			if(AI_LIBERATION)
				dearer_goods = list(EMERGENCY, GAS, MAINTENANCE)
			if(MOURNING)
				cheaper_goods = list(MINERALS, MAINTENANCE)
			if(CULT_CELL_REVEALED)
				dearer_goods = list(SECURITY, BIOMEDICAL, MAINTENANCE)
			if(SECURITY_BREACH)
				dearer_goods = list(SECURITY)
			if(ANIMAL_RIGHTS_RAID)
				dearer_goods = list(ANIMALS)
			if(FESTIVAL)
				dearer_goods = list(FOOD, ANIMALS)
		for(var/good_type in dearer_goods)
			affected_dest.temp_price_change[good_type] = rand(1,100)
		for(var/good_type in cheaper_goods)
			affected_dest.temp_price_change[good_type] = rand(1,100) / 100

/datum/event/economic_event/announce()
	var/author = "Nyx Daily"
	var/channel = author

	//see if our location has custom event info for this event
	var/body = affected_dest.get_custom_eventstring()
	if(!body)
		switch(event_type)
			if(RIOTS)
				body = "[pick("Riots have","Unrest has")] broken out on planet [affected_dest.name]. Authorities call for calm, as [pick("various parties","rebellious elements","peacekeeping forces","\'REDACTED\'")] begin stockpiling weaponry and armour. Meanwhile, food and mineral prices are dropping as local industries attempt empty their stocks in expectation of looting."
			if(WILD_ANIMAL_ATTACK)
				body = "Local [pick("wildlife","animal life","fauna")] on planet [affected_dest.name] has been increasing in agression and raiding outlying settlements for food. Big game hunters have been called in to help alleviate the problem, but numerous injuries have already occurred."
			if(INDUSTRIAL_ACCIDENT)
				body = "[pick("An industrial accident","A smelting accident","A malfunction","A malfunctioning piece of machinery","Negligent maintenance","A cooleant leak","A ruptured conduit")] at a [pick("factory","installation","power plant","dockyards")] on [affected_dest.name] resulted in severe structural damage and numerous injuries. Repairs are ongoing."
			if(BIOHAZARD_OUTBREAK)
				body = "[pick("A \'REDACTED\'","A biohazard","An outbreak","A virus")] on [affected_dest.name] has resulted in quarantine, stopping much shipping in the area. Although the quarantine is now lifted, authorities are calling for deliveries of medical supplies to treat the infected, and gas to replace contaminated stocks."
			if(PIRATES)
				body = "[pick("Pirates","Criminal elements","A [pick("mercenary","Donk Co.","Waffle Co.","\'REDACTED\'")] strike force")] have [pick("raided","blockaded","attempted to blackmail","attacked")] [affected_dest.name] today. Security has been tightened, but many valuable minerals were taken."
			if(CORPORATE_ATTACK)
				body = "A small [pick("pirate","Cybersun Industries","Gorlex Marauders","mercenary")] fleet has precise-jumped into proximity with [affected_dest.name], [pick("for a smash-and-grab operation","in a hit and run attack","in an overt display of hostilities")]. Much damage was done, and security has been tightened since the incident."
			if(ALIEN_RAIDERS)
				if(prob(20))
					body = "The Tiger Co-operative have raided [affected_dest.name] today, no doubt on orders from their enigmatic masters. Stealing wildlife, farm animals, medical research materials and kidnapping civilians. [GLOB.using_map.company_name] authorities are standing by to counter attempts at bio-terrorism."
				else
					body = "[pick("The alien species designated \'United Exolitics\'","The alien species designated \'REDACTED\'","An unknown alien species")] have raided [affected_dest.name] today, stealing wildlife, farm animals, medical research materials and kidnapping civilians. It seems they desire to learn more about us, so the Navy will be standing by to accomodate them next time they try."
			if(AI_LIBERATION)
				body = "A [pick("\'REDACTED\' was detected on","S.E.L.F operative infiltrated","malignant computer virus was detected on","rogue [pick("slicer","hacker")] was apprehended on")] [affected_dest.name] today, and managed to infect [pick("\'REDACTED\'","a sentient sub-system","a class one AI","a sentient defence installation")] before it could be stopped. Many lives were lost as it systematically begin murdering civilians, and considerable work must be done to repair the affected areas."
			if(MOURNING)
				body = "[pick("The popular","The well-liked","The eminent","The well-known")] [pick("professor","entertainer","singer","researcher","public servant","administrator","ship captain","\'REDACTED\'")], [pick( random_name(pick(MALE,FEMALE)), 40; "\'REDACTED\'" )] has [pick("passed away","committed suicide","been murdered","died in a freakish accident")] on [affected_dest.name] today. The entire planet is in mourning, and prices have dropped for industrial goods as worker morale drops."
			if(CULT_CELL_REVEALED)
				body = "A [pick("dastardly","blood-thirsty","villanous","crazed")] cult of [pick("The Elder Gods","Nar'sie","an apocalyptic sect","\'REDACTED\'")] has [pick("been discovered","been revealed","revealed themselves","gone public")] on [affected_dest.name] earlier today. Public morale has been shaken due to [pick("certain","several","one or two")] [pick("high-profile","well known","popular")] individuals [pick("performing \'REDACTED\' acts","claiming allegiance to the cult","swearing loyalty to the cult leader","promising to aid to the cult")] before those involved could be brought to justice. The editor reminds all personnel that supernatural myths will not be tolerated on [GLOB.using_map.company_name] facilities."
			if(SECURITY_BREACH)
				body = "There was [pick("a security breach in","an unauthorised access in","an attempted theft in","an anarchist attack in","violent sabotage of")] a [pick("high-security","restricted access","classified","\'REDACTED\'")] [pick("\'REDACTED\'","section","zone","area")] this morning. Security was tightened on [affected_dest.name] after the incident, and the editor reassures all [GLOB.using_map.company_name] personnel that such lapses are rare."
			if(ANIMAL_RIGHTS_RAID)
				body = "[pick("Militant animal rights activists","Members of the terrorist group Animal Rights Consortium","Members of the terrorist group \'REDACTED\'")] have [pick("launched a campaign of terror","unleashed a swathe of destruction","raided farms and pastures","forced entry to \'REDACTED\'")] on [affected_dest.name] earlier today, freeing numerous [pick("farm animals","animals","\'REDACTED\'")]. Prices for tame and breeding animals have spiked as a result."
			if(FESTIVAL)
				body = "A [pick("festival","week long celebration","day of revelry","planet-wide holiday")] has been declared on [affected_dest.name] by [pick("Governor","Commissioner","General","Commandant","Administrator")] [random_name(pick(MALE,FEMALE))] to celebrate [pick("the birth of their [pick("son","daughter")]","coming of age of their [pick("son","daughter")]","the pacification of rogue military cell","the apprehension of a violent criminal who had been terrorising the planet")]. Massive stocks of food and meat have been bought driving up prices across the planet."

	news_network.SubmitArticle(body, author, channel, null, 1)

/datum/event/economic_event/end()
	for(var/good_type in dearer_goods)
		affected_dest.temp_price_change[good_type] = 1
	for(var/good_type in cheaper_goods)
		affected_dest.temp_price_change[good_type] = 1
