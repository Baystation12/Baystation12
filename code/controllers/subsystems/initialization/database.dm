SUBSYSTEM_DEF(database)
    name = "Database"
    init_order = SS_INIT_DB
    flags = SS_NO_FIRE

    var/datum/database/db

/datum/controller/subsystem/database/PreInit()
    //FIXME blah
    . = ..()

/datum/controller/subsystem/database/stat_entry()
    ..(db.Connected() ? "connected" : "not connected")