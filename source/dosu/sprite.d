module dosu.sprite;

import std.string;
import bindbc.sdl;
import std.stdio;

class Sprite {
    public SDL_Texture* texture;
    public SDL_Rect* rect;
    public SDL_Rect* clip;
    public SDL_Point* center;
    public double angle;
    public SDL_RendererFlip flip;

    this(SDL_Renderer* renderer, string path, int x, int y) {
        try {
            texture = IMG_LoadTexture(renderer, path.ptr);
        } catch (Exception e) {
            writeln("Error loading sprite: ", e.msg);
        }
        int w, h;
        SDL_QueryTexture(texture, null, null, &w, &h);
        rect = new SDL_Rect(x, y, w, h);
        clip = null;
        center = new SDL_Point(w / 2, h / 2);
        angle = 0;
        flip = SDL_FLIP_NONE;
    }

    this(SDL_Renderer* renderer, string path, int x, int y, int w, int h) {
        try {
            
            texture = IMG_LoadTexture(renderer, path.ptr);
        } catch (Exception e) {
            writeln("Error loading sprite: ", e.msg);
        }
        rect = new SDL_Rect(x, y, w, h);
        clip = null;
        center = new SDL_Point(w / 2, h / 2);
        angle = 0;
        flip = SDL_FLIP_NONE;
    }
    
    void draw(SDL_Renderer* renderer) {
        SDL_RenderCopyEx(renderer, texture, clip, rect, angle, center, flip);
    }
}