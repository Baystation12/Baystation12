/obj/machinery/food_replicator
	name = "replicator"
	desc = "like a microwave, except better."
	icon = 'icons/obj/vending.dmi'
	icon_state = "soda"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 40
	var/biomass = 100
	var/biomass_max = 100
	var/biomass_per = 10
	var/deconstruct_eff = 0.5
	var/dispensing_type
	var/dispensing_time = 0
	var/list/menu = list("nutrition slab" = /obj/item/weapon/reagent_containers/food/snacks/tofu,
					 "turkey substitute" = /obj/item/weapon/reagent_containers/food/snacks/tofurkey,
					 "waffle substitute" = /obj/item/weapon/reagent_containers/food/snacks/soylenviridians,
					 "nutrition fries" = /obj/item/weapon/reagent_containers/food/snacks/fries,
					 "liquid nutrition" = /obj/item/weapon/reagent_containers/food/snacks/soydope,
					 "pudding substitute" = /obj/item/weapon/reagent_containers/food/snacks/ricepudding)

/obj/machinery/food_replicator/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/replicator(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src) //used to hold the biomass
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src) //used to cook the food
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src) //used to deconstruct the stuff

	RefreshParts()

/obj/machinery/food_replicator/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/S = O
		user.drop_item(O)
		for(var/datum/reagent/nutriment/N in S.reagentlist())
			biomass = max(biomass + min(1,round(N.volume*deconstruct_eff)), biomass_max)
		qdel(O)
	else if(istype(O, /obj/item/weapon/storage/bag/plants))
		for(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in O.contents)
			user << "You empty \the [O] into \the [src]"
			G.loc = null
			for(var/datum/reagent/nutriment/N in G.reagentlist())
				biomass = max(biomass + min(1,round(N.volume*deconstruct_eff)), biomass_max)
			qdel(G)
	else
		..()

/obj/machinery/food_replicator/update_icon()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else if( !(stat & NOPOWER) )
		icon_state = initial(icon_state)
	else
		src.icon_state = "[initial(icon_state)]-off"

/obj/machinery/food_replicator/hear_talk(mob/M as mob, text, verb, datum/language/speaking)
	if(speaking.machine_understands)
		spawn(20)
			var/true_text = lowertext(html_decode(text))
			for(var/menu_item in menu)
				if(findtext(true_text, menu_item))
					dispense_food(menu_item)
					return
			if(findtext(true_text, "status"))
				state_status()
			else if(findtext(true_text, "menu"))
				state_menu()
	..()

/obj/machinery/food_replicator/proc/state_status()
	var/message_bio = "boop beep"
	if(biomass == 0)
		message_bio = "Biomass is out!"
	else if(biomass <= biomass_max/4)
		message_bio = "Biomass is nearly out."
	else if(biomass <= biomass_max/2)
		message_bio = "Biomass is roughly half full."
	else if(biomass != biomass_max)
		message_bio = "Biomass is near maximum capacity!"
	else
		message_bio = "Biomass is full!"
	src.audible_message("<b>\The [src]</b> states, \"[message_bio]\"")

/obj/machinery/food_replicator/proc/state_menu()
	src.audible_message("<b>\The [src]</b> states, \"Greetings! I serve the following dishes: [english_list(menu)]\"")

/obj/machinery/food_replicator/proc/dispense_food(var/text)
	var/type = menu[text]
	if(!type)
		src.audible_message("<b>\The [src]</b> states, \"Error! I cannot find the recipe for that item.\"")
		return

	if(biomass < biomass_per)
		src.audible_message("<b>\The [src]</b> states, \"Error! I do not have enough biomass to serve any dishes.\"")
		return
	biomass -= biomass_per

	src.audible_message("<b>\The [src]</b> rumbles and vibrates.")
	playsound(src.loc, 'sound/machines/juicer.ogg', 50, 1)
	spawn(rand(30,60))
		src.audible_message("<b>\The [src]</b> states, \"Your [text] is ready!\"")
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
		var/atom/A = new type(src.loc)
		A.name = text
		A.desc = "Looks... actually pretty good."
		use_power(200)

/obj/machinery/food_replicator/RefreshParts()
	deconstruct_eff = 0
	biomass_max = 0
	biomass_per = 20
	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(istype(P, /obj/item/weapon/stock_parts/matter_bin))
			biomass_max += 100 * P.rating
		if(istype(P, /obj/item/weapon/stock_parts/manipulator))
			biomass_per = max(1, biomass_per - 5 * P.rating)
		if(istype(P, /obj/item/weapon/stock_parts/micro_laser))
			deconstruct_eff += 0.5 * P.rating
	biomass = min(biomass,biomass_max)