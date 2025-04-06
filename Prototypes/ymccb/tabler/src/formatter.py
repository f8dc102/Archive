import pandas as pd
import os
from collections import defaultdict

# -------------------------------
# 1) 노선별 주석 매핑(딕셔너리)
# -------------------------------
bus_notes_map = {
    "30": [
        {
            "pattern": "상지대 경유",
            "superscript": "¹",
            "desc": "상지대 경유(주말, 공휴일, 상지대방학 제외)",
        },
        {
            "pattern": "원주역 미경유",
            "superscript": "²",
            "desc": "원주역 미경유",
        },
    ],
    "34": [
        {
            "pattern": "연세대발)원주역",
            "superscript": "¹",
            "desc": "원주역 경유",
        },
    ],
    "34-1": [
        {
            "desc": "※ 회촌에서 학관 버스정류장까지 평균 7분 정도 소요",
        },
    ],
}

# -------------------------------
# 2) CSV / 출력 디렉토리 설정
# -------------------------------
CSV_DIR = "data/csv"
OUTPUT_DIR = "data/output"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# -------------------------------
# 3) CSV 파일 목록 가져오기
# -------------------------------
csv_files = [f for f in os.listdir(CSV_DIR) if f.endswith(".csv")]

def convert_time(time_str):
    """
    시간 문자열(예: '8:15') -> (hour, minute) 튜플 변환.
    '-'나 '통학' 같은 특수 문자열은 무시(=None 반환)
    """
    if not isinstance(time_str, str) or "-" in time_str or "통학" in time_str:
        return None
    hour, minute = map(int, time_str.split(":"))
    return hour, f"{minute:02d}"

def detect_bus_number(csv_filename):
    """
    파일명에서 노선 번호 추출하는 로직 예시.
    예: 'bus30.csv' -> '30', '34.csv' -> '34'
    """
    import re
    match = re.search(r'\d+(-\d+)?', csv_filename)  # 34-1 같은 것도 추출 가능
    if match:
        return match.group(0)
    return None  # 기본값

def process_notes(row, minute_str, notes_config, used_superscripts):
    """
    특정 row의 '비고' 내용에 notes_config(노선별 패턴 정보)를 매칭하여
    시간(minute_str) 뒤에 첨자를 붙여서 반환.
    또한 어떤 첨자가 사용되었는지 used_superscripts에 기록.
    """
    result_time = minute_str
    remark = row.get("비고", "")
    
    if pd.notna(remark):
        for note_item in notes_config:
            # pattern 키가 없고 desc만 있는 항목(예: 34-1) 처리
            if "pattern" not in note_item:
                # 이 경우는 별도 첨자나 시간 뒤 꾸밈 없음
                continue
            # 만약 '비고'에 pattern이 포함되어 있으면
            if note_item["pattern"] in remark:
                # 첨자를 추가
                result_time += note_item["superscript"]
                # 사용된 첨자 기록
                used_superscripts[note_item["superscript"]] = note_item["desc"]
    return result_time

