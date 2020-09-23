#define DISPENSER_REAGENT_VALUE 0.2

/datum/reagent/acetone
	name = "Acetone"
	description = "A colorless liquid solvent used in chemical synthesis."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#808080"
	metabolism = REM * 0.2
	value = DISPENSER_REAGENT_VALUE

	dissolves_text = TRUE

	codex_lore = "<p>Acetone, or propanone, is an organic compound. It is a colourless, toxic liquid with a characteristic pungent odour.</p>"
	codex_mechanics = "<p>Acetone is a base chemical used in the creation of various compounds and medicines and is commonly found in chemical dispensers.</p>\
		<p>It is produced by Giant Armored Serpentids as a stress hormone to produce Dexalin naturally.</p>"

	toxin_immune_species = list(IS_NABBER)
	toxin_blood = 3

/datum/reagent/aluminium
	name = "Aluminium"
	taste_description = "metal"
	taste_mult = 1.1
	description = "A silvery white and ductile member of the boron group of chemical elements."
	reagent_state = SOLID
	color = "#a8a8a8"
	value = DISPENSER_REAGENT_VALUE

	codex_lore = "<p>Aluminium is a chemical element with the symbol Al and atomic number 13. It is a silvery-white, soft, non-magnetic and ductile metal in the boron group.</p>"
	codex_mechanics = "<p>Aluminium is a base chemical used in the creation of various compounds and medicines and is commonly found in chemical dispensers.</p>"

/datum/reagent/ammonia
	name = "Ammonia"
	taste_description = "mordant"
	taste_mult = 2
	description = "A caustic substance commonly used in fertilizer or household cleaners."
	reagent_state = LIQUID
	color = "#404030"
	metabolism = REM * 0.5
	overdose = 5
	value = DISPENSER_REAGENT_VALUE

	codex_lore = "<p>Ammonia is a compound of nitrogen and hydrogen. A stable binary hydride, it is a colourless substance with a characteristic pungent smell.</p>"
	codex_mechanics = "<p>Ammonia is a base chemical used in the creation of various compounds and medicines and is commonly found in chemical dispensers.</p>\
		<p>It can be used as a replacement for nitrogen by vox, and overdose for vox is 6 times the normal amount.</p>"

	toxin_immune_species = list(IS_VOX, IS_DIONA)
	toxin_blood = 1.5

/datum/reagent/ammonia/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if (alien == IS_VOX)
		M.add_chemical_effect(CE_OXYGENATED, 2)
	..()

/datum/reagent/ammonia/overdose(var/mob/living/carbon/M, var/alien)
	if(alien != IS_VOX || volume > overdose*6)
		..()

/datum/reagent/carbon
	name = "Carbon"
	description = "A chemical element, the building block of life."
	taste_description = "sour chalk"
	taste_mult = 1.5
	reagent_state = SOLID
	color = "#1c1300"
	ingest_met = REM * 5
	value = DISPENSER_REAGENT_VALUE

	codex_lore = "<p>Carbon is a chemical element with the symbol C and atomic number 6. It is nonmetallic and belongs to group 14 of the periodic table.</p>"
	codex_mechanics = "<p>Carbon is a base chemical used in the creation of various compounds and medicines and is commonly found in chemical dispensers.</p>\
		<p>When ingested as a species other than Diona, carbon can neutralize and remove other reagents from the stomach (This includes food and drink).</p>\
		<p>When splashed on the floor, it becomes dirt.</p>"

/datum/reagent/carbon/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	var/datum/reagents/ingested = M.get_ingested_reagents()
	if(ingested && ingested.reagent_list.len > 1) // Need to have at least 2 reagents - cabon and something to remove
		var/effect = 1 / (ingested.reagent_list.len - 1)
		for(var/datum/reagent/R in ingested.reagent_list)
			if(R == src)
				continue
			ingested.remove_reagent(R.type, removed * effect)

/datum/reagent/carbon/touch_turf(var/turf/T)
	if(!istype(T, /turf/space))
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, T)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(T)
			dirtoverlay.alpha = volume * 30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha + volume * 30, 255)

