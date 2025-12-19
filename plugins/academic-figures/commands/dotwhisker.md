---
description: Generate a dot-whisker coefficient plot for regression results
---

## Goal

Generate a publication-ready dot-whisker plot (coefficient plot) showing regression estimates with confidence intervals, following AJPS style guidelines.

## Preparation

Collect the following parameters from the user:

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| `data` | Yes | - | CSV with columns: term, estimate, std.error (or conf.low, conf.high) |
| `model` | No | - | Column name for model identifier (for multi-model comparison) |
| `ci_level` | No | 0.95 | Confidence interval level |
| `reference` | No | 0 | Reference line position |
| `reorder` | No | `false` | Reorder variables by estimate size |
| `title` | No | - | Chart title |
| `xlabel` | No | `Coefficient Estimate` | X-axis label |
| `output` | No | `paper/figures/dotwhisker` | Output file path |
| `width` | No | 6 | Figure width in inches |
| `height` | No | 5 | Figure height in inches |

## Data Format

Input CSV should have these columns:
- `term`: Variable names
- `estimate`: Point estimates
- `std.error`: Standard errors (will compute CI as estimate +/- 1.96*SE)
- OR `conf.low`, `conf.high`: Pre-computed confidence interval bounds
- `model` (optional): Model identifier for multi-model plots

## Execution Steps

1. **Load and prepare data**

```python
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib as mpl
import numpy as np
from pathlib import Path
from scipy import stats

data = pd.read_csv('{{data}}')

# Compute confidence intervals if not provided
ci_level = float('{{ci_level}}' or 0.95)
z_score = stats.norm.ppf((1 + ci_level) / 2)

if 'conf.low' not in data.columns:
    data['conf.low'] = data['estimate'] - z_score * data['std.error']
    data['conf.high'] = data['estimate'] + z_score * data['std.error']
```

2. **Configure academic style**

```python
plt.rcParams['font.sans-serif'] = ['STFangsong', 'SimSun', 'PingFang SC', 'SimHei']
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['axes.unicode_minus'] = False

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

COLORS = ['#000000', '#7F7F7F']
MARKERS = ['o', 's', '^', 'D']
```

3. **Generate dot-whisker plot**

```python
fig, ax = plt.subplots(figsize=({{width}}, {{height}}))

model_col = '{{model}}' if '{{model}}' else None
reference = float('{{reference}}' or 0)
reorder = '{{reorder}}' == 'true'

if reorder:
    data = data.sort_values('estimate', ascending=True)

variables = data['term'].unique()
y_pos = np.arange(len(variables))

if model_col and model_col in data.columns:
    # Multi-model comparison
    models = data[model_col].unique()
    n_models = len(models)
    offset_step = 0.3 / n_models

    for i, model in enumerate(models):
        subset = data[data[model_col] == model]
        offset = (i - n_models/2 + 0.5) * offset_step

        # Map variable positions
        var_to_pos = {var: pos for pos, var in enumerate(variables)}
        positions = [var_to_pos[var] + offset for var in subset['term']]

        # Draw whiskers (confidence intervals)
        for j, (_, row) in enumerate(subset.iterrows()):
            pos = var_to_pos[row['term']] + offset
            ax.plot([row['conf.low'], row['conf.high']], [pos, pos],
                    color=COLORS[i % len(COLORS)], linewidth=1.5)

        # Draw points
        ax.scatter(subset['estimate'], positions,
                   color=COLORS[i % len(COLORS)],
                   s=50, marker=MARKERS[i % len(MARKERS)],
                   label=model, zorder=5)
else:
    # Single model
    for i, (_, row) in enumerate(data.iterrows()):
        ax.plot([row['conf.low'], row['conf.high']], [i, i],
                color='black', linewidth=1.5, solid_capstyle='round')

    ax.scatter(data['estimate'], y_pos, color='black', s=60, zorder=5)

# Reference line
ax.axvline(x=reference, color='gray', linestyle='--', linewidth=1, alpha=0.7)

# Configure axes
ax.set_yticks(y_pos)
ax.set_yticklabels(variables)
ax.set_xlabel('{{xlabel}}' or f'系数估计值 ({int(ci_level*100)}% 置信区间)')

if '{{title}}':
    ax.set_title('{{title}}')

ax.invert_yaxis()  # Highest variable at top

if model_col:
    ax.legend(loc='lower right')

plt.tight_layout()
```

4. **Save output**

```python
output_path = Path('{{output}}' or 'paper/figures/dotwhisker')
output_path.parent.mkdir(parents=True, exist_ok=True)

for fmt in ['pdf', 'png']:
    fig.savefig(f"{output_path}.{fmt}")
    print(f"Saved: {output_path}.{fmt}")

plt.close()
```

## Example Usage

```
/academic-figures:dotwhisker regression_results.csv --title "工资决定因素分析" --xlabel "系数估计值 (95% 置信区间)"
```

## Data Example

```csv
term,estimate,std.error
教育年限,0.082,0.009
工作经验,0.035,0.004
性别 (女性),-0.152,0.023
城市户籍,0.124,0.019
```

## Output

- Clean dot-whisker plot with reference line at zero
- Confidence intervals displayed as horizontal lines
- Point estimates as solid dots
- No overlapping annotations
