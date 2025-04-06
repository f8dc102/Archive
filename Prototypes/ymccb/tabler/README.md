# ymccb

Yonsei Wonju Bus Timetabler

## Instructions

1. Get the bus timetable from the official website.

2. Copy the xlsx file to data/raw directory and rename it to `[BUS_NUMBER][if Holiday add H suffix to here else pass].xlsx`.

3. Change directory to root of this project.

```bash
cd [Drag and Drop the root of this project]
```

4. Activate the virtual environment.

```bash
source venv/bin/activate
```

5. Run the script of `xlsx_to_csv.py`.

```bash
python src/xlsx_to_csv.py
```

6. Run the script of `formatter.py`.

```bash
python src/formatter.py
```

7. Check the output file in the `data/output` directory.

Enjoy!