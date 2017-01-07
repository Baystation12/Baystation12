/*
The overmap system allows adding new maps to the big 'galaxy' map.
There's overmap zlevel, that looks like a map. On it, token objects (overmap objects) are moved, representing ship movement etc.
No actual turfs are moved, you would need exploration shuttles or teleports to move atoms between different sectors/ships.

*************************************************************
# How to make new sector
*************************************************************
0. Map whatever.
1. Make /obj/effect/overmap/sector/[whatever]
	If you want explorations shuttles be able to dock here, remember to set *landing_area*
2. Put /obj/effect/overmap/sector/[whatever] on the map. Even if it's multiz, only one is needed, on any z.
3. Done.

*************************************************************
# How to make new ship
0. Map whatever.
1. Make /obj/effect/overmap/ship/[whatever]
	If you want explorations shuttles be able to dock here, remember to set *landing_area*
2. Put /obj/effect/overmap/ship/[whatever] on the map. If it's multiz, only one is needed, on any z.
3. Put Helm Console anywhere on the map.
4. Put Engines Control Console anywhere on the map.
5. Put some engines hooked up to gas supply anywhere on the map.
6. Done.


*************************************************************
# Overmap object
*************************************************************
/obj/effect/overmap
### WHAT IT DOES
Lets overmap know this place should be represented on the map as a sector/ship.
If this zlevel (or any of connected ones for multiz) doesn't have this object, you won't be able to travel there by ovemap means.
### HOW TO USE
1. Create subtype for your ship/sector. Use /ship one for ships.
2. Put it anywhere on the ship/sector map. It will do the rest on its own during init.
If your thing is multiz, only one is needed per multiz sector/ship.

If it's player's main base (e.g Exodus), set 'base' var to 1, so it adds itself to station_levels list.
If you want exploration shuttles (look below) to be able to dock here, set *landing_area* var to the type of area they should use
e.g. *landing_area* = /area/sector/shuttle/butts_inbound

*************************************************************
# Helm console
*************************************************************
/obj/machinery/computer/helm
### WHAT IT DOES
Lets you steer ship around on overmap.
Lets you use autopilot.
### HOW TO USE
Just place it anywhere on the ship. It will do the rest on its own during init.

*************************************************************
# Engines control console
*************************************************************
/obj/machinery/computer/engines
### WHAT IT DOES
Lets use use engines of your ship.
Lets you check status of engines.
### HOW TO USE
Just place it anywhere on the ship. It will do the rest on its own during init.

*************************************************************
# Thermal engines
*************************************************************
/obj/machinery/atmospherics/unary/engine
### WHAT IT DOES
Lets your ship move on the map at all.
### HOW TO USE
Put them on map, hook up to pipes with any gas. More pressure = more thrust.
Make sure you have Engines control terminal. It'll handle the rest.

*************************************************************
# Exploration shuttle terminal
*************************************************************
/obj/machinery/computer/shuttle_control/explore
### WHAT IT DOES
Lets you control shuttles that can change destinations and visit other sectors/ships.
### HOW TO USE
1. Map a shuttle area.
2. Set landing_type var to the type of that area.
3. Place console anywhere on the ship/sector.
4. Use. You can select destinations if you're in range (on same tile by defualt) on the map and sector has *landing_area* defined
*/