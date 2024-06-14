/* *
* Renderers
* Renderers are virtual objects that act as draw groups of things, including
* other Renderers. Renderers are similar to older uses of PLANE_MASTER but
* employ render targets using the "*" slate prefix to draw off-screen, to be
* composited in a controlled and flexible order and in some cases, reuse for
* visual effects.
*/


/// Main renderers are expected to always be on mobs with clients.
#define RENDERER_MAIN FLAG(0)

/**
 * Shared renderers have a single instance and are added/removed instead of created/deleted.
 * Many renderers can be shared - only ones that depend on the state of the mob seeing them,
 * such as effects with preferences, require an owner.
 */
#define RENDERER_SHARED FLAG(1)

/// Renderers with non-default setup behavior in hook/startup/proc/setup_renderers.
#define RENDERER_SHARED_CUSTOM FLAG(2)


/// The base /renderer definition and defaults.
/atom/movable/renderer
	abstract_type = /atom/movable/renderer
	appearance_flags = DEFAULT_RENDERER_APPEARANCE_FLAGS
	screen_loc = "CENTER"
	plane = LOWEST_PLANE
	blend_mode = BLEND_OVERLAY

	/// A bitfield of RENDERER_* defines.
	var/renderer_flags = EMPTY_BITFIELD

	/// The compositing renderer this renderer belongs to.
	var/group = RENDER_GROUP_FINAL

	/// The relay movable used to composite this renderer to its group.
	var/atom/movable/relay // Also see https://secure.byond.com/forum/?post=2141928 maybe.

	/// Optional blend mode override for the renderer's composition relay.
	var/relay_blend_mode

	/// If text, uses the text or, if TRUE, uses "*AUTO-[name]".
	var/render_target_name = TRUE

	/// When not shared, the mob associated with this renderer.
	var/mob/owner


/atom/movable/renderer/Destroy()
	if (renderer_flags & RENDERER_SHARED)
		return QDEL_HINT_LETMELIVE
	QDEL_NULL(relay)
	owner = null
	return ..()


INITIALIZE_IMMEDIATE(/atom/movable/renderer)
/atom/movable/renderer/Initialize(mapload, mob/owner)
	. = ..()
	if (. == INITIALIZE_HINT_QDEL)
		return
	src.owner = owner
	if (isnull(group))
		if (istext(render_target_name))
			render_target = render_target_name
		return
	if (istext(render_target_name))
		render_target = render_target_name
	else if (render_target_name)
		render_target = "*[ckey(name)]"
	relay = new
	relay.screen_loc = "CENTER"
	relay.appearance_flags = PASS_MOUSE | NO_CLIENT_COLOR | KEEP_TOGETHER
	relay.name = "[render_target] relay"
	relay.mouse_opacity = mouse_opacity
	relay.render_source = render_target
	relay.layer = (plane + abs(LOWEST_PLANE)) * 0.5
	relay.plane = group
	if (isnull(relay_blend_mode))
		relay.blend_mode = blend_mode
	else
		relay.blend_mode = relay_blend_mode


/**
* Graphic preferences
* Some renderers may be able to use a graphic preference to determine how to display effects.
* For example reduce particle counts or filter variables.
*/
/atom/movable/renderer/proc/GraphicsUpdate()
	return


/**
* Renderers on /mob
* We attach renderers to mobs for their lifespan. Only mobs with clients get
* renderers, and they are removed again when the mob loses its client. Mobs
* get their own unique renderer instances but it would not be inconceivable
* to share them globally.
*/

/// A map of (instance = plane) renderers in use by this mob.
/mob/var/list/atom/movable/renderer/rdr_to_plane

/// A map of (type = instance) renderers in use by this mob.
/mob/var/list/atom/movable/renderer/rdr_by_type


/// Creates the mob's renderers on /Login()
/mob/proc/AddDefaultRenderers()
	if (rdr_to_plane)
		ClearRenderers()
	rdr_to_plane = list()
	rdr_by_type = list()
	for (var/atom/movable/renderer/renderer as anything in GLOB.rdr_main_owned)
		renderer = new renderer (null, src)
		rdr_to_plane[renderer] = renderer.plane
		rdr_by_type[renderer.type] = renderer
		if (renderer.relay)
			my_client.screen += renderer.relay
		my_client.screen += renderer
	for (var/atom/movable/renderer/renderer as anything in GLOB.rdr_main_shared)
		rdr_to_plane[renderer] = renderer.plane
		rdr_by_type[renderer.type] = renderer
		if (renderer.relay)
			my_client.screen += renderer.relay
		my_client.screen += renderer


