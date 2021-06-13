using FreeTypeAbstraction

"""
    xheight(font::FTFont)

The height of the letter x in the given font, i.e. the height of the letters
without neither ascender nor descender.
"""
xheight(font::FTFont) = inkheight(TeXChar('x', font))
thickness(font::FTFont) = font.underline_thickness / font.units_per_EM

# TODO This whole file probably need rework
abstract type TeXFontSet end

struct NewCMFontSet <: TeXFontSet
    regular::FTFont
    italic::FTFont
    math::FTFont
end

function get_math_char(char::Char, fontset)
    if char in raw".;:!?()[]"
        TeXChar(char, fontset.regular)
    else
        TeXChar(char, fontset.italic)
    end
end

get_function_char(char::Char, fontset) = TeXChar(char, fontset.regular)
get_number_char(char::Char, fontset) = TeXChar(char, fontset.regular)

"""
    get_symbol_char(char, command, fontset)

Create a TeXChar for the character representing a symbol in the given
font set. The argument `command` contains the LaTeX command corresponding to the
character, to allow supporting non-unicode font sets.
"""
# TODO Substitute minus sign
get_symbol_char(char::Char, command, fontset) = TeXChar(char, fontset.math)

thickness(fontset) = thickness(fontset.math)
sqrt_thickness(fontset) = thickness(fontset.math)

xheight(fontset) = xheight(fontset.regular)

load_font(name) = FTFont(joinpath(@__DIR__, "..", "..", "assets", "fonts", name))

# TODO Somehow defining a constant messed up some pointers
load_fontset(::Type{NewCMFontSet}) = NewCMFontSet(
    load_font("NewCM10-Regular.otf"),
    load_font("NewCM10-Italic.otf"),
    load_font("NewCMMath-Regular.otf")
)
