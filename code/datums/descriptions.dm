/*
This is what is supplied to the examine tab.  Everything has a 'descriptions' variable, which is null by default.  When it is not null,
it contains this datum.  To add this datum to something, all you do is add this to the thing..

	descriptions = new/datum/descriptions("I am some helpful blue text","I have backstory text about this obj.","You can use this to kill everyone.")

First string is the 'info' var, second is the 'fluff' var, and third is the 'antag' var.  All are optional.  Just add it to the object you want to have it.

If you are wondering, BYOND does not let you do desc = new/datum/descriptions .

More strings can be added easily, but you will need to add a proc to retrieve it from the atom.  The procs are defined in atoms.dm.

*/
/datum/descriptions
	var/info
	var/fluff
	var/antag

/datum/descriptions/New(var/info, var/fluff, var/antag)
	src.info = info
	src.fluff = fluff
	src.antag = antag