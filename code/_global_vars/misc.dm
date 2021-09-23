GLOBAL_LIST_EMPTY(all_observable_events)

GLOBAL_LIST_INIT(font_resources, list('fonts/Shage/Shage.ttf'))


// True if net rebuild will be called manually after an event.
GLOBAL_VAR_INIT(defer_powernet_rebuild, FALSE)

// Those networks can only be accessed by pre-existing terminals. AIs and new terminals can't use them.
GLOBAL_LIST_INIT(restricted_camera_networks, list(\
	NETWORK_ERT,\
	NETWORK_MERCENARY,\
	NETWORK_CRESCENT,\
	"Secret"\
))
