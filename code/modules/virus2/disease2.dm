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

/datum/disease2/disease/proc/makerandom(var/greater=0)
	var/datum/disease2/effectholder/holder = new /datum/disease2/effectholder
	holder.stage = 1
	if(greater)
		holder.getrandomeffect_greater()
	else
		holder.getrandomeffect_lesser()
	effects += holder
	holder = new /datum/disease2/effectholder
	holder.stage = 2
	if(greater)
		holder.getrandomeffect_greater()
	else
		holder.getrandomeffect_lesser()
	effects += holder
	holder = new /datum/disease2/effectholder
	holder.stage = 3
	if(greater)
		holder.getrandomeffect_greater()
	else
		holder.getrandomeffect_lesser()
	effects += holder
	holder = new /datum/disease2/effectholder
	holder.stage = 4
	if(greater)
		holder.getrandomeffect_greater()
	else
		holder.getrandomeffect_lesser()
	effects += holder
	uniqueID = rand(0,10000)
	infectionchance = rand(1,10)
	// pick 2 antigens
	antigen |= text2num(pick(ANTIGENS))
	antigen |= text2num(pick(ANTIGENS))
	spreadtype = "Airborne"

/datum/disease2/disease/proc/activate(var/mob/living/carbon/mob)
	if(dead)
		cure(mob)
		mob.virus2 = null
		return
	if(mob.stat == 2)
		return
	// with a certain chance, the mob may become immune to the disease before it starts properly
	if(stage <= 1 && clicks == 0)
		if(prob(20))
			mob.antibodies |= antigen // 20% immunity is a good chance IMO, because it allows finding an immune person easily
		else
	if(mob.radiation > 50)
		if(prob(1))
			majormutate()
	if(mob.reagents.has_reagent("spaceacillin"))
		return
	if(mob.reagents.has_reagent("virusfood"))
		mob.reagents.remove_reagent("virusfood",0.1)
		clicks += 10
	if(clicks > stage*100 && prob(10))
		if(stage == 4)
			src.cure(mob)
			mob.antibodies |= src.antigen
			mob.virus2 = null
			del src
		stage++
		clicks = 0
	for(var/datum/disease2/effectholder/e in effects)
		e.runeffect(mob,stage)
	clicks+=speed

/datum/disease2/disease/proc/cure(var/mob/living/carbon/mob)
	var/datum/disease2/effectholder/E
	if(stage>1)
		E = effects[1]
		E.effect.deactivate(mob)
	if(stage>2)
		E = effects[2]
		E.effect.deactivate(mob)
	if(stage>3)
		E = effects[3]
		E.effect.deactivate(mob)
	if(stage>4)
		E = effects[4]
		E.effect.deactivate(mob)

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
