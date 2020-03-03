
/**
 *  A vending machine
 */
/obj/machinery/vending
	name = "Vendomat"
	desc = "A generic vending machine."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	layer = BELOW_OBJ_LAYER
	anchored = 1
	density = 1
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_ROTATABLE
	clicksound = "button"
	clickvol = 40
	base_type = /obj/machinery/vending/assist
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null

	var/icon_vend //Icon_state when vending
	var/icon_deny //Icon_state when denying access
	var/diona_spawn_chance = 0.1

	// Power
	idle_power_usage = 10
	var/vend_power_usage = 150 //actuators and stuff

	// Vending-related
	var/active = 1 //No sales pitches if off!
	var/vend_ready = 1 //Are we ready to vend?? Is it time??
	var/vend_delay = 10 //How long does it take to vend?
	var/categories = CAT_NORMAL // Bitmask of cats we're currently showing
	var/datum/stored_items/vending_products/currently_vending = null // What we're requesting payment for right now
	var/status_message = "" // Status screen messages like "insufficient funds", displayed in NanoUI
	var/status_error = 0 // Set to 1 if status_message is an error

	/*
		Variables used to initialize the product list
		These are used for initialization only, and so are optional if
		product_records is specified
	*/
	var/list/products	= list() // For each, use the following pattern:
	var/list/contraband	= list() // list(/type/path = amount,/type/path2 = amount2)
	var/list/premium 	= list() // No specified amount = only one in stock
	var/list/prices     = list() // Prices for each item, list(/type/path = price), items not in the list don't have a price.

	// List of vending_product items available.
	var/list/product_records = list()


	// Variables used to initialize advertising
	var/product_slogans = "" //String of slogans spoken out loud, separated by semicolons
	var/product_ads = "" //String of small ad messages in the vending screen

	var/list/ads_list = list()

	// Stuff relating vocalizations
	var/list/slogan_list = list()
	var/shut_up = 1 //Stop spouting those godawful pitches!
	var/vend_reply //Thank you for shopping!
	var/last_reply = 0
	var/last_slogan = 0 //When did we last pitch?
	var/slogan_delay = 6000 //How long until we can pitch again?

	// Things that can go wrong
	emagged = 0 //Ignores if somebody doesn't have card access to that machine.
	var/seconds_electrified = 0 //Shock customers like an airlock.
	var/shoot_inventory = 0 //Fire items at customers! We're broken!
	var/shooting_chance = 2 //The chance that items are being shot per tick

	var/scan_id = 1
	var/obj/item/weapon/material/coin/coin
	wires = /datum/wires/vending

/obj/machinery/vending/Initialize(mapload, d=0, populate_parts = TRUE)
	. = ..()
	if(product_slogans)
		slogan_list += splittext(product_slogans, ";")

		// So not all machines speak at the exact same time.
		// The first time this machine says something will be at slogantime + this random value,
		// so if slogantime is 10 minutes, it will say it at somewhere between 10 and 20 minutes after the machine is crated.
		last_slogan = world.time + rand(0, slogan_delay)

	if(product_ads)
		ads_list += splittext(product_ads, ";")

	build_inventory(populate_parts)

/**
 *  Build src.produdct_records from the products lists
 *
 *  src.products, src.contraband, src.premium, and src.prices allow specifying
 *  products that the vending machine is to carry without manually populating
 *  src.product_records.
 */
/obj/machinery/vending/proc/build_inventory(populate_parts = FALSE)
	var/list/all_products = list(
		list(src.products, CAT_NORMAL),
		list(src.contraband, CAT_HIDDEN),
		list(src.premium, CAT_COIN))

	for(var/current_list in all_products)
		var/category = current_list[2]

		for(var/entry in current_list[1])
			var/datum/stored_items/vending_products/product = new/datum/stored_items/vending_products(src, entry)

			product.price = (entry in src.prices) ? src.prices[entry] : 0
			if(populate_parts)
				product.amount = (current_list[1][entry]) ? current_list[1][entry] : 1
			product.category = category

			src.product_records.Add(product)

/obj/machinery/vending/Destroy()
	qdel(coin)
	coin = null
	for(var/datum/stored_items/vending_products/R in product_records)
		qdel(R)
	product_records = null
	return ..()

/obj/machinery/vending/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				spawn(0)
					src.malfunction()
					return
				return
		else
	return

/obj/machinery/vending/emag_act(var/remaining_charges, var/mob/user)
	if (!emagged)
		emagged = 1
		req_access.Cut()
		to_chat(user, "You short out the product lock on \the [src]")
		return 1

/obj/machinery/vending/attackby(obj/item/weapon/W as obj, mob/user as mob)

	var/obj/item/weapon/card/id/I = W.GetIdCard()

	if (currently_vending && vendor_account && !vendor_account.suspended)
		var/paid = 0
		var/handled = 0

		if (I) //for IDs and PDAs and wallets with IDs
			paid = pay_with_card(I,W)
			handled = 1
		else if (istype(W, /obj/item/weapon/spacecash/ewallet))
			var/obj/item/weapon/spacecash/ewallet/C = W
			paid = pay_with_ewallet(C)
			handled = 1
		else if (istype(W, /obj/item/weapon/spacecash/bundle))
			var/obj/item/weapon/spacecash/bundle/C = W
			paid = pay_with_cash(C)
			handled = 1

		if(paid)
			src.vend(currently_vending, usr)
			return TRUE
		else if(handled)
			SSnano.update_uis(src)
			return TRUE // don't smack that machine with your 2 thalers

	if (I || istype(W, /obj/item/weapon/spacecash))
		attack_hand(user)
		return TRUE
	if(isMultitool(W) || isWirecutter(W))
		if(src.panel_open)
			attack_hand(user)
			return TRUE
	if(istype(W, /obj/item/weapon/material/coin) && premium.len > 0)
		if(!user.unEquip(W, src))
			return FALSE
		coin = W
		categories |= CAT_COIN
		to_chat(user, "<span class='notice'>You insert \the [W] into \the [src].</span>")
		SSnano.update_uis(src)
		return TRUE
	if((user.a_intent == I_HELP) && attempt_to_stock(W, user))
		return TRUE
	if((. = component_attackby(W, user)))
		return
	if((obj_flags & OBJ_FLAG_ANCHORABLE) && isWrench(W))
		wrench_floor_bolts(user)
		power_change()
		return

/obj/machinery/vending/state_transition(decl/machine_construction/new_state)
	. = ..()
	SSnano.update_uis(src)

/obj/machinery/vending/MouseDrop_T(var/obj/item/I as obj, var/mob/user as mob)
	if(!CanMouseDrop(I, user) || (I.loc != user))
		return
	return attempt_to_stock(I, user)

/obj/machinery/vending/proc/attempt_to_stock(var/obj/item/I as obj, var/mob/user as mob)
	for(var/datum/stored_items/vending_products/R in product_records)
		if(I.type == R.item_path)
			stock(I, R, user)
			return 1

/**
 *  Receive payment with cashmoney.
 */
/obj/machinery/vending/proc/pay_with_cash(var/obj/item/weapon/spacecash/bundle/cashmoney)
	if(currently_vending.price > cashmoney.worth)
		// This is not a status display message, since it's something the character
		// themselves is meant to see BEFORE putting the money in
		to_chat(usr, "\icon[cashmoney] <span class='warning'>That is not enough money.</span>")
		return 0

	visible_message("<span class='info'>\The [usr] inserts some cash into \the [src].</span>")
	cashmoney.worth -= currently_vending.price

	if(cashmoney.worth <= 0)
		qdel(cashmoney)
	else
		cashmoney.update_icon()

	// Vending machines have no idea who paid with cash
	credit_purchase("(cash)")
	return 1

/**
 * Scan a chargecard and deduct payment from it.
 *
 * Takes payment for whatever is the currently_vending item. Returns 1 if
 * successful, 0 if failed.
 */
/obj/machinery/vending/proc/pay_with_ewallet(var/obj/item/weapon/spacecash/ewallet/wallet)
	visible_message("<span class='info'>\The [usr] swipes \the [wallet] through \the [src].</span>")
	if(currently_vending.price > wallet.worth)
		src.status_message = "Insufficient funds on chargecard."
		src.status_error = 1
		return 0
	else
		wallet.worth -= currently_vending.price
		credit_purchase("[wallet.owner_name] (chargecard)")
		return 1

/**
 * Scan a card and attempt to transfer payment from associated account.
 *
 * Takes payment for whatever is the currently_vending item. Returns 1 if
 * successful, 0 if failed
 */
