GLOBAL_LIST_INIT(nrods, list())

/obj/machinery/power/nuclear_rod
	name = "Nuclear rod"
	desc = "A nuclear rod, that generates radiation, thermal energy and some problems ."
	icon = 'icons/obj/machines/nuclearcore.dmi'
	icon_state = "base_rod"
	anchored = 1
	density = 1
	var/sealed = FALSE
	use_power = 0
	var/accepted_rads = 0
	var/own_rads = 0
	var/reaction_rads
	var/rodtemp = 293
	var/sealcoeff = 0
	var/raddecay = 0.003
	var/list/reactants = list()
	var/integrity = 100
	var/broken = 0
	var/thermalkoeff = 360  //Here is the coefficients, I added them for ingame reactor cinfigurations, if reactor is working correctly, they can be replaced with integers
	var/radkoeff = 65
	var/raddeccoeff = 121
	var/thermaldecaycoeff = 10
	var/obj/item/weapon/nuclearfuel/rod/F = null
	var/list/possible_reactions = new /list(0)

/obj/machinery/power/nuclear_rod/Initialize()
	. = ..()
	GLOB.nrods += src

/obj/machinery/power/nuclear_rod/Destroy()
	GLOB.nrods -= src
	return ..()

/obj/machinery/power/nuclear_rod/examine(mob/user)
	if (..(user, 3))
		to_chat(user, "The thermometer placed on the rod indicates that \the [src] has the temperature of [rodtemp] K.")
		return 1

/obj/machinery/power/nuclear_rod/physical_attack_hand(mob/user)   //Removing the assembly.
	add_fingerprint(user)
	if(reactants.len && do_after(user, 30,src) && rodtemp < 1000)

		var/obj/item/weapon/nuclearfuel/rod/F = new(get_turf(src), reactants)
		user.put_in_hands(F)
		reactants = list()

/obj/machinery/power/nuclear_rod/attackby(obj/item/weapon/W, mob/user)  //Interaction with tools
	if(rodtemp < 2000)
		if(!broken)
			src.add_fingerprint(user)
			if(isCrowbar(W))
				playsound(loc, 'sound/machines/click.ogg', 50, 1)
				user.visible_message("<span class='notice'>[user] begins to switch sealing on the rod.</span>")
				if(do_after(user, 50,src))
					switch(sealed)
						if(TRUE)
							sealed = FALSE
						if(FALSE)
							sealed = TRUE
					playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
					user.visible_message("<span class='notice'>[user] switched sealing on the rod.</span>")
					return
				return

			else if(istype(W, /obj/item/weapon/nuclearfuel/rod))
				if(!reactants.len && rodtemp < 1000)
					playsound(loc, 'sound/machines/click.ogg', 50, 1)
					F = W
					message_admins("[user] loaded [src] with [W]")
					user.unEquip(W, src)

			else if(isWrench(W))
				playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)
				switch(anchored)
					if(1.0)
						user.visible_message("<span class='notice'>[user] unwrenched rod from the ground.</span>")
						anchored = 0
					if(0.0)
						user.visible_message("<span class='notice'>[user] wrenched rod into place.</span>")
						anchored = 1

			else if(isWelder(W))
				to_chat(user, "<span class='notice'>You are fixing the rod with [W].</span>")
				playsound(src, 'sound/items/Welder.ogg', 10, 1)
				if(do_after(user, 40,src))
					integrity = 100

			else if(isMultitool(W))
				var/new_id = input("Enter a new ident tag.", "Nuclear rod", id_tag) as null|text
				if(new_id && user.Adjacent(src))
					id_tag = new_id
				var/new_name = input("Enter a new name for a rod.", "Nuclear rod", name) as null|text
				if(new_name && user.Adjacent(src))
					name = new_name

		else
			if(isWelder(W))
				to_chat(user, "<span class='notice'>You are removing molten rod with [W].</span>")
				playsound(src, 'sound/items/Welder.ogg', 10, 1)
				if(do_after(user, 100,src))
					qdel(src)
	else
		to_chat(user, "<span class='notice'>Rod is too hot to operate.</span>")

/obj/machinery/power/nuclear_rod/proc/check_state()   // Well, this is kinda ugly, but at least it works
	if (rodtemp > 5000)
		integrity -= (rodtemp - 5000)/10
	if (integrity <= 0 && broken == 0)
		explosion(src, -1, -1, rodtemp/ 500, rodtemp / 200)
		SSradiation.radiate (src, 500)
		sealed = 0
		broken = 1
		reactants = list()
		message_admins("[src] just molten down!")
		own_rads = 2000

/obj/machinery/power/nuclear_rod/Process()     // Here is main purpouse of the rod - heating and radiating.
	React()
	if(rodtemp < 0)
		rodtemp = 0
	if(F && !reactants.len)
		reactants = F.reactants
		qdel(F)
	var/raddecay = rand((raddeccoeff * 0.95), raddeccoeff)
	var/datum/gas_mixture/environment = loc.return_air()
	if(sealed == 0)
		if(rodtemp > 500)
			set_light(0.6, 1, 7)
		var/emitted = own_rads/(rodtemp+1)*(rodtemp+300)
		SSradiation.radiate(src, emitted)
		var/ratio = min((thermaldecaycoeff / 2), (environment.return_pressure()/ONE_ATMOSPHERE))
		var/chamb_temp = environment.temperature
		if ((rodtemp > chamb_temp) && ((rodtemp -= (rodtemp-chamb_temp) * ratio / thermaldecaycoeff) > 0))
			environment.add_thermal_energy((rodtemp-chamb_temp)*ratio*1200)
			rodtemp -= (rodtemp-chamb_temp) * ratio / thermaldecaycoeff
		else
			rodtemp += (chamb_temp - rodtemp) * ratio / 20
	else
		SSradiation.radiate(src, round (own_rads * sealcoeff))
	own_rads = own_rads/raddecay*100
	if(own_rads > 5000)
		own_rads -= own_rads/raddecay*10
	if(reaction_rads > 5)
		reaction_rads = reaction_rads/(rand(191,211))/(rodtemp + 500)*10000
	check_state()
	update_icon()

