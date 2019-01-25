/*
Overmap2 is a rewrite designed to increase the zlevel cap, easier maintenance and be more extendible, replacing Skymarshal's old bitshifting system from Bay12.
The main change is to centralise much of hte processing code into /obj/effect/overmap and have /obj/effect/landmark/map_data on each zlevel
It is designed to be backwards compatible as much as possible.
The changes are documented in this file, otherwise README.dm should be considered accurate.
Some Baystation or Torch specific things are removed to make the overmap system more flexible.

Cael_Aislinn, January 2019

*************************************************************

var/global/list/map_sectors = list()

This is a list of all accessible zlevels, stored as text strings of their z index.
Each entry also associates the owning overmap object (also known as 'sector')

*************************************************************

var/global/list/map_datas = list()

This is a list of all accessible zlevels, stored as text strings of their z index.
Each entry also associates the /obj/effect/landmark/map_data for that zlevel

*************************************************************

/obj/effect/overmap

Also known as a 'sector'. Now given additional responsibilities for linking and managing connections between zlevels.

var/list/map_z = list()

this functions the same as before

var/list/map_z_data = list()

A list of all connected /obj/effect/landmark/map_data

var/tag

This is the ID that is used to link its connected /obj/effect/overmap so it should be unique and set in or before New() ie on the map or definition

*************************************************************

/obj/effect/landmark/map_data

One of these should be placed on each accessible (player) zlevel. It should be given a name that matches the var/tag of its /obj/effect/overmap
Make sure the name is set at the top of New() or before New() is called ie in the map or definition

var/list/map_z_data = list()

A list of all connected /obj/effect/landmark/map_data

var/above, var/below

The /obj/effect/landmark/map_data for the connected zlevel that are adjacent to this one. This is a peer linkage and it is set and managed by the /obj/effect/overmap

*************************************************************

*/
