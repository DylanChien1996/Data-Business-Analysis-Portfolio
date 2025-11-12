# 🏨 Hotel Review Analysis Dashboard

An end-to-end project analyzing **global hotel reviews (2015–2017)** with **Python, R, and Tableau**.  
It explores **guest ratings, sentiment, traveler types, and nationalities** to reveal what drives hotel satisfaction across regions.

---

## 🖼️ Dashboard Preview

![Dashboard Preview](dashboard_preview.png)

> *Built in Tableau — KPIs, global rating map, sentiment by traveler type, and yearly rating trend.*

---

## 📊 Project Overview

This project demonstrates a full analytics workflow:

- **Data Cleaning & Sentiment Scoring** (Python, VADER)
- **Statistical Validation** (R — ANOVA & Tukey HSD)
- **Interactive Visualization** (Tableau Desktop)
- **Business Insights** on traveler mix, satisfaction, and trends

Focus questions:
- Which **traveler type** tends to give higher/lower ratings?
- What is the **overall positive sentiment** across reviews?
- How do **ratings evolve** from 2015 to 2017?
- Are there patterns by **reviewer nationality**?

---

## 📁 Files Included

| File | Description |
|------|--------------|
| `Hotel Review Analysis Dashboard.twb` | Tableau dashboard (final visualization) |
| `Hotel Review Analysis_py.ipynb` | Python notebook for cleaning & sentiment analysis (VADER) |
| `Hotel Review Analysis_R.R` | R script for ANOVA and Tukey post-hoc tests |
| `dashboard_preview.png` | Dashboard image used as GitHub cover |

> *資料檔因容量限制未附；儀表板已內嵌匯出結果可直接檢視。*

---

## 🧠 Key Insights

- 💑 **Couple travelers** show the **highest positive sentiment** (~**52%**)
- 💼 **Business travelers**給出較低的情緒與評分（平均約 **7.9–8.0**）
- 📈 **Average reviewer score** 保持穩定在 **8.2–8.5** 之間（2015–2017）
- 💬 整體 **Positive Sentiment ≈ 76%**，代表整體滿意度偏高
- 🌍 部分國籍組合在 Top 10 中維持 **>9.0** 的高分表現

---

## ⚙️ Tools Used

| Tool | Purpose |
|------|----------|
| **Python (Pandas, VADER)** | Data cleaning & sentiment scoring |
| **R (tidyverse, stats)** | ANOVA, Tukey HSD, significance checks |
| **Tableau Desktop** | KPI cards, global map, interactive charts |
| **Excel** | Quick checks & final data prep |

---

## 📚 Data Notes

- 時間範圍：**2015–2017**  
- 評分與情緒值來自清理後之評論資料；Tableau 儀表板提供互動式探索與過濾功能。  
- `dashboard_preview.png` 僅作為 GitHub 封面縮圖；請開啟 `.twb` 以完整互動。

---

## ✨ Author

**Dylan Chien (Vincent)**  
🎓 M.Sc. in Advanced Analytics – Big Data  
📍 Warsaw, Poland  
🔗 [LinkedIn](https://www.linkedin.com/in/dylan-chien-868a03135) ｜ [GitHub Portfolio](https://github.com/DylanChien1996)

---

> _“Turning hotel reviews into actionable insights for better guest experiences.”_
