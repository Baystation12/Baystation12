// this proc will only work with DEBUG enabled
#ifdef DEBUG
/hook/roundend/proc/send_runtimes_to_ircbot()
	if(!revdata.revision) return // we can't do much useful if we don't know what we are
	var/list/errors = list()
	for(var/erruid in error_cache.error_sources)
		var/datum/ErrorViewer/ErrorSource/e = error_cache.error_sources[erruid]
		var/datum/ErrorViewer/ErrorEntry/err = e.errors[1]

		var/data = list(
			id = erruid,
			name = err.info_name,
			info = err.info
		)

		errors[++errors.len] = list2params(data)

	runtimes2irc(list2params(errors), revdata.revision)

	return 1
#endif


