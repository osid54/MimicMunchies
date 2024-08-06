extends Sprite2D

var moving := false
@onready var mainScene = get_parent()
var movesLeft := randi_range(3,7):
	set(value):
		movesLeft = value
		if movesLeft == 0:
			mainScene.makeCoin()
			movesLeft = randi_range(3,7)
var enemiesMove := 10:
	set(value):
		enemiesMove = value
		if enemiesMove == 0 and nextEnemy <= 2:
			mainScene.makeEnemy(nextEnemy)
			nextEnemy += 1
			enemiesMove = 10 + nextEnemy * 5
var nextEnemy := 0
var pos := Vector2()

func _ready():
	#printRows()
	position = pos*64+Vector2(64,64)*(pos-Vector2(1,1))
	#$Label.text = str(pos)

func _process(_delta):
	if not moving:
		if Input.is_action_pressed("down"):
			move(Vector2(0,1))
		elif Input.is_action_just_pressed("up"):
			move(Vector2(0,-1))
		elif Input.is_action_just_pressed("right"):
			move(Vector2(1,0))
		elif Input.is_action_just_pressed("left"):
			move(Vector2(-1,0))

func move(dir):
	var newPos = pos + dir
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
		moving = true
		tween.tween_property(self,"position",position+dir*128,1)
		endMove()
		mainScene.tiles[pos.y+3][pos.x+4] = ""
		mainScene.tiles[newPos.y+3][newPos.x+4] = "player"
		pos = newPos
		$Label.text = str(pos)

func endMove():
	await get_tree().create_timer(1.0).timeout
	$AnimationPlayer.play("idle")
	if mainScene.get_node("enemies").get_child_count() > 0:
		mainScene.moveEnemy()
		await get_tree().create_timer(1.0).timeout
	moving = false
	movesLeft -= 1
	enemiesMove -= 1
	#printRows()

func areaEntered(area):
	if area.isCoin:
		await get_tree().create_timer(.1).timeout
		area.queue_free()
		mainScene.makeCoin()