/obj/machinery/vending/proc/pay_with_card(var/obj/item/weapon/card/id/I, var/obj/item/ID_container)
	if(I==ID_container || ID_container == null)
		visible_message("<span class='info'>\The [usr] swipes \the [I] through \the [src].</span>")
	else
		visible_message("<span class='info'>\The [usr] swipes \the [ID_container] through \the [src].</span>")
	var/datum/money_account/customer_account = get_account(I.associated_account_number)
	if (!customer_account)
		src.status_message = "Error: Unable to access account. Please contact technical support if problem persists."
		src.status_error = 1
		return 0

	if(customer_account.suspended)
		src.status_message = "Unable to access account: account suspended."
		src.status_error = 1
		return 0

	// Have the customer punch in the PIN before checking if there's enough money. Prevents people from figuring out acct is
	// empty at high security levels
	if(customer_account.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
		var/attempt_pin = input("Enter pin code", "Vendor transaction") as num
		customer_account = attempt_account_access(I.associated_account_number, attempt_pin, 2)

		if(!customer_account)
			src.status_message = "Unable to access account: incorrect credentials."
			src.status_error = 1
			return 0

	if(currently_vending.price > customer_account.money)
		src.status_message = "Insufficient funds in account."
		src.status_error = 1
		return 0
	else
		// Okay to move the money at this point
		customer_account.transfer(vendor_account, currently_vending.price, "Purchase of [currently_vending.item_name]")

		return 1

/**
 *  Add money for current purchase to the vendor account.
 *
 *  Called after the money has already been taken from the customer.
 */
/obj/machinery/vending/proc/credit_purchase(var/target as text)
	vendor_account.deposit(currently_vending.price, "Purchase of [currently_vending.item_name]", target)

/obj/machinery/vending/physical_attack_hand(mob/user)
	if(src.seconds_electrified != 0)
		if(src.shock(user, 100))
			return TRUE

/obj/machinery/vending/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/**
 *  Display the NanoUI window for the vending machine.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/vending/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/list/data = list()
	if(currently_vending)
		data["mode"] = 1
		data["product"] = currently_vending.item_name
		data["price"] = currently_vending.price
		data["message_err"] = 0
		data["message"] = src.status_message
		data["message_err"] = src.status_error
	else
		data["mode"] = 0
		var/list/listed_products = list()

		for(var/key = 1 to src.product_records.len)
			var/datum/stored_items/vending_products/I = src.product_records[key]

			if(!(I.category & src.categories))
				continue

			listed_products.Add(list(list(
				"key" = key,
				"name" = I.item_name,
				"price" = I.price,
				"color" = I.display_color,
				"amount" = I.get_amount())))

		data["products"] = listed_products

	if(src.coin)
		data["coin"] = src.coin.name

	if(src.panel_open)
		data["panel"] = 1
		data["speaker"] = src.shut_up ? 0 : 1
	else
		data["panel"] = 0

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "vending_machine.tmpl", src.name, 440, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/vending/OnTopic(mob/user, href_list, datum/topic_state/state)
	if(href_list["remove_coin"] && !istype(usr,/mob/living/silicon))
		if(!coin)
			to_chat(user, "There is no coin in this machine.")
			return TOPIC_HANDLED

		coin.forceMove(loc)
		if(!user.get_active_hand())
			user.put_in_hands(coin)
		to_chat(user, "<span class='notice'>You remove \the [coin] from \the [src]</span>")
		coin = null
		categories &= ~CAT_COIN
		return TOPIC_HANDLED

	if (href_list["vend"] && vend_ready && !currently_vending)
		var/key = text2num(href_list["vend"])
		if(!is_valid_index(key, product_records))
			return TOPIC_REFRESH
		var/datum/stored_items/vending_products/R = product_records[key]
		if(!istype(R))
			return TOPIC_REFRESH

		// This should not happen unless the request from NanoUI was bad
		if(!(R.category & categories))
			return TOPIC_REFRESH

		if(R.price <= 0)
			vend(R, user)
		else if(istype(user,/mob/living/silicon)) //If the item is not free, provide feedback if a synth is trying to buy something.
			to_chat(user, "<span class='danger'>Artificial unit recognized.  Artificial units cannot complete this transaction.  Purchase canceled.</span>")
		else
			currently_vending = R
			if(!vendor_account || vendor_account.suspended)
				status_message = "This machine is currently unable to process payments due to problems with the associated account."
				status_error = 1
			else
				status_message = "Please swipe a card or insert cash to pay for the item."
				status_error = 0
		return TOPIC_REFRESH

	if(href_list["cancelpurchase"])
		currently_vending = null
		return TOPIC_REFRESH

	if(href_list["togglevoice"] && panel_open)
		shut_up = !shut_up
		return TOPIC_HANDLED

/obj/machinery/vending/get_req_access()
	if(!scan_id)
		return list()
	return ..()

/obj/machinery/vending/proc/vend(var/datum/stored_items/vending_products/R, mob/user)
	if((!allowed(user)) && !emagged && scan_id)	//For SECURE VENDING MACHINES YEAH
		to_chat(user, "<span class='warning'>Access denied.</span>")//Unless emagged of course
		flick(src.icon_deny,src)
		return
	src.vend_ready = 0 //One thing at a time!!
	src.status_message = "Vending..."
	src.status_error = 0
	SSnano.update_uis(src)

	if (R.category & CAT_COIN)
		if(!coin)
			to_chat(user, "<span class='notice'>You need to insert a coin to get this item.</span>")
			return
		if(!isnull(coin.string_colour))
			if(prob(50))
				to_chat(user, "<span class='notice'>You successfully pull the coin out before \the [src] could swallow it.</span>")
			else
				to_chat(user, "<span class='notice'>You weren't able to pull the coin out fast enough, the machine ate it, string and all.</span>")
				qdel(coin)
				coin = null
				categories &= ~CAT_COIN
		else
			qdel(coin)
			coin = null
			categories &= ~CAT_COIN

	if(((src.last_reply + (src.vend_delay + 200)) <= world.time) && src.vend_reply)
		spawn(0)
			src.speak(src.vend_reply)
			src.last_reply = world.time

	use_power_oneoff(vend_power_usage)	//actuators and stuff
	if (src.icon_vend) //Show the vending animation if needed
		flick(src.icon_vend,src)
	spawn(src.vend_delay) //Time to vend
		if(prob(diona_spawn_chance)) //Hehehe
			var/turf/T = get_turf(src)
			var/mob/living/carbon/alien/diona/S = new(T)
			src.visible_message("<span class='notice'>\The [src] makes an odd grinding noise before coming to a halt as \a [S.name] slurmps out from the receptacle.</span>")
		else //Just a normal vend, then
			R.get_product(get_turf(src))
			src.visible_message("\The [src] clunks as it vends \the [R.item_name].")
			playsound(src, 'sound/machines/vending_machine.ogg', 25, 1)
			if(prob(1)) //The vending gods look favorably upon you
				sleep(3)
				if(R.get_product(get_turf(src)))
					src.visible_message("<span class='notice'>\The [src] clunks as it vends an additional [R.item_name].</span>")

		src.status_message = ""
		src.status_error = 0
		src.vend_ready = 1
		currently_vending = null
		SSnano.update_uis(src)

/**
 * Add item to the machine
 *
 * Checks if item is vendable in this machine should be performed before
 * calling. W is the item being inserted, R is the associated vending_product entry.
 */
/obj/machinery/vending/proc/stock(obj/item/weapon/W, var/datum/stored_items/vending_products/R, var/mob/user)
	if(!user.unEquip(W))
		return

	if(R.add_product(W))
		to_chat(user, "<span class='notice'>You insert \the [W] in the product receptor.</span>")
		SSnano.update_uis(src)
		return 1

	SSnano.update_uis(src)

/obj/machinery/vending/Process()
	if(stat & (BROKEN|NOPOWER))
		return

	if(!src.active)
		return

	if(src.seconds_electrified > 0)
		src.seconds_electrified--

	//Pitch to the people!  Really sell it!
	if(((src.last_slogan + src.slogan_delay) <= world.time) && (src.slogan_list.len > 0) && (!src.shut_up) && prob(5))
		var/slogan = pick(src.slogan_list)
		src.speak(slogan)
		src.last_slogan = world.time

	if(src.shoot_inventory && prob(shooting_chance))
		src.throw_item()

	return

/obj/machinery/vending/proc/speak(var/message)
	if(stat & NOPOWER)
		return

	if (!message)
		return

	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='game say'><span class='name'>\The [src]</span> beeps, \"[message]\"</span>",2)
	return

/obj/machinery/vending/powered()
	return anchored && ..()

/obj/machinery/vending/on_update_icon()
	overlays.Cut()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else if( !(stat & NOPOWER) )
		icon_state = initial(icon_state)
	else
		spawn(rand(0, 15))
			src.icon_state = "[initial(icon_state)]-off"
	if(panel_open)
		overlays += image(src.icon, "[initial(icon_state)]-panel")

//Oh no we're malfunctioning!  Dump out some product and break.
/obj/machinery/vending/proc/malfunction()
	for(var/datum/stored_items/vending_products/R in src.product_records)
		while(R.get_amount()>0)
			R.get_product(loc)
		break
	set_broken(TRUE)

//Somebody cut an important wire and now we're following a new definition of "pitch."
/obj/machinery/vending/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for(var/datum/stored_items/vending_products/R in shuffle(src.product_records))
		throw_item = R.get_product(loc)
		if (throw_item)
			break
	if (!throw_item)
		return 0
	spawn(0)
		throw_item.throw_at(target, rand(1,2), 3)
	src.visible_message("<span class='warning'>\The [src] launches \a [throw_item] at \the [target]!</span>")
	return 1

