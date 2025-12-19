---
description: Generate a bar chart with error bars and grayscale styling for academic publications
---

## Goal

Generate a publication-ready bar chart with optional error bars, grayscale styling, and Chinese font support.

## Preparation

Collect the following parameters from the user:

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| `data` | Yes | - | Data source: CSV file path |
| `x` | Yes | - | Column name for categories (X-axis) |
| `y` | Yes | - | Column name for values |
| `error` | No | - | Column name for error values (for error bars) |
| `group` | No | - | Column name for grouping (creates grouped bars) |
| `title` | No | - | Chart title |
| `xlabel` | No | - | X-axis label |
| `ylabel` | No | - | Y-axis label |
| `orientation` | No | `vertical` | Bar orientation: vertical or horizontal |
| `show_values` | No | `true` | Show value labels on bars |
| `output` | No | `paper/figures/bar_chart` | Output file path |
| `width` | No | 6 | Figure width in inches |
| `height` | No | 4 | Figure height in inches |

## Execution Steps

1. **Load and prepare data**

```python
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib as mpl
import numpy as np
from pathlib import Path

data = pd.read_csv('{{data}}')
```

2. **Configure academic style**

```python
plt.rcParams['font.sans-serif'] = ['STFangsong', 'SimSun', 'PingFang SC', 'SimHei']
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['axes.unicode_minus'] = False

COLORS = ['#000000', '#4D4D4D', '#7F7F7F', '#B2B2B2', '#D9D9D9']
HATCHES = ['', '///', '...', 'xxx', '\\\\\\']

mpl.rcParams.update({
    'font.size': 11,
    'axes.linewidth': 0.8,
    'axes.spines.top': False,
    'axes.spines.right': False,
    'axes.grid': True,
    'grid.alpha': 0.3,
    'legend.frameon': False,
    'savefig.dpi': 300,
    'savefig.bbox': 'tight'
})
```

3. **Generate bar chart**

```python
fig, ax = plt.subplots(figsize=({{width}}, {{height}}))

x_col = '{{x}}'
y_col = '{{y}}'
error_col = '{{error}}' if '{{error}}' else None
group_col = '{{group}}' if '{{group}}' else None
orientation = '{{orientation}}' or 'vertical'
show_values = '{{show_values}}' != 'false'

categories = data[x_col].unique()
x_pos = np.arange(len(categories))

if group_col:
    # Grouped bar chart
    groups = data[group_col].unique()
    n_groups = len(groups)
    width = 0.8 / n_groups

    for i, group in enumerate(groups):
        subset = data[data[group_col] == group]
        values = [subset[subset[x_col] == cat][y_col].values[0] if len(subset[subset[x_col] == cat]) > 0 else 0
                  for cat in categories]
        errors = None
        if error_col:
            errors = [subset[subset[x_col] == cat][error_col].values[0] if len(subset[subset[x_col] == cat]) > 0 else 0
                      for cat in categories]

        offset = (i - n_groups/2 + 0.5) * width
        bars = ax.bar(x_pos + offset, values, width,
                      label=group,
                      color=COLORS[i % len(COLORS)],
                      edgecolor='black', linewidth=0.8,
                      hatch=HATCHES[i % len(HATCHES)] if i > 0 else '',
                      yerr=errors, capsize=4,
                      error_kw={'linewidth': 1, 'color': 'black'})
else:
    # Simple bar chart
    values = data.groupby(x_col)[y_col].mean().reindex(categories).values
    errors = None
    if error_col:
        errors = data.groupby(x_col)[error_col].mean().reindex(categories).values

    bars = ax.bar(x_pos, values,
                  color=COLORS[2],
                  edgecolor='black', linewidth=0.8,
                  yerr=errors, capsize=4,
                  error_kw={'linewidth': 1, 'color': 'black'})

    # Add value labels above bars (above error bars if present)
    if show_values:
        for bar, val, err in zip(bars, values, errors if errors is not None else [0]*len(values)):
            height = val + (err if err else 0) + (max(values) * 0.03)
            ax.text(bar.get_x() + bar.get_width()/2, height,
                    f'{val:.0f}%' if val < 100 else f'{val:.0f}',
                    ha='center', va='bottom', fontsize=9)

# Configure axes
ax.set_xticks(x_pos)
ax.set_xticklabels(categories, rotation=15 if len(str(categories[0])) > 4 else 0, ha='right' if len(str(categories[0])) > 4 else 'center')
ax.set_xlabel('{{xlabel}}' or '')
ax.set_ylabel('{{ylabel}}' or y_col)

if '{{title}}':
    ax.set_title('{{title}}')

if group_col:
    ax.legend()

# Adjust y-axis to fit labels
if show_values:
    ymax = ax.get_ylim()[1]
    ax.set_ylim(0, ymax * 1.1)

plt.tight_layout()
```

4. **Save output**

```python
output_path = Path('{{output}}' or 'paper/figures/bar_chart')
output_path.parent.mkdir(parents=True, exist_ok=True)

for fmt in ['pdf', 'png']:
    fig.savefig(f"{output_path}.{fmt}")
    print(f"Saved: {output_path}.{fmt}")

plt.close()
```

## Example Usage

```
/academic-figures:bar survey.csv --x category --y support_rate --error std_error --title "政策支持率" --ylabel "支持率 (%)"
```

## Output

- Grayscale bar chart with optional error bars
- Value labels positioned above error bars (not overlapping)
- PDF and PNG formats