/datum/reagent/copper
	name = "Copper"
	description = "A highly ductile metal."
	taste_description = "copper"
	color = "#6e3b08"
	value = DISPENSER_REAGENT_VALUE

	codex_lore = "<p>Copper is a chemical element with the symbol Cu and atomic number 29. It is a soft, malleable, and ductile metal with very high thermal and electrical conductivity.</p>"
	codex_mechanics = "<p>Copper is a base chemical used in the creation of various compounds and medicines and is commonly found in chemical dispensers.</p>"

/datum/reagent/ethanol
	name = "Ethanol" //Parent class for all alcoholic reagents.
	description = "A well-known alcohol with a variety of applications."
	taste_description = "pure alcohol"
	reagent_state = LIQUID
	color = "#404030"
	alpha = 180
	touch_met = 5
	var/nutriment_factor = 0
	var/hydration_factor = 0
	var/strength = 10 // This is, essentially, units between stages - the lower, the stronger. Less fine tuning, more clarity.
	var/toxicity = 1

	var/druggy = 0
	var/adj_temp = 0
	var/targ_temp = 310
	var/halluci = 0

	glass_name = "ethanol"
	glass_desc = "A well-known alcohol with a variety of applications."
	value = DISPENSER_REAGENT_VALUE

	dissolves_text = TRUE

	codex_lore = "<p>Ethanol (ethyl alcohol, grain alcohol, drinking alcohol, spirits, or simply alcohol) is a chemical compound that is volatile, flammable, colorless, and a slight characterist odour.</p>"
	codex_mechanics = "<p>Ethanol is a base chemical used in the creation of various compounds and medicines and is commonly found in chemical dispensers.</p>"

	toxin_blood = 2
	flammable_touch_mob = 15

	vehicle_fuel_mod = 10
	vehicle_fuel_flammable = TRUE

/datum/reagent/ethanol/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjust_nutrition(nutriment_factor * removed)
	M.adjust_hydration(hydration_factor * removed)
	var/strength_mod = 1
	if(alien == IS_SKRELL)
		strength_mod *= 5
	if(alien == IS_DIONA)
		strength_mod = 0

	M.add_chemical_effect(CE_ALCOHOL, 1)
	var/effective_dose = M.chem_doses[type] * strength_mod * (1 + volume/60) //drinking a LOT will make you go down faster

	if(effective_dose >= strength) // Early warning
		M.make_dizzy(6) // It is decreased at the speed of 3 per tick
	if(effective_dose >= strength * 2) // Slurring
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		M.slurring = max(M.slurring, 30)
	if(effective_dose >= strength * 3) // Confusion - walking in random directions
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		M.confused = max(M.confused, 20)
	if(effective_dose >= strength * 4) // Blurry vision
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		M.eye_blurry = max(M.eye_blurry, 10)
	if(effective_dose >= strength * 5) // Drowsyness - periodically falling asleep
		M.add_chemical_effect(CE_PAINKILLER, 150/strength)
		M.drowsyness = max(M.drowsyness, 20)
	if(effective_dose >= strength * 6) // Toxic dose
		M.add_chemical_effect(CE_ALCOHOL_TOXIC, toxicity)
	if(effective_dose >= strength * 7) // Pass out
		M.Paralyse(20)
		M.Sleeping(30)

	if(druggy != 0)
		M.druggy = max(M.druggy, druggy)

	if(adj_temp > 0 && M.bodytemperature < targ_temp) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(targ_temp, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > targ_temp)
		M.bodytemperature = min(targ_temp, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

	if(halluci)
		M.adjust_hallucination(halluci, halluci)

/datum/reagent/hydrazine
	name = "Hydrazine"
	description = "A toxic, colorless, flammable liquid with a strong ammonia-like odor, in hydrate form."
	taste_description = "sweet tasting metal"
	reagent_state = LIQUID
	color = "#808080"
	metabolism = REM * 0.2
	touch_met = 5
	value = DISPENSER_REAGENT_VALUE

	codex_lore = "<p>Hydrazine is an inrganic compound made of nitrogen and hydrogen atoms. It is a colorless and flammable liquid with an ammonia-like odor.</p>"
	codex_mechanics = "<p>Hydrazine is a base chemical used in the creation of various compounds and medicines and is commonly found in chemical dispensers.</p>\
		<p>When splashed on the floor, it becomes liquid fuel.</p>"

	toxin_blood = 4
	toxin_touch = 0.2
	flammable_touch = 12

	vehicle_fuel_mod = 1.5
	vehicle_fuel_flammable = TRUE

/datum/reagent/hydrazine/touch_turf(var/turf/T)
	new /obj/effect/decal/cleanable/liquid_fuel(T, volume)
	remove_self(volume)
	return

/datum/reagent/iron
	name = "Iron"
	description = "Pure iron is a metal."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#353535"
	value = DISPENSER_REAGENT_VALUE

	codex_lore = "<p>Iron is a chemical element with the symbol Fe and atomic number 26. It is a metal that belongs to the first transition series and group 8 of the periodic table.</p>"
	codex_mechanics = "<p>Iron is a base chemical used in the creation of various compounds and medicines and is commonly found in chemical dispensers.</p>\
		<p>It helps to restore lost blood when ingested, except for Diona.</p>"

/datum/reagent/iron/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_BLOODRESTORE, 8 * removed)