/*
 * Vending machine types
 */

/*

/obj/machinery/vending/[vendors name here]   // --vending machine template   :)
	name = ""
	desc = ""
	icon = ''
	icon_state = ""
	vend_delay = 15
	products = list()
	contraband = list()
	premium = list()

*/

/obj/machinery/vending/boozeomat
	name = "Booze-O-Mat"
	desc = "A refrigerated vending unit for alcoholic beverages and alcoholic beverage accessories."
	icon_state = "fridge_dark"
	icon_deny = "fridge_dark-deny"
	products = list(/obj/item/weapon/reagent_containers/food/drinks/glass2/square = 10,
					/obj/item/weapon/reagent_containers/food/drinks/flask/barflask = 5,
					/obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/gin = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/vermouth = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/rum = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/wine = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/kahlua = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/sake = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/jagermeister = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/melonliquor = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/bluecuracao = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/specialwhiskey = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/llanbrydewhiskey = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing =5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/blackstrap = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/prosecco = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/champagne = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/herbal = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer = 15,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/ale = 15,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/hellshenpa = 15,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/small/gingerbeer = 15,
					/obj/item/weapon/reagent_containers/food/drinks/cans/speer = 10,
					/obj/item/weapon/reagent_containers/food/drinks/cans/ale = 10,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/cola = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/space_up = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/space_mountain_wind = 5,
					/obj/item/weapon/reagent_containers/food/drinks/cans/beastenergy = 5,
					/obj/item/weapon/reagent_containers/food/drinks/tea/black = 15,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/tomatojuice = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/limejuice = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/unathijuice = 5,
					/obj/item/weapon/reagent_containers/food/drinks/cans/tonic = 15,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/cream = 5,
					/obj/item/weapon/reagent_containers/food/drinks/cans/sodawater = 15,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/grenadine = 5,
					/obj/item/weapon/reagent_containers/food/condiment/mint = 2,
					/obj/item/weapon/reagent_containers/food/drinks/ice = 10,
					/obj/item/weapon/glass_extra/stick = 15,
					/obj/item/weapon/glass_extra/straw = 15)
	contraband = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/premiumwine = 3,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/premiumvodka = 3,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/patron = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/goldschlager = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/lordaniawine = 5,
					/obj/item/weapon/reagent_containers/food/drinks/bottle/brandy = 5)
	vend_delay = 15
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	product_slogans = "I hope nobody asks me for a bloody cup o' tea...;Alcohol is humanity's friend. Would you abandon a friend?;Quite delighted to serve you!;Is nobody thirsty on this station?"
	product_ads = "Drink up!;Booze is good for you!;Alcohol is humanity's best friend.;Quite delighted to serve you!;Care for a nice, cold beer?;Nothing cures you like booze!;Have a sip!;Have a drink!;Have a beer!;Beer is good for you!;Only the finest alcohol!;Best quality booze since 2053!;Award-winning wine!;Maximum alcohol!;Man loves beer.;A toast for progress!"
	req_access = list(access_bar)
	base_type = /obj/machinery/vending/boozeomat

/obj/machinery/vending/assist
	products = list(	/obj/item/device/assembly/prox_sensor = 5,/obj/item/device/assembly/igniter = 3,/obj/item/device/assembly/signaler = 4,
						/obj/item/weapon/wirecutters = 1)
	contraband = list(/obj/item/device/flashlight = 5,/obj/item/device/assembly/timer = 2)
	product_ads = "Only the finest!;Have some tools.;The most robust equipment.;The finest gear in space!"

/obj/machinery/vending/assist/antag
	name = "AntagCorpVend"
	contraband = list()
	products = list(	/obj/item/device/assembly/prox_sensor = 5, /obj/item/device/assembly/signaler = 4,
						/obj/item/device/assembly/infra = 4, /obj/item/device/assembly/prox_sensor = 4,
						/obj/item/weapon/handcuffs = 8, /obj/item/device/flash = 4, /obj/item/clothing/glasses/sunglasses = 4)

/obj/machinery/vending/coffee
	name = "Hot Drinks machine"
	desc = "A vending machine which dispenses hot drinks and hot drinks accessories."
	product_ads = "Have a drink!;Drink up!;It's good for you!;Would you like a hot joe?;I'd kill for some coffee!;The best beans in the galaxy.;Only the finest brew for you.;Mmmm. Nothing like a coffee.;I like coffee, don't you?;Coffee helps you work!;Try some tea.;We hope you like the best!;Try our new chocolate!;Admin conspiracies"
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	icon_deny = "coffee-deny"
	vend_delay = 34
	base_type = /obj/machinery/vending/coffee
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vend_power_usage = 85000 //85 kJ to heat a 250 mL cup of coffee
	products = list(/obj/item/weapon/reagent_containers/food/drinks/coffee = 15,
					/obj/item/weapon/reagent_containers/food/drinks/tea/black = 15,
					/obj/item/weapon/reagent_containers/food/drinks/tea/green = 15,
					/obj/item/weapon/reagent_containers/food/drinks/tea/chai = 15,
					/obj/item/weapon/reagent_containers/food/drinks/h_chocolate = 10,
					/obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar = 25,
					/obj/item/weapon/reagent_containers/pill/pod/cream = 25,
					/obj/item/weapon/reagent_containers/pill/pod/cream_soy = 25,
					/obj/item/weapon/reagent_containers/pill/pod/orange = 10,
					/obj/item/weapon/reagent_containers/pill/pod/mint = 10,
					/obj/item/weapon/reagent_containers/food/drinks/ice = 10)

	prices = list(/obj/item/weapon/reagent_containers/food/drinks/coffee = 10,
				  /obj/item/weapon/reagent_containers/food/drinks/tea/black = 10,
				  /obj/item/weapon/reagent_containers/food/drinks/tea/green = 10,
				  /obj/item/weapon/reagent_containers/food/drinks/tea/chai = 10,
				  /obj/item/weapon/reagent_containers/food/drinks/h_chocolate = 15,
				  /obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar = 1,
				  /obj/item/weapon/reagent_containers/pill/pod/cream = 5,
				  /obj/item/weapon/reagent_containers/pill/pod/cream_soy = 5,
				  /obj/item/weapon/reagent_containers/pill/pod/orange = 5,
				  /obj/item/weapon/reagent_containers/pill/pod/mint = 5,
				  /obj/item/weapon/reagent_containers/food/drinks/ice = 1)

/obj/machinery/vending/coffee/on_update_icon()
	..()
	if(stat & BROKEN && prob(20))
		icon_state = "[initial(icon_state)]-hellfire"
	else if(!(stat & NOPOWER))
		overlays += image(icon, "[initial(icon_state)]-screen")


/obj/machinery/vending/snack
	name = "Getmore Chocolate Corp"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation, based out of Mars."
	product_slogans = "Try our new nougat bar!;Twice the calories for half the price!"
	product_ads = "The healthiest!;Award-winning chocolate bars!;Mmm! So good!;Oh my god it's so juicy!;Have a snack.;Snacks are good for you!;Have some more Getmore!;Best quality snacks straight from mars.;We love chocolate!;Try our new jerky!"
	icon_state = "snack"
	icon_vend = "snack-vend"
	icon_deny = "snack-deny"
	vend_delay = 25
	base_type = /obj/machinery/vending/snack
	products = list(/obj/item/clothing/mask/chewable/candy/lolli = 8,
					/obj/item/weapon/storage/chewables/candy/gum = 4,
					/obj/item/weapon/storage/chewables/candy/cookies = 4,
					/obj/item/weapon/reagent_containers/food/snacks/candy = 6,/obj/item/weapon/reagent_containers/food/drinks/dry_ramen = 6,/obj/item/weapon/reagent_containers/food/snacks/chips =6,
					/obj/item/weapon/reagent_containers/food/snacks/sosjerky = 6,/obj/item/weapon/reagent_containers/food/snacks/no_raisin = 6,/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie = 6,
					/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers = 6, /obj/item/weapon/reagent_containers/food/snacks/tastybread = 6)
	contraband = list(/obj/item/weapon/reagent_containers/food/snacks/syndicake = 6, /obj/item/weapon/reagent_containers/food/snacks/skrellsnacks = 3)
	prices = list(/obj/item/clothing/mask/chewable/candy/lolli = 2,
					/obj/item/weapon/storage/chewables/candy/gum = 4,
					/obj/item/weapon/storage/chewables/candy/cookies = 4,
					/obj/item/weapon/reagent_containers/food/snacks/candy = 1,/obj/item/weapon/reagent_containers/food/drinks/dry_ramen = 5,/obj/item/weapon/reagent_containers/food/snacks/chips = 1,
					/obj/item/weapon/reagent_containers/food/snacks/sosjerky = 2,/obj/item/weapon/reagent_containers/food/snacks/no_raisin = 1,/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie = 1,
					/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers = 1, /obj/item/weapon/reagent_containers/food/snacks/tastybread = 2)

