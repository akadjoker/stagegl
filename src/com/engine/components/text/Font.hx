package com.engine.components.text;

import com.engine.misc.BlendMode;
import com.engine.misc.Clip;
import com.engine.misc.Util;
import com.engine.render.SpriteBatch;
import com.engine.render.Texture;



import openfl.geom.Matrix;
import flash.display.Graphics;
import flash.geom.Point;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import openfl.Assets;
using StringTools;


/**
 * A bitmap font, created in any tool that exports the BMFont format, such as the original BMFont
 * editor, Hiero, or Glyph Designer.
 */
class Font
{
    /**
     * The name that was used to load this font.
     */
    public var name (default, null) :String;

    /**
     * The size of this font, in pixels.
     */
    public var size (default, null) :Float;

    /**
     * The vertical distance between each line of text in this font, in pixels.
     */
    public var lineHeight (default, null) :Float;

    /**
     * Parses a font using files in an asset pack.
     * @param name The path to the font within the asset pack, excluding the .fnt suffix.
     */
    public function new ( name :String)
    {
        this.name = name;
  
        reload();

    }

    /**
     * Splits text into multiple lines that fit into a given width when displayed using this font.
     */
    public function splitLines (text :String, maxWidth :Float) :Array<String>
    {
        var glyphs = getGlyphs(text);
        var line = "";
        var lines = [];
        var x = 0;
        var ii = 0;
        var ll = glyphs.length;
        var lastSpaceIdx = -1;

        while (ii < ll) {
            var glyph = glyphs[ii];
            if (x + glyph.clip.width > maxWidth) {
                // Ran off the edge, add a line
                x = 0;
                var space = line.lastIndexOf(" ");
                if (space >= 0) {
                    // Backtrack to the beginning of the last word
                    lines.push(line.substr(0, space));
                    ii = lastSpaceIdx + 1;
                } else {
                    lines.push(line);
                }
                line = "";

            } else {
                if (glyph.charCode == " ".code) {
                    lastSpaceIdx = ii;
                }
                line += String.fromCharCode(glyph.charCode);
                x += glyph.xAdvance;
                ++ii;
                if (ii != ll) {
                    var nextGlyph = glyphs[ii];
                    x += glyph.getKerning(nextGlyph.charCode);
                }
            }
        }
        lines.push(line);

        return lines;
    }

    /**
     * Get the list of Glyphs that make up a string. Characters without glyphs in this font will be
     * missing from the list.
     */
    public function getGlyphs (text :String) :Array<Glyph>
    {
        var list = [];
        for (ii in 0...text.length) {
            var charCode = text.fastCodeAt(ii);
            var glyph = _glyphs.get(charCode);
            if (glyph != null) {
                list.push(glyph);
            } else {
              trace("Requested a missing character from font"+
                    "font"+ name+ "charCode"+ charCode);
            }
        }
        return list;
    }

    public function layoutText (text :String, ?align :TextAlign, wrapWidth :Float = 0,
        letterSpacing :Float = 0, lineSpacing :Float = 0) :TextLayout
    {
        if (align == null) {
            align = Left;
        }
        return new TextLayout(this, text, align, wrapWidth, letterSpacing, lineSpacing);
    }

    /**
     * Get the Glyph for a given character code.
     */
    inline public function getGlyph (charCode :Int) :Glyph
    {
        return _glyphs.get(charCode);
    }

    private function reload ()
    {
        _glyphs = new Map();
        _glyphs.set(NEWLINE.charCode, NEWLINE);

        var parser = new ConfigParser(Assets.getText(name ));
        var pages = new Map<Int,Texture>();

        // The basename of the font's path, where we'll find the textures
        var idx = name.lastIndexOf("/");
        var basePath = (idx >= 0) ? name.substr(0, idx+1) : "";

        // BMFont spec: http://www.angelcode.com/products/bmfont/doc/file_format.html
        for (keyword in parser.keywords()) {
            switch (keyword) {
            case "info":
                for (pair in parser.pairs()) {
                    switch (pair.key) {
                    case "size":
                        size = pair.getInt();
                    }
                }

            case "common":
                for (pair in parser.pairs()) {
                    switch (pair.key) {
                    case "lineHeight":
                        lineHeight = pair.getInt();
                    }
                }

            case "page":
                var pageId :Int = 0;
                var file :String = null;
                for (pair in parser.pairs()) {
                    switch (pair.key) {
                    case "id":
                        pageId = pair.getInt();
                    case "file":
                        file = pair.getString();
                    }
                }
             //   pages.set(pageId, _pack.getTexture(basePath + file.removeFileExtension()));
			    pages.set(pageId, Game.game.getTexture("assets/"+file));    //_pack.getTexture(basePath + file.removeFileExtension()));

            case "char":
                var glyph = null;
                for (pair in parser.pairs()) {
                    switch (pair.key) {
                    case "id":
                        glyph = new Glyph(pair.getInt());
                    case "x":
                        glyph.clip.x = pair.getInt();
                    case "y":
                        glyph.clip.y = pair.getInt();
                    case "width":
                        glyph.clip.width = pair.getInt();
                    case "height":
                        glyph.clip.height = pair.getInt();
                    case "page":
                        glyph.page = pages.get(pair.getInt());
                    case "xoffset":
                        glyph.clip.offsetX = pair.getInt();
                    case "yoffset":
                        glyph.clip.offsetY = pair.getInt();
                    case "xadvance":
                        glyph.xAdvance = pair.getInt();
                    }
                }
                _glyphs.set(glyph.charCode, glyph);

            case "kerning":
                var first :Glyph = null;
                var second = 0, amount = 0;
                for (pair in parser.pairs()) {
                    switch (pair.key) {
                    case "first":
                        first = _glyphs.get(pair.getInt());
                    case "second":
                        second = pair.getInt();
                    case "amount":
                        amount = pair.getInt();
                    }
                }
                if (first != null && amount != 0) {
                    first.setKerning(second, amount);
                }
            }
        }
    }