/obj/machinery/power/nuclear_rod/on_update_icon()
	if (broken == 1)
		icon_state = "broken_rod"
	else
		if (sealed == 0)
			if(!reactants.len)
				icon_state = "nofuel_rod"
			else
				switch(rodtemp)
					if(0 to 500)
						icon_state = "base_rod"
					if(500 to 1000)
						icon_state = "heat_rod"
					if(1000 to 3500)
						icon_state = "optimal_rod"
					else
						icon_state = "overheat_rod"
		else
			icon_state = "sealed_rod"

/obj/machinery/power/nuclear_rod/proc/AddReact(var/name, var/quantity = 1)  //Just put reactants back in rod.
	if(name in reactants)
		reactants[name] += quantity
	else
		reactants.Add(name)
		reactants[name] = quantity

/obj/machinery/power/nuclear_rod/proc/React() //This proc is quite baggy, so not be suprised by some strange shit, that certanly WILL happen, if you do not fix it.
	possible_reactions = list()
	if((SSradiation.get_rads_at_turf(get_turf(src)) - own_rads) > 0)
		reaction_rads += (SSradiation.get_rads_at_turf(get_turf(src)) - own_rads)
	if (reaction_rads < 0)
		reaction_rads = 0

	if(reactants.len)
		var/list/produced_reactants = new /list(0)
		var/list/allreactions = decls_repository.get_decls_of_subtype(/decl/nuclear_reaction)
		for(var/decl in allreactions)
			var/decl/nuclear_reaction/p_reaction = allreactions[decl]
			if(!p_reaction.substance || (p_reaction.type in possible_reactions))
				continue
			if(reactants[p_reaction.substance] && (reaction_rads >= p_reaction.required_rads))
				possible_reactions += p_reaction.type
		while(possible_reactions.len)
			var/cur_reaction_type = pick_n_take(possible_reactions)
			var/decl/nuclear_reaction/cur_reaction = new cur_reaction_type
			var/max_num_reactants = 0
			if(reaction_rads < cur_reaction.required_rads)
				continue

			if(reactants[cur_reaction.substance] > 0.000001)  //To eliminate especially "weak" reactions
				if(cur_reaction.required_rads > 0)
					max_num_reactants = (1 + reaction_rads/cur_reaction.required_rads) * reactants[cur_reaction.substance] / 80000
				else
					max_num_reactants = reactants[cur_reaction.substance] / 2000
			else
				max_num_reactants =	reactants[cur_reaction.substance]
			var/amount_reacting = rand((max_num_reactants * 0.96), max_num_reactants)//This value is sometimes manages to get negative
			if(amount_reacting <= 0)
				continue

			if( reactants[cur_reaction.substance] - amount_reacting >= 0 )
				reactants[cur_reaction.substance] -= amount_reacting
			else
				amount_reacting = reactants[cur_reaction.substance]
				reactants[cur_reaction.substance] = 0

			if(((amount_reacting * cur_reaction.heat_production * thermalkoeff/9) < 5000) && ((amount_reacting * cur_reaction.heat_production) > 0)) //Change coefficients to configure the rod thermal output. DO NOT forget to doblicate it into if operator.
				if(((rodtemp + amount_reacting * cur_reaction.heat_production * thermalkoeff) < 3000) || ((amount_reacting * cur_reaction.heat_production * 320) < 250))
					rodtemp += amount_reacting * cur_reaction.heat_production * thermalkoeff // Temperature increase. Stronger reaction = more temperature.
				else
					if(((rodtemp + amount_reacting * cur_reaction.heat_production * thermalkoeff/3) < 4000) || ((amount_reacting * cur_reaction.heat_production * 100) < 200))
						rodtemp += amount_reacting * cur_reaction.heat_production * thermalkoeff/3  
					else
						rodtemp += amount_reacting * cur_reaction.heat_production * thermalkoeff / 9

			if(own_rads < 500) //Same as above, but with radiation.
				own_rads += amount_reacting * cur_reaction.radiation * radkoeff  //Coefficients are declared in define of the rod.
			else if(own_rads < 2000)
				own_rads += amount_reacting * cur_reaction.radiation * radkoeff/2
			else if(own_rads < 7000)
				own_rads += amount_reacting * cur_reaction.radiation * radkoeff/6

			for(var/pr_reactant in cur_reaction.products)   //Well, this code is mostly copied from R-ust and chemistry, so you can look there for better explanations
				var/success = 0
				for(var/check_reactant in produced_reactants)
					if(check_reactant == pr_reactant)
						produced_reactants[pr_reactant] += cur_reaction.products[pr_reactant] * amount_reacting
						success = 1
						break
				if(!success)
					produced_reactants[pr_reactant] = cur_reaction.products[pr_reactant] * amount_reacting
		//	possible_reactions -= cur_reaction.type
		for(var/prreactant in produced_reactants)
			AddReact(prreactant, produced_reactants[prreactant])  //Look at AddReact() for details
	return 1
