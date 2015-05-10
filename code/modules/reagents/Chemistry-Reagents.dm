#define SOLID 1
#define LIQUID 2
#define GAS 3
#define REAGENTS_OVERDOSE 30
#define REM REAGENTS_EFFECT_MULTIPLIER

//The reaction procs must ALWAYS set src = null, this detaches the proc from the object (the reagent)
//so that it can continue working when the reagent is deleted while the proc is still active.


/datum/reagent
	var/name = "Reagent"
	var/id = "reagent"
	var/description = ""
	var/datum/reagents/holder = null
	var/reagent_state = SOLID
	var/list/data = null
	var/volume = 0
	var/nutriment_factor = 0
	var/custom_metabolism = REAGENTS_METABOLISM
	var/overdose = 0
	var/overdose_dam = 1
	var/scannable = 0 //shows up on health analyzers
	var/glass_icon_state = null
	var/glass_name = null
	var/glass_desc = null
	var/glass_center_of_mass = null
	//var/list/viruses = list()
	var/color = "#000000" // rgb: 0, 0, 0, 0 - supports alpha channels
	var/color_weight = 1

/datum/reagent/proc/reaction_mob(var/mob/M, var/method=TOUCH, var/volume) //By default we have a chance to transfer some
	if(!istype(M, /mob/living))	return 0
	var/datum/reagent/self = src
	src = null										  //of the reagent to the mob on TOUCHING it.

	if(self.holder)		//for catching rare runtimes
		if(!istype(self.holder.my_atom, /obj/effect/effect/smoke/chem))
			// If the chemicals are in a smoke cloud, do not try to let the chemicals "penetrate" into the mob's system (balance station 13) -- Doohl

			if(method == TOUCH)

				var/chance = 1
				var/block  = 0

				for(var/obj/item/clothing/C in M.get_equipped_items())
					if(C.permeability_coefficient < chance) chance = C.permeability_coefficient
					if(istype(C, /obj/item/clothing/suit/bio_suit))
						// bio suits are just about completely fool-proof - Doohl
						// kind of a hacky way of making bio suits more resistant to chemicals but w/e
						if(prob(75))
							block = 1

					if(istype(C, /obj/item/clothing/head/bio_hood))
						if(prob(75))
							block = 1

				chance = chance * 100

				if(prob(chance) && !block)
					if(M.reagents)
						M.reagents.add_reagent(self.id,self.volume/2)
	return 1

/datum/reagent/proc/reaction_obj(var/obj/O, var/volume) //By default we transfer a small part of the reagent to the object
	src = null						//if it can hold reagents. nope!
	//if(O.reagents)
	//	O.reagents.add_reagent(id,volume/3)
	return

/datum/reagent/proc/reaction_turf(var/turf/T, var/volume)
	src = null
	return

/datum/reagent/proc/on_mob_life(var/mob/living/M as mob, var/alien)
	if(!istype(M, /mob/living))
		return //Noticed runtime errors from pacid trying to damage ghosts, this should fix. --NEO
	if( (overdose > 0) && (volume >= overdose))//Overdosing, wooo
		M.adjustToxLoss(overdose_dam)
	holder.remove_reagent(src.id, custom_metabolism) //By default it slowly disappears.
	return

/datum/reagent/proc/on_move(var/mob/M)
	return

// Called after add_reagents creates a new reagent.
/datum/reagent/proc/on_new(var/data)
	return

// Called when two reagents of the same are mixing. <-- Blatant lies
/datum/reagent/proc/on_merge(var/newdata, var/newamount)
	return

/datum/reagent/proc/on_update(var/atom/A)
	return

/datum/reagent/Destroy() // This should only be called by the holder, so it's already handled clearing its references
	..()
	holder = null

/datum/reagent/woodpulp
	name = "Wood Pulp"
	id = "woodpulp"
	description = "A mass of wood fibers."
	reagent_state = LIQUID
	color = "#B97A57"