/datum/reagent/lithium
	name = "Lithium"
	description = "A chemical element, used as antidepressant."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#808080"
	value = DISPENSER_REAGENT_VALUE

	codex_lore = "<p>Lithium is a chemical element with the symbol Li and atomic number 3. It is a soft, silvery-white alkali metal.</p>"
	codex_mechanics = "<p>Lithium is a base chemical used in the creation of various compounds and medicines and is commonly found in chemical dispensers.</p>\
		<p>It causes mild drug-like effects if ingested or injected.</p>"

/datum/reagent/lithium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		if(istype(M.loc, /turf/space))
			M.SelfMove(pick(GLOB.cardinal))
		if(prob(5))
			M.emote(pick("twitch", "drool", "moan"))

/datum/reagent/mercury
	name = "Mercury"
	description = "A chemical element."
	taste_mult = 0 //mercury apparently is tasteless. IDK
	reagent_state = LIQUID
	color = "#484848"
	value = DISPENSER_REAGENT_VALUE

	codex_lore = "<p>Mercury is a chemical element with the symbol Hg and atomic number 80. It is commonly known as quicksilver and is a heavy, silvery d-block element.</p>"
	codex_mechanics = "<p>Mercury is a base chemical used in the creation of various compounds and medicines and is commonly found in chemical dispensers.</p>\
		<p>It causes mild drug-like effects and mild brain damage if ingested or injected.</p>"

/datum/reagent/mercury/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		if(istype(M.loc, /turf/space))
			M.SelfMove(pick(GLOB.cardinal))
		if(prob(5))
			M.emote(pick("twitch", "drool", "moan"))
		M.adjustBrainLoss(0.1)

/datum/reagent/phosphorus
	name = "Phosphorus"
	description = "A chemical element, the backbone of biological energy carriers."
	taste_description = "vinegar"
	reagent_state = SOLID
	color = "#832828"
	value = DISPENSER_REAGENT_VALUE

	codex_lore = "<p>Phosphorus is a chemical element with the symbol P and atomic number 15. Phosphorus is highly reactive and can be found in white and red varieties. In minerals, phosphorus is generally found as phosphate.</p>"
	codex_mechanics = "<p>Phosphorus is a base chemical used in the creation of various compounds and medicines and is commonly found in chemical dispensers.</p>"

/datum/reagent/potassium
	name = "Potassium"
	description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.
	reagent_state = SOLID
	color = "#a0a0a0"
	value = DISPENSER_REAGENT_VALUE

	codex_lore = "<p>Potassium is a chemical element with the compound K and atomic number 19. It is a silvery-white metal that reacts violently with water.<br/>\
		Many a novice chemist has found himself with a broken chemistry dispenser after experimenting with this chemical.</p>"
	codex_mechanics = "<p>Potassium is a base chemical used in the creation of various compounds and medicines and is commonly found in chemical dispensers.</p>\
		<p>Increases heart rate with ingested or injected. Don't drink water after drinking or injecting this or you'll incur the wrath of the admins.</p>\
		<p>Potassium is produced and added to the bloodstream by the kidneys if the organ is damaged.</p>"
	codex_antag = "<p>A water-potassium grenade, while a relatively small explosion, is easy to create due to the availability of water, and low-suspicion of potassium in both research and medical.</p>"

/datum/reagent/potassium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(volume > 3)
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume > 10)
		M.add_chemical_effect(CE_PULSE, 1)

