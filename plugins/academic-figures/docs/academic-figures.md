# Academic Figures Documentation

A comprehensive guide to generating publication-ready figures for academic papers.

## Overview

The `academic-figures` skill provides commands for creating various chart types commonly used in academic publications, with consistent grayscale styling suitable for black-and-white printing and full Chinese language support.

## Installation

```bash
/plugin install academic-figures@LLM-Research-Marketplace
```

After installation, run `/academic-figures:setup` to verify your environment.

## Commands

### `/academic-figures:setup`

Checks your Python environment and configures fonts.

**What it does:**
- Verifies Python version and required packages (matplotlib, numpy, pandas)
- Detects available Chinese fonts
- Generates a test figure to verify font rendering

### `/academic-figures:line`

Creates line charts for time series and trend visualization.

**Key Parameters:**
- `data`: CSV file path
- `x`: X-axis column
- `y`: Y-axis column(s), comma-separated for multiple lines
- `group`: Optional grouping column

**Example:**
```
/academic-figures:line gdp_data.csv --x year --y growth_rate --group region --title "经济增长趋势"
```

### `/academic-figures:bar`

Creates bar charts with optional error bars.

**Key Parameters:**
- `data`: CSV file path
- `x`: Category column
- `y`: Value column
- `error`: Optional error column for error bars
- `group`: Optional grouping for clustered bars

**Example:**
```
/academic-figures:bar survey.csv --x policy --y support --error se --title "政策支持率"
```

### `/academic-figures:dotwhisker`

Creates coefficient plots (dot-whisker plots) for regression results.

**Data Format:**
Your CSV should have columns: `term`, `estimate`, `std.error` (or `conf.low`, `conf.high`)

**Key Parameters:**
- `data`: CSV with regression coefficients
- `model`: Optional model identifier for multi-model comparison
- `reference`: Reference line position (default: 0)

**Example:**
```
/academic-figures:dotwhisker regression.csv --title "回归分析结果" --xlabel "系数估计值"
```

### `/academic-figures:scatter`

Creates scatter plots with optional trend lines.

**Key Parameters:**
- `data`: CSV file path
- `x`, `y`: Axis columns
- `group`: Optional grouping (different markers)
- `facet`: Optional faceting (multiple panels)
- `fit_line`: none, linear, or loess

**Example:**
```
/academic-figures:scatter data.csv --x education --y income --group urban --fit_line linear
```

### `/academic-figures:map`

Creates choropleth maps.

**Requirements:** geopandas (`pip install geopandas`)

**Key Parameters:**
- `shapefile`: Path to .shp or .geojson
- `data`: Optional CSV with attribute data
- `fill_var`: Column for choropleth coloring

**Example:**
```
/academic-figures:map provinces.shp --data gdp.csv --join_key name --fill_var gdp_per_capita
```

## Style Guide

### Colors

All figures use a grayscale palette suitable for B&W printing:
- Black (#000000)
- Dark gray (#4D4D4D)
- Medium gray (#7F7F7F)
- Light gray (#B2B2B2)
- Very light gray (#D9D9D9)

### Fonts

- **Chinese**: STFangsong (华文仿宋) with fallbacks to SimSun, PingFang SC
- **Size**: 11pt default
- **Labels**: Bold axis labels

### Line Styles

For multiple series, use distinct line styles:
1. Solid (—)
2. Dashed (--)
3. Dotted (:)
4. Dash-dot (-.)

### Markers

For scatter plots and line endpoints:
- Circle (o)
- Square (s)
- Triangle (^)
- Diamond (D)
- Inverted triangle (v)

### Output

- Default resolution: 300 DPI
- Default formats: PDF (vector) and PNG (raster)
- Default size: 6" × 4"
- Default location: `paper/figures/`

## Troubleshooting

### Chinese characters not displaying

1. Run `/academic-figures:setup` to check available fonts
2. Ensure STFangsong or similar is installed
3. Clear matplotlib cache: `rm -rf ~/.matplotlib/fontlist*.json`

### Import errors

Install missing packages:
```bash
pip install matplotlib numpy pandas
pip install geopandas  # for maps only
```

### Figure too large/small

Adjust width and height parameters:
```
/academic-figures:line data.csv --width 8 --height 5
```

## Best Practices

1. **Always preview**: Generate both PDF and PNG to verify appearance
2. **Use relative paths**: Save to `paper/figures/` for consistency
3. **Consistent sizing**: Use same dimensions across related figures
4. **Clear labels**: Use descriptive Chinese or English labels
5. **Minimal design**: Avoid unnecessary gridlines or decorations

## References

- [AJPS Figure Guidelines](https://ajps.org/guidelines-for-manuscripts/)
- [dotwhisker R package](https://cran.r-project.org/web/packages/dotwhisker/)
- [matplotlib documentation](https://matplotlib.org/stable/contents.html)
