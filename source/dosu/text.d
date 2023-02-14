module dosu.text;

import std.string;
import std.stdio;
import bindbc.sdl;

enum Alignment {
    Left,
    Center,
    Right
}

class Text {
    
    public string text;
    public int x;
    public int y;
    public int w;
    public int h;
    public int size;
    public Alignment alignment;
    public SDL_Color color;
    public bool visible;
    public string fontName;

    this(string text, string font, int size, int x, int y, Alignment aling) {
        this.text = text;
        this.x = x;
        this.y = y;
        this.size = size;
        this.alignment = aling;
        this.color = SDL_Color(255, 255, 255, 255);
        this.visible = true;
        this.fontName = font;
    }


    void draw(SDL_Renderer* renderer) {
        auto font = TTF_OpenFont(fontName.ptr, size);
        if (font is null) {
            throw new Exception("Failed to load font");
        }

        auto surface = TTF_RenderText_Blended(font, text.ptr, color);
        if (surface is null) {
            throw new Exception("Failed to render text");
        }

        auto texture = SDL_CreateTextureFromSurface(renderer, surface);
        if (texture is null) {
            throw new Exception("Failed to create texture");
        }

        SDL_QueryTexture(texture, null, null, &w, &h);

        SDL_Rect dest;
        final switch (alignment) {
            case Alignment.Left:
                dest = SDL_Rect(x, y, w, h);
                break;
            case Alignment.Center:
                dest = SDL_Rect(x - w / 2, y, w, h);
                break;
            case Alignment.Right:
                dest = SDL_Rect(x - w, y, w, h);
                break;
        }

        SDL_RenderCopy(renderer, texture, null, &dest);

        SDL_FreeSurface(surface);
        SDL_DestroyTexture(texture);
        TTF_CloseFont(font);
    }


    void draw_wrapped(SDL_Renderer* renderer, int width) {
        auto font = TTF_OpenFont(fontName.ptr, size);
        if (font is null) {
            throw new Exception("Failed to load font");
        }

        auto surface = TTF_RenderText_Blended_Wrapped(font, text.ptr, color, width);
        if (surface is null) {
            throw new Exception("Failed to render text");
        }

        auto texture = SDL_CreateTextureFromSurface(renderer, surface);
        if (texture is null) {
            throw new Exception("Failed to create texture");
        }

        SDL_Rect dest;
        final switch (alignment) {
            case Alignment.Left:
                dest = SDL_Rect(x, y, w, h);
                break;
            case Alignment.Center:
                dest = SDL_Rect(x - w / 2, y, w, h);
                break;
            case Alignment.Right:
                dest = SDL_Rect(x - w, y, w, h);
                break;
        }
        
        SDL_RenderCopy(renderer, texture, null, &dest);

        SDL_FreeSurface(surface);
        SDL_DestroyTexture(texture);
        TTF_CloseFont(font);
    }

    void draw(SDL_Renderer* renderer, int wrapWidth) {
         auto font = TTF_OpenFont(fontName.ptr, size);
        if (font is null) {
            throw new Exception("Failed to load font");
        }

        auto surface = TTF_RenderText_Blended_Wrapped(font, text.ptr, color, wrapWidth);
        if (surface is null) {
            throw new Exception("Failed to render text");
        }

        auto texture = SDL_CreateTextureFromSurface(renderer, surface);
        if (texture is null) {
            throw new Exception("Failed to create texture");
        }


        SDL_QueryTexture(texture, null, null, &w, &h);
        SDL_Rect destination = SDL_Rect(x, y, w, h);
        SDL_RenderCopy(renderer, texture, null, &destination);

        SDL_FreeSurface(surface);
        SDL_DestroyTexture(texture);
        TTF_CloseFont(font);
    } 
    
    
    
}