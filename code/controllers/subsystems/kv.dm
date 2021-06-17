
SUBSYSTEM_DEF(kv)
	name = "KV Store"
	wait = 30 SECONDS
	priority = SS_PRIORITY_KV
	flags = SS_NO_INIT | SS_BACKGROUND

	var/list/store = list()
	var/checking = 0

/datum/controller/subsystem/kv/Recover()
	store = SSkv.store

/datum/controller/subsystem/kv/fire(resumed = FALSE)
	if (!checking)
		checking = length(store)
	if (checking)
		for (var/i = checking, i > 0, --i)
			var/weakref/W = store[i]
			var/datum/instance = W.resolve()
			if (QDELETED(instance))
				store.Cut(i, i + 1)
			if (MC_TICK_CHECK)
				checking = i - 1
				return
		checking = 0

/datum/controller/subsystem/kv/proc/Put(datum/instance, key, value)
	var/W = weakref(instance)
	if (!W)
		return FALSE
	var/pool = store[W]
	if (!pool)
		pool = store[W] = list()
	pool[key] = value
	return TRUE

/datum/controller/subsystem/kv/proc/Get(datum/instance, key)
	var/W = weakref(instance)
	if (!W)
		return
	var/pool = store[W]
	if (pool)
		return pool[key]