/datum/reagent/radium
	name = "Radium"
	description = "Radium is an alkaline earth metal. It is extremely radioactive."
	taste_description = "the color blue, and regret"
	reagent_state = SOLID
	color = "#c7c7c7"
	value = DISPENSER_REAGENT_VALUE

	codex_lore = "<p>Radium is a chemical element with the symbol Ra and atomic number 88. It is the sixth element in group 2 of the periodic table, also known as the alkaline earth metals. \
		Pure radium is silvery-white and is highly radioactive.</p>"
	codex_mechanics = "<p>Radium is a base chemical used in the creation of various compounds and medicines and is commonly found in chemical dispensers.</p>\
		<p>It causes radiation exposure if ingested or injected.</p>\
		<p>It can leave behind a glowing mess if splashed on the floor.</p>"

/datum/reagent/radium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.apply_damage(10 * removed, IRRADIATE, armor_pen = 100) // Radium may increase your chances to cure a disease

/datum/reagent/radium/touch_turf(var/turf/T)
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)
			return

/datum/reagent/acid
	name = "Sulphuric Acid"
	description = "A very corrosive mineral acid with the molecular formula H2SO4."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#db5008"
	metabolism = REM * 2
	touch_met = 50 // It's acid!
	var/power = 5
	var/meltdose = 10 // How much is needed to melt
	var/max_damage = 40
	value = DISPENSER_REAGENT_VALUE

	codex_lore = "<p>Sulphuric acid is a mineral acid composed of the elements sulfur, oxygen, and hydrogen. \
		It is a colourless, odourless, and viscous liquid that is soluble in water and is synthesized in reactions that are highly exothermic.</p>"
	codex_mechanics = "<p>Sulphuric acid is a base chemical used in the creation of various compounds and medicines and is commonly found in chemical dispensers.</p>\
		<p>It is used in the production of circuit boards with a circuit printer.</p>"

/datum/reagent/acid/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.take_organ_damage(0, removed * power)

/datum/reagent/acid/affect_touch(var/mob/living/carbon/M, var/alien, var/removed) // This is the most interesting
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head)
			if(H.head.unacidable)
				to_chat(H, "<span class='danger'>Your [H.head] protects you from the acid.</span>")
				remove_self(volume)
				return
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.head] melts away!</span>")
				qdel(H.head)
				H.update_inv_head(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.wear_mask)
			if(H.wear_mask.unacidable)
				to_chat(H, "<span class='danger'>Your [H.wear_mask] protects you from the acid.</span>")
				remove_self(volume)
				return
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.wear_mask] melts away!</span>")
				qdel(H.wear_mask)
				H.update_inv_wear_mask(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.glasses)
			if(H.glasses.unacidable)
				to_chat(H, "<span class='danger'>Your [H.glasses] partially protect you from the acid!</span>")
				removed /= 2
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.glasses] melt away!</span>")
				qdel(H.glasses)
				H.update_inv_glasses(1)
				removed -= meltdose / 2
		if(removed <= 0)
			return

	if(M.unacidable)
		return

	if(removed < meltdose) // Not enough to melt anything
		M.take_organ_damage(0, min(removed * power * 0.1, max_damage)) //burn damage, since it causes chemical burns. Acid doesn't make bones shatter, like brute trauma would.
	else
		M.take_organ_damage(0, min(removed * power * 0.2, max_damage))
		if(ishuman(M)) // Applies disfigurement
			var/mob/living/carbon/human/H = M
			var/screamed
			for(var/obj/item/organ/external/affecting in H.organs)
				if(!screamed && affecting.can_feel_pain())
					screamed = 1
					H.emote("scream")
				affecting.status |= ORGAN_DISFIGURED

/datum/reagent/acid/touch_obj(var/obj/O)
	if(O.unacidable)
		return
	if((istype(O, /obj/item) || istype(O, /obj/effect/vine)) && (volume > meltdose))
		var/obj/effect/decal/cleanable/molten_item/I = new/obj/effect/decal/cleanable/molten_item(O.loc)
		I.desc = "Looks like this was \an [O] some time ago."
		for(var/mob/M in viewers(5, O))
			to_chat(M, "<span class='warning'>\The [O] melts.</span>")
		qdel(O)
		remove_self(meltdose) // 10 units of acid will not melt EVERYTHING on the tile

