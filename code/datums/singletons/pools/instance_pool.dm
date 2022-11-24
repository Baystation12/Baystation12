/singleton/instance_pool
	abstract_type = /singleton/instance_pool

	/// Configurable. A field of the constants below.
	var/instance_pool_flags = EMPTY_BITFIELD

	var/const/CALL_ON_RETURN = FLAG(0)
	var/const/CALL_ON_GET = FLAG(1)

	/// Configurable. Path. The path of the instances this pool manages.
	var/datum/instance_path

	/// Configurable. Natural. The maximum number of instances this pool will retain.
	var/pool_size

	/// Configurable. List of paths. If set, becomes (path => instance).
	var/list/singleton/instance_configurator/configurators

	///Internal. A fixed size sparse list of instances ready to be checked out.
	var/list/datum/available_instances

	///Internal. The index to check out next. If 0, we start creating new ones.
	var/next_instance


/singleton/instance_pool/Initialize()
	available_instances = new (pool_size)
	for (var/i = 1 to pool_size)
		available_instances[i] = new instance_path
		available_instances[i].instance_pool = src
	if (configurators)
		configurators = Singletons.GetMap(configurators)
	next_instance = pool_size
	..()


/// Sealed. Re-add instance to the pool if it's not full. Only one use, below, in datum/Destroy.
/singleton/instance_pool/proc/ReturnInstance(datum/instance)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if (next_instance < pool_size)
		available_instances[++next_instance] = instance
		instance.instance_configurator?.Clear(instance)
		if (instance_pool_flags & CALL_ON_RETURN)
			OnReturnInstance(instance)
		return TRUE


/// Virtual. Manipulate a newly returned instance in a common way, such as to clean it of timers.
/singleton/instance_pool/proc/OnReturnInstance(datum/instance)
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	return


/// Sealed. Get an instance from the pool, creating a new one if needed, applying configurator if supplied.
/singleton/instance_pool/proc/GetInstance(singleton/instance_configurator/configurator)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/datum/instance
	if (next_instance)
		instance = available_instances[next_instance]
		available_instances[next_instance--] = null
	else
		instance = new instance_path
		instance.instance_pool = src
	if (configurator)
		configurators[configurator].Apply(instance)
	if (instance_pool_flags & CALL_ON_GET)
		OnGetInstance(instance)
	return instance


/// Virtual. Manipulate a newly checked out instance in a common way.
/singleton/instance_pool/proc/OnGetInstance(datum/instance)
	PROTECTED_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	return
