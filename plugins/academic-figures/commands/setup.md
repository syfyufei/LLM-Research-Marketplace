---
description: Check environment and configure fonts for academic figure generation
---

## Goal

Verify the user's Python environment has required packages installed and detect available Chinese fonts for academic figure generation.

## Execution Steps

1. **Check Python and required packages**

Run the following Python script to check dependencies:

```python
import sys
print(f"Python version: {sys.version}")

required = ['matplotlib', 'numpy', 'pandas']
optional = ['seaborn', 'geopandas', 'scipy']

missing_required = []
missing_optional = []

for pkg in required:
    try:
        __import__(pkg)
        print(f"[OK] {pkg}")
    except ImportError:
        missing_required.append(pkg)
        print(f"[MISSING] {pkg}")

for pkg in optional:
    try:
        __import__(pkg)
        print(f"[OK] {pkg} (optional)")
    except ImportError:
        missing_optional.append(pkg)
        print(f"[MISSING] {pkg} (optional)")

if missing_required:
    print(f"\nInstall missing required packages: pip install {' '.join(missing_required)}")
```

2. **Detect available Chinese fonts**

```python
from matplotlib import font_manager

# Chinese font candidates by platform
font_candidates = [
    'STFangsong', 'SimSun', 'SimHei',  # Windows/Mac
    'PingFang SC', 'Heiti SC', 'STHeiti',  # macOS
    'Noto Sans CJK SC', 'WenQuanYi Micro Hei',  # Linux
    'Microsoft YaHei', 'FangSong'
]

available_fonts = set(f.name for f in font_manager.fontManager.ttflist)
chinese_fonts = [f for f in font_candidates if f in available_fonts]

print("\nAvailable Chinese fonts:")
for f in chinese_fonts:
    print(f"  - {f}")

if chinese_fonts:
    print(f"\nRecommended font: {chinese_fonts[0]}")
else:
    print("\nWARNING: No Chinese fonts found. Chinese characters may not display correctly.")
    print("Consider installing: Noto Sans CJK or Source Han Sans")
```

3. **Test figure generation**

```python
import matplotlib.pyplot as plt
import matplotlib as mpl

# Configure Chinese font
chinese_fonts = ['STFangsong', 'SimSun', 'PingFang SC', 'SimHei']
plt.rcParams['font.sans-serif'] = chinese_fonts
plt.rcParams['font.family'] = 'sans-serif'
plt.rcParams['axes.unicode_minus'] = False

# Test plot
fig, ax = plt.subplots(figsize=(4, 3))
ax.bar(['类别A', '类别B', '类别C'], [3, 7, 5], color=['black', 'gray', 'lightgray'])
ax.set_title('中文字体测试')
ax.set_ylabel('数值')
plt.tight_layout()
plt.savefig('font_test.png', dpi=150)
plt.close()
print("\nTest figure saved to: font_test.png")
print("Please verify Chinese characters display correctly.")
```

## Output

Report the following to the user:
- Python version and package status
- Available Chinese fonts
- Test figure location for verification

## Error Handling

- If matplotlib is missing: Provide `pip install matplotlib numpy pandas` command
- If no Chinese fonts found: Suggest installing Noto Sans CJK fonts
- If font test fails: Check matplotlib cache with `matplotlib.get_cachedir()`
