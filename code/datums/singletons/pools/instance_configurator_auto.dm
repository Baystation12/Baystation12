/*
* An automatic instance configurator for /datum/instance_pool.
* Just add vars with names matching vars in instance_path.
* Very simple to use, but relatively expensive. Prefer bespoke configurators where reasonable.
*/

/singleton/instance_configurator/auto
	abstract_type = /singleton/instance_configurator/auto

	/// Configurable. The instance path this prototype is intended to manipulate.
	var/datum/instance_path

	/// Internal. Members of /singleton/instance_configurator/auto and below.
	var/static/list/vars_to_skip

	/// Internal. A harvested list of var names on this prototype that match var names in instance_path.
	var/list/vars_to_apply = list()


/singleton/instance_configurator/auto/Initialize()
	if (type == /singleton/instance_configurator/auto) // We are the auto prototype. Generate the skip list.
		vars_to_skip = list()
		for (var/name in vars)
			vars_to_skip += name
		return
	if (!vars_to_skip) // We are the first implementation created. Generate a new skip list as above.
		var/singleton/instance_configurator/auto/auto = new
		qdel(auto)
	var/singleton/instance = new instance_path // Check what we need to apply to.
	for (var/name in (vars - vars_to_skip))
		if (name in instance.vars)
			vars_to_apply += name
			continue
		log_error({"Invalid auto var "[name]" in [type]!"})
	qdel(instance) // And clean up.
	if (!length(vars_to_apply)) // Something went terribly wrong.
		log_error({"Invalid auto configurator [type] - failed to get any applicable vars."})
		vars_to_apply = null
	..()


/// Applies matching vars from the configurator to the instance. If you need other behavior, do not use auto.
/singleton/instance_configurator/auto/Apply(datum/instance)
	SHOULD_NOT_OVERRIDE(TRUE)
	for (var/name in vars_to_apply)
		instance.vars[name] = vars[name]
	..()
