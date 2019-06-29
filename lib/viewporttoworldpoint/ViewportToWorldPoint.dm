/* Adds client.ViewportToWorldPoint().
*/
client
	proc
		/* Takes a point relative to the viewport (1,1 is the bottom-left pixel of the viewport)
			and an optional transform of the world plane (in case you transform the world plane via plane master).
			Should work in isometric too.
		*/
		ViewportToWorldPoint(vector2/view_point, matrix/world_plane_transform = null)
			var matrix/viewport_matrix
			switch(world.map_format)
				if(ISOMETRIC_MAP)
					viewport_matrix = matrix(
						1, -2, bound_x + bound_height / 2 + 1,
						1,  2, bound_y - bound_width / 2 - 3)
				else
					viewport_matrix = matrix(
						1, 0, bound_x - 1,
						0, 1, bound_y - 1)

			if(world_plane_transform)
				var vector2/to_center = new(bound_width / 2, bound_height / 2)
				return (to_center + (view_point - to_center) / world_plane_transform) * viewport_matrix
			else
				return view_point * viewport_matrix
