SUBSYSTEM_DEF(graphs_update)
	name = "Graphs (Update)"
	priority = SS_PRIORITY_GRAPH
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 1

	var/list/pending_graphs
	var/list/current_run

/datum/controller/subsystem/graphs_update/Initialize(start_uptime)
	pending_graphs = list()


/datum/controller/subsystem/graphs_update/UpdateStat(time)
	return


/datum/controller/subsystem/graphs_update/proc/Queue(var/datum/graph/graph)
	pending_graphs |= graph
	wake()

/datum/controller/subsystem/graphs_update/fire(resumed = 0)
	if (!resumed)
		src.current_run = pending_graphs.Copy()
		pending_graphs.Cut()

	var/list/current_run = src.current_run
	while(current_run.len)
		var/datum/graph/G = current_run[current_run.len]
		current_run.len--
		if(!QDELETED(G))
			G.ProcessPendingConnections()
		if (MC_TICK_CHECK)
			return

	if(!length(pending_graphs))
		suspend()

/datum/controller/subsystem/graphs_update/Recover(var/datum/controller/subsystem/graphs_update/GU)
	pending_graphs = GU.pending_graphs