/// Removes the mob's renderers on /Logout()
/mob/proc/ClearRenderers()
	if (my_client)
		for (var/atom/movable/renderer/renderer as anything in rdr_to_plane)
			if (renderer.relay)
				my_client.screen -= renderer.relay
			my_client.screen -= renderer
			if (~renderer.renderer_flags & RENDERER_SHARED)
				qdel(renderer)
	rdr_to_plane = null
	rdr_by_type = null


/// Returns the renderer instance of_type if the mob has one and it is not shared.
/mob/proc/GetRenderer(atom/movable/renderer/of_type)
	if (!my_client)
		return
	var/atom/movable/renderer/renderer = rdr_by_type[of_type]
	if (renderer?.renderer_flags & RENDERER_SHARED)
		return
	return renderer


/// Adds a non-main renderer to the mob by type if the mob doesn't already have it.
/mob/proc/AddRenderer(atom/movable/renderer/of_type)
	if (!my_client)
		return
	var/flags = initial(of_type.renderer_flags)
	if (flags & RENDERER_MAIN)
		return
	if (of_type in rdr_by_type)
		return
	var/atom/movable/renderer/renderer
	if (flags & RENDERER_SHARED)
		renderer = GLOB.rdr_all_shared[of_type]
	else
		renderer = new of_type (null, src)
	if (renderer.relay)
		my_client.screen += renderer.relay
	my_client.screen += renderer
	rdr_to_plane[renderer] = renderer.plane
	rdr_by_type[of_type] = renderer


/// Removes a non-main renderer to the mob by type.
/mob/proc/RemoveRenderer(atom/movable/renderer/of_type)
	if (!my_client)
		return
	var/flags = initial(of_type.renderer_flags)
	if (flags & RENDERER_MAIN)
		return
	var/atom/movable/renderer/renderer = rdr_by_type[of_type]
	if (!renderer)
		return
	if (renderer.relay)
		my_client.screen -= renderer.relay
	my_client.screen -= renderer
	rdr_by_type -= of_type
	rdr_to_plane -= renderer
	if (~renderer.renderer_flags & RENDERER_SHARED)
		qdel(renderer)


/* *
* Plane Renderers
* We treat some renderers as planes with layers. When some atom has the same plane
* as a Plane Renderer, it is drawn by that renderer. The layer of the atom determines
* its draw order within the scope of the renderer. The draw order of same-layered things
* is probably by atom contents order, but can be assumed not to matter - if it's visibly
* incorrect, it should have a more appropriate layer value.
* Higher plane values are composited over lower. Here, they are ordered from under to over.
*/


 /// Handles byond internal letterboxing. Avoid touching.
/atom/movable/renderer/letterbox
	name = "Letterbox"
	group = RENDER_GROUP_SCENE
	plane = BLACKNESS_PLANE
	blend_mode = BLEND_MULTIPLY
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	renderer_flags = RENDERER_MAIN | RENDERER_SHARED


/atom/movable/renderer/space
	name = "Space"
	group = RENDER_GROUP_SCENE
	plane = SPACE_PLANE
	renderer_flags = RENDERER_MAIN | RENDERER_SHARED


/atom/movable/renderer/skybox
	name = "Skybox"
	group = RENDER_GROUP_SCENE
	plane = SKYBOX_PLANE
	relay_blend_mode = BLEND_MULTIPLY
	renderer_flags = RENDERER_MAIN | RENDERER_SHARED


/atom/movable/renderer/zmimic
	name = "Zrenderer"
	group = RENDER_GROUP_SCENE
	renderer_flags = RENDERER_MAIN | RENDERER_SHARED | RENDERER_SHARED_CUSTOM


/atom/movable/renderer/zmimic/Initialize(mapload, _owner, _plane)
	plane = _plane
	name = "Zrenderer [plane]"
	return ..()


