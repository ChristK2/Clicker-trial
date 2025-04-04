extends Area2D

@onready var sprite = $Coin
@onready var score_counter: Node = %ScoreCounter
@onready var pickup_coin: AudioStreamPlayer2D = $PickupCoin
@onready var vfx: GPUParticles2D = $vfx

var speed_multiplier = 1.2  # Base speed
var last_click_time = 0.0   # Tracks the time between clicks
var decay_rate = 0.9       # How fast the speed decreases per second
var frame_timer = 0.0       # Tracks animation timing
var idle_reset_timer = 0.0  # Timer
var is_animating = false    # Control start animation (When clicked)

func _ready():
	sprite.frame = 0
	is_animating = false
	vfx.emitting = false

func _process(delta):
	if is_animating:
		if speed_multiplier > 0.0:
			speed_multiplier = max(speed_multiplier - decay_rate * delta, 0.0) # Gradually reduce speed

			frame_timer += speed_multiplier * delta
			if frame_timer >= 1.0 / sprite.sprite_frames.get_frame_count("turn"):
				frame_timer = 0.0
				sprite.frame = (sprite.frame + 1) % sprite.sprite_frames.get_frame_count("turn") # Animation based on speed

			# Track inactivity time 👇
			idle_reset_timer = 0.0  # Reset the timer while animation is active
		else:
			idle_reset_timer += delta
			if idle_reset_timer >= 3.0:
				sprite.frame = 0  # Reset to the first frame
				idle_reset_timer = 0.0  # Reset the timer
				is_animating = false    # Stop animating until next click

func _on_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var current_time = Time.get_ticks_msec() / 1000.0
		var click_interval = current_time - last_click_time
		last_click_time = current_time
		score_counter.add_money()

		# Activate animation
		if not is_animating:
			is_animating = true

		# Increase speed based on click speed
		if click_interval < 0.5:
			speed_multiplier = min(speed_multiplier + 0.5, 5.0)
		else:
			speed_multiplier = 1.2  # Reset if clicks slow down

		idle_reset_timer = 0.0 # Reset idle timer when clicked
		
		if not pickup_coin.playing:
			pickup_coin.play()
			
