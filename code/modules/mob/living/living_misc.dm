/**
 * Takes a +integer count, type of a /mob/living, and varargs to create instances with
 * Given a count 1, returns null or an instance of type
 * Otherwise a list of length between 0 and count of instances of type
 * Return count is dependent on config.living_limit if set for type
 */
/proc/create_living(count, mob/living/type, ...) as /list
	if (!isnum(count) || count < 1 || floor(count) != count)
		crash_with("invalid count '[count]'")
	if (!ispath(type, /mob/living) || is_abstract(type))
		crash_with("invalid type '[type]'")
	var/alist/living_limit = config?.living_limit
	var/available = living_limit?[type]
	var/single = count == 1
	if (!isnull(available))
		if (available < 1)
			if (config.living_limit_flags & config.LIVING_LIMIT_LOUD)
				log_debug({"create_living [count] [type] rejected - none available"})
			if (single)
				return
			return list()
		if (count > available)
			if (config.living_limit_flags & config.LIVING_LIMIT_LOUD)
				log_debug({"create_living [count] [type] limited - [available] available"})
			count = available
		living_limit[type] -= count
	var/list/instance_args = args.Copy(3)
	if (single)
		return new type (arglist(instance_args))
	var/list/instances = new (count)
	for (var/i = 1 to count)
		instances[i] = new type (arglist(instance_args))
	return instances


/mob/living/Destroy()
	if (~config.living_limit_flags & config.LIVING_LIMIT_SOFT)
		var/alist/living_limit = config?.living_limit
		if (!isnull(living_limit?[type]))
			living_limit[type] += 1
	return ..()


/mob/living/on_death()
	if (config.living_limit_flags & config.LIVING_LIMIT_SOFT)
		var/alist/living_limit = config?.living_limit
		if (!isnull(living_limit?[type]))
			living_limit[type] += 1
