# Away sites

## What exactly is an away site?

It's a kind of map template which:
* is placed in its own zlevel (or collection of zlevels),
* should only get placed once per round,
* can be randomly picked to be placed automatically during round setup,
* normally has an overmap presence and shuttle landmarks so ships can fly to it.

### Er, what's a map template?

It's a datum you can define in the code (`/datum/map_template`) which points at one or more .dmm map files, and allows the game (or admins) to spawn those map files when and where they please, whether that's into an existing zlevel (like decorating exoplanets with ruins), or on a totally fresh one (like an away site!).

## How do I make away sites?

tl;dr you make your .dmm files, then you write a new map template datum (`/datum/map_template/ruin/away_site/insert_your_away_site_name_here`), then you include whatever file you defined that datum in into `torch.dm` and `away_sites_testing.dm`, and you're all set.

BUT HEED MY RUMINATIONS

## While mapping

### Don't use Torch-specific types

Away maps are expected to work whether you're on Torch, the example map, the Bearcat, or anything else you might want to load as the server's main map. That means your map mustn't use areas, turfs, objects, mobs or datums that are specific to any main map.

e.g. you can use `/area/space`, or `/turf/simulated/wall`, because neither are specific to Torch. They live out in the main codebase, are always compiled in, and are available to all maps. But you can't use `/obj/random_multi/single_item/punitelly`, because Punitelli only exists when Torch is compiled.

To make life easier, you can uncheck maps/torch/torch.dm (or your regional equivalent), then recompile, to make sure these types aren't available while you're mapping.

### Don't re-use area types from other maps

Except for, like, `/area/space`. That one's probably fine.

(Now that's just areas! Other stuff might be ok. Except very map-specific stuff as noted!)

Re-using areas is a shortcut, but it's bad for testability, and you can't guarantee that the area you re-use isn't loaded up and in active use on the server - in which case it'll hideously merge together with its brother in terms of stuff like air alarms, APCs, etc. Suddenly your derelict starship is randomly receiving power from another zlevel. Not good. Avoid. Make your own area types!

If in doubt, ask #codershuttle on IRC/#coding on Discord.

### If you're doing multi-z, make a different .dmm file for each zlevel

Not exactly a technical requirement, but it makes things easier in terms of collaboration. See how it's done with `torch-1.dmm`, `torch-2.dmm`, etc.

## Afterwards (or during, I'm not a cop)

### Make sure you've got a .dm file for all your stuff

Like `maps/away/derelict/derelict.dm`. It's a pretty good place to put all your new types! #include other files here too. This file's going to be the hub of your map's wheel, to cack-hand a metaphor.

### Make a map template datum there

The game will read this to learn about your new shiny away sites, including what .dmm files it needs to load, how much it 'costs' to spawn (usually 1, increase for more performance-heavy away sites). Ask devs or read code if unsure.

### Include your .dm file in any main map file, and away sites testing

That's `maps/away_sites_testing/away_sites_testing.dm`, and probably `maps/torch/torch.dm`. It goes in the testing one to make sure Travis runs it through unit testing, and it goes in the Torch one to make it available while we play Torch. If we have since changed map, yell at someone to update this doc.

### Don't include it, or the .dmms, in the .dme

That means don't have any of your away map stuff checked in Dream Maker. It'll get included, as if by magic, via the work you did in the previous step!

That's it! You're probably done! Unless Travis explodes at you.

### Some of the stuff I put in my map isn't behaving properly!

The map loader works best when everything it's spawning does all its initialisation work in `Initialize`, instead of in `New`. Most likely your misbehaving thing is doing more initialisation than is healthy in `New`. It's fixable! Often not even that hard. Go talk to a dev.