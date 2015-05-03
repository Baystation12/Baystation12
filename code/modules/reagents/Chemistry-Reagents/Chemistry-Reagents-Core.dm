/datum/reagent/blood
	data = new/list("donor"=null,"viruses"=null,"species"="Human","blood_DNA"=null,"blood_type"=null,"blood_colour"= "#A10808","resistances"=null,"trace_chem"=null, "antibodies" = list())
	name = "Blood"
	id = "blood"
	reagent_state = LIQUID
	color = "#C80000" // rgb: 200, 0, 0

	glass_icon_state = "glass_red"
	glass_name = "glass of tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

/datum/reagent/blood/reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
	var/datum/reagent/blood/self = src
	src = null
	if(self.data && self.data["viruses"])
		for(var/datum/disease/D in self.data["viruses"])
			//var/datum/disease/virus = new D.type(0, D, 1)
			// We don't spread.
			if(D.spread_type == SPECIAL || D.spread_type == NON_CONTAGIOUS) continue

			if(method == TOUCH)
				M.contract_disease(D)
			else //injected
				M.contract_disease(D, 1, 0)
	if(self.data && self.data["virus2"] && istype(M, /mob/living/carbon))//infecting...
		var/list/vlist = self.data["virus2"]
		if (vlist.len)
			for (var/ID in vlist)
				var/datum/disease2/disease/V = vlist[ID]

				if(method == TOUCH)
					infect_virus2(M,V.getcopy())
				else
					infect_virus2(M,V.getcopy(),1) //injected, force infection!
	if(self.data && self.data["antibodies"] && istype(M, /mob/living/carbon))//... and curing
		var/mob/living/carbon/C = M
		C.antibodies |= self.data["antibodies"]

/datum/reagent/blood/on_merge(var/newdata, var/newamount)
	if(!data || !newdata)
		return
	if(newdata["blood_colour"])
		color = newdata["blood_colour"]
	if(data && newdata)
		if(data["viruses"] || newdata["viruses"])

			var/list/mix1 = data["viruses"]
			var/list/mix2 = newdata["viruses"]

			// Stop issues with the list changing during mixing.
			var/list/to_mix = list()

			for(var/datum/disease/advance/AD in mix1)
				to_mix += AD
			for(var/datum/disease/advance/AD in mix2)
				to_mix += AD

			var/datum/disease/advance/AD = Advance_Mix(to_mix)
			if(AD)
				var/list/preserve = list(AD)
				for(var/D in data["viruses"])
					if(!istype(D, /datum/disease/advance))
						preserve += D
				data["viruses"] = preserve
	return ..()

/datum/reagent/blood/on_update(var/atom/A)
	if(data["blood_colour"])
		color = data["blood_colour"]
	return ..()

/datum/reagent/blood/reaction_turf(var/turf/simulated/T, var/volume)//splash the blood all over the place
	if(!istype(T)) return
	var/datum/reagent/blood/self = src
	src = null
	if(!(volume >= 3)) return

	if(!self.data["donor"] || istype(self.data["donor"], /mob/living/carbon/human))
		blood_splatter(T,self,1)
	else if(istype(self.data["donor"], /mob/living/carbon/alien))
		var/obj/effect/decal/cleanable/blood/B = blood_splatter(T,self,1)
		if(B) B.blood_DNA["UNKNOWN DNA STRUCTURE"] = "X*"
	if(volume >= 5 && !istype(T.loc, /area/chapel)) //blood desanctifies non-chapel tiles
		T.holy = 0
	return

/* Must check the transfering of reagents and their data first. They all can point to one disease datum.

/datum/reagent/blood/Destroy()
	if(src.data["virus"])
		var/datum/disease/D = src.data["virus"]
		D.cure(0)
	..()
*/

/datum/reagent/vaccine
	//data must contain virus type
	name = "Vaccine"
	id = "vaccine"
	reagent_state = LIQUID
	color = "#C81040" // rgb: 200, 16, 64

