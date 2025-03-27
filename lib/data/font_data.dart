import 'package:google_fonts/google_fonts.dart';
import '../models/font_model.dart';

class FontData {
  // Get a list of historically significant fonts (substituting with Google Fonts)
  static List<FontModel> getHistoricalFonts() {
    return [
      FontModel(
        name: 'Helvetica', 
        fontFamily: GoogleFonts.roboto().fontFamily, // Substitute with similar font
        tags: ['Sans-serif', 'Modern'],
        description: 'Arguably the most famous typeface of all time. Designed to be neutral and versatile.',
        year: 1957,
        designer: 'Max Miedinger',
      ),
      FontModel(
        name: 'Garamond', 
        fontFamily: GoogleFonts.ebGaramond().fontFamily,
        tags: ['Serif', 'Old-style'],
        description: 'One of the most influential and widely used typefaces in history, known for its legibility.',
        year: 1530,
        designer: 'Claude Garamond',
      ),
      FontModel(
        name: 'Futura', 
        fontFamily: GoogleFonts.questrial().fontFamily, // Substitute
        tags: ['Sans-serif', 'Geometric'],
        description: 'Based on geometric shapes, especially the circle, it became representative of Bauhaus style.',
        year: 1927,
        designer: 'Paul Renner',
      ),
      FontModel(
        name: 'Bodoni', 
        fontFamily: GoogleFonts.bodoniModa().fontFamily,
        tags: ['Serif', 'Modern'],
        description: 'Known for its high contrast between thick and thin strokes, a modern serif typeface.',
        year: 1798,
        designer: 'Giambattista Bodoni',
      ),
      FontModel(
        name: 'Times New Roman', 
        fontFamily: GoogleFonts.merriweather().fontFamily, // Similar
        tags: ['Serif', 'Transitional'],
        description: 'Commissioned by The Times newspaper in London, one of the most widely used typefaces.',
        year: 1931,
        designer: 'Stanley Morison',
      ),
      FontModel(
        name: 'Baskerville', 
        fontFamily: GoogleFonts.libreBaskerville().fontFamily,
        tags: ['Serif', 'Transitional'],
        description: 'A transitional serif typeface known for its increased contrast and more vertical stress.',
        year: 1757,
        designer: 'John Baskerville',
      ),
      FontModel(
        name: 'Palatino', 
        fontFamily: GoogleFonts.playfairDisplay().fontFamily, // Substitute
        tags: ['Serif', 'Renaissance'],
        description: 'Designed to be legible in print, on screen, and at various sizes.',
        year: 1949,
        designer: 'Hermann Zapf',
      ),
      FontModel(
        name: 'Gill Sans', 
        fontFamily: GoogleFonts.workSans().fontFamily, // Substitute
        tags: ['Sans-serif', 'Humanist'],
        description: 'One of the most influential British typefaces, known for its balance and legibility.',
        year: 1928,
        designer: 'Eric Gill',
      ),
      FontModel(
        name: 'Frutiger', 
        fontFamily: GoogleFonts.nunito().fontFamily, // Substitute
        tags: ['Sans-serif', 'Humanist'],
        description: 'Designed for the signage at Charles de Gaulle Airport, optimized for legibility at a distance.',
        year: 1976,
        designer: 'Adrian Frutiger',
      ),
      FontModel(
        name: 'Gotham', 
        fontFamily: GoogleFonts.montserrat().fontFamily, // Substitute
        tags: ['Sans-serif', 'Geometric'],
        description: 'Inspired by mid-20th century architectural signage in New York City.',
        year: 2000,
        designer: 'Tobias Frere-Jones',
      ),
      FontModel(
        name: 'Avenir', 
        fontFamily: GoogleFonts.nunito().fontFamily, // Substitute
        tags: ['Sans-serif', 'Geometric'],
        description: 'Meaning "future" in French, it combines elements of geometric and humanist sans-serif designs.',
        year: 1988,
        designer: 'Adrian Frutiger',
      ),
      FontModel(
        name: 'Didot', 
        fontFamily: GoogleFonts.playfairDisplay().fontFamily, // Substitute
        tags: ['Serif', 'Modern'],
        description: 'Known for its high contrast and thin serifs, commonly used in fashion magazines.',
        year: 1784,
        designer: 'Firmin Didot',
      ),
      FontModel(
        name: 'Optima', 
        fontFamily: GoogleFonts.tenorSans().fontFamily, // Substitute
        tags: ['Sans-serif', 'Humanist'],
        description: 'A unique sans-serif with subtle swelling at terminals, giving it a calligraphic quality.',
        year: 1958,
        designer: 'Hermann Zapf',
      ),
      FontModel(
        name: 'Univers', 
        fontFamily: GoogleFonts.openSans().fontFamily, // Substitute
        tags: ['Sans-serif', 'Neo-grotesque'],
        description: 'Revolutionary for its systematic family of 21 fonts with consistent design across weights and widths.',
        year: 1957,
        designer: 'Adrian Frutiger',
      ),
      FontModel(
        name: 'Clarendon', 
        fontFamily: GoogleFonts.bitter().fontFamily, // Substitute
        tags: ['Serif', 'Slab-serif'],
        description: 'One of the first registered typefaces, known for its bold, bracketed serifs.',
        year: 1845,
        designer: 'Robert Besley',
      ),
      FontModel(
        name: 'Franklin Gothic', 
        fontFamily: GoogleFonts.frankRuhlLibre().fontFamily, // Substitute
        tags: ['Sans-serif', 'Gothic'],
        description: 'A classic American sans-serif with a strong, sturdy appearance.',
        year: 1902,
        designer: 'Morris Fuller Benton',
      ),
      FontModel(
        name: 'Caslon', 
        fontFamily: GoogleFonts.libreBaskerville().fontFamily, // Substitute
        tags: ['Serif', 'Old-style'],
        description: 'An elegant English typeface that influenced American colonial printing.',
        year: 1722,
        designer: 'William Caslon',
      ),
      FontModel(
        name: 'Akzidenz-Grotesk', 
        fontFamily: GoogleFonts.inter().fontFamily, // Substitute
        tags: ['Sans-serif', 'Neo-grotesque'],
        description: 'One of the first sans-serif typefaces to be widely used, influencing later designs like Helvetica.',
        year: 1896,
        designer: 'H. Berthold AG',
      ),
    ];
  }
} 