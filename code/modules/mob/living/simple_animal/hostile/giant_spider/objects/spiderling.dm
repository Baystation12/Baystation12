/// Giant spiderling type. Creates actual giant spiders.
/obj/item/spider/giant
	health_max = 8 // More air resistance, but not boot.

	var/growth_remaining

	/// The giant spider type(s) this nymph will become, as a path or (path = prob) map
	var/mob/living/simple_animal/hostile/giant_spider/spider_type = list(
		/mob/living/simple_animal/hostile/giant_spider/lurker = 0.1,
		/mob/living/simple_animal/hostile/giant_spider/tunneler = 0.08,
		/mob/living/simple_animal/hostile/giant_spider/pepper = 0.5,
		/mob/living/simple_animal/hostile/giant_spider/webslinger = 1,
		/mob/living/simple_animal/hostile/giant_spider/electric = 0.5,
		/mob/living/simple_animal/hostile/giant_spider/thermic = 0.5,
		/mob/living/simple_animal/hostile/giant_spider/frost = 0.5,
		/mob/living/simple_animal/hostile/giant_spider/carrier = 2,
		/mob/living/simple_animal/hostile/giant_spider/phorogenic = 0.01,
		/mob/living/simple_animal/hostile/giant_spider = 2,
		/mob/living/simple_animal/hostile/giant_spider/guard = 2,
		/mob/living/simple_animal/hostile/giant_spider/nurse = 2,
		/mob/living/simple_animal/hostile/giant_spider/spitter = 2,
		/mob/living/simple_animal/hostile/giant_spider/hunter = 1
	)


/obj/item/spider/giant/Initialize(mapload, atom/parent, _growth_remaining = rand(60, 120))
	. = ..()
	if (!growth_remaining)
		growth_remaining = _growth_remaining


/obj/item/spider/giant/Process(at_uptime)
	if (--growth_remaining < 1)
		if (loc)
			if (islist(spider_type))
					spider_type = pickweight(spider_type)
				new spider_type (loc, src)
		qdel(src)
		return
	else if (isorgan(loc) && growth_remaining < 10)
		var/obj/item/organ/external/organ = loc
		organ.implants -= src
		dropInto()
		return
	..()
