/datum/disease2/disease
	var/infectionchance = 10
	var/speed = 1
	var/spreadtype = "Blood" // Can also be "Airborne"
	var/stage = 1
	var/stageprob = 10
	var/dead = 0
	var/clicks = 0
	var/uniqueID = 0
	var/list/datum/disease2/effectholder/effects = list()
	var/antigen = 0 // 16 bits describing the antigens, when one bit is set, a cure with that bit can dock here
	var/max_stage = 4

/datum/disease2/disease/New()
	uniqueID = rand(0,10000)
	..()

/datum/disease2/disease/proc/makerandom(var/greater=0)
	for(var/i=1 ; i <= max_stage ; i++ )
		var/datum/disease2/effectholder/holder = new /datum/disease2/effectholder
		holder.stage = i
		if(greater)
			holder.getrandomeffect(2)
		else
			holder.getrandomeffect()
		effects += holder
	uniqueID = rand(0,10000)
	infectionchance = rand(1,10)
	antigen |= text2num(pick(ANTIGENS))
	antigen |= text2num(pick(ANTIGENS))
	spreadtype = "Airborne"

/datum/disease2/disease/proc/activate(var/mob/living/carbon/mob)
	if(dead)
		cure(mob)
		mob.virus2 -= src
		return
	if(mob.stat == 2)
		return
	if(stage <= 1 && clicks == 0) 	// with a certain chance, the mob may become immune to the disease before it starts properly
		if(prob(20))
			mob.antibodies |= antigen // 20% immunity is a good chance IMO, because it allows finding an immune person easily
		else
	if(mob.radiation > 50)
		if(prob(1))
			majormutate()

	//Space antibiotics stop disease completely (temporary)
	if(mob.reagents.has_reagent("spaceacillin"))
		return

	//Virus food speeds up disease progress
	if(mob.reagents.has_reagent("virusfood"))
		mob.reagents.remove_reagent("virusfood",0.1)
		clicks += 10

	//Moving to the next stage
	if(clicks > stage*100 && prob(10))
		if(stage == max_stage)
			src.cure(mob)
			mob.antibodies |= src.antigen
			mob.virus2 -= src
			del src
		stage++
		clicks = 0
	//Do nasty effects
	for(var/datum/disease2/effectholder/e in effects)
		e.runeffect(mob,stage)

	//fever
	mob.bodytemperature += max(mob.bodytemperature, min(310+5*stage ,mob.bodytemperature+5*stage))
	clicks+=speed

/datum/disease2/disease/proc/cure(var/mob/living/carbon/mob)
	for(var/datum/disease2/effectholder/e in effects)
		e.effect.deactivate(mob)

/datum/disease2/disease/proc/minormutate()
	var/datum/disease2/effectholder/holder = pick(effects)
	holder.minormutate()
	infectionchance = min(10,infectionchance + rand(0,1))

/datum/disease2/disease/proc/majormutate()
	var/datum/disease2/effectholder/holder = pick(effects)
	holder.majormutate()

/datum/disease2/disease/proc/getcopy()
	var/datum/disease2/disease/disease = new /datum/disease2/disease
	disease.infectionchance = infectionchance
	disease.spreadtype = spreadtype
	disease.stageprob = stageprob
	disease.antigen   = antigen
	disease.uniqueID = uniqueID
	for(var/datum/disease2/effectholder/holder in effects)
		var/datum/disease2/effectholder/newholder = new /datum/disease2/effectholder
		newholder.effect = new holder.effect.type
		newholder.chance = holder.chance
		newholder.cure = holder.cure
		newholder.multiplier = holder.multiplier
		newholder.happensonce = holder.happensonce
		newholder.stage = holder.stage
		disease.effects += newholder
	return disease

/datum/disease2/disease/proc/issame(var/datum/disease2/disease/disease)
	var/list/types = list()
	var/list/types2 = list()
	for(var/datum/disease2/effectholder/d in effects)
		types += d.effect.type
	var/equal = 1

	for(var/datum/disease2/effectholder/d in disease.effects)
		types2 += d.effect.type

	for(var/type in types)
		if(!(type in types2))
			equal = 0
	return equal
