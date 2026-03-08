package main

import rl "vendor:raylib"

GRAVITY :: 900
JUMP_VEL :: -450

main :: proc() {

	rl.InitWindow(640, 480, "Samir Emulator")
	rl.SetTargetFPS(60)

	bird := rl.LoadImage("./boytoy.png")
	rl.ImageResize(&bird, 130, 80)
	texture := rl.LoadTextureFromImage(bird)
	rl.UnloadImage(bird)

	player_pos: f32 = 0
	player_vel: f32 = 0

	for (!rl.WindowShouldClose()) {

		dt := rl.GetFrameTime()

		if rl.IsKeyPressed(.SPACE) {
			player_vel = JUMP_VEL
		} else {
			player_vel += GRAVITY * dt
		}

		player_pos += player_vel * dt

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

		// rl.DrawRectangle(50, i32(player_pos), 60, 60, rl.RED)
		rl.DrawTexture(texture, 50, i32(player_pos), rl.WHITE)

		rl.EndDrawing()
	}

	rl.CloseWindow()

}