/obj/machinery/vending/cola
	name = "Robust Softdrinks"
	desc = "A softdrink vendor provided by Robust Industries, LLC."
	icon_state = "Cola_Machine"
	icon_vend = "Cola_Machine-vend"
	icon_deny = "Cola_Machine-deny"
	vend_delay = 11
	base_type = /obj/machinery/vending/cola
	product_slogans = "Robust Softdrinks: More robust than a toolbox to the head!"
	product_ads = "Refreshing!;Hope you're thirsty!;Over 1 million drinks sold!;Thirsty? Why not cola?;Please, have a drink!;Drink up!;The best drinks in space."
	products = list(/obj/item/weapon/reagent_containers/food/drinks/cans/cola = 10,/obj/item/weapon/reagent_containers/food/drinks/cans/space_mountain_wind = 10,
					/obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb = 10,/obj/item/weapon/reagent_containers/food/drinks/cans/starkist = 10,
					/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle = 10,/obj/item/weapon/reagent_containers/food/drinks/cans/space_up = 10,
					/obj/item/weapon/reagent_containers/food/drinks/cans/iced_tea = 10, /obj/item/weapon/reagent_containers/food/drinks/cans/grape_juice = 10)
	contraband = list(/obj/item/weapon/reagent_containers/food/drinks/cans/thirteenloko = 5, /obj/item/weapon/reagent_containers/food/snacks/liquidfood = 6)
	prices = list(/obj/item/weapon/reagent_containers/food/drinks/cans/cola = 1,/obj/item/weapon/reagent_containers/food/drinks/cans/space_mountain_wind = 1,
					/obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb = 1,/obj/item/weapon/reagent_containers/food/drinks/cans/starkist = 1,
					/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle = 2,/obj/item/weapon/reagent_containers/food/drinks/cans/space_up = 1,
					/obj/item/weapon/reagent_containers/food/drinks/cans/iced_tea = 1,/obj/item/weapon/reagent_containers/food/drinks/cans/grape_juice = 1)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/soda
	name = "Radical Renard"
	desc = "A softdrink vendor promoted by Radical Renard."
	icon_state = "Soda_Machine"
	icon_vend = "Soda_Machine-vend"
	icon_deny = "Soda_Machine-deny"
	vend_delay = 11
	base_type = /obj/machinery/vending/soda
	product_slogans = "Not applicable!"
	product_ads = "Not applicable."
	products = list(/obj/item/weapon/reagent_containers/food/drinks/cans/cola_diet = 10,/obj/item/weapon/reagent_containers/food/drinks/cans/rootbeer = 10,
					/obj/item/weapon/reagent_containers/food/drinks/cans/cola_apple = 10,/obj/item/weapon/reagent_containers/food/drinks/cans/cola_orange = 10,
					/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle = 10,/obj/item/weapon/reagent_containers/food/drinks/cans/cola_grape = 10,
					/obj/item/weapon/reagent_containers/food/drinks/cans/cola_lemonlime = 10, /obj/item/weapon/reagent_containers/food/drinks/cans/cola_strawberry = 10)
	contraband = list(/obj/item/weapon/reagent_containers/food/drinks/cans/cola_pork = 10)
	prices = list(/obj/item/weapon/reagent_containers/food/drinks/cans/cola_diet = 1,/obj/item/weapon/reagent_containers/food/drinks/cans/rootbeer = 1,
					/obj/item/weapon/reagent_containers/food/drinks/cans/cola_apple = 1,/obj/item/weapon/reagent_containers/food/drinks/cans/cola_orange = 1,
					/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle = 1,/obj/item/weapon/reagent_containers/food/drinks/cans/cola_grape = 1,
					/obj/item/weapon/reagent_containers/food/drinks/cans/cola_lemonlime = 1,/obj/item/weapon/reagent_containers/food/drinks/cans/cola_strawberry = 1)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/fitness
	name = "SweatMAX"
	desc = "An exercise aid and nutrition supplement vendor that preys on your inadequacy."
	product_slogans = "SweatMAX, get robust!"
	product_ads = "Pain is just weakness leaving the body!;Run! Your fat is catching up to you;Never forget leg day!;Push out!;This is the only break you get today.;Don't cry, sweat!;Healthy is an outfit that looks good on everybody."
	icon_state = "fitness"
	icon_vend = "fitness-vend"
	icon_deny = "fitness-deny"
	vend_delay = 6
	base_type = /obj/machinery/vending/fitness
	products = list(/obj/item/weapon/reagent_containers/food/drinks/milk/smallcarton = 8,
					/obj/item/weapon/reagent_containers/food/drinks/milk/smallcarton/chocolate = 8,
					/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle = 8,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask/proteinshake = 8,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask = 8,
					/obj/item/weapon/reagent_containers/food/snacks/candy/proteinbar = 8,
					/obj/item/weapon/storage/mre/random = 8,
					/obj/item/weapon/storage/mre/menu9 = 4,
					/obj/item/weapon/storage/mre/menu10 = 4,
					/obj/item/weapon/reagent_containers/pill/diet = 8,
					/obj/item/weapon/towel/random = 8)

	prices = list(/obj/item/weapon/reagent_containers/food/drinks/milk/smallcarton = 3,
					/obj/item/weapon/reagent_containers/food/drinks/milk/smallcarton/chocolate = 3,
					/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle = 2,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask/proteinshake = 20,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask = 5,
					/obj/item/weapon/reagent_containers/food/snacks/candy/proteinbar = 5,
					/obj/item/weapon/storage/mre/random = 50,
					/obj/item/weapon/storage/mre/menu9 = 50,
					/obj/item/weapon/storage/mre/menu10 = 50,
					/obj/item/weapon/reagent_containers/pill/diet = 25,
					/obj/item/weapon/towel/random = 40)

	contraband = list(/obj/item/weapon/reagent_containers/syringe/steroid = 4)

/obj/machinery/vending/fitness/on_update_icon()
	..()
	if(!(stat & NOPOWER))
		overlays += image(icon, "[initial(icon_state)]-overlay")

