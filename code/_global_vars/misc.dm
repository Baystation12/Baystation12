GLOBAL_LIST_EMPTY(all_observable_events)

// True if net rebuild will be called manually after an event.
GLOBAL_VAR_INIT(defer_powernet_rebuild, FALSE)

// Those networks can only be accessed by pre-existing terminals. AIs and new terminals can't use them.
GLOBAL_LIST_INIT(restricted_camera_networks, list(\
	NETWORK_ERT,\
	NETWORK_MERCENARY,\
	NETWORK_CRESCENT,\
	"Secret"\
))

GLOBAL_VAR_INIT(stat_flags_planted, 0)

GLOBAL_VAR_INIT(stat_flora_scanned, 0)

GLOBAL_LIST_EMPTY(stat_fauna_scanned)

GLOBAL_VAR_INIT(extracted_slime_cores_amount, 0)

GLOBAL_VAR_INIT(crew_death_count, 0)
