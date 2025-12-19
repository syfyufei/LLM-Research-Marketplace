---
description: Generate a choropleth map with grayscale fill for academic publications
---

## Goal

Generate a publication-ready choropleth map with grayscale fills suitable for academic journals.

## Preparation

Collect the following parameters from the user:

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| `shapefile` | Yes | - | Path to shapefile (.shp) or GeoJSON file |
| `data` | No | - | CSV with attribute data to join |
| `join_key` | No | - | Column name to join shapefile with data |
| `fill_var` | No | - | Column name for fill values (choropleth) |
| `title` | No | - | Map title |
| `legend_title` | No | - | Legend title |
| `output` | No | `paper/figures/map` | Output file path |
| `width` | No | 8 | Figure width in inches |
| `height` | No | 6 | Figure height in inches |

## Execution Steps

1. **Load geographic data**

```python
import geopandas as gpd
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib as mpl
from pathlib import Path

# Load shapefile or GeoJSON
gdf = gpd.read_file('{{shapefile}}')

# Optionally join with attribute data
if '{{data}}':
    attr_data = pd.read_csv('{{data}}')
    join_key = '{{join_key}}'
    gdf = gdf.merge(attr_data, on=join_key, how='left')
```

2. **Configure academic style**

```python
plt.rcParams['font.sans-serif'] = ['STFangsong', 'SimSun', 'PingFang SC', 'SimHei']
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['axes.unicode_minus'] = False

mpl.rcParams.update({
    'font.size': 11,
    'savefig.dpi': 300,
    'savefig.bbox': 'tight'
})

# Grayscale colormap
from matplotlib.colors import LinearSegmentedColormap
grayscale_cmap = LinearSegmentedColormap.from_list('grayscale',
    ['#FFFFFF', '#D9D9D9', '#B2B2B2', '#7F7F7F', '#4D4D4D', '#000000'])
```

3. **Generate map**

```python
fig, ax = plt.subplots(figsize=({{width}}, {{height}}))

fill_var = '{{fill_var}}' if '{{fill_var}}' else None

if fill_var and fill_var in gdf.columns:
    # Choropleth map
    gdf.plot(column=fill_var,
             ax=ax,
             cmap=grayscale_cmap,
             edgecolor='black',
             linewidth=0.5,
             legend=True,
             legend_kwds={
                 'label': '{{legend_title}}' or fill_var,
                 'orientation': 'horizontal',
                 'shrink': 0.6,
                 'pad': 0.05
             })
else:
    # Simple boundary map
    gdf.plot(ax=ax,
             facecolor='white',
             edgecolor='black',
             linewidth=0.8)

# Remove axes for cleaner look
ax.set_axis_off()

if '{{title}}':
    ax.set_title('{{title}}', fontsize=12, fontweight='bold', pad=10)

plt.tight_layout()
```

4. **Save output**

```python
output_path = Path('{{output}}' or 'paper/figures/map')
output_path.parent.mkdir(parents=True, exist_ok=True)

for fmt in ['pdf', 'png']:
    fig.savefig(f"{output_path}.{fmt}")
    print(f"Saved: {output_path}.{fmt}")

plt.close()
```

## Requirements

This command requires `geopandas` which can be installed with:
```bash
pip install geopandas
```

## Example Usage

```
/academic-figures:map china_provinces.shp --data gdp_data.csv --join_key province --fill_var gdp_per_capita --title "中国各省人均GDP"
```

## Data Sources

Common sources for shapefiles:
- Natural Earth: https://www.naturalearthdata.com/
- GADM: https://gadm.org/
- 中国地图: https://datav.aliyun.com/portal/school/atlas/area_selector

## Output

- Choropleth map with grayscale fill gradient
- Clean boundary lines
- Horizontal legend below map
- PDF and PNG formats