/datum/reagent/acid/hydrochloric //Like sulfuric, but less toxic and more acidic.
	name = "Hydrochloric Acid"
	description = "A very corrosive mineral acid with the molecular formula HCl."
	taste_description = "stomach acid"
	reagent_state = LIQUID
	color = "#808080"
	power = 3
	meltdose = 8
	max_damage = 30
	value = DISPENSER_REAGENT_VALUE * 2

	codex_lore = "<p>Hydrochloric acid or muriatic acid is a colorless inorganic chemical system. It has a distinctive pungent smell. \
		It is classified as strongly acidic and can attack the skin over a wide composition range, since the hydrogen chloride completely dissociates in an aqueous solution.</p>"
	codex_mechanics = "<p>Hydrochloric acid is a base chemical used in the creation of various compounds and medicines and is commonly found in chemical dispensers.</p>"

/datum/reagent/silicon
	name = "Silicon"
	description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	reagent_state = SOLID
	color = "#a8a8a8"
	value = DISPENSER_REAGENT_VALUE

	codex_lore = "<p>Silicon is a chemical element with the symbol Si and atomic number 14. \
		It is a hard, brittle crystalline solid with a blue-grey metallic lustre, and is a tetravalent metalloid and semiconductor.</p>"
	codex_mechanics = "<p>Silicon is a base chemical used in the creation of various compounds and medicines and is commonly found in chemical dispensers.</p>"

/datum/reagent/sodium
	name = "Sodium"
	description = "A chemical element, readily reacts with water."
	taste_description = "salty metal"
	reagent_state = SOLID
	color = "#808080"
	value = DISPENSER_REAGENT_VALUE

	codex_lore = "<p>Sodium is a chemical element with the symbol Na and atomic number 11. \
		It is a soft, silvery-white, highly reactive metal. Sodium is an alkali metal, being in group 1 of the periodic table.</p>"
	codex_mechanics = "<p>Sodium is a base chemical used in the creation of various compounds and medicines and is commonly found in chemical dispensers.</p>"

/datum/reagent/sugar
	name = "Sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	taste_description = "sugar"
	taste_mult = 3
	reagent_state = SOLID
	color = "#ffffff"
	scannable = 1

	glass_name = "sugar"
	glass_desc = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	glass_icon = DRINK_ICON_NOISY
	value = DISPENSER_REAGENT_VALUE

	codex_lore = "<p>Sugar is the generic name for sweet-tasting, soluble carbohydrates, many of which are used in food.</p>"
	codex_mechanics = "<p>Sugar is a base chemical used in the creation of various compounds, medicines, food, and drink and is commonly found in chemical and drink dispensers.</p>\
		<p>It has a moderate drug-like effect if ingested or injected by Unathi.</p>"
	codex_antag = "<p>If you are a cortical borer, sugar acts like a sedative to you if your host ingests or injects it or anything that contains it, preventing you from assuming control of your host.</p>"

	sugar_factor = 1

	vehicle_fuel_explode = TRUE

/datum/reagent/sugar/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
	..()

	M.adjust_nutrition(removed * 3)

/datum/reagent/sulfur
	name = "Sulfur"
	description = "A chemical element with a pungent smell."
	taste_description = "old eggs"
	reagent_state = SOLID
	color = "#bf8c00"
	value = DISPENSER_REAGENT_VALUE

	codex_lore = "<p>Sulfur is a chemical element with the symbol S and atomic number 16. It is abundant, multivalent and nonmetallic. Elemental sulfur is a bright yellow color.</p>"
	codex_mechanics = "<p>Sulfur is a base chemical used in the creation of various compounds and medicines and is commonly found in chemical dispensers.</p>"

/datum/reagent/tungsten
	name = "Tungsten"
	description = "A chemical element, and a strong oxidising agent."
	taste_mult = 0 //no taste
	reagent_state = SOLID
	color = "#dcdcdc"
	value = DISPENSER_REAGENT_VALUE

	codex_lore = "<p>Tungsten, or wolfram, is a chemical element with the symbol W and atomic number 74. It is remarkable for it's robustness and density.</p>"
	codex_mechanics = "<p>Tungsten is a base chemical used in the creation of various compounds and is commonly found in chemical dispensers.</p>"

#undef DISPENSER_REAGENT_VALUE