/obj/machinery/vending/cigarette
	name = "Cigarette machine" //OCD had to be uppercase to look nice with the new formating
	desc = "A specialized vending machine designed to contribute to your slow and uncomfortable death."
	product_slogans = "There's no better time to start smokin'.;\
		Smoke now, and win the adoration of your peers.;\
		They beat cancer centuries ago, so smoke away.;\
		If you're not smoking, you must be joking."
	product_ads = "Probably not bad for you!;\
		Don't believe the scientists!;\
		It's good for you!;\
		Don't quit, buy more!;\
		Smoke!;\
		Nicotine heaven.;\
		Best cigarettes since 2150.;\
		Award-winning cigarettes, all the best brands.;\
		Feeling temperamental? Try a Temperamento!;\
		Carcinoma Angels - go fuck yerself!;\
		Don't be so hard on yourself, kid. Smoke a Lucky Star!;\
		We understand the depressed, alcoholic cowboy in you. That's why we also smoke Jericho.;\
		Professionals. Better cigarettes for better people. Yes, better people."
	vend_delay = 21
	icon_state = "cigs"
	icon_vend = "cigs-vend"
	icon_deny = "cigs-deny"
	base_type = /obj/machinery/vending/cigarette
	products = list(
					/obj/item/weapon/storage/cigpaper/filters = 5,
					/obj/item/weapon/storage/cigpaper = 3,
					/obj/item/weapon/storage/cigpaper/fancy = 2,
					/obj/item/weapon/storage/chewables/rollable/bad = 2,
					/obj/item/weapon/storage/chewables/rollable/generic = 2,
					/obj/item/weapon/storage/chewables/rollable/fine = 2,
					/obj/item/weapon/storage/fancy/cigarettes = 5,
					/obj/item/weapon/storage/fancy/cigarettes/luckystars = 2,
					/obj/item/weapon/storage/fancy/cigarettes/jerichos = 2,
					/obj/item/weapon/storage/fancy/cigarettes/menthols = 2,
					/obj/item/weapon/storage/fancy/cigarettes/carcinomas = 2,
					/obj/item/weapon/storage/fancy/cigarettes/professionals = 2,
					/obj/item/weapon/storage/fancy/cigarettes/cigarello = 2,
					/obj/item/weapon/storage/fancy/cigarettes/cigarello/mint = 2,
					/obj/item/weapon/storage/fancy/cigarettes/cigarello/variety = 2,
					/obj/item/weapon/storage/box/matches = 10,
					/obj/item/weapon/flame/lighter/random = 4,
					/obj/item/weapon/storage/chewables/tobacco = 2,
					/obj/item/weapon/storage/chewables/tobacco2 = 2,
					/obj/item/weapon/storage/chewables/tobacco3 = 2,
					/obj/item/clothing/mask/smokable/ecig/simple = 10,
					/obj/item/clothing/mask/smokable/ecig/util = 5,
					/obj/item/clothing/mask/smokable/ecig/deluxe = 1,
					/obj/item/weapon/reagent_containers/ecig_cartridge/med_nicotine = 10,
					/obj/item/weapon/reagent_containers/ecig_cartridge/high_nicotine = 5,
					/obj/item/weapon/reagent_containers/ecig_cartridge/orange = 5,
					/obj/item/weapon/reagent_containers/ecig_cartridge/mint = 5,
					/obj/item/weapon/reagent_containers/ecig_cartridge/watermelon = 5,
					/obj/item/weapon/reagent_containers/ecig_cartridge/grape = 5,
					/obj/item/weapon/reagent_containers/ecig_cartridge/lemonlime = 5,
					/obj/item/weapon/reagent_containers/ecig_cartridge/coffee = 5,
					/obj/item/weapon/reagent_containers/ecig_cartridge/blanknico = 2)
	contraband = list(/obj/item/weapon/flame/lighter/zippo = 4,
					/obj/item/clothing/mask/smokable/cigarette/rolled/sausage = 3)
	premium = list(/obj/item/weapon/storage/fancy/cigar = 5,/obj/item/weapon/storage/fancy/cigarettes/killthroat = 5)

	prices = list(
					/obj/item/weapon/storage/chewables/tobacco = 40,
					/obj/item/weapon/storage/chewables/tobacco2 = 50,
					/obj/item/weapon/storage/chewables/tobacco3 = 60,
					/obj/item/weapon/storage/cigpaper/filters = 5,
					/obj/item/weapon/storage/cigpaper = 8,
					/obj/item/weapon/storage/cigpaper/fancy = 12,
					/obj/item/weapon/storage/chewables/rollable/bad = 20,
					/obj/item/weapon/storage/chewables/rollable/generic = 40,
					/obj/item/weapon/storage/chewables/rollable/fine = 60,
					/obj/item/weapon/storage/fancy/cigarettes = 45,
					/obj/item/weapon/storage/fancy/cigarettes/luckystars = 50,
					/obj/item/weapon/storage/fancy/cigarettes/jerichos = 65,
					/obj/item/weapon/storage/fancy/cigarettes/menthols = 55,
					/obj/item/weapon/storage/fancy/cigarettes/carcinomas = 65,
					/obj/item/weapon/storage/fancy/cigarettes/professionals = 70,
					/obj/item/weapon/storage/fancy/cigarettes/cigarello = 85,
					/obj/item/weapon/storage/fancy/cigarettes/cigarello/mint = 85,
					/obj/item/weapon/storage/fancy/cigarettes/cigarello/variety = 85,
					/obj/item/weapon/storage/box/matches = 2,
					/obj/item/weapon/flame/lighter/random = 5,
					/obj/item/clothing/mask/smokable/ecig/simple = 50,
					/obj/item/clothing/mask/smokable/ecig/util = 100,
					/obj/item/clothing/mask/smokable/ecig/deluxe = 250,
					/obj/item/weapon/reagent_containers/ecig_cartridge/med_nicotine = 15,
					/obj/item/weapon/reagent_containers/ecig_cartridge/high_nicotine = 15,
					/obj/item/weapon/reagent_containers/ecig_cartridge/orange = 15,
					/obj/item/weapon/reagent_containers/ecig_cartridge/mint = 15,
					/obj/item/weapon/reagent_containers/ecig_cartridge/watermelon = 15,
					/obj/item/weapon/reagent_containers/ecig_cartridge/grape = 15,
					/obj/item/weapon/reagent_containers/ecig_cartridge/lemonlime = 15,
					/obj/item/weapon/reagent_containers/ecig_cartridge/coffee = 15,
					/obj/item/weapon/reagent_containers/ecig_cartridge/blanknico = 15)


/obj/machinery/vending/medical
	name = "NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_deny = "med-deny"
	icon_vend = "med-vend"
	vend_delay = 18
	base_type = /obj/machinery/vending/medical
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?;Ping!"
	req_access = list(access_medical_equip)
	products = list(/obj/item/weapon/reagent_containers/glass/bottle/antitoxin = 4,/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline = 4,
					/obj/item/weapon/reagent_containers/glass/bottle/stoxin = 4,/obj/item/weapon/reagent_containers/glass/bottle/toxin = 4,
					/obj/item/weapon/reagent_containers/syringe/antiviral = 4,/obj/item/weapon/reagent_containers/syringe = 12,
					/obj/item/device/scanner/health = 5,/obj/item/weapon/reagent_containers/glass/beaker = 4, /obj/item/weapon/reagent_containers/dropper = 2,
					/obj/item/stack/medical/advanced/bruise_pack = 3, /obj/item/stack/medical/advanced/ointment = 3, /obj/item/stack/medical/splint = 2,
					/obj/item/weapon/reagent_containers/hypospray/autoinjector/pain = 4)
	contraband = list(/obj/item/clothing/mask/chewable/candy/lolli/meds = 8,
					/obj/item/weapon/reagent_containers/pill/tox = 3,/obj/item/weapon/reagent_containers/pill/stox = 4,/obj/item/weapon/reagent_containers/pill/antitox = 6,
					/obj/item/weapon/reagent_containers/hypospray/autoinjector/combatpain = 2)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.


//This one's from bay12
/obj/machinery/vending/phoronresearch
	name = "Toximate 3000"
	desc = "All the fine parts you need in one vending machine!"
	base_type = /obj/machinery/vending/phoronresearch
	products = list(/obj/item/clothing/suit/bio_suit = 6,/obj/item/clothing/head/bio_hood = 6,
					/obj/item/device/transfer_valve = 6,/obj/item/device/assembly/timer = 6,/obj/item/device/assembly/signaler = 6,
					/obj/item/device/assembly/prox_sensor = 6,/obj/item/device/assembly/igniter = 6)

/obj/machinery/vending/wallmed1
	name = "NanoMed"
	desc = "A wall-mounted version of the NanoMed."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	icon_vend = "wallmed-vend"
	base_type = /obj/machinery/vending/wallmed1
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(
		/obj/item/stack/medical/bruise_pack = 3,
		/obj/item/stack/medical/ointment = 3,
		/obj/item/weapon/reagent_containers/pill/paracetamol = 4,
		/obj/item/weapon/storage/med_pouch/trauma,
		/obj/item/weapon/storage/med_pouch/burn,
		/obj/item/weapon/storage/med_pouch/oxyloss,
		/obj/item/weapon/storage/med_pouch/toxin
		)
	contraband = list(/obj/item/weapon/reagent_containers/syringe/antitoxin = 4,/obj/item/weapon/reagent_containers/syringe/antiviral = 4,/obj/item/weapon/reagent_containers/pill/tox = 1)

/obj/machinery/vending/wallmed2
	name = "NanoMed Mini"
	desc = "A wall-mounted version of the NanoMed, containing only vital first aid equipment."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	icon_vend = "wallmed-vend"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	base_type = /obj/machinery/vending/wallmed2
	products = list(
		/obj/item/weapon/reagent_containers/hypospray/autoinjector = 5,
		/obj/item/stack/medical/bruise_pack = 4,
		/obj/item/stack/medical/ointment = 4,
		/obj/item/weapon/storage/med_pouch/trauma,
		/obj/item/weapon/storage/med_pouch/burn,
		/obj/item/weapon/storage/med_pouch/oxyloss,
		/obj/item/weapon/storage/med_pouch/toxin,
		/obj/item/weapon/storage/med_pouch/radiation
		)
	contraband = list(/obj/item/weapon/reagent_containers/pill/tox = 3, /obj/item/weapon/reagent_containers/hypospray/autoinjector/pain = 2)

/obj/machinery/vending/security
	name = "SecTech"
	desc = "A security equipment vendor."
	product_ads = "Crack capitalist skulls!;Beat some heads in!;Don't forget - harm is good!;Your weapons are right here.;Handcuffs!;Freeze, scumbag!;Don't tase me bro!;Tase them, bro.;Why not have a donut?"
	icon_state = "sec"
	icon_deny = "sec-deny"
	icon_vend = "sec-vend"
	vend_delay = 14
	base_type = /obj/machinery/vending/security
	req_access = list(access_security)
	products = list(
		/obj/item/weapon/handcuffs = 8,
		/obj/item/weapon/grenade/flashbang = 4,
		/obj/item/weapon/grenade/chem_grenade/teargas = 4,
		/obj/item/device/flash = 5,
		/obj/item/weapon/reagent_containers/food/snacks/donut/normal = 12,
		/obj/item/weapon/storage/box/evidence = 6)
	contraband = list(/obj/item/clothing/glasses/sunglasses = 2,/obj/item/weapon/storage/box/donut = 2)

