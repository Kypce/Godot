extends Area2D

@export var speed = -250

# Initializes the start position of the bullet as we want it to start with the player/mob
func start(pos):
	position = pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed * delta

# Function for detecting when a bullet collides with another object with signal area_entered from Area2D
func _on_area_entered(area):
	if area.is_in_group("enemies"):
		area.explode()
		queue_free()

# Function to delete any bullets that go offscreen with screen_exited signal from VisibleOnScreenNotifier2D
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
