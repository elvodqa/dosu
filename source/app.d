import std.stdio;
import std.conv;
import bindbc.sdl;
import dosu.sprite;
import dosu.text;
import dosu.music_player;

void main()
{
	SDLSupport sdlStatus = loadSDL();
	if (sdlStatus != sdlSupport)
	{
		writeln("Failed loading SDL: ", sdlStatus);
		throw new Exception("Failed loading SDL");
	}

	if(loadSDLImage() < sdlImageSupport) { 
		throw new Exception("Failed loading BindBC SDL_image");
	}

	if (loadSDLTTF() < sdlTTFSupport) { 
		throw new Exception("Failed loading BindBC SDL_ttf");
	}

	writeln(sdlMixerSupport);
	if (loadSDLMixer() < sdlMixerSupport) { 
		throw new Exception("Failed loading BindBC SDL_mixer");
	}

	if (SDL_Init(SDL_INIT_EVERYTHING) != 0)
	{
		writeln("Failed to initialize SDL: ", SDL_GetError());
	}
	
	auto flags = IMG_INIT_PNG | IMG_INIT_JPG;
	if(IMG_Init(flags) != flags) { 
		throw new Exception("Failed to initialize SDL_image");
	}

	if(TTF_Init() == -1) { 
		throw new Exception("Failed to initialize SDL_ttf");
	}

	if (Mix_Init(MIX_INIT_MP3) == -1) { 
		throw new Exception("Failed to initialize SDL_mixer");
	}
	
	auto window = SDL_CreateWindow(
		"dosu!",
		SDL_WINDOWPOS_CENTERED,
		SDL_WINDOWPOS_CENTERED,
		1200, 720,	
		SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE | SDL_WINDOW_MAXIMIZED
	);

	if (!window) {
		throw new Exception("Failed to create window");
	}

	auto renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
	if (!renderer) {
		throw new Exception("Failed to create renderer");
	}
	
	int w, h;
	SDL_GetWindowSize(window, &w, &h);
	Sprite sprite = new Sprite(renderer, "./res/skin/hitcircle.png", w/2-200, h/2-200, 400, 400);
	Text logoText = new Text("DOSU!", "res/fonts/p5hatty.ttf", 100, w/2, h/2, Alignment.Left);
	logoText.x = w/2 - logoText.w/2;
	logoText.y = h/2 - logoText.h/2;
	
	MusicPlayer songPlayer = new MusicPlayer();
	songPlayer.play("./res/surprise.mp3");
	
	
	SDL_SetRenderDrawColor(renderer, 88, 85, 83, 255);
	bool running = true;
	SDL_Event event; 
	while (running) {
		if (SDL_PollEvent(&event)) {
			switch (event.type) {
				case SDL_QUIT:
					running = false;
					break;
				// resize
				case SDL_WINDOWEVENT:
					if (event.window.event == SDL_WINDOWEVENT_RESIZED) {
						SDL_GetWindowSize(window, &w, &h);
						sprite.rect.x = w/2-200;
						sprite.rect.y = h/2-200;
						logoText.x = w/2 - logoText.w/2;
						logoText.y = h/2 - logoText.h/2;
					}
					break;

				// key pressed
				case SDL_KEYDOWN:
					switch (event.key.keysym.sym) {
						case SDLK_ESCAPE:
							running = false;
							break;
						case SDLK_SPACE:
							if (!songPlayer.isPlaying()) {
								songPlayer.resume();
							} else {
								songPlayer.pause();
							}
							break;
						case SDLK_LEFT:
							songPlayer.setPosition(songPlayer.getPosition() - 10_000);
							break;
						case SDLK_RIGHT:
							songPlayer.setPosition(songPlayer.getPosition() + 10_000);
							break;
						default:
							break;
					}
					break;
				default:
					break;
			}
		}
		sprite.angle += 10;

		SDL_RenderClear(renderer);

		sprite.draw(renderer);
		logoText.draw(renderer);
		logoText.text = "DOSU! " ~ (songPlayer.getPosition()/1000).to!string;

		SDL_RenderPresent(renderer);
	}
}


