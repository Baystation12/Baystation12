/*
* Configures instances from /singleton/instance_pool for use.
*/

/singleton/instance_configurator
	abstract_type = /singleton/instance_configurator


/// Set up instance for use.
/singleton/instance_configurator/proc/Apply(datum/instance)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	instance.instance_configurator = src
	return


/// Clean up instance after use.
/singleton/instance_configurator/proc/Clear(datum/instance)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	instance.instance_configurator = null
	return