/datum/reagent/vaccine/reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
	var/datum/reagent/vaccine/self = src
	src = null
	if(self.data&&method == INGEST)
		for(var/datum/disease/D in M.viruses)
			if(istype(D, /datum/disease/advance))
				var/datum/disease/advance/A = D
				if(A.GetDiseaseID() == self.data)
					D.cure()
			else
				if(D.type == self.data)
					D.cure()

		M.resistances += self.data
	return

#define WATER_LATENT_HEAT 19000 // How much heat is removed when applied to a hot turf, in J/unit (19000 makes 120 u of water roughly equivalent to 4L)
/datum/reagent/water
	name = "Water"
	id = "water"
	description = "A ubiquitous chemical substance that is composed of hydrogen and oxygen."
	reagent_state = LIQUID
	color = "#0064C877" // rgb: 0, 100, 200
	custom_metabolism = 0.01

	glass_icon_state = "glass_clear"
	glass_name = "glass of water"
	glass_desc = "The father of all refreshments."

/datum/reagent/water/reaction_turf(var/turf/simulated/T, var/volume)
	if (!istype(T)) return

	//If the turf is hot enough, remove some heat
	var/datum/gas_mixture/environment = T.return_air()
	var/min_temperature = T0C + 100	//100C, the boiling point of water

	if (environment && environment.temperature > min_temperature) //abstracted as steam or something
		var/removed_heat = between(0, volume*WATER_LATENT_HEAT, -environment.get_thermal_energy_change(min_temperature))
		environment.add_thermal_energy(-removed_heat)
		if (prob(5))
			T.visible_message("\red The water sizzles as it lands on \the [T]!")

	else //otherwise, the turf gets wet
		if(volume >= 3)
			if(T.wet >= 1) return
			T.wet = 1
			if(T.wet_overlay)
				T.overlays -= T.wet_overlay
				T.wet_overlay = null
			T.wet_overlay = image('icons/effects/water.dmi',T,"wet_floor")
			T.overlays += T.wet_overlay

			src = null
			spawn(800)
				if (!istype(T)) return
				if(T.wet >= 2) return
				T.wet = 0
				if(T.wet_overlay)
					T.overlays -= T.wet_overlay
					T.wet_overlay = null

	//Put out fires.
	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot)
		qdel(hotspot)
		if(environment)
			environment.react() //react at the new temperature

/datum/reagent/water/reaction_obj(var/obj/O, var/volume)
	var/turf/T = get_turf(O)
	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles )
		lowertemp.temperature = max( min(lowertemp.temperature-2000,lowertemp.temperature / 2) ,0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)
	if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/monkeycube))
		var/obj/item/weapon/reagent_containers/food/snacks/monkeycube/cube = O
		if(!cube.wrapped)
			cube.Expand()

/datum/reagent/water/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
	if (istype(M, /mob/living/carbon/slime))
		var/mob/living/carbon/slime/S = M
		S.apply_water(volume)
	if(method == TOUCH && isliving(M))
		M.adjust_fire_stacks(-(volume / 10))
		if(M.fire_stacks <= 0)
			M.ExtinguishMob()
		return

/datum/reagent/fuel
	name = "Welding fuel"
	id = "fuel"
	description = "Required for welders. Flamable."
	reagent_state = LIQUID
	color = "#660000" // rgb: 102, 0, 0
	overdose = REAGENTS_OVERDOSE

	glass_icon_state = "dr_gibb_glass"
	glass_name = "glass of welder fuel"
	glass_desc = "Unless you are an industrial tool, this is probably not safe for consumption."

/datum/reagent/fuel/reaction_obj(var/obj/O, var/volume)
	var/turf/the_turf = get_turf(O)
	if(!the_turf)
		return //No sense trying to start a fire if you don't have a turf to set on fire. --NEO
	new /obj/effect/decal/cleanable/liquid_fuel(the_turf, volume)
/datum/reagent/fuel/reaction_turf(var/turf/T, var/volume)
	new /obj/effect/decal/cleanable/liquid_fuel(T, volume)
	return
/datum/reagent/fuel/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.adjustToxLoss(1)
	..()
	return
/datum/reagent/fuel/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)//Splashing people with welding fuel to make them easy to ignite!
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH)
		M.adjust_fire_stacks(volume / 10)
		return