    // A special glyph to handle the newline character, which is not included in most fonts
    private static var NEWLINE = new Glyph('\n'.code);

 
    private var _glyphs :Map<Int,Glyph>;


}

/**
 * Represents a single glyph in a bitmap font.
 */
class Glyph
{
    /**
     * This glyph's ASCII character code.
     */
    public var charCode (default, null) :Int;

    // Location and dimensions of this glyph on the sprite sheet
	public var clip:Clip;

    /**
     * The atlas that contains this glyph.
     */
    public var page :Texture = null;

    public var xOffset :Int = 0;
    public var yOffset :Int = 0;

    public var xAdvance :Int = 0;

    public function new (charCode :Int)
    {
        this.charCode = charCode;
		clip = new Clip();
    }

    /**
     * Draws this glyph to a Graphics surface.
     */
    public function draw (batch:SpriteBatch, destX :Float, destY :Float)
    {
        // Avoid drawing whitespace
        if (clip.width > 0) 
		{
			batch.RenderFont(page,destX + clip.offsetX, destY + clip.offsetY,1,clip,false,true,1,1,1,1,BlendMode.NORMAL);
			//batch.drawTexture(page, m, clip, destX + clip.offsetX, destY + clip.offsetY, false, false,1,1,1,1, BlendMode.NORMAL);
			
        //    g.drawSubTexture(page, destX + xOffset, destY + yOffset, x, y, width, height);
        }
    }

    public function getKerning (nextCharCode :Int) :Int
    {
        return (_kernings != null) ? Std.int(_kernings.get(nextCharCode)) : 0;
    }

    public function setKerning (nextCharCode :Int, amount :Int)
    {
        if (_kernings == null) {
            _kernings = new Map();
        }
        _kernings.set(nextCharCode, amount);
    }

    private var _kernings :Map<Int,Int> = null;
}

enum TextAlign
{
    Left;
    Center;
    Right;
}

/**
 * Measures and lays out a block of text, handling word wrapping, alignment and newline characters.
 */
class TextLayout
{
    /** The bounding box that contains this text. */
    public var bounds (default, null) :Rectangle;

    /** The number of lines in this text. */
    public var lines (default, null) :Int = 0;