// Draws the game world; live mobs, items, turfs, etc.
/atom/movable/renderer/game
	name = "Game"
	group = RENDER_GROUP_SCENE
	plane = DEFAULT_PLANE
	renderer_flags = RENDERER_MAIN | RENDERER_SHARED


/// Draws observers; ghosts, camera eyes, etc.
/atom/movable/renderer/observers
	name = "Observers"
	group = RENDER_GROUP_SCENE
	plane = OBSERVER_PLANE
	renderer_flags = RENDERER_MAIN | RENDERER_SHARED


/// Draws darkness effects.
/atom/movable/renderer/lighting
	name = "Lighting"
	group = RENDER_GROUP_SCENE
	plane = LIGHTING_PLANE
	relay_blend_mode = BLEND_MULTIPLY
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	renderer_flags = RENDERER_MAIN | RENDERER_SHARED


/atom/movable/renderer/lighting/Initialize()
	. = ..()
	filters += filter(
		type = "alpha",
		render_source = EMISSIVE_TARGET,
		flags = MASK_INVERSE
	)


/// Draws visuals that should not be affected by darkness.
/atom/movable/renderer/above_lighting
	name = "Above Lighting"
	group = RENDER_GROUP_SCENE
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	renderer_flags = RENDERER_MAIN | RENDERER_SHARED


/// Draws full screen visual effects, like pain and bluespace.
/atom/movable/renderer/screen_effects
	name = "Screen Effects"
	group = RENDER_GROUP_SCENE
	plane = FULLSCREEN_PLANE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	renderer_flags = RENDERER_MAIN | RENDERER_SHARED


/// Draws user interface elements.
/atom/movable/renderer/interface
	name = "Interface"
	group = RENDER_GROUP_SCREEN
	plane = HUD_PLANE
	renderer_flags = RENDERER_MAIN | RENDERER_SHARED


/* *
* Group renderers
* We treat some renderers as render groups that other renderers subscribe to. Renderers
* subscribe themselves to groups by setting a group value equal to the plane of a Group
* Renderer. This value is used for the Renderer's relay to include it into the Group, and
* the Renderer's plane is used as the relay's layer.
* Group renderers can subscribe themselves to other Group Renderers. This allows for more
* granular manipulation of how the final scene is composed.
*/


/// Render group for stuff INSIDE the typical game context - people, items, lighting, etc.
/atom/movable/renderer/scene_group
	name = "Scene Group"
	group = RENDER_GROUP_FINAL
	plane = RENDER_GROUP_SCENE
	renderer_flags = RENDERER_MAIN


/// Render group for stuff OUTSIDE the typical game context - UI, full screen effects, etc.
/atom/movable/renderer/screen_group
	name = "Screen Group"
	group = RENDER_GROUP_FINAL
	plane = RENDER_GROUP_SCREEN
	renderer_flags = RENDERER_MAIN | RENDERER_SHARED


/// Render group for final compositing before user display.
/atom/movable/renderer/final_group
	name = "Final Group"
	group = RENDER_GROUP_NONE
	plane = RENDER_GROUP_FINAL
	renderer_flags = RENDERER_MAIN | RENDERER_SHARED


/* *
* Effect Renderers
* Some renderers are used to produce complex screen effects. These are drawn using filters
* rather than composition groups, and may be added to another renderer in the following
* fashion. Setting a render_target_name with no group is the expected patter for Effect
* Renderers as it allows them to draw to a slate that will be empty unless a relevant
* behavior, such as the effect atom below, causes them to be noticeable.
*/


/// Renders the /obj/effect/warp example effect as well as gravity catapult effects
/atom/movable/renderer/warp
	name = "Warp Effect"
	group = RENDER_GROUP_NONE
	plane = WARP_EFFECT_PLANE
	render_target_name = "*warp"
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	renderer_flags = RENDERER_MAIN | RENDERER_SHARED


//Similar to warp but not as strong
/atom/movable/renderer/heat
	name = "Heat Effect"
	group = RENDER_GROUP_NONE
	plane = HEAT_EFFECT_PLANE
	render_target_name = HEAT_COMPOSITE_TARGET
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	renderer_flags = RENDERER_MAIN

	var/obj/gas_heat_object
	var/obj/gas_cold_object


