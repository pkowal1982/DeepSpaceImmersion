@tool
extends EditorScenePostImport


func _post_import(root: Object) -> Object:
	add_rigid_bodies(root)
	add_collision_shapes(root)
	set_owner_recursively(root, root)
	return root


func add_collision_shapes(parent: Node) -> void:
	for node in parent.get_children():
		var name := str(node.name)
		if name.ends_with("-colonly") and node is Node3D:
			var collision_shape: CollisionShape3D = add_collision_shape(node)
			# Blender exporter has error in children transform output
			# Geometry needs to have center at the same place as parent collision shape
			clear_transform_on_children(collision_shape)
		add_collision_shapes(node)


func add_collision_shape(node: Node3D) -> CollisionShape3D:
	var collision_shape: CollisionShape3D = CollisionShape3D.new()
	var node_name := str(node.name)
	var name := node_name.substr(0, node_name.rfind("-colonly"))
	var basis: Basis = node.transform.basis
	collision_shape.transform = node.transform
	collision_shape.transform.basis = collision_shape.transform.basis.orthonormalized()
	collision_shape.name = name
	if name.ends_with("-Box"):
		var box: BoxShape3D = BoxShape3D.new()
		box.size = basis.get_scale() * 2
		collision_shape.shape = box
	if name.ends_with("-Sphere"):
		var sphere: SphereShape3D = SphereShape3D.new()
		sphere.radius = basis.get_scale().x
		collision_shape.shape = sphere
	elif name.ends_with("-Capsule"):
		var capsule: CapsuleShape3D = CapsuleShape3D.new()
		capsule.radius = basis.get_scale().x
		capsule.height = 2 * basis.get_scale().y
		collision_shape.shape = capsule
	node.replace_by(collision_shape)
	return collision_shape


func clear_transform_on_children(parent: Node3D) -> void:
	for node in parent.get_children():
		if node is Node3D:
			node.transform = Transform3D.IDENTITY


func add_rigid_bodies(parent: Node3D) -> void:
	for node in parent.get_children():
		var name := str(node.name)
		if name.ends_with("-Rigid") and node is Node3D:
			add_rigid_body(node)
		add_rigid_bodies(node)


func add_rigid_body(node: Node3D) -> void:
	var rigid_body := RigidDynamicBody3D.new()
	var node_name := str(node.name)
	var name := node_name.substr(0, node_name.rfind("-Rigid"))
	rigid_body.transform = node.transform
	rigid_body.name = name
	node.replace_by(rigid_body)


func create_physics_body() -> PhysicsBody3D:
	return StaticBody3D.new()


func set_owner_recursively(parent: Node, root: Node) -> void:
	for node in parent.get_children():
		node.owner = root
		set_owner_recursively(node, root)
