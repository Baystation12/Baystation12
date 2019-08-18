/********
* Tests *
********/
/datum/unit_test/graph_test/simple_merge
	name = "GRAPH: Shall be able to merge simple graphs"

/datum/unit_test/graph_test/simple_merge/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")

	var/datum/graph/testing/graphA = new(list(nodeA), name = "Graph A")
	var/datum/graph/testing/graphB = new(list(nodeB), name = "Graph B")
	graphs += graphA
	graphs += graphB

	var/expected_nodes = list(nodeA, nodeB)
	var/expected_edges = list() // If one initialize using list(nodeA = list(nodeB)) it becomes list("nodeA" = list(nodeB)) which breaks things
	expected_edges[nodeA] = list(nodeB)
	expected_edges[nodeB] = list(nodeA)

	graphA.on_check_expectations = new/datum/graph_expectation(expected_nodes, expected_edges)
	graphB.on_check_expectations = new/datum/graph_expectation/deleted()

	graphA.Connect(nodeB, nodeA)
	return TRUE


/datum/unit_test/graph_test/simple_split
	name = "GRAPH: Shall be able to split a simple graph"

/datum/unit_test/graph_test/simple_split/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")

	var/edges = list()
	edges[nodeA] = list(nodeB)
	edges[nodeB] = list(nodeA)
	var/datum/graph/testing/graph = new(list(nodeA, nodeB), edges)
	graph.split_expectations = list(new/datum/graph_expectation(list(nodeA)), new/datum/graph_expectation(list(nodeB)))

	graphs += graph

	graph.Disconnect(nodeB)
	return TRUE


/datum/unit_test/graph_test/deletion_split
	name = "GRAPH: Shall be able to handle node deletion"

/datum/unit_test/graph_test/deletion_split/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")
	var/datum/node/test/nodeC = new("Node C")

	var/edges = list()
	edges[nodeA] = list(nodeB)
	edges[nodeB] = list(nodeA, nodeC)
	edges[nodeC] = list(nodeB)
	var/datum/graph/testing/graph = new(list(nodeA, nodeB, nodeC), edges)
	graph.split_expectations = list(new/datum/graph_expectation(list(nodeA)), new/datum/graph_expectation(list(nodeC)))

	graphs += graph
	qdel(nodeB)
	return TRUE


/datum/unit_test/graph_test/self_connect
	name = "GRAPH: Shall be able to connect to self"

/datum/unit_test/graph_test/self_connect/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")
	var/datum/node/test/nodeC = new("Node C")

	var/edges = list()
	edges[nodeA] = list(nodeB)
	edges[nodeB] = list(nodeA, nodeC)
	edges[nodeC] = list(nodeB)
	var/datum/graph/testing/graph = new(list(nodeA, nodeB, nodeC), edges)
	graphs += graph

	var/expected_edges = list()
	expected_edges[nodeA] = list(nodeB, nodeC)
	expected_edges[nodeB] = list(nodeA, nodeC)
	expected_edges[nodeC] = list(nodeB, nodeA)
	graph.on_check_expectations = new/datum/graph_expectation(list(nodeA, nodeB, nodeC), expected_edges)

	graph.Connect(nodeC, nodeA)

	return TRUE


/datum/unit_test/graph_test/partial_disconnect
	name = "GRAPH: Shall be able to handle a partial disconnect"

/datum/unit_test/graph_test/partial_disconnect/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")
	var/datum/node/test/nodeC = new("Node C")

	var/edges = list()
	edges[nodeA] = list(nodeB)
	edges[nodeB] = list(nodeA, nodeC)
	edges[nodeC] = list(nodeB)
	var/datum/graph/testing/graph = new(list(nodeA, nodeB, nodeC), edges)

	var/expected_edges = list()
	expected_edges[nodeA] = list(nodeB)
	expected_edges[nodeB] = list(nodeA)

	graph.split_expectations = list(new/datum/graph_expectation(list(nodeA, nodeB), expected_edges), new/datum/graph_expectation(list(nodeC)))
	graphs += graph

	graph.Disconnect(nodeB, nodeC)
	return TRUE


/datum/unit_test/graph_test/full_disconnect
	name = "GRAPH: Shall be able to handle a full disconnect"

/datum/unit_test/graph_test/full_disconnect/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")
	var/datum/node/test/nodeC = new("Node C")

	var/edges = list()
	edges[nodeA] = list(nodeB)
	edges[nodeB] = list(nodeA, nodeC)
	edges[nodeC] = list(nodeB)
	var/datum/graph/testing/graph = new(list(nodeA, nodeB, nodeC), edges)

	graph.split_expectations = list(new/datum/graph_expectation(list(nodeA)), new/datum/graph_expectation(list(nodeB)), new/datum/graph_expectation(list(nodeC)))
	graphs += graph

	graph.Disconnect(nodeB)
	return TRUE