/atom/movable/renderer/heat/proc/Setup()
	var/mob/M = owner
	if (ismob(M))
		var/quality = M.get_preference_value(/datum/client_preference/graphics_quality)
		if (gas_heat_object)
			vis_contents -= gas_heat_object
		if (gas_cold_object)
			vis_contents -= gas_cold_object
		if (quality == GLOB.PREF_LOW)
			QDEL_NULL(gas_heat_object)
			gas_heat_object = new /obj/heat
			QDEL_NULL(gas_cold_object)
			gas_cold_object = new /obj/effect/cold_mist_gas
		else
			QDEL_NULL(gas_heat_object)
			QDEL_NULL(gas_cold_object)
			gas_cold_object = new /obj/particle_emitter/mist/gas
			if (quality == GLOB.PREF_MED)
				gas_heat_object = new /obj/particle_emitter/heat
			else if (quality == GLOB.PREF_HIGH)
				gas_heat_object = new /obj/particle_emitter/heat/high
		vis_contents += gas_heat_object
		if (config.enable_cold_mist)
			vis_contents += gas_cold_object


/atom/movable/renderer/heat/Initialize()
	. = ..()
	Setup()


/atom/movable/renderer/heat/GraphicsUpdate()
	. = ..()
	Setup()


/atom/movable/renderer/scene_group/Initialize()
	. = ..()
	filters += filter(
		type = "displace",
		render_source = "*warp",
		size = 5
	)
	filters += filter(
		type = "displace",
		render_source = HEAT_COMPOSITE_TARGET,
		size = 2.5
	)


/*!
 * Emmissives work by exploiting BYONDs color matrix filter to use layers to handle emissive blockers.
 *
 * Emissive overlays are pasted with an atom color that converts them to be entirely some specific color.
 * Emissive blockers are pasted with an atom color that converts them to be entirely some different color.
 * Emissive overlays and emissive blockers are put onto the same plane.
 * The layers for the emissive overlays and emissive blockers cause them to mask eachother similar to normal BYOND objects.
 * A color matrix filter is applied to the emissive plane to mask out anything that isn't whatever the emissive color is.
 * This is then used to alpha mask the lighting plane.
 *
 * This works best if emissive overlays applied only to objects that emit light,
 * since luminosity=0 turfs may not be rendered.
 */


/atom/movable/renderer/emissive
	name = "Emissive"
	group = RENDER_GROUP_NONE
	plane = EMISSIVE_PLANE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	render_target_name = EMISSIVE_TARGET
	renderer_flags = RENDERER_MAIN | RENDERER_SHARED


/atom/movable/renderer/emissive/Initialize()
	. = ..()
	filters += filter(
		type = "color",
		color = GLOB.em_mask_matrix
	)


/// A map of (type = instance|list(instance)) of all normal renderers that mobs can share an instance of.
GLOBAL_LIST_EMPTY(rdr_all_shared)


/// A map of (instance = plane) renderers that should be attached to all cliented mobs by default.
GLOBAL_LIST_EMPTY(rdr_main_shared)


/// A list of renderer types to instantiate on all cliented mobs by default.
GLOBAL_LIST_EMPTY(rdr_main_owned)


/hook/startup/proc/setup_renderers()
	for (var/atom/movable/renderer/renderer as anything in subtypesof(/atom/movable/renderer))
		var/flags = initial(renderer.renderer_flags)
		if (~flags & RENDERER_SHARED)
			if (flags & RENDERER_MAIN)
				GLOB.rdr_main_owned += renderer
			continue
		if (flags & RENDERER_SHARED_CUSTOM)
			continue
		renderer = new renderer
		GLOB.rdr_all_shared[renderer.type] = renderer
		if (flags & RENDERER_MAIN)
			GLOB.rdr_main_shared[renderer] = renderer.plane
	var/list/zmimic_renderers = list()
	for (var/i = 0 to OPENTURF_MAX_DEPTH)
		var/atom/movable/renderer/zmimic/renderer = new (null, null, OPENTURF_MAX_PLANE - i)
		GLOB.rdr_main_shared[renderer] = renderer.plane
		zmimic_renderers += renderer
	GLOB.rdr_all_shared[/atom/movable/renderer/zmimic] = zmimic_renderers
	return TRUE
