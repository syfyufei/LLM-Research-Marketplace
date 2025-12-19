---
description: Generate a line chart with grayscale styling for academic publications
---

## Goal

Generate a publication-ready line chart with grayscale styling and Chinese font support.

## Preparation

Collect the following parameters from the user:

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| `data` | Yes | - | Data source: CSV file path, or inline data |
| `x` | Yes | - | Column name for X-axis |
| `y` | Yes | - | Column name(s) for Y-axis (comma-separated for multiple lines) |
| `group` | No | - | Column name for grouping/coloring lines |
| `title` | No | - | Chart title |
| `xlabel` | No | X column name | X-axis label |
| `ylabel` | No | Y column name | Y-axis label |
| `output` | No | `paper/figures/line_chart` | Output file path (without extension) |
| `format` | No | `pdf,png` | Output formats |
| `width` | No | 6 | Figure width in inches |
| `height` | No | 4 | Figure height in inches |

## Execution Steps

1. **Load data**

```python
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib as mpl
import numpy as np
from pathlib import Path

# Load data
data = pd.read_csv('{{data}}')  # or pd.read_excel() for .xlsx
```

2. **Configure academic style**

```python
# Font configuration
plt.rcParams['font.sans-serif'] = ['STFangsong', 'SimSun', 'PingFang SC', 'SimHei']
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['axes.unicode_minus'] = False

# Academic style
COLORS = ['#000000', '#4D4D4D', '#7F7F7F', '#B2B2B2', '#D9D9D9']
LINESTYLES = ['-', '--', ':', '-.']
MARKERS = ['o', 's', '^', 'D', 'v']

mpl.rcParams.update({
    'font.size': 11,
    'axes.linewidth': 0.8,
    'axes.spines.top': False,
    'axes.spines.right': False,
    'axes.grid': True,
    'grid.alpha': 0.3,
    'grid.linewidth': 0.5,
    'grid.linestyle': '--',
    'legend.frameon': False,
    'savefig.dpi': 300,
    'savefig.bbox': 'tight'
})
```

3. **Generate line chart**

```python
fig, ax = plt.subplots(figsize=({{width}}, {{height}}))

x_col = '{{x}}'
y_cols = '{{y}}'.split(',')  # Support multiple Y columns
group_col = '{{group}}' if '{{group}}' else None

if group_col:
    # Grouped lines
    groups = data[group_col].unique()
    for i, group in enumerate(groups):
        subset = data[data[group_col] == group]
        ax.plot(subset[x_col], subset[y_cols[0]],
                color=COLORS[i % len(COLORS)],
                linestyle=LINESTYLES[i % len(LINESTYLES)],
                marker=MARKERS[i % len(MARKERS)],
                markersize=6, linewidth=1.5,
                label=group)
else:
    # Multiple Y columns as separate lines
    for i, y_col in enumerate(y_cols):
        ax.plot(data[x_col], data[y_col.strip()],
                color=COLORS[i % len(COLORS)],
                linestyle=LINESTYLES[i % len(LINESTYLES)],
                marker=MARKERS[i % len(MARKERS)],
                markersize=6, linewidth=1.5,
                label=y_col.strip())

# Labels and title
ax.set_xlabel('{{xlabel}}' or x_col)
ax.set_ylabel('{{ylabel}}' or y_cols[0])
if '{{title}}':
    ax.set_title('{{title}}')

ax.legend()
plt.tight_layout()
```

4. **Save output**

```python
output_path = Path('{{output}}' or 'paper/figures/line_chart')
output_path.parent.mkdir(parents=True, exist_ok=True)

formats = '{{format}}'.split(',') if '{{format}}' else ['pdf', 'png']
for fmt in formats:
    fig.savefig(f"{output_path}.{fmt.strip()}")
    print(f"Saved: {output_path}.{fmt.strip()}")

plt.close()
```

## Example Usage

User request: "Create a line chart showing GDP growth over years for regions A, B, C"

```
/academic-figures:line data.csv --x year --y gdp --group region --title "GDP增长趋势比较"
```

## Output

- PDF file (vector format, best for publications)
- PNG file (raster format, for preview)

Both saved to `paper/figures/` or specified output path.
