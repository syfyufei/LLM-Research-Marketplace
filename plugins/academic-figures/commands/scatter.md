---
description: Generate a scatter plot with optional trend line for academic publications
---

## Goal

Generate a publication-ready scatter plot with grayscale styling, optional trend lines, and support for grouping and faceting.

## Preparation

Collect the following parameters from the user:

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| `data` | Yes | - | Data source: CSV file path |
| `x` | Yes | - | Column name for X-axis |
| `y` | Yes | - | Column name for Y-axis |
| `group` | No | - | Column name for grouping (different markers) |
| `facet` | No | - | Column name for faceting (multiple panels) |
| `fit_line` | No | `none` | Trend line: none, linear, loess |
| `title` | No | - | Chart title |
| `xlabel` | No | X column name | X-axis label |
| `ylabel` | No | Y column name | Y-axis label |
| `output` | No | `paper/figures/scatter` | Output file path |
| `width` | No | 6 | Figure width in inches |
| `height` | No | 5 | Figure height in inches |

## Execution Steps

1. **Load data**

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

COLORS = ['#000000', '#4D4D4D', '#7F7F7F', '#B2B2B2']
MARKERS = ['o', 's', '^', 'D', 'v']

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

3. **Generate scatter plot**

```python
x_col = '{{x}}'
y_col = '{{y}}'
group_col = '{{group}}' if '{{group}}' else None
facet_col = '{{facet}}' if '{{facet}}' else None
fit_line = '{{fit_line}}' or 'none'

if facet_col:
    # Faceted scatter plot
    facets = data[facet_col].unique()
    n_facets = len(facets)
    fig, axes = plt.subplots(1, n_facets, figsize=({{width}} * n_facets / 2, {{height}}), sharey=True)
    if n_facets == 1:
        axes = [axes]

    for ax, facet in zip(axes, facets):
        subset = data[data[facet_col] == facet]

        ax.scatter(subset[x_col], subset[y_col],
                   color='black', s=30, alpha=0.6,
                   edgecolors='black', linewidths=0.5)

        if fit_line == 'linear':
            z = np.polyfit(subset[x_col], subset[y_col], 1)
            p = np.poly1d(z)
            x_line = np.linspace(subset[x_col].min(), subset[x_col].max(), 100)
            ax.plot(x_line, p(x_line), color='black', linestyle='--', linewidth=1)

        ax.set_title(facet)
        ax.set_xlabel('{{xlabel}}' or x_col if ax == axes[len(axes)//2] else '')

    axes[0].set_ylabel('{{ylabel}}' or y_col)

    if '{{title}}':
        fig.suptitle('{{title}}', y=1.02, fontweight='bold')

else:
    # Single scatter plot
    fig, ax = plt.subplots(figsize=({{width}}, {{height}}))

    if group_col:
        groups = data[group_col].unique()
        for i, group in enumerate(groups):
            subset = data[data[group_col] == group]
            ax.scatter(subset[x_col], subset[y_col],
                       marker=MARKERS[i % len(MARKERS)],
                       color=COLORS[i % len(COLORS)],
                       s=40, alpha=0.7, label=group,
                       edgecolors='black', linewidths=0.5)
    else:
        ax.scatter(data[x_col], data[y_col],
                   color='black', s=40, alpha=0.6,
                   edgecolors='black', linewidths=0.5)

    # Add trend line
    if fit_line == 'linear':
        z = np.polyfit(data[x_col], data[y_col], 1)
        p = np.poly1d(z)
        x_line = np.linspace(data[x_col].min(), data[x_col].max(), 100)
        ax.plot(x_line, p(x_line), color='black', linestyle='--', linewidth=1.5,
                label='趋势线' if group_col else None)
    elif fit_line == 'loess':
        try:
            from scipy.ndimage import uniform_filter1d
            # Simple moving average as LOESS approximation
            sorted_idx = np.argsort(data[x_col])
            x_sorted = data[x_col].values[sorted_idx]
            y_sorted = data[y_col].values[sorted_idx]
            y_smooth = uniform_filter1d(y_sorted, size=max(5, len(y_sorted)//10))
            ax.plot(x_sorted, y_smooth, color='black', linestyle='--', linewidth=1.5,
                    label='趋势线' if group_col else None)
        except ImportError:
            print("LOESS requires scipy. Using linear fit instead.")
            z = np.polyfit(data[x_col], data[y_col], 1)
            p = np.poly1d(z)
            x_line = np.linspace(data[x_col].min(), data[x_col].max(), 100)
            ax.plot(x_line, p(x_line), color='black', linestyle='--', linewidth=1.5)

    ax.set_xlabel('{{xlabel}}' or x_col)
    ax.set_ylabel('{{ylabel}}' or y_col)

    if '{{title}}':
        ax.set_title('{{title}}')

    if group_col or (fit_line != 'none' and group_col):
        ax.legend()

plt.tight_layout()
```

4. **Save output**

```python
output_path = Path('{{output}}' or 'paper/figures/scatter')
output_path.parent.mkdir(parents=True, exist_ok=True)

for fmt in ['pdf', 'png']:
    fig.savefig(f"{output_path}.{fmt}")
    print(f"Saved: {output_path}.{fmt}")

plt.close()
```

## Example Usage

```
/academic-figures:scatter data.csv --x education --y income --group region --fit_line linear --title "教育与收入的关系"
```

## Output

- Scatter plot with grayscale styling
- Optional trend line (linear or LOESS)
- Grouped by marker shape and color
- Faceted panels if specified