/obj/machinery/vending/hydronutrients
	name = "NutriMax"
	desc = "A plant nutrients vendor."
	product_slogans = "Aren't you glad you don't have to fertilize the natural way?;Now with 50% less stink!;Plants are people too!"
	product_ads = "We like plants!;Don't you want some?;The greenest thumbs ever.;We like big plants.;Soft soil..."
	icon_state = "nutri"
	icon_deny = "nutri-deny"
	icon_vend = "nutri-vend"
	vend_delay = 26
	base_type = /obj/machinery/vending/hydronutrients
	products = list(/obj/item/weapon/reagent_containers/glass/bottle/eznutrient = 6,/obj/item/weapon/reagent_containers/glass/bottle/left4zed = 4,/obj/item/weapon/reagent_containers/glass/bottle/robustharvest = 3,/obj/item/weapon/plantspray/pests = 20,
					/obj/item/weapon/reagent_containers/syringe = 5,/obj/item/weapon/storage/plants = 5)
	premium = list(/obj/item/weapon/reagent_containers/glass/bottle/ammonia = 10,/obj/item/weapon/reagent_containers/glass/bottle/diethylamine = 5)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/hydronutrients/generic
	icon_state = "nutri_generic"
	icon_vend = "nutri_generic-vend"
	icon_deny = "nutri_generic-deny"

/obj/machinery/vending/hydroseeds
	name = "MegaSeed Servitor"
	desc = "When you need seeds fast!"
	product_slogans = "THIS'S WHERE TH' SEEDS LIVE! GIT YOU SOME!;Hands down the best seed selection this half of the galaxy!;Also certain mushroom varieties available, more for experts! Get certified today!"
	product_ads = "We like plants!;Grow some crops!;Grow, baby, growww!;Aw h'yeah son!"
	icon_state = "seeds"
	icon_vend = "seeds-vend"
	icon_deny = "seeds-deny"
	vend_delay = 13
	base_type = /obj/machinery/vending/hydroseeds
	products = list(/obj/item/seeds/bananaseed = 3,/obj/item/seeds/berryseed = 3,/obj/item/seeds/carrotseed = 3,/obj/item/seeds/chantermycelium = 3,/obj/item/seeds/chiliseed = 3,
					/obj/item/seeds/cornseed = 3, /obj/item/seeds/eggplantseed = 3, /obj/item/seeds/potatoseed = 3, /obj/item/seeds/replicapod = 3,/obj/item/seeds/soyaseed = 3,
					/obj/item/seeds/sunflowerseed = 3,/obj/item/seeds/tomatoseed = 3,/obj/item/seeds/towermycelium = 3,/obj/item/seeds/wheatseed = 3,/obj/item/seeds/appleseed = 3,
					/obj/item/seeds/poppyseed = 3,/obj/item/seeds/sugarcaneseed = 3,/obj/item/seeds/ambrosiavulgarisseed = 3,/obj/item/seeds/peanutseed = 3,/obj/item/seeds/whitebeetseed = 3,/obj/item/seeds/watermelonseed = 3,/obj/item/seeds/limeseed = 3,
					/obj/item/seeds/lemonseed = 3,/obj/item/seeds/orangeseed = 3,/obj/item/seeds/grassseed = 3,/obj/item/seeds/cocoapodseed = 3,/obj/item/seeds/plumpmycelium = 2,
					/obj/item/seeds/cabbageseed = 3,/obj/item/seeds/grapeseed = 3,/obj/item/seeds/pumpkinseed = 3,/obj/item/seeds/cherryseed = 3,/obj/item/seeds/plastiseed = 3,/obj/item/seeds/riceseed = 3,/obj/item/seeds/lavenderseed = 3)
	contraband = list(/obj/item/seeds/amanitamycelium = 2,/obj/item/seeds/glowshroom = 2,/obj/item/seeds/libertymycelium = 2,/obj/item/seeds/mtearseed = 2,
					  /obj/item/seeds/nettleseed = 2,/obj/item/seeds/reishimycelium = 2,/obj/item/seeds/reishimycelium = 2,/obj/item/seeds/shandseed = 2,)
	premium = list(/obj/item/weapon/reagent_containers/spray/waterflower = 1)

/obj/machinery/vending/hydroseeds/vend(var/datum/stored_items/vending_products/R, mob/user)
	..()
	flick("[icon_state]-shelf[rand(3)]", src)

/obj/machinery/vending/hydroseeds/generic
	icon_state = "seeds_generic"
	icon_vend = "seeds_generic-vend"
	icon_deny = "seeds_generic-deny"

/**
 *  Populate hydroseeds product_records
 *
 *  This needs to be customized to fetch the actual names of the seeds, otherwise
 *  the machine would simply list "packet of seeds" times 20
 */
/obj/machinery/vending/hydroseeds/build_inventory()
	var/list/all_products = list(
		list(src.products, CAT_NORMAL),
		list(src.contraband, CAT_HIDDEN),
		list(src.premium, CAT_COIN))

	for(var/current_list in all_products)
		var/category = current_list[2]

		for(var/entry in current_list[1])
			var/obj/item/seeds/S = new entry(src)
			var/name = S.name
			var/datum/stored_items/vending_products/product = new/datum/stored_items/vending_products(src, entry, name)

			product.price = (entry in src.prices) ? src.prices[entry] : 0
			product.amount = (current_list[1][entry]) ? current_list[1][entry] : 1
			product.category = category

			src.product_records.Add(product)

/obj/machinery/vending/magivend
	name = "MagiVend"
	desc = "A magic vending machine."
	icon_state = "MagiVend"
	icon_deny = "MagiVend-deny"
	icon_vend = "MagiVend-vend"
	product_slogans = "Sling spells the proper way with MagiVend!;Be your own Houdini! Use MagiVend!"
	vend_delay = 15
	vend_reply = "Have an enchanted evening!"
	product_ads = "FJKLFJSD;AJKFLBJAKL;1234 LOONIES LOL!;>MFW;Kill them fuckers!;GET DAT FUKKEN DISK;HONK!;EI NATH;Down with Central!;Admin conspiracies since forever!;Space-time bending hardware!"
	products = list(/obj/item/clothing/head/wizard = 1,/obj/item/clothing/suit/wizrobe = 1,/obj/item/clothing/head/wizard/red = 1,/obj/item/clothing/suit/wizrobe/red = 1,/obj/item/clothing/shoes/sandal = 1,/obj/item/weapon/staff = 2)

/obj/machinery/vending/dinnerware
	name = "Dinnerware"
	desc = "A kitchen and restaurant equipment vendor."
	product_ads = "Mm, food stuffs!;Food and food accessories.;Get your plates!;You like forks?;I like forks.;Woo, utensils.;You don't really need these..."
	icon_state = "dinnerware"
	icon_vend = "dinnerware-vend"
	icon_deny = "dinnerware-deny"
	base_type = /obj/machinery/vending/dinnerware
	products = list(
	/obj/item/weapon/reagent_containers/glass/beaker/bowl =2,
	/obj/item/weapon/tray = 8,
	/obj/item/weapon/material/knife/kitchen = 3,
	/obj/item/weapon/material/kitchen/rollingpin = 2,
	/obj/item/weapon/reagent_containers/food/drinks/pitcher = 2,
	/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeecup = 8,
	/obj/item/weapon/reagent_containers/food/drinks/glass2/coffeecup/teacup = 8,
	/obj/item/weapon/reagent_containers/food/drinks/glass2/carafe = 2,
	/obj/item/weapon/reagent_containers/food/drinks/glass2/square = 8,
	/obj/item/clothing/suit/chef/classic = 2,
	/obj/item/weapon/storage/lunchbox = 3,
	/obj/item/weapon/storage/lunchbox/heart = 3,
	/obj/item/weapon/storage/lunchbox/cat = 3,
	/obj/item/weapon/storage/lunchbox/nt = 3,
	/obj/item/weapon/storage/lunchbox/mars = 3,
	/obj/item/weapon/storage/lunchbox/cti = 3,
	/obj/item/weapon/storage/lunchbox/nymph = 3,
	/obj/item/weapon/storage/lunchbox/syndicate = 3,
	/obj/item/weapon/storage/lunchbox/dais = 3,
	/obj/item/weapon/material/knife/kitchen/cleaver = 1)


	contraband = list(/obj/item/weapon/material/knife/kitchen/cleaver/bronze = 1)

/obj/machinery/vending/sovietsoda
	name = "BODA"
	desc = "An old soda vending machine. How could this have got here?"
	icon_state = "sovietsoda"
	icon_vend = "sovietsoda-vend"
	icon_deny = "sovietsoda-deny"
	base_type = /obj/machinery/vending/sovietsoda
	product_ads = "For Tsar and Country.;Have you fulfilled your nutrition quota today?;Very nice!;We are simple people, for this is all we eat.;If there is a person, there is a problem. If there is no person, then there is no problem."
	products = list(/obj/item/weapon/reagent_containers/food/drinks/cans/syndicola = 50,
					/obj/item/weapon/reagent_containers/food/drinks/cans/syndicolax = 30,
					/obj/item/weapon/reagent_containers/food/drinks/cans/artbru = 20,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/square/boda = 20,
					/obj/item/weapon/reagent_containers/food/drinks/glass2/square/bodaplus = 20)
	contraband = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/space_up = 300) // TODO Russian cola can
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/tool
	name = "YouTool"
	desc = "Tools for tools."
	icon_state = "tool"
	icon_deny = "tool-deny"
	icon_vend = "tool-vend"
	vend_delay = 11
	base_type = /obj/machinery/vending/tool
	products = list(/obj/item/stack/cable_coil/random = 10,/obj/item/weapon/crowbar = 5,/obj/item/weapon/weldingtool = 3,/obj/item/weapon/wirecutters = 5,
					/obj/item/weapon/wrench = 5,/obj/item/device/scanner/gas = 5,/obj/item/device/t_scanner = 5,/obj/item/weapon/screwdriver = 5,
					/obj/item/device/flashlight/flare/glowstick = 3, /obj/item/device/flashlight/flare/glowstick/red = 3, /obj/item/weapon/tape_roll = 8)
	contraband = list(/obj/item/weapon/weldingtool/hugetank = 2,/obj/item/clothing/gloves/insulated/cheap = 2)
	premium = list(/obj/item/clothing/gloves/insulated = 1)