/datum/unit_test/graph_test/connected_graph_full_disconnect
	name = "GRAPH: Shall be able to handle a full disconnect in a connected graph"

/datum/unit_test/graph_test/connected_graph_full_disconnect/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")
	var/datum/node/test/nodeC = new("Node C")

	var/edges = list()
	edges[nodeA] = list(nodeB, nodeC)
	edges[nodeB] = list(nodeA, nodeC)
	edges[nodeC] = list(nodeA, nodeB)
	var/datum/graph/testing/graph = new(list(nodeA, nodeB, nodeC), edges)
	graphs += graph

	var/expected_edges = list()
	expected_edges[nodeA] = list(nodeC)
	expected_edges[nodeC] = list(nodeA)
	graph.split_expectations = list(new/datum/graph_expectation(list(nodeA, nodeC), expected_edges), new/datum/graph_expectation(list(nodeB)))

	graph.Disconnect(nodeB)
	return TRUE


/datum/unit_test/graph_test/connected_graph_partial_disconnect
	name = "GRAPH: Shall be able to handle a partial disconnect in a connected graph"

/datum/unit_test/graph_test/connected_graph_partial_disconnect/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")
	var/datum/node/test/nodeC = new("Node C")

	var/edges = list()
	edges[nodeA] = list(nodeB, nodeC)
	edges[nodeB] = list(nodeA, nodeC)
	edges[nodeC] = list(nodeA, nodeB)
	var/datum/graph/testing/graph = new(list(nodeA, nodeB, nodeC), edges)
	graphs += graph

	var/expected_edges = list()
	expected_edges[nodeA] = list(nodeB, nodeC)
	expected_edges[nodeB] = list(nodeA)
	expected_edges[nodeC] = list(nodeA)
	graph.on_check_expectations = new/datum/graph_expectation(list(nodeA, nodeB, nodeC), expected_edges)

	graph.Disconnect(nodeB, nodeC)
	return TRUE

/datum/unit_test/graph_test/adjacent_disconnects
	name = "GRAPH: Shall be able to handle adjacent disconnects"

/datum/unit_test/graph_test/adjacent_disconnects/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B")
	var/datum/node/test/nodeC = new("Node C")
	var/datum/node/test/nodeD = new("Node D")

	var/edges = list()
	edges[nodeA] = list(nodeB)
	edges[nodeB] = list(nodeA, nodeC)
	edges[nodeC] = list(nodeB, nodeD)
	edges[nodeD] = list(nodeC)

	var/datum/graph/testing/graph = new(list(nodeA, nodeB, nodeC, nodeD), edges)
	graphs += graph

	graph.split_expectations = list(new/datum/graph_expectation(list(nodeA)), new/datum/graph_expectation(list(nodeD)))

	qdel(nodeB)
	qdel(nodeC)
	return TRUE

/datum/unit_test/graph_test/multiple_disconnects
	name = "GRAPH: Shall be able to handle multiple disconnects"

/datum/unit_test/graph_test/multiple_disconnects/start_test()
	var/datum/node/test/nodeA = new("Node A")
	var/datum/node/test/nodeB = new("Node B") // Disconnects only from A
	var/datum/node/test/nodeC = new("Node C")
	var/datum/node/test/nodeD = new("Node D") // Disconnects from C and E
	var/datum/node/test/nodeE = new("Node E")
	var/datum/node/test/nodeF = new("Node F")
	var/datum/node/test/nodeG = new("Node G") // Deleted node
	var/datum/node/test/nodeH = new("Node H")

	var/edges = list()
	edges[nodeA] = list(nodeB)
	edges[nodeB] = list(nodeA, nodeC)
	edges[nodeC] = list(nodeB, nodeD)
	edges[nodeD] = list(nodeC, nodeE)
	edges[nodeE] = list(nodeD, nodeF)
	edges[nodeF] = list(nodeE, nodeG)
	edges[nodeG] = list(nodeF, nodeH)
	edges[nodeH] = list(nodeG)
	var/datum/graph/testing/graph = new(list(nodeA, nodeB, nodeC, nodeD, nodeE, nodeF, nodeG, nodeH), edges)
	graphs += graph

	var/expected_graph_one = list(nodeA)

	var/expected_graph_two = list(nodeB, nodeC)
	var/expected_edges_two = list()
	expected_edges_two[nodeB] = list(nodeC)
	expected_edges_two[nodeC] = list(nodeB)

	var/expected_graph_three = list(nodeD)

	var/expected_graph_four = list(nodeE, nodeF)
	var/expected_edges_four = list()
	expected_edges_four[nodeE] = list(nodeF)
	expected_edges_four[nodeF] = list(nodeE)

	var/expected_graph_five = list(nodeH)

	graph.split_expectations = list(
		new/datum/graph_expectation(expected_graph_one),
		new/datum/graph_expectation(expected_graph_two, expected_edges_two),
		new/datum/graph_expectation(expected_graph_three),
		new/datum/graph_expectation(expected_graph_four, expected_edges_four),
		new/datum/graph_expectation(expected_graph_five),
		)

	graph.Disconnect(nodeB, nodeA)
	graph.Disconnect(nodeD)
	qdel(nodeG)
	return TRUE

