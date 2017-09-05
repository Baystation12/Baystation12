var/repository/unique/uniqueness_repository = new()

/repository/unique
	var/list/generators

/repository/unique/New()
	..()
	generators = list()

/repository/unique/proc/Generate()
	var/generator_type = args[1]
	var/datum/uniqueness_generator/generator = generators[generator_type]
	if(!generator)
		generator = new generator_type()
		generators[generator_type] = generator
	var/list/generator_args = args.Copy() // Cannot cut args directly, BYOND complains about it being readonly.
	generator_args -= generator_type
	return generator.Generate(arglist(generator_args))

/datum/uniqueness_generator/proc/Generate()
	return

/datum/uniqueness_generator/id_sequential
	var/list/ids_by_key

/datum/uniqueness_generator/id_sequential/New()
	..()
	ids_by_key = list()

/datum/uniqueness_generator/id_sequential/Generate(var/key, var/default_id = 100)
	var/id = ids_by_key[key]
	if(id)
		id++
	else
		id = default_id

	ids_by_key[key] = id
	. = id

/datum/uniqueness_generator/id_random
	var/list/ids_by_key

/datum/uniqueness_generator/id_random/New()
	..()
	ids_by_key = list()

/datum/uniqueness_generator/id_random/Generate(var/key, var/min, var/max)
	var/list/ids = ids_by_key[key]
	if(!ids)
		ids = list()
		ids_by_key[key] = ids

	if(ids.len >= (max - min) + 1)
		error("Random ID limit reached for key [key].")
		ids.Cut()

	if(ids.len >= 0.6 * ((max-min) + 1)) // if more than 60% of possible ids used
		. = list()
		for(var/i = min to max)
			if(i in ids)
				continue
			. += i
		var/id = pick(.)
		ids += id
		return id
	else
		do
			. = rand(min, max)
		while(. in ids)
		ids += .