/obj/machinery/vending/tool/adherent
	name = "Adherent Tool Dispenser"
	desc = "This looks like a heavily modified vending machine. It contains technology that doesn't appear to be human in origin."
	product_ads = "\[C#\]\[Cb\]\[Db\]. \[Ab\]\[A#\]\[Bb\]. \[E\]\[C\]\[Gb\]\[B#\]. \[C#\].;\[Cb\]\[A\]\[F\]\[Cb\]\[C\]\[E\]\[Cb\]\[E\]\[Fb\]. \[G#\]\[C\]\[Ab\]\[A\]\[C#\]\[B\]. \[Eb\]\[choral\]. \[E#\]\[C#\]\[Ab\]\[E\]\[C#\]\[Fb\]\[Cb\]\[F#\]\[C#\]\[Gb\]."
	icon_state = "adh-tool"
	icon_deny = "adh-tool-deny"
	icon_vend = "adh-tool-vend"
	vend_delay = 5
	products = list(/obj/item/weapon/weldingtool/electric/crystal = 5,
					/obj/item/weapon/wirecutters/crystal = 5,
					/obj/item/weapon/screwdriver/crystal = 5,
					/obj/item/weapon/crowbar/crystal = 5,
					/obj/item/weapon/wrench/crystal = 5,
					/obj/item/device/multitool/crystal = 5,
					/obj/item/weapon/storage/belt/utility/crystal = 5,
					/obj/item/weapon/storage/toolbox/crystal = 5)

/obj/machinery/vending/tool/adherent/vend(var/datum/stored_items/vending_products/R, var/mob/living/carbon/user)
	if((istype(user) && user.species.name == SPECIES_ADHERENT) || emagged)
		. = ..()
	else
		to_chat(user, "<span class='notice'>The vending machine emits a discordant note, and a small hole blinks several times. It looks like it wants something inserted.</span>")

/obj/machinery/vending/engivend
	name = "Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "engivend"
	icon_deny = "engivend-deny"
	icon_vend = "engivend-vend"
	vend_delay = 21
	base_type = /obj/machinery/vending/engivend
	req_access = list(list(access_atmospherics,access_engine_equip))
	products = list(/obj/item/clothing/glasses/meson = 2,/obj/item/device/multitool = 4,/obj/item/device/geiger = 4,/obj/item/weapon/airlock_electronics = 10,/obj/item/weapon/module/power_control = 10,/obj/item/weapon/airalarm_electronics = 10,/obj/item/weapon/cell = 10,/obj/item/clamp = 10)
	contraband = list(/obj/item/weapon/cell/high = 3)
	premium = list(/obj/item/weapon/storage/belt/utility = 3)

//This one's from bay12
/obj/machinery/vending/engineering
	name = "Robco Tool Maker"
	desc = "Everything you need for do-it-yourself repair."
	icon_state = "engi"
	icon_deny = "engi-deny"
	icon_vend = "engi-vend"
	base_type = /obj/machinery/vending/engineering
	req_access = list(list(access_atmospherics,access_engine_equip))
	products = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/oiljug = 6,
					/obj/item/weapon/storage/belt/utility = 4,/obj/item/clothing/glasses/meson = 4,/obj/item/clothing/gloves/insulated = 4, /obj/item/weapon/screwdriver = 12,
					/obj/item/weapon/crowbar = 12,/obj/item/weapon/wirecutters = 12,/obj/item/device/multitool = 12,/obj/item/weapon/wrench = 12,/obj/item/device/t_scanner = 12,
					/obj/item/weapon/cell = 8, /obj/item/weapon/weldingtool = 8,/obj/item/clothing/head/welding = 8,
					/obj/item/weapon/light/tube = 10,/obj/item/weapon/stock_parts/scanning_module = 5,/obj/item/weapon/stock_parts/micro_laser = 5,
					/obj/item/weapon/stock_parts/matter_bin = 5,/obj/item/weapon/stock_parts/manipulator = 5,/obj/item/weapon/stock_parts/console_screen = 5,
					/obj/item/weapon/stock_parts/capacitor = 5, /obj/item/weapon/stock_parts/keyboard = 5, /obj/item/weapon/stock_parts/power/apc/buildable = 5)
	contraband = list(/obj/item/weapon/rcd = 1, /obj/item/weapon/rcd_ammo = 5)
	// There was an incorrect entry (cablecoil/power).  I improvised to cablecoil/heavyduty.
	// Another invalid entry, /obj/item/weapon/circuitry.  I don't even know what that would translate to, removed it.
	// The original products list wasn't finished.  The ones without given quantities became quantity 5.  -Sayu

//This one's from bay12
/obj/machinery/vending/robotics
	name = "Robotech Deluxe"
	desc = "All the tools you need to create your own robot army."
	icon_state = "robotics"
	icon_deny = "robotics-deny"
	icon_vend = "robotics-vend"
	req_access = list(access_robotics)
	base_type = /obj/machinery/vending/robotics
	products = list(/obj/item/weapon/reagent_containers/food/drinks/bottle/oiljug = 5,
					/obj/item/stack/cable_coil = 4,/obj/item/device/flash/synthetic = 4,/obj/item/weapon/cell = 4,/obj/item/device/scanner/health = 2,
					/obj/item/weapon/scalpel = 1,/obj/item/weapon/circular_saw = 1,/obj/item/weapon/tank/anesthetic = 2,/obj/item/clothing/mask/breath/medical = 5,
					/obj/item/weapon/screwdriver = 2,/obj/item/weapon/crowbar = 2)
	contraband = list(/obj/item/device/flash = 2)

//FOR ACTORS GUILD - mainly props that cannot be spawned otherwise
/obj/machinery/vending/props
	name = "prop dispenser"
	desc = "All the props an actor could need. Probably."
	icon_state = "theater"
	icon_vend = "theater-vend"
	icon_deny = "theater-deny"
	products = list(/obj/structure/flora/pottedplant = 2, /obj/item/device/flashlight/lamp = 2, /obj/item/device/flashlight/lamp/green = 2, /obj/item/weapon/reagent_containers/food/drinks/jar = 1,
					/obj/item/weapon/nullrod = 1, /obj/item/toy/cultsword = 4, /obj/item/toy/katana = 2)

/obj/machinery/vending/props/on_update_icon()
	..()
	if(!(stat & NOPOWER))
		overlays += image(icon, "[initial(icon_state)]-overlay")

//FOR ACTORS GUILD - Containers
/obj/machinery/vending/containers
	name = "container dispenser"
	desc = "A container that dispenses containers."
	icon_state = "robotics"
	base_type = /obj/machinery/vending/containers
	products = list(/obj/structure/closet/crate/freezer = 2, /obj/structure/closet = 3, /obj/structure/closet/crate = 3)

/obj/machinery/vending/fashionvend
	name = "Smashing Fashions"
	desc = "For all your cheap knockoff needs."
	product_slogans = "Look smashing for your darling!;Be rich! Dress rich!"
	icon_state = "theater"
	vend_delay = 15
	base_type = /obj/machinery/vending/fashionvend
	vend_reply = "Absolutely smashing!"
	product_ads = "Impress the love of your life!;Don't look poor, look rich!;100% authentic designers!;All sales are final!;Lowest prices guaranteed!"
	products = list(/obj/item/weapon/mirror = 8,
					/obj/item/weapon/haircomb = 8,
					/obj/item/clothing/glasses/monocle = 5,
					/obj/item/clothing/glasses/sunglasses = 5,
					/obj/item/weapon/lipstick = 3,
					/obj/item/weapon/lipstick/black = 3,
					/obj/item/weapon/lipstick/purple = 3,
					/obj/item/weapon/lipstick/jade = 3,
					/obj/item/weapon/storage/wallet/poly = 2)
	contraband = list(/obj/item/clothing/glasses/eyepatch = 2, /obj/item/clothing/accessory/horrible = 2)
	premium = list(/obj/item/clothing/mask/smokable/pipe = 3)
	prices = list(/obj/item/weapon/mirror = 60,
					/obj/item/weapon/haircomb = 40,
					/obj/item/clothing/glasses/monocle = 700,
					/obj/item/clothing/glasses/sunglasses = 500,
					/obj/item/weapon/lipstick = 100,
					/obj/item/weapon/lipstick/black = 100,
					/obj/item/weapon/lipstick/purple = 100,
					/obj/item/weapon/lipstick/jade = 100,
					/obj/item/weapon/storage/wallet/poly = 600
					)
