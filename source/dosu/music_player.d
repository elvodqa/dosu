module dosu.music_player;

import bindbc.sdl;
import std.conv;
import std.format;
import std.stdio;


class MusicPlayer
{
    private Mix_Music* music;
    private bool playing = false;
    private double position = 0;
    private double startTime = 0;
    
    this()
    {
        SDL_Init(SDL_INIT_AUDIO);
        Mix_OpenAudio(44100, AUDIO_S16SYS, 2, 1024);
    }

    void play(string filename)
    {
        if (playing)
        {
            stop();
        }

        music = Mix_LoadMUS(filename.ptr);

        if (music == null)
        {
            throw new Exception(format("Failed to load music: %s", Mix_GetError()));
        }

        Mix_PlayMusic(music, 0);
        playing = true;
        startTime = SDL_GetTicks();
    }

    bool isPlaying()
    {
        return playing;
    }

    void pause()
    {
        Mix_PauseMusic();
        playing = false;
        position = getPosition();
    }

    void stop()
    {
        Mix_HaltMusic();
        Mix_FreeMusic(music);
        music = null;
        playing = false;
        position = 0;
    }

    void resume()
    {
        Mix_ResumeMusic();
        playing = true;
    }

    void setPosition(double ms)
    {
        if (playing)
        {
            if (ms < 0)
            {
                ms = 0;
            }
            //else if (ms > Mix_MusicLength(music))
            {
               //ms = Mix_MusicLength(music);
            }
            Mix_RewindMusic();
            Mix_SetMusicPosition(ms/1000);
            position = ms; 
        }
    }

    double getPosition()
    {
        position = Mix_GetMusicPosition(music);
        return 1;
    }

    
    
    void setVolume(int volume)
    {
        Mix_VolumeMusic(volume/100);
    }

    float getVolume()
    {
        return Mix_VolumeMusic(-1);
    }
}

