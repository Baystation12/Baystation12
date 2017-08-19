/datum/event/brand_intelligence
	announceWhen	= 21
	endWhen			= 1000	//Ends when all vending machines are subverted anyway.

	var/list/obj/machinery/vending/vendingMachines = list()
	var/list/obj/machinery/vending/infectedVendingMachines = list()
	var/obj/machinery/vending/originMachine


/datum/event/brand_intelligence/announce()
	command_announcement.Announce("Rampant brand intelligence has been detected aboard the [station_name()]. The origin is believed to be \a \"[initial(originMachine.name)]\" type. Fix it, before it spreads to other vending machines.", "Machine Learning Alert")


/datum/event/brand_intelligence/start()
	for(var/obj/machinery/vending/V in GLOB.machines)
		if(isNotStationLevel(V.z))	continue
		vendingMachines.Add(V)

	if(!vendingMachines.len)
		kill()
		return

	originMachine = pick(vendingMachines)
	vendingMachines.Remove(originMachine)
	originMachine.shut_up = 0
	originMachine.shoot_inventory = 1


/datum/event/brand_intelligence/tick()
	if(!vendingMachines.len || !originMachine || originMachine.shut_up || !originMachine.shoot_inventory)	//if every machine is infected, or if the original vending machine is missing or has it's voice switch flipped or fixed
		end()
		kill()
		return

	if(IsMultiple(activeFor, 5))
		if(prob(15))
			var/obj/machinery/vending/infectedMachine = pick(vendingMachines)
			vendingMachines.Remove(infectedMachine)
			infectedVendingMachines.Add(infectedMachine)
			infectedMachine.shut_up = 0
			infectedMachine.shoot_inventory = 1

	if(IsMultiple(activeFor, 12))
		originMachine.speak(pick("Try our aggressive new marketing strategies!", \
								 "You should buy products to feed your lifestyle obsession!", \
								 "Consume!", \
								 "Your money can buy happiness!", \
								 "Engage direct marketing!", \
								 "Advertising is legalized lying! But don't let that put you off our great deals!", \
								 "You don't want to buy anything? Yeah, well I didn't want to buy your mom either."))

/datum/event/brand_intelligence/end()
	for(var/obj/machinery/vending/infectedMachine in infectedVendingMachines)
		infectedMachine.shut_up = 1
		infectedMachine.shoot_inventory = 0
