extends Node2D

@onready var coin = preload("res://assets/objects/coin.tscn")
@onready var player = preload("res://assets/characters/player.tscn")

var tiles := []

func _ready():
	for i in 8:
		tiles.append([])
		for j in 10:
			tiles[i].append("")
	
	var p = player.instantiate()
	p.pos = Vector2(randi_range(0,1),randi_range(0,1))
	tiles[p.pos.y+3][p.pos.x+4] = "player"
	add_child(p)
	
	makeCoin()

func makeCoin():
	if $coins.get_child_count() > 0 and randf() > 0.5:
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

func makeEnemy():
	pass

func moveEnemy():
	for enemy in $enemies.get_children():
		if randf() >= .5:
			enemy.rot()
		enemy.move()
