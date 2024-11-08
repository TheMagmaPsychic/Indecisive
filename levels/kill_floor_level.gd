extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body_: Node3D) -> void:
	$CSGCombiner3D/jump1/SpotLight3D2.visible = false
	$SpotLight3D.visible = false
	$CSGCombiner3D/jump2/SpotLight3D2.visible = true


func _on_jump2_area_3d_body_entered(body: Node3D) -> void:
	$CSGCombiner3D/jump2/SpotLight3D2.visible = false
	$CSGCombiner3D/jump3/SpotLight3D2.visible = true


func _on_jump3_area_3d_body_entered(body: Node3D) -> void:
	$CSGCombiner3D/jump3/SpotLight3D2.visible = false
	$CSGCombiner3D/jump4/SpotLight3D2.visible = true


func _on_killzone_entered(body: Node3D) -> void:
	body.global_position = Vector3(0,10,-34)
	body.velocity = Vector3.ZERO
