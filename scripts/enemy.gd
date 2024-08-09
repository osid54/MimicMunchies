extends Area2D

@onready var mainScene = get_parent().get_parent()
var pos := Vector2()
var direction := 0
var eType := 0

var eTypes = ["knight","archer","mage"]

func _ready():
	#print(pos)
	direction = randi()
	$attackJoint.rotation = getDir()*PI/2
	$Sprite2D.texture = load("res://src/sprites/enemies/"+eTypes[eType]+".png")
	$attackJoint/attack.eType = eType
	$attackJoint/attack.adjust()
	$AnimationPlayer.play("spawn")
	await $AnimationPlayer.animation_finished
	modulate = Color.WHITE
	$AnimationPlayer.play("idle")


func move():
	await get_tree().create_timer(randf_range(0,.3)).timeout
	var newPos = pos
	$attackJoint/attack.disAll()
	match getDir():
		0:
			newPos += Vector2(0,-1)
			if !mainScene.checkTileWall(newPos):
				$AnimationPlayer.play("S")
			else:
				rot()
				return
		2:
			newPos += Vector2(0,1)
			if !mainScene.checkTileWall(newPos):
				$AnimationPlayer.play("N")
			else:
				rot()
				return
		3:
			newPos += Vector2(-1,0)
			if !mainScene.checkTileWall(newPos):
				$AnimationPlayer.play("E")
			else:
				rot()
				return
		1:
			newPos += Vector2(1,0)
			if !mainScene.checkTileWall(newPos):
				$AnimationPlayer.play("W")
			else:
				rot()
				return
		_:
			print("uh oh")
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self,"position",position+(newPos-pos)*128,1)
	endMove()
	mainScene.tiles[pos.y+3][pos.x+4] = ""
	mainScene.tiles[newPos.y+3][newPos.x+4] = "enemy"
	pos = newPos
	#$Label.text = str(pos)

func endMove():
	await get_tree().create_timer(.1).timeout
	$move.play()
	await get_tree().create_timer(.9).timeout
	$AnimationPlayer.play("idle")

func rot():
	$attackJoint/attack.disAll()
	var turn = [-1,1].pick_random()
	direction += turn
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($attackJoint,"rotation",$attackJoint.rotation+turn*PI/2,1)
	await get_tree().create_timer(.1).timeout
	$move.play()
	await get_tree().create_timer(.9).timeout
	$attackJoint.rotation = getDir()*PI/2
	$AnimationPlayer.play("idle")

func getDir():
	return direction % 4
