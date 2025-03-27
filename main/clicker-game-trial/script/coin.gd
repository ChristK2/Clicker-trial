extends Area2D

@onready var sprite = $Coin

var speed_multiplier = 1.0  # Base speed
var last_click_time = 0.0   # Tracks the time between clicks
var decay_rate = 0.5        # How fast the speed decreases per second
var is_animating = false    # To track if the animation is playing

func _process(delta):
	# Gradually reduce the speed if no recent clicks
	if speed_multiplier > 0.0:
		speed_multiplier = max(speed_multiplier - decay_rate * delta, 0.0)
		sprite.speed_scale = speed_multiplier

		# Once the speed hits zero, the animation will stop at the current frame
		if speed_multiplier <= 0.01 and is_animating:
			sprite.speed_scale = 0.0  # Stop the animation's movement
			is_animating = false  # Mark animation as stopped

func _on_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var current_time = Time.get_ticks_msec() / 1000.0
		var click_interval = current_time - last_click_time
		last_click_time = current_time

		# Increase speed if clicks are fast
		if click_interval < 0.5:
			speed_multiplier = min(speed_multiplier + 0.5, 5.0)
		else:
			speed_multiplier = 1.0  # Reset if clicks slow down
		
		# Adjust animation speed
		sprite.speed_scale = speed_multiplier

		# If the animation is not playing, start it from the current frame
		if not sprite.is_playing():
			sprite.play("turn", true)  # Keep playing from current frame without resetting
			is_animating = true  # Animation is playing
