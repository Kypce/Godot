extends Node2D

@onready var start_button = $CanvasLayer/CenterContainer/Start
@onready var game_over = $CanvasLayer/CenterContainer/GameOver

var enemy = preload("res://enemy.tscn")

var score = 0
var max_shield = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.hide()
	$Player.can_shoot = false
	start_button.show()
	game_over.hide()

func _on_enemy_died(value):
	score += value
	$CanvasLayer/UI.update_score(score)

func spawn_enemies():
	for x in range(9):
		for y in range(3):
			var e = enemy.instantiate()
			var pos = Vector2(x * (16 + 8) + 24, 16 * 4 + y * 16)
			add_child(e)
			e.start(pos)
			e.died.connect(_on_enemy_died)

func _on_start_pressed():
	start_button.hide()
	new_game()
	
func new_game():
	score = 0
	$CanvasLayer/UI.update_score(score)
	
	$Player.shield = max_shield
	
	$Player.start()
	spawn_enemies()

func _on_player_died():
	get_tree().call_group("enemies", "queue_free")
	game_over.show()
	$Player.can_shoot = false
	
	await get_tree().create_timer(2).timeout
	game_over.hide()
	await get_tree().create_timer(1).timeout
	start_button.show()
