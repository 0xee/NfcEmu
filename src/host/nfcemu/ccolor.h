// ccolor.h

#include <stdio.h>

#define CC_CONSOLE_COLOR_DEFAULT "\033[0m"
#define CC_FORECOLOR(C) "\033[" #C "m"
#define CC_BACKCOLOR(C) "\033[" #C "m"
#define CC_ATTR(A) "\033[" #A "m"
enum Color
{
    Black,
    Red,
    Green,
    Yellow,
    Blue,
    Magenta,
    Cyan,
    White,
    Default = 9
};

enum Attributes
{
    Reset,
    Bright,
    Dim,
    Underline,
    Blink,
    Reverse,
    Hidden
};

class cc
{


public:

    class fore
    {
    public:
        static const char *black;
        static const char *blue;
        static const char *red;
        static const char *magenta;
        static const char *green;
        static const char *cyan;
        static const char *yellow;
        static const char *white;
        static const char *console;

        static const char *lightblack;
        static const char *lightblue;
        static const char *lightred;
        static const char *lightmagenta;
        static const char *lightgreen;
        static const char *lightcyan;
        static const char *lightyellow;
        static const char *lightwhite;
    };

    class back
    {
    public:
        static const char *black;
        static const char *blue;
        static const char *red;
        static const char *magenta;
        static const char *green;
        static const char *cyan;
        static const char *yellow;
        static const char *white;
        static const char *console;

        static const char *lightblack;
        static const char *lightblue;
        static const char *lightred;
        static const char *lightmagenta;
        static const char *lightgreen;
        static const char *lightcyan;
        static const char *lightyellow;
        static const char *lightwhite;
    };

    static char *color(int attr, int fg, int bg);
    static const char *console;
    static const char *underline;

    static void Enable(bool const en) { enabled = en; }
    static bool Enabled() { return enabled; }

private:
    static bool enabled;

};

