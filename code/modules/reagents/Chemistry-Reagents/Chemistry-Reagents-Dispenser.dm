/datum/reagent/aluminum
	name = "Aluminum"
	id = "aluminum"
	description = "A silvery white and ductile member of the boron group of chemical elements."
	reagent_state = SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168

/datum/reagent/carbon
	name = "Carbon"
	id = "carbon"
	description = "A chemical element, the builing block of life."
	reagent_state = SOLID
	color = "#1C1300" // rgb: 30, 20, 0

	custom_metabolism = 0.01

/datum/reagent/carbon/reaction_turf(var/turf/T, var/volume)
	src = null
	if(!istype(T, /turf/space))
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, T)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(T)
			dirtoverlay.alpha = volume*30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha+volume*30, 255)

/datum/reagent/chlorine
	name = "Chlorine"
	id = "chlorine"
	description = "A chemical element with a characteristic odour."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	overdose = REAGENTS_OVERDOSE

/datum/reagent/chlorine/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.take_organ_damage(1*REM, 0)
	..()
	return

/datum/reagent/copper
	name = "Copper"
	id = "copper"
	description = "A highly ductile metal."
	color = "#6E3B08" // rgb: 110, 59, 8

	custom_metabolism = 0.01

/datum/reagent/ethanol
	name = "Ethanol" //Parent class for all alcoholic reagents.
	id = "ethanol"
	description = "A well-known alcohol with a variety of applications."
	reagent_state = LIQUID
	nutriment_factor = 0 //So alcohol can fill you up! If they want to.
	color = "#404030" // rgb: 64, 64, 48
	var/boozepwr = 5 //higher numbers mean the booze will have an effect faster.
	var/dizzy_adj = 3
	var/adj_drowsy = 0
	var/adj_sleepy = 0
	var/slurr_adj = 3
	var/confused_adj = 2
	var/slur_start = 90			//amount absorbed after which mob starts slurring
	var/confused_start = 150	//amount absorbed after which mob starts confusing directions
	var/blur_start = 300	//amount absorbed after which mob starts getting blurred vision
	var/pass_out = 400	//amount absorbed after which mob starts passing out

	glass_icon_state = "glass_clear"
	glass_name = "glass of ethanol"
	glass_desc = "A well-known alcohol with a variety of applications."

/datum/reagent/ethanol/on_mob_life(var/mob/living/M as mob, var/alien)
	M:nutrition += nutriment_factor
	holder.remove_reagent(src.id, (alien ? FOOD_METABOLISM : ALCOHOL_METABOLISM)) // Catch-all for creatures without livers.

	if (adj_drowsy)	M.drowsyness = max(0,M.drowsyness + adj_drowsy)
	if (adj_sleepy) M.sleeping = max(0,M.sleeping + adj_sleepy)

	if(!src.data || (!isnum(src.data)  && src.data.len)) data = 1   //if it doesn't exist we set it.  if it's a list we're going to set it to 1 as well.  This is to
	src.data += boozepwr						//avoid a runtime error associated with drinking blood mixed in drinks (demon's blood).

	var/d = data

	// make all the beverages work together
	for(var/datum/reagent/ethanol/A in holder.reagent_list)
		if(A != src && isnum(A.data)) d += A.data

	if(alien && alien == IS_SKRELL) //Skrell get very drunk very quickly.
		d*=5

	M.dizziness += dizzy_adj.
	if(d >= slur_start && d < pass_out)
		if (!M:slurring) M:slurring = 1
		M:slurring += slurr_adj
	if(d >= confused_start && prob(33))
		if (!M:confused) M:confused = 1
		M.confused = max(M:confused+confused_adj,0)
	if(d >= blur_start)
		M.eye_blurry = max(M.eye_blurry, 10)
		M:drowsyness  = max(M:drowsyness, 0)
	if(d >= pass_out)
		M:paralysis = max(M:paralysis, 20)
		M:drowsyness  = max(M:drowsyness, 30)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/liver/L = H.internal_organs_by_name["liver"]
			if (!L)
				H.adjustToxLoss(5)
			else if(istype(L))
				L.take_damage(0.1, 1)
			H.adjustToxLoss(0.1)
	..()
	return

