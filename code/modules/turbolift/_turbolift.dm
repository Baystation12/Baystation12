/*
 * Turbolifts! Sort of like multishuttles-lite.
 *
 * How-to: Map /obj/turbolift_map_holder in at the bottom of the shaft, give it a depth
 * value equivalent to the number of floors it should span (inclusive of the first),
 * and at runtime it will update the map, set areas and create control panels and
 * wifi-set doors appropriate to itself. You will save time at init if you map the
 * elevator shaft in properly before runtime, but ultimately you're just avoiding a
 * bunch of ChangeTurf() calls.
 */

var/global/list/turbolifts = list()
