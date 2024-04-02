extends NavigationRegion3D

func update_navigation_mesh():
# use bake and update function of region
	var on_thread: bool = true
	bake_navigation_mesh(on_thread)
