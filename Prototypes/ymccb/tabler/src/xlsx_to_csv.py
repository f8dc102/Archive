import pandas as pd
import os

# Directory to xlsx files
XLSX_DIR = "data/raw"  # RAW XLSX DIRECTORY
CSV_DIR = "data/csv"    # CONVERTED CSV DIRECTORY

# If the CSV directory does not exist, create it
os.makedirs(CSV_DIR, exist_ok=True)

# Convert all XLSX files to CSV
xlsx_files = [f for f in os.listdir(XLSX_DIR) if f.endswith(".xlsx")]

for xlsx_file in xlsx_files:
    xlsx_path = os.path.join(XLSX_DIR, xlsx_file)
    csv_path = os.path.join(CSV_DIR, xlsx_file.replace(".xlsx", ".csv"))

    # Read the Excel file (only the first sheet)
    df = pd.read_excel(xlsx_path, sheet_name=0)

    # Save as CSV (UTF-8 encoding)
    df.to_csv(csv_path, index=False, encoding="utf-8")

    print(f"✅ Converted: {xlsx_file} → {csv_path}")

print("🎉 Done!")