/datum/reagent/ethanol/reaction_obj(var/obj/O, var/volume)
	if(istype(O,/obj/item/weapon/paper))
		var/obj/item/weapon/paper/paperaffected = O
		paperaffected.clearpaper()
		usr << "The solution dissolves the ink on the paper."
	if(istype(O,/obj/item/weapon/book))
		if(istype(O,/obj/item/weapon/book/tome))
			usr << "The solution does nothing. Whatever this is, it isn't normal ink."
			return
		if(volume >= 5)
			var/obj/item/weapon/book/affectedbook = O
			affectedbook.dat = null
			usr << "The solution dissolves the ink on the book."
		else
			usr << "It wasn't enough..."
	return

/datum/reagent/ethanol/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)//Splashing people with ethanol isn't quite as good as fuel.
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH)
		M.adjust_fire_stacks(volume / 15)
		return

/datum/reagent/fluorine
	name = "Fluorine"
	id = "fluorine"
	description = "A highly-reactive chemical element."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	overdose = REAGENTS_OVERDOSE

/datum/reagent/fluorine/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.adjustToxLoss(1*REM)
	..()
	return

/datum/reagent/hydrogen
	name = "Hydrogen"
	id = "hydrogen"
	description = "A colorless, odorless, nonmetallic, tasteless, highly combustible diatomic gas."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128

	custom_metabolism = 0.01

/datum/reagent/iron
	name = "Iron"
	id = "iron"
	description = "Pure iron is a metal."
	reagent_state = SOLID
	color = "#353535"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/lithium
	name = "Lithium"
	id = "lithium"
	description = "A chemical element, used as antidepressant."
	reagent_state = SOLID
	color = "#808080" // rgb: 128, 128, 128
	overdose = REAGENTS_OVERDOSE

/datum/reagent/lithium/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(M.canmove && !M.restrained() && istype(M.loc, /turf/space))
		step(M, pick(cardinal))
	if(prob(5)) M.emote(pick("twitch","drool","moan"))
	..()
	return

/datum/reagent/mercury
	name = "Mercury"
	id = "mercury"
	description = "A chemical element."
	reagent_state = LIQUID
	color = "#484848" // rgb: 72, 72, 72
	overdose = REAGENTS_OVERDOSE

/datum/reagent/mercury/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(M.canmove && !M.restrained() && istype(M.loc, /turf/space))
		step(M, pick(cardinal))
	if(prob(5)) M.emote(pick("twitch","drool","moan"))
	M.adjustBrainLoss(2)
	..()
	return

/datum/reagent/nitrogen
	name = "Nitrogen"
	id = "nitrogen"
	description = "A colorless, odorless, tasteless gas."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128

	custom_metabolism = 0.01

/datum/reagent/nitrogen/on_mob_life(var/mob/living/M as mob, var/alien)
	if(M.stat == 2) return
	if(alien && alien == IS_VOX)
		M.adjustOxyLoss(-2*REM)
		holder.remove_reagent(src.id, REAGENTS_METABOLISM) //By default it slowly disappears.
		return
	..()

/datum/reagent/oxygen
	name = "Oxygen"
	id = "oxygen"
	description = "A colorless, odorless gas."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128

	custom_metabolism = 0.01

/datum/reagent/oxygen/on_mob_life(var/mob/living/M as mob, var/alien)
	if(M.stat == 2) return
	if(alien && alien == IS_VOX)
		M.adjustToxLoss(REAGENTS_METABOLISM)
		holder.remove_reagent(src.id, REAGENTS_METABOLISM) //By default it slowly disappears.
		return
	..()

/datum/reagent/phosphorus
	name = "Phosphorus"
	id = "phosphorus"
	description = "A chemical element, the backbone of biological energy carriers."
	reagent_state = SOLID
	color = "#832828" // rgb: 131, 40, 40

	custom_metabolism = 0.01

/datum/reagent/potassium
	name = "Potassium"
	id = "potassium"
	description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	reagent_state = SOLID
	color = "#A0A0A0" // rgb: 160, 160, 160

	custom_metabolism = 0.01

/datum/reagent/radium
	name = "Radium"
	id = "radium"
	description = "Radium is an alkaline earth metal. It is extremely radioactive."
	reagent_state = SOLID
	color = "#C7C7C7" // rgb: 199,199,199

