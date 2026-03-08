package main

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

// Constant declarations

WINDOW_HEIGHT :: 480
WINDOW_WIDTH :: 640

MAX_FRAMES :: 4

GRAVITY :: 900
JUMP_VEL :: -450

// struct declaration for animation

Animation :: struct {
	frames:         [MAX_FRAMES]rl.Texture2D,
	curr_frame:     i8,
	frame_time:     f32,
	frame_duration: f32,
}

main :: proc() {

	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Samir Emulator")
	rl.SetTargetFPS(60)

	bg_texture := rl.LoadTexture("./bg.jpeg")

	bird := Animation {
		frames         = {},
		curr_frame     = 0,
		frame_time     = 0,
		frame_duration = 0.15,
	}

	for i in 0 ..< MAX_FRAMES {
		path := strings.clone_to_cstring(fmt.tprintf("./sprites/frame-%d.png", i + 1))
		img := rl.LoadImage(path)
		rl.ImageResize(&img, 130, 90)
		bird.frames[i] = rl.LoadTextureFromImage(img)
		rl.UnloadImage(img)
	}

	player_pos: f32 = 0
	player_vel: f32 = 0

	for (!rl.WindowShouldClose()) {

		dt := rl.GetFrameTime()

		bird.frame_time += dt

		if (bird.frame_time >= bird.frame_duration) {
			bird.frame_time = 0
			bird.curr_frame = (bird.curr_frame + 1) % MAX_FRAMES
		}

		if rl.IsKeyPressed(.SPACE) {
			player_vel = JUMP_VEL
		} else {
			player_vel += GRAVITY * dt
		}

		player_pos += player_vel * dt

		rl.BeginDrawing()

		rl.ClearBackground(rl.BLACK)

		source := rl.Rectangle{0, 0, f32(bg_texture.width), f32(bg_texture.height)}
		dest := rl.Rectangle{0, 0, f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())}

		rl.DrawTexturePro(bg_texture, source, dest, {0, 0}, 0, rl.WHITE)
		rl.DrawTexture(bird.frames[bird.curr_frame], 50, i32(player_pos), rl.WHITE)

		rl.EndDrawing()
	}

	for i in 0 ..< MAX_FRAMES {
		rl.UnloadTexture(bird.frames[i])
	}

	rl.UnloadTexture(bg_texture)

	rl.CloseWindow()

}
