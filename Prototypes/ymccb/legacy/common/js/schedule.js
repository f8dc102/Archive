let isWeekday = true; // 현재 모드 (true = 평일, false = 휴일)

/**
 * Toggle the bus schedule panel visibility.
 */
document.getElementById("toggleBusSchedule").addEventListener("click", function () {
    const panel = document.getElementById("busSchedulePanel");
    panel.classList.toggle("collapsed");
    this.textContent = panel.classList.contains("collapsed") ? "▼" : "▲";
});

/**
 * Toggle the schedule mode (평일 ↔ 휴일)
 */
document.getElementById("toggleScheduleMode").addEventListener("click", function () {
    isWeekday = !isWeekday;

    // UI 업데이트
    document.getElementById("scheduleMode").innerText = isWeekday ? "평일" : "휴일";

    // 새 일정에 맞게 시간표 다시 로드
    displayBusSchedule(document.getElementById("busSelector").value);
});

/**
 * Show the bus schedule when the page loads.
 */
document.addEventListener("DOMContentLoaded", async function () {
    await displayBusSchedule();
});

/**
 * Load and parse a CSV file.
 * @param {string} filePath - Path to the CSV file.
 * @returns {Promise<{header: Array, data: Array, footer: string}>} - Parsed CSV header, data, and footer.
 */
async function loadCSV(filePath) {
    const response = await fetch(filePath);
    const text = await response.text();

    const lines = text.trim().split("\n").filter(line => line);

    let footer = "";
    const header = lines[0].split(",").map(h => h.trim()); // 첫 번째 줄을 헤더로 저장
    const data = lines
        .slice(1) // 헤더 제외
        .filter(line => !line.startsWith("#")) // 주석(#) 제외한 데이터만 저장
        .map(line => {
            const values = line.match(/(".*?"|[^,]+)(?=\s*,|\s*$)/g).map(v => v.replace(/^"|"$/g, ''));

            return {
                time: values[0], // ⏰ 시간대
                upBound: values[1] || "-", // 🏫 연세대발
                downBound: values[2] || "-", // 🚌 장양리발
            };
        });

    // 주석(#) 라인 가져오기
    const footerLines = lines.filter(line => line.startsWith("#")).map(line => line.replace(/^#\s*/, ''));
    if (footerLines.length > 0) {
        footer = footerLines.join(" / "); // 여러 줄이면 " / "로 합치기
    }

    return { header, data, footer };
}

/**
 * Load and display bus schedule from CSV.
 */
async function displayBusSchedule(routeId = "251000068") {
    const scheduleToggle = document.getElementById("scheduleToggleContainer");

    // 🚨 30번 노선은 평일/휴일 개념이 없으므로 버튼 숨김
    if (routeId === "251000068") {
        scheduleToggle.style.display = "none";
    } else {
        scheduleToggle.style.display = "flex";
    }

    // 🚍 CSV 파일 결정
    const filePath = routeId === "251000068"
        ? `common/csvs/${routeId}.csv` // 30번은 단일 파일
        : `common/csvs/${routeId}${isWeekday ? "" : "H"}.csv`;

    const { header, data: scheduleData, footer } = await loadCSV(filePath);

    // console.log("✅ Loaded:", filePath);

    const tableHead = document.getElementById("busScheduleHeader");
    const tableBody = document.getElementById("busScheduleTable");

    if (!tableHead || !tableBody) {
        console.error("🚨 Error: HTML 요소를 찾을 수 없음!");
        return;
    }

    // 📝 헤더 업데이트
    tableHead.innerHTML = `
            <tr>
                <th>${header[0]}</th>
                <th>${header[1]}</th>
                <th>${header[2]}</th>
            </tr>
        `;

    tableBody.innerHTML = ""; // 기존 데이터 지우기

    scheduleData.forEach(entry => {
        const row = document.createElement("tr");

        row.innerHTML = `
                <td style="text-align: center; font-size: 14px; padding: 5px;">${entry.time}</td>
                <td style="text-align: ${entry.upBound === '-' ? 'center' : 'left'}; font-size: 14px; padding: 5px;">${entry.upBound}</td>
                <td style="text-align: ${entry.downBound === '-' ? 'center' : 'left'}; font-size: 14px; padding: 5px;">${entry.downBound}</td>
            `;

        tableBody.appendChild(row);
    });

    // 📝 미주 추가 (CSV에서 불러온 내용 자동 적용)
    if (footer) {
        const footerRow = document.createElement("tr");
        footerRow.innerHTML = `
                <td colspan="3" style="text-align: left; font-size: 12px; padding-top: 5px; color: gray;">
                    ${footer}
                </td>
            `;
        tableBody.appendChild(footerRow);
    }
}