# Academic Figures

A Claude Code skill for generating publication-ready academic figures with grayscale styling and Chinese font support.

## Installation

```bash
/plugin install academic-figures@LLM-Research-Marketplace
```

## Quick Start

1. **Setup**: Run `/academic-figures:setup` to verify dependencies
2. **Generate**: Use chart commands with your data

## Commands

| Command | Description |
|---------|-------------|
| `/academic-figures:setup` | Check environment and configure fonts |
| `/academic-figures:line` | Generate line charts |
| `/academic-figures:bar` | Generate bar charts with error bars |
| `/academic-figures:dotwhisker` | Generate coefficient plots |
| `/academic-figures:scatter` | Generate scatter plots |
| `/academic-figures:map` | Generate choropleth maps |

## Features

- **Grayscale Design**: Optimized for B&W academic publishing
- **Chinese Support**: Full CJK character rendering (STFangsong, SimSun, etc.)
- **High Quality**: 300 DPI output, PDF and PNG formats
- **AJPS Style**: Following American Journal of Political Science guidelines

## Requirements

- Python 3.8+
- matplotlib
- numpy
- pandas
- geopandas (for maps)

## Example

```python
# Line chart with Chinese labels
/academic-figures:line data.csv --x year --y gdp --title "经济增长趋势"
```

## Output

Figures are saved to `paper/figures/` by default with both PDF and PNG formats.

## License

MIT
