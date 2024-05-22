/**
** Callbacks
Callbacks wrap a target, callable, and arguments to pass. See the dm reference for call().
When the target is GLOBAL_PROC, the callable is global - otherwise it is a datum (or dead) reference.
Callbacks are created with the new keyword via a global alias like:
- var/datum/callback/instance = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(get_area), someObject)
Callbacks are thin - they should be used with invoke or invoke_async.

** Invocation
invoke and invoke_async call a callable against a target with optional params. They accept either:
invoke(target, callable, params...)
or invoke(<callback>, extra params...)
and return the result of calling those. invoke_async does not wait for an outcome and will return (.)
on the first sleep, and so should be used only where results are not required.

** Callables
Callables are proc names or proc references, with references preferred for safety (in most cases).
These vary between 515 and older major versions:
Before 515:
- PROC_REF(name refers to the last override of name on target, OR the global proc name.
After 515:
- src::name() must be used for the last override, or ::name() for the global.
- nameof() is available at compile time to resolve safe proc names like nameof(/datum::fooBehavior()).
  This can be preferable to direct refs in complex cases.
A specific version of a proc may be called by fully specifying its type depth, like
invoke(myLivingMob, TYPE_PROC_REF(/mob/living, handle_vision)

** Timers
Timers accept callbacks as their first argument. For full timer documentation, see the timedevent
datum. For example:
addTimer(CALLBACK(myMob, proc_ref(drop_l_hand())), 10 SECONDS)
*/

var/global/const/GLOBAL_PROC = FALSE

var/global/const/Callback = /datum/callback


/datum/callback
	//var/const/Global = FALSE //515 - GLOBAL_PROC becomes Callback::Global
	var/identity
	var/datum/target = GLOBAL_PROC
	var/callable
	var/list/params


/datum/callback/Destroy()
	target = null
	callable = null
	LAZYCLEARLIST(params)
	return ..()


/datum/callback/New(datum/target, callable, ...)
	src.target = target
	src.callable = callable
	if (length(args) > 2)
		params = args.Copy(3)
	switch (target)
		if (null)
			identity = "(null) [callable]"
		if (FALSE)
			identity = "(global) [callable]"
		else
			identity = "([target.type] \ref[target]) [callable]"


/proc/invoke(datum/callback/target, callable, ...)
	if (target == GLOBAL_PROC)
		var/list/params
		if (length(args) > 2)
			params = args.Copy(3)
		return call(callable)(arglist(params))
	else if (QDELETED(target))
		return
	else if (istype(target))
		var/list/params = list(target.target, target.callable)
		if (LAZYLEN(target.params))
			params += target.params
		if (length(args) > 1)
			params += args.Copy(2)
		return invoke(arglist(params))
	else
		var/list/params
		if (length(args) > 2)
			params = args.Copy(3)
		return call(target, callable)(arglist(params))


/proc/invoke_async(datum/callback/target, callable, ...)
	set waitfor = FALSE
	if (target == GLOBAL_PROC)
		var/list/params
		if (length(args) > 2)
			params = args.Copy(3)
		return call(callable)(arglist(params))
	else if (QDELETED(target))
		return
	else if (istype(target))
		var/list/params = list(target.target, target.callable) + target.params
		if (length(args) > 1)
			params += args.Copy(2)
		return invoke(arglist(params))
	else
		var/list/params
		if (length(args) > 2)
			params = args.Copy(3)
		return call(target, callable)(arglist(params))
