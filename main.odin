package main

import    "core:fmt"
import    "core:strings"
import    "core:math/rand"
import rl "vendor:raylib"

// Constant declarations

WINDOW_WIDTH  :: 720
WINDOW_HEIGHT :: 480

PLAYER_H :: 70
PLAYER_W :: 90

PIPE_W     :: 80
MOVE_SPEED :: 200
PIPE_SPACE :: 150
PIPE_TIME  :: 2

GRAVITY  :: 900
JUMP_VEL :: -450

MAX_FRAMES :: 4

// struct declaration for animation

Animation :: struct {
	frames:         [MAX_FRAMES]rl.Texture2D,
	curr_frame:     i8,
	frame_time:     f32,
	frame_duration: f32,
}

// struct declaration for pipes

Pipe :: struct {
	pos: f32,
	gap: f32,
}

main :: proc() {

	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "BoyToy's Search for Love")
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
		rl.ImageResize(&img, PLAYER_W, PLAYER_H)
		bird.frames[i] = rl.LoadTextureFromImage(img)
		rl.UnloadImage(img)
	}

	player_pos: f32 = 0
	player_vel: f32 = 0
	player_alive: bool = true

	pipe_timer : f32 = 0
	pipe_list : [dynamic] Pipe

	for (!rl.WindowShouldClose()) {

		dt := rl.GetFrameTime()

		if (player_alive) {

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

			if (player_pos >= WINDOW_HEIGHT - PLAYER_W) {
				player_alive = false
			}

			pipe_timer += dt

			if (pipe_timer > PIPE_TIME) {

				append(&pipe_list, Pipe {
					pos = WINDOW_WIDTH,
					gap = rand.float32_range(20, WINDOW_HEIGHT - 120 - PIPE_W)
				})
				
				pipe_timer = 0
			}

			#reverse for &pipe, i in pipe_list {
				pipe.pos -= MOVE_SPEED*dt

				if pipe.pos < -PIPE_W {
					unordered_remove(&pipe_list, i)
				}
			}

		} 
		else {
			if (rl.IsKeyPressed(.SPACE)) {
				player_pos = WINDOW_HEIGHT * 0.5 - PLAYER_H * 0.5
				player_vel = JUMP_VEL
				player_alive = true
			}
		}

		rl.BeginDrawing()

		rl.ClearBackground(rl.BLACK)

		// rl.DrawRectangle(50, i32(player_pos), PLAYER_SIZE, PLAYER_SIZE, rl.BLUE)

		source := rl.Rectangle{0, 0, f32(bg_texture.width), f32(bg_texture.height)}
		dest := rl.Rectangle{0, 0, f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())}

		rl.DrawTexturePro(bg_texture, source, dest, {0, 0}, 0, rl.WHITE)
		rl.DrawTexture(bird.frames[bird.curr_frame], 50, i32(player_pos), rl.WHITE)

		for pipe in pipe_list {
			rl.DrawRectangle(i32(pipe.pos), 0, PIPE_W, i32(pipe.gap), rl.GREEN)
			rl.DrawRectangle(i32(pipe.pos), i32(pipe.gap + PIPE_SPACE), PIPE_W, i32(WINDOW_HEIGHT - PIPE_SPACE - pipe.gap), rl.GREEN)
		}

		if (!player_alive) {
			// look into better colors
			rl.DrawText("You Ded", 260, 150, 30, rl.RED)
			rl.DrawText("Press SPACE to Respawn", 190, 200, 20, rl.WHITE)

			// replace this with a dead bird image later
			rl.DrawRectangle(50, WINDOW_HEIGHT - PLAYER_H, PLAYER_W, PLAYER_H, rl.RED)
		}

		rl.EndDrawing()
	}

	// for i in 0 ..< MAX_FRAMES {
	// 	rl.UnloadTexture(bird.frames[i])
	// }
	//
	// rl.UnloadTexture(bg_texture)

	rl.CloseWindow()

}
