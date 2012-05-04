/obj/effect/proc_holder/spell/aoe_turf/conjure
	name = "Conjure"
	desc = "This spell conjures objs of the specified types in range."

	var/list/summon_type = list() //determines what exactly will be summoned
	//should be text, like list("/obj/machinery/bot/ed209")

	var/summon_lifespan = 0 // 0=permanent, any other time in deciseconds
	var/summon_amt = 1 //amount of objects summoned
	var/summon_ignore_density = 0 //if set to 1, adds dense tiles to possible spawn places
	var/summon_ignore_prev_spawn_points = 0 //if set to 1, each new object is summoned on a new spawn point

	var/list/newVars = list() //vars of the summoned objects will be replaced with those where they meet
	//should have format of list("emagged" = 1,"name" = "Wizard's Justicebot"), for example

/obj/effect/proc_holder/spell/aoe_turf/conjure/cast(list/targets)

	for(var/turf/T in targets)
		if(T.density && !summon_ignore_density)
			targets -= T

	for(var/i=0,i<summon_amt,i++)
		if(!targets.len)
			break
		var/summoned_object_type = text2path(pick(summon_type))
		var/spawn_place = pick(targets)
		if(summon_ignore_prev_spawn_points)
			targets -= spawn_place
		var/atom/summoned_object = new summoned_object_type(spawn_place)

		for(var/varName in newVars)
			if(varName in summoned_object.vars)
				summoned_object.vars[varName] = newVars[varName]

		if(summon_lifespan)
			spawn(summon_lifespan)
				if(summoned_object)
					del(summoned_object)

	return

/obj/effect/proc_holder/spell/aoe_turf/conjure/summonEdSwarm //test purposes
	name = "Dispense Wizard Justice"
	desc = "This spell dispenses wizard justice."

	summon_type = list("/obj/machinery/bot/ed209")
	summon_amt = 10
	range = 3
	newVars = list("emagged" = 1,"name" = "Wizard's Justicebot")