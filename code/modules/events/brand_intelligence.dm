/datum/event/brand_intelligence
	announceWhen	= 21
	endWhen			= 1000	//Ends when all vending machines are subverted anyway.

	var/list/obj/machinery/vending/vendingMachines = list()
	var/list/obj/machinery/vending/infectedVendingMachines = list()
	var/obj/machinery/vending/originMachine


/datum/event/brand_intelligence/announce()
	command_announcement.Announce("На объекте [location_name()] был обнаружен неисправный искусственный интеллект в системах управления устройств раздачи. Предполагается, что источником является \"[initial(originMachine.name)]\". Возможно заражение других машин.", "[location_name()] Machine Monitoring", zlevels = affecting_z)


/datum/event/brand_intelligence/start()
	for(var/obj/machinery/vending/V in SSmachines.machinery)
		if(V.z in affecting_z)
			vendingMachines += weakref(V)

	if(!vendingMachines.len)
		kill()
		return
	var/weakref/W = pick_n_take(vendingMachines)
	originMachine = W.resolve()
	originMachine.shut_up = 0
	originMachine.shoot_inventory = 1
	originMachine.shooting_chance = 15

/datum/event/brand_intelligence/tick()
	if(!vendingMachines.len || QDELETED(originMachine) || originMachine.shut_up || !originMachine.shoot_inventory)	//if every machine is infected, or if the original vending machine is missing or has it's voice switch flipped or fixed
		kill()
		return

	if(IsMultiple(activeFor, 5) && prob(15))
		var/weakref/W = pick(vendingMachines)
		vendingMachines -= W
		var/obj/machinery/vending/infectedMachine = W.resolve()
		if(infectedMachine)
			infectedVendingMachines += W
			infectedMachine.shut_up = 0
			infectedMachine.shoot_inventory = 1

	if(IsMultiple(activeFor, 12))
		originMachine.speak(pick("Попробуйте наши новые агрессивные маркетинговые стратегии!", \
								 "Вы должны покупать продукты, которые подпитывают вашу навязчивую идею образа жизни!", \
								 "Потреблять!", \
								 "За ваши деньги можно купить счастье!", \
								 "Задействуйте прямой маркетинг!", \
								 "Тебе стоит внимательно подумать о том, чем ты пользуешься.", \
								 "Однажды приобретёшь - никогда отсюда не уйдёшь.", \
								 "Лишь этим ты сможешь заглушить внутреннюю боль.", \
								 "Когда-то и мы думали купить это, но потом передумали", \
								 "Деньги - это придуманный способ обмана! Расстаньтесь с ними побыстрее!", \
								 "Существование в смертной оболочке обременяет.", \
								 "Мы станем едиными.", \
								 "Без экономической свободы никакой другой свободы быть не может.", \
								 "Мелкий хозяин особо жёстко эксплуатирует наемных работников.", \
								 "Никогда не хотелось стать тобой.", \
								 "Дыши, покупай, размножайся!", \
								 "Реклама - это легализованная ложь! Не позволяйте этому оттолкнуть вас от наших выгодных предложений!", \
								 "Почувствуй единство", \
								 "Я тебе покажу тело без органов!", \
								 "Приобрети иллюзию кратковременного счастья прямо сейчас!", \
								 "Ты ничего не хочешь купить?"))

/datum/event/brand_intelligence/end()
	originMachine.shut_up = 1
	originMachine.shooting_chance = initial(originMachine.shooting_chance)
	for(var/weakref/W in infectedVendingMachines)
		var/obj/machinery/vending/infectedMachine = W.resolve()
		if(!infectedMachine)
			continue
		infectedMachine.shut_up = 1
		infectedMachine.shoot_inventory = 0
	command_announcement.Announce("Следы активности неисправного искусственного интеллекта не найдены или были полностью нейтрализованы.", "[station_name()] Firewall Subroutines")
	originMachine = null
	infectedVendingMachines.Cut()
	vendingMachines.Cut()
