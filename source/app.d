import std.stdio;
import bindbc.sdl;
import dosu.sprite;
import dosu.text;

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


	if (SDL_Init(SDL_INIT_EVERYTHING) != 0)
	{
		writeln("Failed to initialize SDL: ", SDL_GetError());
	}
	
	auto flags = IMG_INIT_PNG | IMG_INIT_JPG;
	if(IMG_Init(flags) != flags) { 
		throw new Exception("Failed to initialize SDL_image");
	}
	IMG_Init(flags);

	if(TTF_Init() == -1) { 
		throw new Exception("Failed to initialize SDL_ttf");
	}
	
	
	auto window = SDL_CreateWindow(
		"dosu!",
		SDL_WINDOWPOS_CENTERED,
		SDL_WINDOWPOS_CENTERED,
		1200, 720,
		SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE
	);

	if (!window) {
		throw new Exception("Failed to create window");
	}

	auto renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
	if (!renderer) {
		throw new Exception("Failed to create renderer");
	}
	
	
	Sprite sprite = new Sprite(renderer, "./res/skin/hitcircle.png", 0, 0);
	Text t1 = new Text("Deneme sdfd dsf ds  dsf fdsf ds dsf d", "res/fonts/p5hatty.ttf", 50, 100, 100, Alignment.Left);
	
	SDL_SetRenderDrawColor(renderer, 88, 85, 83, 255);
	bool running = true;
	SDL_Event event; 
	while (running) {
		while (SDL_PollEvent(&event)) {
			switch (event.type) {
				case SDL_QUIT:
					running = false;
					break;
				default:
					break;
			}
		}


		SDL_RenderClear(renderer);

		sprite.draw(renderer);
		t1.draw(renderer, 500);
		t1.text = t1.text ~ "a";
		t1.size

		SDL_RenderPresent(renderer);

		
	}
}
