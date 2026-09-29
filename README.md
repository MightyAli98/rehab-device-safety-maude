# Rehab Device Safety: What 10 Years of FDA Reports Reveal

**Muhammad Ali** · Physiotherapist | Medical Data Analyst
*Independent case study built on public data (FDA MAUDE, 2016 – Sep 2026)*

## The question
Which rehab devices cause what harm, how serious is it, and what can distributors and clinics do to prevent it?

## Key findings
| Finding | Evidence | Recommended action |
|---|---|---|
| Burns dominate stimulator harm | Burn/skin injury in 62% of prescription and 49% of OTC TENS reports | Skin-check and electrode-placement card plus replacement electrodes with every unit |
| Home use matters | 76% of OTC TENS reports involve home use; severe outcomes 18.6% vs 4.7% for prescription TENS | Prefer models with auto shut-off; patient instructions on session time and sleep |
| Exoskeleton harm is fractures | 81.5% of exoskeleton reports involve a fall or fracture | Bone-density screening and therapist certification before training |
| Supplier concentration | One manufacturer = 58% of prescription TENS reports, with 10× more deep burns | Request complaint history and safety tests before importing |

## Data
- **Source:** [FDA MAUDE](https://www.fda.gov/medical-devices/medical-device-reporting-mdr-how-report-medical-device-problems/mdr-data-files) bulk files + openFDA API
- **Scope:** 477 reports, 5 product codes (GZJ, NUH, IPF, PHL, BXB), 2016 – Sep 2026
- **Validation:** report counts match the openFDA API exactly (0.0% difference)

## Method
1. **Collect** (`01_build_dataset.ipynb`): streamed ~30 million national records and kept only verified rehab product codes.
2. **Clean** (`02_clean.ipynb`): removed duplicate records (up to 48% in some files), graded harm from patient outcome codes, translated FDA codes, standardised 142 manufacturer name variants to 108.
3. **Analyse** (`03_analysis.ipynb`, `sql/analysis_queries.sql`): severity, harm categories, home use, supplier profiles, device problems, narrative keywords.

**Tools:** Python (pandas), SQL (SQLite), Power BI, Google Colab

## Repository structure
| Location | Contents |
|---|---|
| `*.ipynb` (top level) | Data collection, cleaning and analysis, with a decision log |
| `sql/` | Key analysis queries |
| `data/clean/` | Clean tables (one row per report, plus problems and narratives) |
| `outputs/tables/` | Result tables used in the dashboard |

## Limitations
MAUDE counts reports, not rates: there are no sales figures, many events go unreported, and reports are not verified. Findings show patterns worth acting on, not proof that one product is safer than another. With a company's own complaint and sales data, the same method can produce true complaint rates.