/******************
* Base Test Setup *
******************/
/datum/unit_test/graph_test
	template = /datum/unit_test/graph_test
	async = TRUE
	var/list/graphs

/datum/unit_test/graph_test/New()
	..()
	graphs = list()

/datum/unit_test/graph_test/proc/ReadyToCheckExpectations()
	return length(SSgraphs_update.pending_graphs) == 0 && length(SSgraphs_update.current_run) == 0

/datum/unit_test/graph_test/check_result()
	if(!ReadyToCheckExpectations())
		return FALSE

	var/total_issues = 0
	for(var/datum/graph/testing/GT in graphs)
		for(var/issue in GT.CheckExpectations())
			log_bad("[GT.name] - [issue]")
			total_issues++

	if(total_issues)
		fail("Encountered [total_issues] issue\s")
	else
		pass("Encountered no issues")

	return TRUE


/**********
* Helpers *
**********/
/datum/node/test
	var/name

/datum/node/test/New(var/name)
	..()
	src.name = name

/datum/graph/testing
	var/name
	var/list/split_expectations
	var/datum/graph_expectation/on_check_expectations

	var/on_split_was_called
	var/issues

/datum/graph/testing/New(var/node, var/edges, var/name)
	..()
	src.name = name || "Graph"
	issues = list()

/datum/graph/testing/OnSplit(var/list/subgraphs)
	if(length(split_expectations) != subgraphs.len)
		issues += "Expected number of subgrapghs is [subgraphs.len], was [length(split_expectations)]"
	else if(length(split_expectations))
		var/list/unexpected_subgraphs = list()
		var/list/split_expectations_copy = split_expectations.Copy()
		for(var/subgraph in subgraphs)
			var/expectations_fulfilled = FALSE
			for(var/split_expectation in split_expectations_copy)
				var/datum/graph_expectation/GE = split_expectation
				if(!length(GE.CheckExpectations(subgraph)))
					split_expectations_copy -= GE
					expectations_fulfilled = TRUE
					break
			if(!expectations_fulfilled)
				unexpected_subgraphs += subgraph

		for(var/expected_graph in unexpected_subgraphs)
			issues += "Unexpected graph: [log_info_line(expected_graph)]"
		for(var/expected_split in split_expectations_copy)
			issues += "Unfulfilled split expectation: [log_info_line(expected_split)]"

	on_split_was_called = TRUE

/datum/graph/testing/proc/CheckExpectations()
	if(on_check_expectations)
		issues += on_check_expectations.CheckExpectations(src)
	if(length(split_expectations) && !on_split_was_called)
		issues += "Had split expectations but OnSplit was not called"
	if(!length(split_expectations) && on_split_was_called)
		issues += "Had no split expectations but OnSplit was called"

	return issues

/datum/graph_expectation
	var/list/expected_nodes
	var/list/expected_edges

/datum/graph_expectation/New(var/expected_nodes, var/expected_edges)
	..()
	src.expected_nodes = expected_nodes || list()
	src.expected_edges = expected_edges || list()

/datum/graph_expectation/proc/CheckExpectations(var/datum/graph/graph)
	. = list()
	if(length(expected_nodes ^ (graph.nodes || list())))
		. += "Expected the following nodes [log_info_line(expected_nodes)], was [log_info_line(graph.nodes)]"
	if(length(expected_edges ^ (graph.edges || list())))
		. += "Expected the following edges [log_info_line(expected_edges)], was [log_info_line(graph.edges)]"

	for(var/datum/node/N in graph.nodes)
		if(N.graph != graph)
			. += "[log_info_line(N)]: Expected the following graph [log_info_line(graph)], was [N.graph]"

	for(var/node in expected_edges)
		var/expected_connections = expected_edges[node]
		var/actual_connections = graph.edges[node]
		if(length(expected_connections ^ actual_connections))
			. += "[log_info_line(node)]: Expected the following connections [log_info_line(expected_connections)], was [log_info_line(actual_connections)]"

/datum/graph_expectation/deleted/CheckExpectations(var/datum/graph/graph)
	. = ..()
	if(!QDELETED(graph))
		. += "Expected graph to be deleted, was not"

/datum/graph_expectation/get_log_info_line()
	return "Expected nodes: [log_info_line(expected_nodes)], expected edges: [log_info_line(expected_edges)]"
