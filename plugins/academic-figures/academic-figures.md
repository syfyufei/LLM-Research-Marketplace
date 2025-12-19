---
name: academic-figures
description: Generate publication-ready academic figures with grayscale styling and Chinese font support for scholarly publications
---

# Academic Figures Skill

A Claude Code skill for generating publication-ready figures suitable for academic journals. Designed with grayscale/black-and-white styling for print compatibility and full Chinese language support.

## Features

- **Grayscale Styling**: All figures use black, white, and gray tones suitable for B&W printing
- **Chinese Support**: Proper rendering of Chinese characters using STFangsong or fallback fonts
- **Multiple Chart Types**: Line charts, bar charts, dot-whisker plots, scatter plots, and maps
- **Publication Ready**: 300 DPI output, proper sizing, clean academic aesthetics
- **Dual Format**: Outputs both PDF (vector) and PNG (raster) by default

## Chart Types

### Line Chart (`/academic-figures:line`)
For time series, trends, and multi-group comparisons. Uses distinct line styles (solid, dashed, dotted) and markers to differentiate groups.

### Bar Chart (`/academic-figures:bar`)
For categorical comparisons with optional error bars. Supports grouped and stacked layouts with pattern fills for B&W distinction.

### Dot-Whisker Plot (`/academic-figures:dotwhisker`)
For displaying regression coefficients with confidence intervals. Clean coefficient visualization following AJPS style guidelines.

### Scatter Plot (`/academic-figures:scatter`)
For bivariate relationships with optional trend lines. Supports grouping by shape/color and faceted layouts.

### Map (`/academic-figures:map`)
For geographic data visualization using grayscale fills. Requires shapefile or GeoJSON input.

## Style Guidelines

Based on AJPS (American Journal of Political Science) figure standards:
- Clean, minimal design
- Grayscale palette for B&W compatibility
- Clear axis labels and titles
- Legend positioned to avoid data overlap
- High resolution (300 DPI minimum)

## Usage

Run `/academic-figures:setup` first to verify your environment has the required dependencies and fonts configured correctly.

Then use specific chart commands like `/academic-figures:line` with your data to generate figures.
