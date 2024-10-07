extends Area2D

signal died
signal shield_changed

@export var speed = 150
@export var max_shield = 10
var shield = max_shield:
	set = set_shield

# Bullet variables
@export var cooldown = 0.25
@export var bullet_scene : PackedScene
var can_shoot

@onready var screensize = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	start()

# This places the player
func start():
	position = Vector2(screensize.x / 2, screensize.y - 64)
	can_shoot = true
	show()
	$GunCooldown.wait_time = cooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = Input.get_vector("left", "right", "up", "down")
	if input.x > 0:		# Set animation for right
		$Ship.frame = 2
		$Ship/Boosters.animation = "right"
	elif input.x < 0:	# Set animation for left
		$Ship.frame = 0
		$Ship/Boosters.animation = "left"
	else:				# Set animation for forward/back
		$Ship.frame = 1
		$Ship/Boosters.animation = "forward"
		
	position += input * speed * delta
	position = position.clamp(Vector2(8, 8), screensize - Vector2(8, 8))
	
	if Input.is_action_pressed("shoot"):
		shoot()

func shoot():
	if not can_shoot:	# Checks if player is allowed to shoot (on cooldown = can't)
		return
		
	# Set the can_shoot to false and start the cooldown timer
	can_shoot = false
	$GunCooldown.start()
	# Create a new bullet by calling the bullet_scene and set the position by calling the start() func
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)		# We attach the bullets to the SceneTree root and not the ship as if we attach it to the ship the bullets would be "attached" to it when it moves
	b.start(position + Vector2(0, -8))
	
func set_shield(value):
	shield = min(max_shield, value)
	shield_changed.emit(max_shield, shield)
	if shield <= 0:
		hide()
		died.emit()
	
func _on_gun_cooldown_timeout():
	can_shoot = true

func _on_area_entered(area):
	if area.is_in_group("enemies"):
		area.explode()
		shield -= max_shield / 2
