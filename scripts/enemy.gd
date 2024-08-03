extends Area2D

@onready var mainScene = get_parent()
var pos := Vector2()

func move(dir):
	var newPos = pos + Vector2(randi_range(-1,1),randi_range(-1,1))
	if !mainScene.checkTileWall(newPos):
		match dir:
			Vector2(0,1):
				$AnimationPlayer.play("S")
			Vector2(0,-1):
				$AnimationPlayer.play("N")
			Vector2(1,0):
				$AnimationPlayer.play("E")
			Vector2(-1,0):
				$AnimationPlayer.play("W")
		var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(self,"position",position+dir*128,1)
		endMove()
		mainScene.tiles[pos.y+3][pos.x+4] = ""
		mainScene.tiles[newPos.y+3][newPos.x+4] = "player"
		pos = newPos
		$Label.text = str(pos)

func endMove():
	await get_tree().create_timer(1.0).timeout
	$AnimationPlayer.play("idle")

func rot():
	pass
