SUBSYSTEM_DEF(graphs)
	name = "Graphs"
	priority = SS_PRIORITY_GRAPH
	flags = SS_KEEP_TIMING | SS_NO_INIT
	wait = 1

	/// A list of graphs pending update.
	var/static/list/datum/graph/pending_graphs = list()

	/// The current run of graphs to update.
	var/static/list/datum/graph/queue = list()


/datum/controller/subsystem/graphs/Recover()
	queue.Cut()


/datum/controller/subsystem/graphs/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("Queue: [length(queue)]")


/datum/controller/subsystem/graphs/proc/Queue(datum/graph/graph)
	pending_graphs |= graph


/datum/controller/subsystem/graphs/fire(resumed, no_mc_tick)
	if (!resumed)
		if (!length(pending_graphs))
			return
		queue = pending_graphs.Copy()
	var/cut_until = 1
	for (var/datum/graph/graph as anything in queue)
		++cut_until
		pending_graphs -= graph
		if (QDELETED(graph))
			continue
		graph.ProcessPendingConnections()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	queue.Cut()