def process_bus_schedule(csv_file):
    """
    주어진 CSV 파일을 읽어, 노선 번호를 판별한 뒤 주석 딕셔너리를 적용하여
    시간표를 전처리하고 결과 CSV를 생성.
    """
    file_path = os.path.join(CSV_DIR, csv_file)
    df = pd.read_csv(file_path)

    # 파일명에 'H' 가 있으면 휴일, 없으면 평일
    bus_day_type = "휴일" if "H" in csv_file else "평일"

    # 노선 번호 추출
    bus_number = detect_bus_number(csv_file)
    # 이 노선에 해당하는 주석 정보 불러오기(없으면 빈 리스트)
    notes_config = bus_notes_map.get(bus_number, [])
    
    # departure_columns: "xx발" 컬럼만 추출
    departure_columns = [col for col in df.columns if "발" in col]

    # 원하는 순서대로 정렬(장양리발 → 회촌발 → 연세대발 → 그외)
    preferred_order = ["장양리발", "회촌발", "연세대발"]
    reordered_columns = []
    for col in preferred_order:
        if col in departure_columns:
            reordered_columns.append(col)
    # 나머지 발 컬럼 뒤에 붙이기
    for col in departure_columns:
        if col not in reordered_columns:
            reordered_columns.append(col)
    departure_columns = reordered_columns
    
    # 시간표 딕셔너리 초기화: { hour: {col: [분, 분, ...], ...}, ... }
    time_dict = defaultdict(lambda: {col: [] for col in departure_columns})
    
    # 노선에서 실제로 어떤 첨자가 사용되었는지 기록할 딕셔너리
    used_superscripts = {}  # 예: {"¹": "상지대 경유(주말...)", "²": "원주역 미경유"}

    # 데이터 프레임을 순회하며 시간별로 분(minute) 목록을 누적
    for _, row in df.iterrows():
        for col in departure_columns:
            converted = convert_time(row[col])
            if converted:
                hour, minute = converted
                # 비고를 확인해 주석(첨자)을 붙인 최종 time 문자열 생성
                time_with_notes = process_notes(row, minute, notes_config, used_superscripts)
                time_dict[hour][col].append(time_with_notes)

    # 06:00 ~ 23:00까지만 처리
    formatted_data = []
    for hour in range(6, 24):
        row_data = [f"{hour:02d}:00"]
        for col in departure_columns:
            minutes_list = time_dict[hour][col]
            row_data.append(", ".join(sorted(minutes_list)) if minutes_list else "-")
        formatted_data.append(row_data)

    # 최종 DataFrame 구성
    output_df = pd.DataFrame(formatted_data, columns=["⏰ 시간대"] + departure_columns)

    # 컬럼명 바꾸기
    rename_map = {
        "연세대발": "🏫 연세대발",
        "회촌발": "🌾 회촌발",
        "장양리시내버스공영정류장발": "🚌 장양리발",
    }
    output_df.rename(columns=rename_map, inplace=True)

    # CSV 저장
    output_file = os.path.join(OUTPUT_DIR, csv_file)
    output_df.to_csv(output_file, index=False, encoding="utf-8-sig")

    # -------------------------------
    # 4) 주석(첨자) 레전드 + 평일/휴일 추가
    # -------------------------------
    # notes_config 안에서 "pattern" 없이 "desc"만 있는 항목 = 항상 출력해야 할 내용
    notes_always_print = [
        note_item["desc"]
        for note_item in notes_config
        if "pattern" not in note_item and "desc" in note_item
    ]

    with open(output_file, "a", encoding="utf-8-sig") as f:
        # 만약 첨자(주석)가 있다면 우선 써 줌
        if used_superscripts:
            sorted_superscripts = sorted(used_superscripts.keys())
            notes_line = []
            for sup in sorted_superscripts:
                notes_line.append(f"{sup}) {used_superscripts[sup]}")
            f.write("\n")  # 테이블과 구분을 위해 줄바꿈
            f.write(",".join(notes_line) + "\n")

        # ① 항상 출력해야 하는 desc (ex: 34-1 노선의 안내문 등)
        if notes_always_print:
            f.write("\n")
            for desc_line in notes_always_print:
                f.write(desc_line + "\n")

        # ② 마지막 줄에 노선 번호 + 평일/휴일 정보 추가
        # 예: "30번 평일", "34번 휴일", "34-1번 휴일" 등
        f.write("\n")
        f.write(f"{bus_number}번 {bus_day_type}\n")

    print(f"✅ Converted: {csv_file} → {output_file} ({bus_day_type})")


# -------------------------------
# 5) 전체 CSV 파일 일괄 처리
# -------------------------------
for csv_file in csv_files:
    process_bus_schedule(csv_file)

print("🎉 Done!")