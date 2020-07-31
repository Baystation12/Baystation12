/*
Note about file conventions:
I'm trying to move all the faction stuff into the faction folders to make it more easy to find.
However I'm making an exception here because the supply system is complex with a lot of moving parts.
Putting all the supply stuff together, including the faction specific stuff, makes it much easier to maintain and update
-C, July 2020
*/

/***** OVERVIEW *****/

/*
This system is heavily based off SS13 Cargo Department which involves ordering goods to arrive by shuttle
as well as exporting goods via the same shuttle to earn points for the crew. This new trading system links
it in with the factions system in a much nicer UI as well as using modular computers. The initial implementation
of this system also integrated in a faction reputation system which unlocked extra purchasable items (see innie
missions). This version from August/July 2020 is a genericised version of that to work with any faction, in theory.

Future expansions: Dynamic prices, stock availability, more faction themed gear and random events
*/

/***** TRADE DOCUMENTATION *****/

/*
/datum/computer_file/program/faction_supply
	- This is a wrapper for the nano_module which is designed to integrate with the modular_computer

/datum/nano_module/program/faction_supply
	- This contains the logic for the GUI and is overriden to allow some faction specific stuff.
	- Keeping this abstracted means the logic can be interacted with without requiring a modular_computer

/obj/item/modular_computer/console/preset/****_supply (eg. "unsc_supply")
	- These are faction specific computers that come preloaded with the relevant faction specific trade program
*/

/***** SHUTTLE DOCUMENTATION *****/

/*
SS13 shuttles rely heavily on hardcoding so I've simplified and genericised them as much as possible. The logic for
the trade shuttles and trading itself is in code/modules/halo/trade. Here, we just need to define the following:

- An area with a landmark in the bottom left corner for the shuttle to hide when it's "away"
	(needs to be mapped)
- An area with a landmark in the bottom left corner for the shuttle to sit when it's at the station
	(only landmark needs to be mapped)
- An area for the shuttle along with turfs etc that start mapped in at the station
	(place the landmark in the bottom left corner)
*/