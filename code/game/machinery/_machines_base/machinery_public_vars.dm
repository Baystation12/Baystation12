/decl/public_access
	var/name
	var/desc

/decl/public_access/public_variable
	var/expected_type
	var/can_write = FALSE
	var/var_type = IC_FORMAT_BOOLEAN // Reuses IC defines for better compatibility.

	var/has_updates = FALSE          // Can register listeners for updates on change.
	var/list/listeners = list()

/*
Must be implemented by subtypes.
*/

// Reads off the var value and returns it
/decl/public_access/public_variable/proc/access_var(datum/owner)

// Writes to the var. Returns true if change occured, false otherwise.
// Subtypes shall call parent, and perform the actual write if the return value is true.
// If the var has_updates, you must never modify the var except through this proc.
/decl/public_access/public_variable/proc/write_var(datum/owner, new_value)
	var/old_value = access_var(owner)
	if(old_value == new_value)
		return FALSE
	if(has_updates)
		var_changed(owner, old_value, new_value)
	return TRUE

// Any sanitization should be done in here.
/decl/public_access/public_variable/proc/write_var_protected(datum/owner, new_value)
	if(!can_write)
		return FALSE
	write_var(owner, new_value)

/*
Listener registration. You must unregister yourself if you are destroyed; the owner being destroyed will be handled automatically.
*/

/decl/public_access/public_variable/proc/register_listener(datum/listener, datum/owner, registered_proc)
	. = FALSE
	if(!istype(owner, expected_type))
		CRASH("[log_info_line(listener)] attempted to register for the public variable [type], but passed an invalid owner of type [owner.type].")
	if(!has_updates)
		return // Can try and register, but updates aren't coming
	if(!listeners[owner])
		listeners[owner] = list()
		GLOB.destroyed_event.register(owner, src, .proc/owner_destroyed)
	LAZYADD(listeners[owner][listener], registered_proc)
	return TRUE

/decl/public_access/public_variable/proc/unregister_listener(datum/listener, datum/owner, registered_proc)
	if(!listeners[owner])
		return
	if(!listeners[owner][listener])
		return

	if(registered_proc) // Remove the proc and remove the listener if no more procs
		listeners[owner][listener] -= registered_proc
		if(!length(listeners[owner][listener]))
			listeners[owner] -= listener
	else // Remove the listener
		listeners[owner] -= listener

	if(!length(listeners[owner])) // Clean up the list if no longer listening to anything.
		listeners -= owner
		GLOB.destroyed_event.unregister(owner, src)

/*
Internal procs. Do not modify.
*/

/decl/public_access/public_variable/proc/owner_destroyed(datum/owner)
	GLOB.destroyed_event.unregister(owner, src)
	listeners -= owner

/decl/public_access/public_variable/proc/var_changed(owner, old_value, new_value)
	var/list/to_alert = listeners[owner]
	for(var/thing in to_alert)
		for(var/call_proc in to_alert[thing])
			call(thing, call_proc)(src, owner, old_value, new_value)

/*
Public methods machines can expose. Pretty bare-bones; just wraps a proc and gives it a name for UI purposes.
*/

/decl/public_access/public_method
	var/call_proc
	var/forward_args = FALSE

/decl/public_access/public_method/proc/perform(datum/owner, ...)
	if(forward_args)
		call(owner, call_proc)(arglist(args.Copy(2)))
	else
		call(owner, call_proc)()

/*
Machinery implementation
*/

/// List of all registered `public_variable` decls.
/obj/machinery/var/list/public_variables
/// List of all registered `public_method` decls.
/obj/machinery/var/list/public_methods

/obj/machinery/Initialize()
	for(var/path in public_variables)
		public_variables[path] = decls_repository.get_decl(path)
	for(var/path in public_methods)
		public_methods[path] = decls_repository.get_decl(path)
	. = ..()
