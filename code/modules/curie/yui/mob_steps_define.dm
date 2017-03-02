var/stepsList = list(
  /turf/simulated/floor/tiled = TILE_FOOTSTEP_SOUNDS,
  /turf/simulated/floor/shuttle = TILE_FOOTSTEP_SOUNDS, //Not sure about this one
  /turf/simulated/floor/grass = GRASS_FOOTSTEP_SOUNDS,
  /turf/simulated/floor/plating = METAL_FOOTSTEP_SOUNDS,
  /turf/simulated/floor/airless = METAL_FOOTSTEP_SOUNDS,
  /turf/simulated/floor/carpet = CARPET_FOOTSTEP_SOUNDS,
  /turf/simulated/floor/asteroid = DIRT_FOOTSTEP_SOUNDS,
  /turf/simulated/floor/reinforced = METAL_FOOTSTEP_SOUNDS,
  /turf/simulated/floor/wood = WOOD_FOOTSTEP_SOUNDS,
)

var/itemStepsList[] = list(
  /obj/structure/lattice = GRATE_FOOTSTEP_SOUNDS,
  list(
  /obj/effect/decal/cleanable/blood,
  /obj/effect/decal/cleanable/fruit_smudge,
  /obj/effect/decal/cleanable/egg_smudge,
  /obj/effect/decal/cleanable/greenglow,
  /obj/effect/decal/cleanable/liquid_fuel,
  /obj/effect/decal/cleanable/mucus,
  /obj/effect/decal/cleanable/tomato_smudge,
  /obj/effect/decal/cleanable/pie_smudge,
  /obj/effect/decal/cleanable/vomit) = MUD_FOOTSTEP_SOUNDS,
  /obj/structure/grille = FENCE_FOOTSTEP_SOUNDS
)



var/TILE_FOOTSTEP_SOUNDS[] = list(
"tile1.wav",
"tile2.wav",
"tile3.wav",
"tile4.wav",
"tile5.wav",
"tile6.wav",
"tile7.wav",
"tile8.wav"
)

var/DIRT_FOOTSTEP_SOUNDS[] = list(
"dirt1.wav",
"dirt2.wav",
"dirt3.wav",
"dirt4.wav",
"dirt5.wav",
"dirt6.wav",
"dirt7.wav",
"dirt8.wav"
)

var/CARPET_FOOTSTEP_SOUNDS[] = list(
"carpet1.wav",
"carpet2.wav",
"carpet3.wav",
"carpet4.wav",
"carpet5.wav",
"carpet6.wav",
"carpet7.wav",
"carpet8.wav"
)

var/GRASS_FOOTSTEP_SOUNDS[] = list(
"grass1.wav",
"grass2.wav",
"grass3.wav",
"grass4.wav",
"grass5.wav",
"grass6.wav",
"grass7.wav",
"grass8.wav"
)

var/METAL_FOOTSTEP_SOUNDS[] = list(
"metal1.wav",
"metal2.wav",
"metal3.wav",
"metal4.wav",
"metal5.wav",
"metal6.wav",
"metal7.wav",
"metal8.wav"
)

var/WOOD_FOOTSTEP_SOUNDS[] = list(
"wood1.wav",
"wood2.wav",
"wood3.wav",
"wood4.wav",
"wood5.wav",
"wood6.wav",
"wood7.wav",
"wood8.wav"
)

var/DEFAULT_FOOTSTEP_SOUNDS[] = list(
"rubber1.wav",
"rubber2.wav",
"rubber3.wav",
"rubber4.wav",
"rubber5.wav",
"rubber6.wav",
"rubber7.wav",
"rubber8.wav"
)

var/HEAVY_FOOTSTEP_SOUNDS[] = list( //For Robotz
"ladder1.wav",
"ladder2.wav",
"ladder3.wav",
"ladder4.wav"
)

var/GRATE_FOOTSTEP_SOUNDS[] = list(
"grate1.wav",
"grate2.wav",
"grate3.wav",
"grate4.wav",
"grate5.wav",
"grate6.wav",
"grate7.wav",
"grate8.wav"
)

var/MUD_FOOTSTEP_SOUNDS[] = list( //For nasty stuff
"mud1.wav",
"mud2.wav"
)

var/FENCE_FOOTSTEP_SOUNDS[] = list(
"fence1.wav",
"fence2.wav"
)


var/FOOTSTEP_BLACKLISTED_MOBS[] = list(
/mob/living/carbon/slime/
)

var/footstepVol = 30
var/footstepFreq = 0
var/footstepRange = -1
var/footstepVarReq = 1

