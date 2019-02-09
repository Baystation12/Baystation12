/datum/DMPG
	var/connected = 0
	var/libname = "./libdmpg.so"

/datum/DMPG/proc/__call(fn, ...)
	var/list/fn_args = args.Copy(2)
	. = call(libname, fn)(arglist(fn_args))

/datum/DMPG/proc/Version()
	. = __call("version")

/datum/DMPG/proc/IsConnected()
	. = __call("is_connected")

/datum/DMPG/proc/LastErr()
	. = __call("last_err")

/datum/DMPG/proc/Connect(uri)
	if (!(__call("connect", uri)))
		return LastErr()
	return 1

/datum/DMPG/proc/Query(...)
	. = call(libname, "query")(arglist(args))
	if (!.)
		return LastErr()
	. = json_decode(.)

/datum/DMPG/proc/Execute(...)
	. = call(libname, "execute")(arglist(args))
	if (!.)
		return LastErr()

/datum/DMPG/proc/Shutdown()
	. = __call("shutdown")

/datum/DMPG/Del()
	Shutdown()
	. = ..()

var/datum/DMPG/DMPG = new