// eliza's attempt at a new vending machine
/obj/machinery/vending/games
	name = "Good Clean Fun"
	desc = "Vends things that the CO and SEA are probably not going to appreciate you fiddling with instead of your job..."
	vend_delay = 15
	product_slogans = "Escape to a fantasy world!;Fuel your gambling addiction!;Ruin your friendships!"
	product_ads = "Elves and dwarves!;Totally not satanic!;Fun times forever!"
	icon_state = "games"
	icon_deny = "games-deny"
	icon_vend = "games-vend"
	base_type = /obj/machinery/vending/games
	products = list(/obj/item/toy/blink = 5, /obj/item/toy/eightball = 8, /obj/item/weapon/deck/cards = 5, /obj/item/weapon/deck/tarot = 5, /obj/item/weapon/pack/cardemon = 6, /obj/item/weapon/pack/spaceball = 6, /obj/item/weapon/storage/pill_bottle/dice_nerd = 5, /obj/item/weapon/storage/pill_bottle/dice = 5, /obj/item/weapon/storage/box/checkers = 2, /obj/item/weapon/storage/box/checkers/chess/red = 2, /obj/item/weapon/storage/box/checkers/chess = 2, /obj/item/weapon/board = 2)
	prices = list(/obj/item/toy/blink = 3, /obj/item/toy/eightball = 10, /obj/item/weapon/deck/tarot = 3, /obj/item/weapon/deck/cards = 3, /obj/item/weapon/pack/cardemon = 5, /obj/item/weapon/pack/spaceball = 5, /obj/item/weapon/storage/pill_bottle/dice_nerd = 6, /obj/item/weapon/storage/pill_bottle/dice = 6, /obj/item/weapon/storage/box/checkers = 10, /obj/item/weapon/storage/box/checkers/chess/red = 10, /obj/item/weapon/storage/box/checkers/chess = 10, /obj/item/weapon/board = 2)
	premium = list(/obj/item/weapon/spirit_board = 1, /obj/item/weapon/gun/projectile/revolver/capgun = 1, /obj/item/ammo_magazine/caps = 4)
	contraband = list(/obj/item/weapon/reagent_containers/spray/waterflower = 2, /obj/item/weapon/storage/box/snappops = 3)

//Cajoes/Kyos/BloodyMan's Lavatory Articles Dispensiary

/obj/machinery/vending/lavatory
	name = "Lavatory Essentials"
	desc = "Vends things that make you less reviled in the work-place!"
	vend_delay = 15
	product_slogans = "Take a shower you hippie.;Get a haircut, hippie!;Reeking of vox taint? Take a shower!"

	icon_state = "lavatory"
	icon_deny = "lavatory-deny"
	icon_vend = "lavatory-vend"
	base_type = /obj/machinery/vending/lavatory
	products = list(/obj/item/weapon/soap = 12,
					/obj/item/weapon/mirror = 8,
					/obj/item/weapon/haircomb/random = 8,
					/obj/item/weapon/haircomb/brush = 4,
					/obj/item/weapon/towel/random = 6,
					/obj/item/weapon/reagent_containers/spray/cleaner/deodorant = 5
					)
	contraband = list(/obj/item/weapon/inflatable_duck = 1)
	prices = list(/obj/item/weapon/soap = 20,
				  /obj/item/weapon/mirror = 40,
				  /obj/item/weapon/haircomb/random = 40,
				  /obj/item/weapon/haircomb/brush = 80,
				  /obj/item/weapon/towel/random = 50,
				  /obj/item/weapon/reagent_containers/spray/cleaner/deodorant = 30
					)

//a food variant of the boda machine - It carries slavic themed foods.. Mostly beer snacks
/obj/machinery/vending/snix
	name = "Snix"
	desc = "An old snack vending machine, how did it get here? And are the snacks still good?"
	vend_delay = 30
	base_type = /obj/machinery/vending/snix
	product_slogans = "Snix!"

	icon_state = "snix"
	icon_vend = "snix-vend"
	icon_deny = "snix-deny"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/semki = 7,
					/obj/item/weapon/reagent_containers/food/snacks/canned/caviar = 7,
					/obj/item/weapon/reagent_containers/food/snacks/squid = 7,
					/obj/item/weapon/reagent_containers/food/snacks/croutons = 7,
					/obj/item/weapon/reagent_containers/food/snacks/salo = 7,
					/obj/item/weapon/reagent_containers/food/snacks/driedfish = 7,
					/obj/item/weapon/reagent_containers/food/snacks/pistachios = 7,
					)

	contraband = list(/obj/item/weapon/reagent_containers/food/snacks/canned/caviar/true = 1)

/obj/machinery/vending/snix/on_update_icon()
	..()
	if(!(stat & NOPOWER))
		overlays += image(icon, "[initial(icon_state)]-fan")

/obj/machinery/vending/sol
	name = "Mars-Mart"
	desc = "A SolCentric vending machine dispensing treats from home."
	vend_delay = 30
	product_slogans = "A taste of home!"
	icon_state = "solsnack"
	icon_vend = "solsnack-vend"
	icon_deny = "solsnack-deny"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/lunacake = 8,
					/obj/item/weapon/reagent_containers/food/snacks/lunacake/mochicake = 8,
					/obj/item/weapon/reagent_containers/food/snacks/lunacake/mooncake = 8,
					/obj/item/weapon/reagent_containers/food/snacks/pluto = 8,
					/obj/item/weapon/reagent_containers/food/snacks/triton = 8,
					/obj/item/weapon/reagent_containers/food/snacks/saturn = 8,
					/obj/item/weapon/reagent_containers/food/snacks/jupiter = 8,
					/obj/item/weapon/reagent_containers/food/snacks/mars = 8,
					/obj/item/weapon/reagent_containers/food/snacks/venus = 8,
					/obj/item/weapon/reagent_containers/food/snacks/oort = 8
					)

	prices = list(/obj/item/weapon/reagent_containers/food/snacks/lunacake = 12,
					/obj/item/weapon/reagent_containers/food/snacks/lunacake/mochicake = 12,
					/obj/item/weapon/reagent_containers/food/snacks/lunacake/mooncake = 12,
					/obj/item/weapon/reagent_containers/food/snacks/pluto = 12,
					/obj/item/weapon/reagent_containers/food/snacks/triton = 12,
					/obj/item/weapon/reagent_containers/food/snacks/saturn = 12,
					/obj/item/weapon/reagent_containers/food/snacks/jupiter = 12,
					/obj/item/weapon/reagent_containers/food/snacks/mars = 12,
					/obj/item/weapon/reagent_containers/food/snacks/venus = 12,
					/obj/item/weapon/reagent_containers/food/snacks/oort = 12
	)

/obj/machinery/vending/weeb
	name = "Nippon-tan!"
	desc = "A distressingly ethnic vending machine loaded with high sucrose low calorie for lack of better words snacks."
	vend_delay = 30
	product_slogans = "Konnichiwa gaijin senpai! ;Notice me senpai!; Kawaii-desu!"
	icon_state = "weeb"
	icon_vend = "weeb-vend"
	icon_deny = "weeb-deny"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/weebonuts = 8,
					/obj/item/weapon/reagent_containers/food/snacks/ricecake = 8,
					/obj/item/weapon/reagent_containers/food/snacks/dango = 8,
					/obj/item/weapon/reagent_containers/food/snacks/pokey = 8,
					/obj/item/weapon/reagent_containers/food/snacks/chocobanana = 8
					)

	prices = list(/obj/item/weapon/reagent_containers/food/snacks/weebonuts = 80,
					/obj/item/weapon/reagent_containers/food/snacks/ricecake = 80,
					/obj/item/weapon/reagent_containers/food/snacks/dango = 80,
					/obj/item/weapon/reagent_containers/food/snacks/pokey = 80,
					/obj/item/weapon/reagent_containers/food/snacks/chocobanana = 80
	)

/obj/machinery/vending/weeb/on_update_icon()
	..()
	if(!(stat & NOPOWER))
		overlays += image(icon, "[initial(icon_state)]-fan")

/obj/machinery/vending/hotfood
	name = "Hot Foods"
	desc = "An old vending machine promising 'hot foods'. You doubt any of its contents are still edible."
	vend_delay = 40
	base_type = /obj/machinery/vending/hotfood

	icon_state = "hotfood"
	icon_deny = "hotfood-deny"
	icon_vend = "hotfood-vend"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/old/pizza = 1,
					/obj/item/weapon/reagent_containers/food/snacks/old/burger = 1,
					/obj/item/weapon/reagent_containers/food/snacks/old/hamburger = 1,
					/obj/item/weapon/reagent_containers/food/snacks/old/fries = 1,
					/obj/item/weapon/reagent_containers/food/snacks/old/hotdog = 1,
					/obj/item/weapon/reagent_containers/food/snacks/old/taco = 1
					)

/obj/machinery/vending/hotfood/on_update_icon()
	..()
	if(!(stat & NOPOWER))
		overlays += image(icon, "[initial(icon_state)]-heater")
