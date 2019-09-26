/*
	Advanced Zlevel Handling, by Nanako

	This code introduces the concept of a Scene (all the better words like "location" were already taken)
	A scene is a grouping of zlevels which all form a single physical location. For example, a single ship is a scene, even if it spreads over ten floors.
	each planet is a different scene, each station is a different scene, each derelict ship is a different scene

	All the zlevels within a scene are considered to be connected, and generally two seperate scenes do not connect to each other.
	If you leave a scene you'll float off into space.

	A shuttle is not a scene, generally. They are a special case, and are simply part of whatever scene they're currently docked at.
	If in transit, the space they're flying through is a scene


	Notable types:
*/