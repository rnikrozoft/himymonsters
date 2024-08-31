extends RigidBody2D

var monster_id

var speed = 100
var direction = Vector2.ZERO
var is_moving = true
var timer = 0.0
var change_time = 2.0
var is_stopped = false

var farm

@onready var character = $AnimatedSprite2D
#var alert = Alert.new()

func _ready():
	#$Label.text = monster_id
	change_direction()
	set_random_change_time()
	character.play("walk")

func _on_monster_clicked(viewport, event, shape_idx):
	if Global.is_left_click(event):
		stop_movement()
		#if !Global.is_my_farm:
			#alert.steal_or_kill(self)

func _process(delta):
	if is_stopped:
		return
	
	timer += delta
	if timer >= change_time:
		timer = 0.0
		toggle_movement()
	
	if is_moving:
		handle_movement(delta)
		update_animation_direction()

func handle_movement(delta):
	var movement = direction * speed * delta
	var collision = move_and_collide(movement)
	if collision:
		direction = direction.bounce(collision.get_normal())

func update_animation_direction():
	character.flip_h = direction.x < 0

func toggle_movement():
	is_moving = !is_moving
	if is_moving:
		change_direction()
		set_random_change_time()
		character.play("walk")
	else:
		character.stop()
		character.play("idle")

func change_direction():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func set_random_change_time():
	change_time = randf_range(1.0, 3.0)

func stop_movement():
	is_stopped = true
	is_moving = false
	character.stop()
	character.play("idle")
