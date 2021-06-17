/datum/graph
	var/list/nodes
	var/list/edges

	var/list/pending_connections
	var/list/pending_disconnections

	var/processing

/datum/graph/New(var/list/nodes, var/list/edges, var/previous_owner = null)
	if(!length(nodes))
		CRASH("Invalid list of nodes: [log_info_line(nodes)]")
	if(length(nodes) > 1 && !istype(edges))
		CRASH("Invalid list of edges: [log_info_line(edges)]")
	for(var/n in nodes)
		var/datum/node/node = n
		if(node.graph && node.graph != previous_owner)
			CRASH("Attempted to add a node already belonging to a network")

	// TODO: Check that all edges refer to nodes in the graph and that the graph is coherent

	..()
	src.nodes = nodes
	src.edges = edges || list()

	for(var/n in nodes)
		var/datum/node/node = n
		node.graph = src

/datum/graph/Destroy()
	if(length(nodes) || LAZYLEN(pending_connections) || LAZYLEN(pending_disconnections))
		crash_with("Prevented attempt to delete a network that still has nodes: [length(nodes)] - [LAZYLEN(pending_connections)] - [LAZYLEN(pending_disconnections)]")
		return QDEL_HINT_LETMELIVE
	. = ..()

/datum/graph/proc/Connect(var/datum/node/node, var/list/neighbours, var/queue = TRUE)
	if(!istype(neighbours))
		neighbours = list(neighbours)
	if(!length(neighbours))
		CRASH("Attempted to connect a node without declaring neighbours")
	if(length(nodes & neighbours) != length(neighbours))
		CRASH("Attempted to connect a node to neighbours not in the graph")
	if(LAZYISIN(pending_connections, node))
		CRASH("Attempted to connect a node already pending to be connected")
	if(LAZYISIN(pending_disconnections, node))
		CRASH("Attempted to connect a node already pending to be disconnected")

	LAZYSET(pending_connections, node, neighbours)
	if(queue)
		SSgraphs_update.Queue(src)
	return TRUE

/datum/graph/proc/Disconnect(var/datum/node/node, var/list/neighbours_to_disconnect, var/queue = TRUE)
	if(neighbours_to_disconnect && !istype(neighbours_to_disconnect))
		neighbours_to_disconnect = list(neighbours_to_disconnect)
	if(length(neighbours_to_disconnect) && length(nodes & neighbours_to_disconnect) != length(neighbours_to_disconnect))
		CRASH("Attempted keep a node connected to neighbours not in the graph: [json_encode(nodes)], [json_encode(neighbours_to_disconnect)]")
	if(LAZYISIN(pending_connections, node))
		CRASH("Attempted to disconnect a node already pending to be connected")
	if(LAZYISIN(pending_disconnections, node))
		CRASH("Attempted to disconnect a node already pending to be disconnected")
	if(!(node in nodes))
		CRASH("Attempted disconnect a node that is not in the graph")

	LAZYSET(pending_disconnections, node, neighbours_to_disconnect)
	if(queue)
		SSgraphs_update.Queue(src)
	return TRUE

/datum/graph/proc/Merge(var/datum/graph/other)
	if(!other)
		return

	OnMerge(other)
	for(var/n in other.nodes)
		var/datum/node/node = n
		node.graph = src
	nodes += other.nodes
	edges += other.edges

	for(var/other_node_to_be_connected in other.pending_connections)
		var/other_neighbours = other.pending_connections[other_node_to_be_connected]
		Connect(other_node_to_be_connected, other_neighbours, FALSE)
	for(var/other_node_to_be_disconnected in other.pending_disconnections)
		var/other_formed_neighbours = other.pending_disconnections[other_node_to_be_disconnected]
		Disconnect(other_node_to_be_disconnected, other_formed_neighbours, FALSE)

	other.nodes.Cut()
	other.edges.Cut()
	LAZYCLEARLIST(other.pending_connections)
	LAZYCLEARLIST(other.pending_disconnections)
	qdel(other)

// Subtypes that need to handle merging in specific ways should override this proc
/datum/graph/proc/OnMerge(var/datum/graph/other)
	return

// Here subgraphs is a list of a list of nodes
/datum/graph/proc/Split(var/list/subgraphs)
	var/list/new_subgraphs = list()
	for(var/subgraph in subgraphs)
		if(length(subgraph) == 1)
			var/datum/node/N = subgraph[1] // Doing QDELETED(subgraph[1]) will result in multiple list index calls
			if(QDELETED(N))
				continue
		new_subgraphs += new type(subgraph, edges & subgraph, src)

	OnSplit(new_subgraphs)
	nodes.Cut()
	edges.Cut()
	qdel(src)

// Here subgraphs is a list of a list graphs (with their own lists of nodes and edges)
// Subtypes that need to handle splitting in specific ways should override this proc
// The original graph still has the same nodes/edges as before the split but will be deleted after this proc returns
/datum/graph/proc/OnSplit(var/list/datum/graph/subgraphs)
	return

/datum/graph/proc/ProcessPendingConnections()
	while(LAZYLEN(pending_connections))
		var/datum/node/N = pending_connections[pending_connections.len]
		var/list/new_neighbours = pending_connections[N]
		pending_connections.len--

		if(N.graph != src)
			Merge(N.graph)
		nodes |= N

		if(N in edges)
			edges[N] |= new_neighbours
		else
			edges[N] = new_neighbours

		for(var/new_neighbour in new_neighbours)
			var/neighbour_edges = edges[new_neighbour]
			if(!neighbour_edges)
				neighbour_edges = list()
				edges[new_neighbour] = neighbour_edges
			neighbour_edges |= N

	if(!LAZYLEN(pending_disconnections))
		return

	for(var/pending_node_disconnect in pending_disconnections)
		var/pending_edge_disconnects = pending_disconnections[pending_node_disconnect] || edges[pending_node_disconnect]
		for(var/connected_node in pending_edge_disconnects)
			edges[connected_node] -= pending_node_disconnect
			if(!length(edges[connected_node]))
				edges -= connected_node

		edges[pending_node_disconnect] -= pending_edge_disconnects
		if(!length(edges[pending_node_disconnect]))
			edges -= pending_node_disconnect
	LAZYCLEARLIST(pending_disconnections)

	var/list/subgraphs = list()
	var/list/all_nodes = nodes.Copy()
	while(length(all_nodes))
		var/root_node = all_nodes[all_nodes.len]
		all_nodes.len--
		var/checked_nodes = list()
		var/list/nodes_to_traverse = list(root_node)
		while(length(nodes_to_traverse))
			var/node_to_check = nodes_to_traverse[nodes_to_traverse.len]
			nodes_to_traverse.len--
			checked_nodes += node_to_check
			nodes_to_traverse |= ((edges[node_to_check] || list()) - checked_nodes)
		all_nodes -= checked_nodes
		subgraphs[++subgraphs.len] = checked_nodes

	if(length(subgraphs) == 1)
		return
	Split(subgraphs)

/datum/graph/get_log_info_line()
	return "[..()] (nodes: [log_info_line(nodes)]) (edges: [log_info_line(edges)])"