/datum/reagent/radium/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.apply_effect(2*REM,IRRADIATE,0)
	// radium may increase your chances to cure a disease
	if(istype(M,/mob/living/carbon)) // make sure to only use it on carbon mobs
		var/mob/living/carbon/C = M
		if(C.virus2.len)
			for (var/ID in C.virus2)
				var/datum/disease2/disease/V = C.virus2[ID]
				if(prob(5))
					C.antibodies |= V.antigen
					if(prob(50))
						M.radiation += 50 // curing it that way may kill you instead
						var/absorbed
						var/obj/item/organ/diona/nutrients/rad_organ = locate() in C.internal_organs
						if(rad_organ && !rad_organ.is_broken())
							absorbed = 1
						if(!absorbed)
							M.adjustToxLoss(100)
	..()
	return

/datum/reagent/radium/reaction_turf(var/turf/T, var/volume)
	src = null
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)
			return

/datum/reagent/toxin/acid
	name = "Sulphuric acid"
	id = "sacid"
	description = "A very corrosive mineral acid with the molecular formula H2SO4."
	reagent_state = LIQUID
	color = "#DB5008" // rgb: 219, 80, 8
	toxpwr = 1
	var/meltprob = 10

/datum/reagent/toxin/acid/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.take_organ_damage(0, 1*REM)
	..()
	return

/datum/reagent/toxin/acid/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)//magic numbers everywhere
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(H.head)
				if(prob(meltprob) && !H.head.unacidable)
					H << "<span class='danger'>Your headgear melts away but protects you from the acid!</span>"
					qdel(H.head)
					H.update_inv_head(0)
					H.update_hair(0)
				else
					H << "<span class='warning'>Your headgear protects you from the acid.</span>"
				return

			if(H.wear_mask)
				if(prob(meltprob) && !H.wear_mask.unacidable)
					H << "<span class='danger'>Your mask melts away but protects you from the acid!</span>"
					qdel (H.wear_mask)
					H.update_inv_wear_mask(0)
					H.update_hair(0)
				else
					H << "<span class='warning'>Your mask protects you from the acid.</span>"
				return

			if(H.glasses) //Doesn't protect you from the acid but can melt anyways!
				if(prob(meltprob) && !H.glasses.unacidable)
					H << "<span class='danger'>Your glasses melts away!</span>"
					qdel (H.glasses)
					H.update_inv_glasses(0)

		if(!M.unacidable)
			if(istype(M, /mob/living/carbon/human) && volume >= 10)
				var/mob/living/carbon/human/H = M
				var/obj/item/organ/external/affecting = H.get_organ("head")
				if(affecting)
					if(affecting.take_damage(4*toxpwr, 2*toxpwr))
						H.UpdateDamageIcon()
					if(prob(meltprob)) //Applies disfigurement
						if (!(H.species && (H.species.flags & NO_PAIN)))
							H.emote("scream")
						H.status_flags |= DISFIGURED
			else
				M.take_organ_damage(min(6*toxpwr, volume * toxpwr)) // uses min() and volume to make sure they aren't being sprayed in trace amounts (1 unit != insta rape) -- Doohl
	else
		if(!M.unacidable)
			M.take_organ_damage(min(6*toxpwr, volume * toxpwr))

/datum/reagent/toxin/acid/reaction_obj(var/obj/O, var/volume)
	if((istype(O,/obj/item) || istype(O,/obj/effect/plant)) && prob(meltprob * 3))
		if(!O.unacidable)
			var/obj/effect/decal/cleanable/molten_item/I = new/obj/effect/decal/cleanable/molten_item(O.loc)
			I.desc = "Looks like this was \an [O] some time ago."
			for(var/mob/M in viewers(5, O))
				M << "\red \the [O] melts."
			qdel(O)

/datum/reagent/silicon
	name = "Silicon"
	id = "silicon"
	description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	reagent_state = SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168

/datum/reagent/sodium
	name = "Sodium"
	id = "sodium"
	description = "A chemical element, readily reacts with water."
	reagent_state = SOLID
	color = "#808080" // rgb: 128, 128, 128

	custom_metabolism = 0.01

/datum/reagent/sugar
	name = "Sugar"
	id = "sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255, 255, 255

	glass_icon_state = "iceglass"
	glass_name = "glass of sugar"
	glass_desc = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."

/datum/reagent/sugar/on_mob_life(var/mob/living/M as mob)
	M.nutrition += 1*REM
	..()
	return

/datum/reagent/sulfur
	name = "Sulfur"
	id = "sulfur"
	description = "A chemical element with a pungent smell."
	reagent_state = SOLID
	color = "#BF8C00" // rgb: 191, 140, 0

	custom_metabolism = 0.01
