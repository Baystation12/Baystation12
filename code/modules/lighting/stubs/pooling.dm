/proc/returnToPool(thing)
	qdel(thing)

/proc/getFromPool(type)
	var/list/new_args = args.Copy(2)
	return new type(arglist(new_args))