    public     function new (font :Font, text :String, align :TextAlign, wrapWidth :Float, letterSpacing :Float, lineSpacing :Float)
    {
        _font = font;
        _glyphs = [];
        _offsets = [];
        _lineOffset = Math.round(font.lineHeight + lineSpacing);

        bounds = new Rectangle();
        var lineWidths = [];

        var ll = text.length;
        for (ii in 0...ll) {
            var charCode = text.fastCodeAt(ii);
            var glyph = font.getGlyph(charCode);
            if (glyph != null) {
                _glyphs.push(glyph);
            } else {
                trace("Requested a missing character from font"
                    +"font"+ font.name+ "charCode"+ charCode);
            }
        }

        var lastSpaceIdx = -1;
        var lineWidth = 0.0;
        var lineHeight = 0.0;
        var newline = font.getGlyph("\n".code);

        var addLine = function () {
            bounds.width = Math.max(bounds.width, lineWidth);
            bounds.height += lineHeight;

            lineWidths[lines] = lineWidth;
            lineWidth = 0;
            lineHeight = 0;
            ++lines;
        };

        var ii = 0;
        while (ii < _glyphs.length) {
            var glyph = _glyphs[ii];
            _offsets[ii] = Math.round(lineWidth);

            var wordWrap = wrapWidth > 0 && lineWidth + glyph.clip.width > wrapWidth;
            if (wordWrap || glyph == newline) {
                // Wrap using the last word divider
                if (wordWrap) {
                    if (lastSpaceIdx >= 0) {
                        _glyphs[lastSpaceIdx] = newline;
                        lineWidth = _offsets[lastSpaceIdx];
                        ii = lastSpaceIdx;
                    } else {
                        _glyphs.insert(ii, newline);
                    }
                }
                lastSpaceIdx = -1;

                lineHeight = _lineOffset;
                addLine();

            } else {
                if (glyph.charCode == " ".code) {
                    lastSpaceIdx = ii;
                }
                lineWidth += glyph.xAdvance + letterSpacing;
                lineHeight = Math.max(lineHeight, glyph.clip.height + glyph.yOffset);

                // Handle kerning with the next glyph
                if (ii+1 < _glyphs.length) {
                    var nextGlyph = _glyphs[ii+1];
                    lineWidth += glyph.getKerning(nextGlyph.charCode);
                }
            }

            ++ii;
        }

        // Handle the remaining lineWidth/Height
        addLine();

        var lineY = 0.0;
        var alignOffset = getAlignOffset(align, lineWidths[0], wrapWidth);

        var top = Util.FLOAT_MAX;
        var bottom = Util.FLOAT_MIN;

        // Pack bounds
        var line = 0;
        var ii = 0;
        var ll = _glyphs.length;
        while (ii < ll) {
            var glyph = _glyphs[ii];

            if (glyph.charCode == "\n".code) {
                lineY += _lineOffset;
                ++line;
                alignOffset = getAlignOffset(align, lineWidths[line], wrapWidth);
            }
            _offsets[ii] += alignOffset;

            var glyphY = lineY + glyph.yOffset;
            top = Math.min(top, glyphY);
            bottom = Math.max(bottom, glyphY + glyph.clip.height);

            ++ii;
        }

        bounds.x = getAlignOffset(align, bounds.width, wrapWidth);
        bounds.y = top;
        bounds.height = bottom - top;
    }

   
    public function print (batch:SpriteBatch,px:Float,py:Float)
    {
        var y = 0.0;
        var ii = 0;
        var ll = _glyphs.length;

        while (ii < ll) {
            var glyph = _glyphs[ii];
            if (glyph.charCode == "\n".code) {
                y += _lineOffset;
            } else {
                var x = _offsets[ii];
                glyph.draw(batch,px+x, py+y);
            }
            ++ii;
        }
    }

    private static function getAlignOffset (align :TextAlign,       lineWidth :Float, totalWidth :Float) :Float
    {
        switch (align) {
            case Left: return 0;
            case Right: return totalWidth - lineWidth;
            case Center: return Math.round((totalWidth-lineWidth) / 2);
        }
    }

    private var _font :Font;
    private var _glyphs :Array<Glyph>;
    private var _offsets :Array<Float>;
    private var _lineOffset :Float;
}

private class ConfigParser
{
    public function new (config :String)
    {
        _configText = config;
        _keywordPattern = ~/([A-Za-z]+)(.*)/;
        _pairPattern = ~/([A-Za-z]+)=("[^"]*"|[^\s]+)/;
    }

    public function keywords () :Iterator<String>
    {
        var text = _configText;
        return {
            next: function () {
                text = advance(text, _keywordPattern);
                _pairText = _keywordPattern.matched(2);
                return _keywordPattern.matched(1);
            },
            hasNext: function () {
                return _keywordPattern.match(text);
            }
        };
    }

    public function pairs () :Iterator<ConfigPair>
    {
        var text = _pairText;
        return {
            next: function () {
                text = advance(text, _pairPattern);
                return new ConfigPair(_pairPattern.matched(1), _pairPattern.matched(2));
            },
            hasNext: function () {
                return _pairPattern.match(text);
            }
        };
    }

    private static function advance (text :String, expr :EReg)
    {
        var m = expr.matchedPos();
        return text.substr(m.pos + m.len, text.length);
    }

    // The entire config file contents
    private var _configText :String;

    // The line currently being processed
    private var _pairText :String;

    private var _keywordPattern :EReg;
    private var _pairPattern :EReg;
}

private class ConfigPair
{
    public var key (default, null) :String;

    public function new (key :String, value :String)
    {
        this.key = key;
        _value = value;
    }

    public function getInt () :Int
    {
        return Std.parseInt(_value);
    }

    public function getString () :String
    {
        if (_value.fastCodeAt(0) != "\"".code) {
            return null;
        }
        return _value.substr(1, _value.length-2);
    }

    private var _value :String;
}
