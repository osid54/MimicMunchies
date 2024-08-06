extends Node2D

@onready var coin = preload("res://assets/objects/coin.tscn")
@onready var player = preload("res://assets/characters/player.tscn")
@onready var enemy = preload("res://assets/characters/enemy.tscn")

var tiles := []
var score = 0:
	set(value):
		score = value
		%score.text = "SCORE: "+str("%05d" % score)
var muted := false:
	set(value):
		muted = value
		var bus_idx = AudioServer.get_bus_index("Master")
		AudioServer.set_bus_mute(bus_idx, muted)

func _process(_delta):
	if Input.is_action_pressed("mute"):
		muted = !muted

func _ready():
	$start.play()
	$Camera2D.zoom = Vector2(1,1) * 3/4
	for i in 8:
		tiles.append([])
		for j in 10:
			tiles[i].append("")
	
	var p = player.instantiate()
	p.pos = Vector2(randi_range(0,1),randi_range(0,1))
	tiles[p.pos.y+3][p.pos.x+4] = "player"
	add_child(p)
	
	makeCoin()
	
	var tween = get_tree().create_tween()
	tween.tween_property(%fade,"modulate",Color(1,1,1,0),1)

func makeCoin():
	if $coins.get_child_count() > 0 and randf() > 2/3.0:
		return
	var cPos = Vector2(randi_range(-4,5),randi_range(-3,4))
	while !checkTile(cPos,""):
		cPos = Vector2(randi_range(-4,5),randi_range(-3,4))
	var c = coin.instantiate()
	c.position = Vector2(cPos.x*128-64,cPos.y*128-64)
	$coins.call_deferred("add_child",c)
	tiles[cPos.y+3][cPos.x+4] = "coin"

func checkTile(pos,thing):
	return tiles[pos.y+3][pos.x+4] == thing
	
func checkTileWall(pos):
	return pos.x == -5 or pos.x == 6 or pos.y == -4 or pos.y == 5 or checkTile(pos,"enemy")

func makeEnemy(t):
	var ePos = Vector2(randi_range(-4,5),randi_range(-3,4))
	while !checkTile(ePos,""):
		ePos = Vector2(randi_range(-4,5),randi_range(-3,4))
	var e = enemy.instantiate()
	e.pos = ePos
	e.position = Vector2(ePos.x*128-64,ePos.y*128-64)
	e.eType = t
	$enemies.call_deferred("add_child",e)
	tiles[ePos.y+3][ePos.x+4] = "enemy"
	#print("enemy")

func moveEnemy():
	for e in $enemies.get_children():
		if randf() >= 2/3.0:
			e.rot()
			return
		e.move()
	#printRows()

func printRows():
	for row in tiles: 
		print(row)
	print("")

func gameOver():
	%endScore.text = str("%05d" % score)
	var tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(%end,"scale",Vector2(1,1),1)
	tween.tween_property(%end,"modulate",Color.WHITE,1)

func playAgain():
	var tween = get_tree().create_tween()
	tween.tween_property(%fade,"modulate",Color.WHITE,1)
	await get_tree().create_timer(1).timeout
	get_tree().reload_current_scene()
