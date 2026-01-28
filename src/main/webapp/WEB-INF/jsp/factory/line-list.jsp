<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <spring:message code="factory.line.list.title" text="생산라인 관리 - TP MES" />
                </title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <link href="/assets/factory-modern.css" rel="stylesheet">
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <style>
                    .container {
                        max-width: 1600px;
                    }

                    .filter-row {
                        grid-template-columns: 1fr 1fr auto;

                        /* Responsive Design */
                        @media (max-width: 768px) {
                            body {
                                padding: 12px;
                            }

                            .page-header {
                                padding: 20px;
                            }

                            .page-header h1 {
                                font-size: 22px;
                            }

                            table {
                                font-size: 13px;
                                display: block;
                                overflow-x: auto;
                            }

                            .filter-form {
                                flex-direction: column;
                            }

                            .btn {
                                width: 100%;
                            }
                        }

                        @media (max-width: 480px) {
                            .page-header h1 {
                                font-size: 20px;
                            }

                            table {
                                font-size: 12px;
                            }
                        }
                    }
                </style>
            </head>

            <body>
                <%@ include file="../app/_appHeader.jspf" %>

                    <div class="container">
                        <div class="page-header">
                            <h1>⚙️
                                <spring:message code="factory.line.management" text="생산라인 관리" />
                            </h1>
                            <p class="subtitle">실시간 생산 현황을 모니터링하고 관리합니다</p>
                        </div>

                        <c:if test="${not empty message}">
                            <div
                                style="background: linear-gradient(135deg, #48bb78 0%, #38a169 100%); color: white; padding: 16px 20px; border-radius: 12px; margin-bottom: 24px;">
                                ${message}
                            </div>
                        </c:if>

                        <div class="filter-card">
                            <form method="get" action="/factory/lines" id="filterForm">
                                <div class="filter-row">
                                    <div class="filter-group">
                                        <label>🏭
                                            <spring:message code="factory.plant" text="공장" />
                                        </label>
                                        <select name="factory" id="factorySelect">
                                            <option value="">전체 공장</option>
                                            <c:forEach items="${factories}" var="fac">
                                                <option value="${fac.factoryId}" ${selectedFactory==fac.factoryId
                                                    ? 'selected' : '' }>
                                                    ${fac.factoryName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="filter-group">
                                        <label>📊
                                            <spring:message code="factory.status" text="운영 상태" />
                                        </label>
                                        <select name="status" id="statusSelect">
                                            <option value="">전체 상태</option>
                                            <option value="RUNNING" ${selectedStatus=='RUNNING' ? 'selected' : '' }>가동 중
                                            </option>
                                            <option value="STOPPED" ${selectedStatus=='STOPPED' ? 'selected' : '' }>정지
                                            </option>
                                            <option value="IDLE" ${selectedStatus=='IDLE' ? 'selected' : '' }>대기
                                            </option>
                                            <option value="MAINTENANCE" ${selectedStatus=='MAINTENANCE' ? 'selected'
                                                : '' }>
                                                점검</option>
                                            <option value="ERROR" ${selectedStatus=='ERROR' ? 'selected' : '' }>오류
                                            </option>
                                        </select>
                                    </div>

                                    <div class="filter-group">
                                        <button type="submit" class="btn btn-primary">
                                            <spring:message code="common.filter.apply" text="필터 적용" />
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <div style="display: flex; justify-content: flex-end; margin-bottom: 16px;">
                            <a href="/factory/lines/new" class="btn btn-primary">
                                ➕
                                <spring:message code="factory.line.new" text="신규 라인 등록" />
                            </a>
                        </div>

                        <div class="table-container">
                            <c:choose>
                                <c:when test="${empty lines}">
                                    <div style="text-align: center; padding: 60px; color: #718096;">
                                        <p>등록된 생산라인이 없습니다</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>
                                                    <spring:message code="factory.line.id" text="라인 ID" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.line.name" text="라인명" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.location" text="소속 (사업장/공장)" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.line.type" text="유형" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.status" text="상태" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.workers" text="투입 인원" />
                                                </th>
                                                <th>
                                                    <spring:message code="factory.utilization" text="가동률" />
                                                </th>
                                                <th>
                                                    <spring:message code="common.action" text="작업" />
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${lines}" var="line">
                                                <tr>
                                                    <td><code
                                                            style="background: #edf2f7; padding: 4px 8px; border-radius: 6px;">${line.lineId}</code>
                                                    </td>
                                                    <td>
                                                        <strong>${line.lineName}</strong>
                                                        <br><small style="color: #718096;">${line.lineCode}</small>
                                                    </td>
                                                    <td>
                                                        <div>${line.plantName}</div>
                                                        <small style="color: #718096;">${line.factoryName}</small>
                                                    </td>
                                                    <td>${line.lineType}</td>
                                                    <td>
                                                        <span class="badge badge-${line.status.toLowerCase()}">
                                                            ${line.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div onclick="showWorkers('${line.lineId}', '${line.lineName}')"
                                                            class="clickable-count"
                                                            id="worker-count-container-${line.lineId}"
                                                            data-standard="${line.standardWorkers}">
                                                            <strong id="worker-current-${line.lineId}"
                                                                style="color: ${line.currentWorkers == line.standardWorkers ? '#48bb78' : '#ed8936'};">
                                                                ${line.currentWorkers}
                                                            </strong> / ${line.standardWorkers}명
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div style="display: flex; align-items: center; gap: 8px;">
                                                            <div class="progress-bar">
                                                                <div class="progress-fill"
                                                                    style="width: ${line.utilizationRate}%;"></div>
                                                            </div>
                                                            <strong>${line.utilizationRate}%</strong>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <form method="post"
                                                            action="/factory/lines/${line.lineId}/status"
                                                            style="display: inline;">
                                                            <select name="status" onchange="this.form.submit()"
                                                                style="padding: 4px 8px; border-radius: 6px;">
                                                                <option value="">상태 변경</option>
                                                                <option value="RUNNING">가동</option>
                                                                <option value="STOPPED">정지</option>
                                                                <option value="MAINTENANCE">점검</option>
                                                            </select>
                                                            <input type="hidden" name="isOperating" value="true">
                                                        </form>
                                                        <a href="/factory/lines/${line.lineId}/edit"
                                                            class="btn btn-secondary"
                                                            style="padding: 4px 8px; font-size: 13px; margin-left: 4px;">
                                                            수정
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="summary-box">
                            총 <strong>${lines.size()}</strong>개의 생산라인이 조회되었습니다
                        </div>
                    </div>

                    <%@ include file="../include/footer.jspf" %>


                        <!-- Workers Modal -->
                        <div id="workersModal" class="modal-overlay" style="display: none;">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <div>
                                        <h3 id="modalTitle">투입 인원 현황</h3>
                                        <p id="modalSubtitle" style="color: #718096; font-size: 14px; margin-top: 4px;">
                                            현재 라인에 배정된 인원 목록입니다</p>
                                    </div>
                                    <button class="close-btn" onclick="closeModal()">&times;</button>
                                </div>

                                <div class="worker-allocation-section"
                                    style="margin-bottom: 20px; padding-bottom: 20px; border-bottom: 1px solid #e2e8f0;">
                                    <h4 style="font-size: 14px; font-weight: 600; margin-bottom: 10px;">인원 추가 배정</h4>
                                    <div style="display: flex; gap: 8px;">
                                        <select id="workerSelect"
                                            style="flex: 1; padding: 8px; border: 1px solid #e2e8f0; border-radius: 6px;">
                                            <option value="">배정할 사원을 선택하세요</option>
                                        </select>
                                        <button onclick="assignWorker()" class="btn btn-primary"
                                            style="padding: 8px 16px; font-size: 13px;">추가</button>
                                    </div>
                                </div>

                                <div id="workersList" class="workers-list">
                                    <!-- Workers will be loaded here -->
                                </div>
                            </div>
                        </div>

                        <!-- Toast Container -->
                        <div id="toastContainer" class="toast-container"></div>

                        <style>
                            .modal-overlay {
                                position: fixed;
                                top: 0;
                                left: 0;
                                width: 100%;
                                height: 100%;
                                background: rgba(0, 0, 0, 0.5);
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                z-index: 1000;
                            }

                            .modal-content {
                                background: white;
                                border-radius: 12px;
                                width: 90%;
                                max-width: 600px;
                                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
                            }

                            .modal-header {
                                padding: 16px 20px;
                                border-bottom: 1px solid #e2e8f0;
                                display: flex;
                                justify-content: space-between;
                                align-items: center;
                            }

                            .modal-header h3 {
                                margin: 0;
                                font-size: 18px;
                            }

                            .close-btn {
                                background: none;
                                border: none;
                                font-size: 24px;
                                cursor: pointer;
                                color: #718096;
                            }

                            .modal-body {
                                /* This was for the old modal, but the new one uses .workers-list */
                                padding: 20px;
                                max-height: 500px;
                                overflow-y: auto;
                            }

                            .worker-avatar {
                                width: 40px;
                                height: 40px;
                                background: #e2e8f0;
                                border-radius: 50%;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                font-size: 20px;
                            }

                            .worker-info div:first-child {
                                font-weight: 600;
                                font-size: 15px;
                            }

                            .worker-info div:last-child {
                                font-size: 13px;
                                color: #718096;
                            }

                            .clickable-count {
                                cursor: pointer;
                                color: #3182ce;
                                text-decoration: none;
                                font-weight: 500;
                                transition: color 0.2s;
                            }

                            .clickable-count:hover {
                                color: #2c5282;
                                text-decoration: underline;
                            }

                            /* Worker Modal Styles */
                            .modal-overlay {
                                position: fixed;
                                top: 0;
                                left: 0;
                                width: 100%;
                                height: 100%;
                                background: rgba(0, 0, 0, 0.5);
                                backdrop-filter: blur(4px);
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                z-index: 1000;
                            }

                            .modal-content {
                                background: white;
                                border-radius: 16px;
                                width: 90%;
                                max-width: 550px;
                                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
                                overflow: hidden;
                                display: flex;
                                flex-direction: column;
                                max-height: 85vh;
                            }

                            .modal-header {
                                padding: 20px 24px;
                                border-bottom: 1px solid #e2e8f0;
                                display: flex;
                                justify-content: space-between;
                                align-items: flex-start;
                                background: #fff;
                            }

                            .modal-header h3 {
                                margin: 0;
                                font-size: 18px;
                                font-weight: 700;
                                color: #2d3748;
                            }

                            .close-btn {
                                background: none;
                                border: none;
                                font-size: 24px;
                                cursor: pointer;
                                color: #a0aec0;
                                transition: color 0.2s;
                                line-height: 1;
                                padding: 0;
                            }

                            .close-btn:hover {
                                color: #4a5568;
                            }

                            .worker-allocation-section {
                                padding: 20px 24px;
                                background: #f7fafc;
                                border-bottom: 1px solid #e2e8f0;
                            }

                            .worker-allocation-section h4 {
                                font-size: 14px;
                                font-weight: 600;
                                color: #4a5568;
                                margin: 0 0 12px 0;
                            }

                            #workerSelect {
                                flex: 1;
                                padding: 10px 12px;
                                border: 1px solid #cbd5e0;
                                border-radius: 8px;
                                font-size: 14px;
                                color: #2d3748;
                                outline: none;
                                transition: border-color 0.2s, box-shadow 0.2s;
                                background-color: white;
                            }

                            #workerSelect:focus {
                                border-color: #4299e1;
                                box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.15);
                            }

                            .workers-list {
                                padding: 24px;
                                overflow-y: auto;
                                flex: 1;
                            }

                            .worker-item {
                                display: flex;
                                align-items: center;
                                justify-content: space-between;
                                padding: 12px 16px;
                                background: white;
                                border: 1px solid #e2e8f0;
                                border-radius: 10px;
                                margin-bottom: 12px;
                                transition: transform 0.1s, box-shadow 0.1s;
                            }

                            .worker-item:hover {
                                border-color: #cbd5e0;
                                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                            }

                            .worker-info {
                                display: flex;
                                align-items: center;
                                gap: 16px;
                            }

                            .worker-avatar {
                                width: 42px;
                                height: 42px;
                                background: linear-gradient(135deg, #ebf4ff 0%, #c3dafe 100%);
                                color: #4c51bf;
                                border-radius: 12px;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                font-weight: 700;
                                font-size: 16px;
                            }

                            .worker-name {
                                font-weight: 600;
                                color: #2d3748;
                                font-size: 15px;
                            }

                            .worker-id {
                                color: #718096;
                                font-size: 13px;
                                font-weight: normal;
                                margin-left: 4px;
                            }

                            .worker-meta {
                                font-size: 13px;
                                color: #718096;
                                margin-top: 2px;
                            }

                            .status-badge {
                                background: #c6f6d5;
                                color: #22543d;
                                font-size: 12px;
                                font-weight: 600;
                                padding: 4px 10px;
                                border-radius: 20px;
                                display: inline-block;
                            }

                            .btn-remove {
                                color: #e53e3e;
                                background: rgba(229, 62, 62, 0.1);
                                border: none;
                                cursor: pointer;
                                width: 28px;
                                height: 28px;
                                border-radius: 6px;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                font-size: 18px;
                                margin-left: 12px;
                                transition: all 0.2s;
                            }

                            .btn-remove:hover {
                                background: #e53e3e;
                                color: white;
                            }

                            /* Scrollbar styling */
                            .workers-list::-webkit-scrollbar {
                                width: 6px;
                            }

                            .workers-list::-webkit-scrollbar-track {
                                background: #f1f1f1;
                            }

                            .workers-list::-webkit-scrollbar-thumb {
                                background: #cbd5e0;
                                border-radius: 3px;
                            }

                            .workers-list::-webkit-scrollbar-thumb:hover {
                                background: #a0aec0;
                            }

                            /* Toast Notification */
                            .toast-container {
                                position: fixed;
                                top: 20px;
                                right: 20px;
                                z-index: 9999;
                                display: flex;
                                flex-direction: column;
                                gap: 10px;
                                pointer-events: none;
                            }

                            .toast-api {
                                background: white;
                                padding: 16px 24px;
                                border-radius: 12px;
                                box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
                                display: flex;
                                align-items: center;
                                gap: 12px;
                                transform: translateX(120%);
                                transition: transform 0.3s cubic-bezier(0.68, -0.55, 0.265, 1.55);
                                min-width: 300px;
                                pointer-events: auto;
                                border-left: 5px solid #cbd5e0;
                            }

                            .toast-api.show {
                                transform: translateX(0);
                            }

                            .toast-api.success {
                                border-left-color: #48bb78;
                            }

                            .toast-api.error {
                                border-left-color: #f56565;
                            }

                            .toast-icon {
                                font-size: 20px;
                            }

                            .toast-message {
                                font-size: 14px;
                                color: #2d3748;
                                font-weight: 500;
                            }

                            @keyframes slideIn {
                                from {
                                    opacity: 0;
                                    transform: translateY(-10px);
                                }

                                to {
                                    opacity: 1;
                                    transform: translateY(0);
                                }
                            }

                            .worker-item.new-item {
                                animation: slideIn 0.3s ease-out;
                                border-left: 3px solid #48bb78;
                            }
                        </style>

                        <script>
                            function updateWorkerCount(lineId, change) {
                                const currentEl = document.getElementById('worker-current-' + lineId);
                                const containerEl = document.getElementById('worker-count-container-' + lineId);
                                if (!currentEl || !containerEl) return;

                                let current = parseInt(currentEl.innerText);
                                const standard = parseInt(containerEl.dataset.standard);

                                current += change;
                                if (current < 0) current = 0; // Precaution

                                currentEl.innerText = current;

                                if (current >= standard) {
                                    currentEl.style.color = '#48bb78'; // Green
                                } else {
                                    currentEl.style.color = '#ed8936'; // Orange
                                }
                            }

                            document.getElementById('factorySelect').addEventListener('change', function () {
                                document.getElementById('filterForm').submit();
                            });

                            document.getElementById('statusSelect').addEventListener('change', function () {
                                document.getElementById('filterForm').submit();
                            });

                            let currentLineId = '';

                            function showToast(message, type = 'info') {
                                const container = document.getElementById('toastContainer');
                                const toast = document.createElement('div');
                                toast.className = 'toast-api ' + type;

                                let icon = 'ℹ️';
                                if (type === 'success') icon = '✅';
                                if (type === 'error') icon = '⚠️';

                                toast.innerHTML = '<div class="toast-icon">' + icon + '</div>' +
                                    '<div class="toast-message">' + message + '</div>';

                                container.appendChild(toast);

                                // Trigger reflow
                                void toast.offsetWidth;

                                toast.classList.add('show');

                                setTimeout(function () {
                                    toast.classList.remove('show');
                                    setTimeout(function () {
                                        toast.remove();
                                    }, 300);
                                }, 3000);
                            }

                            function showWorkers(lineId, lineName) {
                                currentLineId = lineId;
                                document.getElementById('modalTitle').textContent = '👷 ' + lineName + ' - 투입 인원 현황';
                                document.getElementById('workersModal').style.display = 'flex';
                                loadWorkers(lineId);
                                loadAvailableWorkers();
                            }

                            function closeModal() {
                                document.getElementById('workersModal').style.display = 'none';
                            }

                            function loadWorkers(lineId) {
                                const listContainer = document.getElementById('workersList');
                                listContainer.innerHTML = '<div style="text-align: center; padding: 20px; color: #718096;">데이터를 불러오는 중...</div>';

                                Api.get('/factory/lines/' + lineId + '/workers', function (workers) {
                                    if (!workers || workers.length === 0) {
                                        listContainer.innerHTML =
                                            '<div style="text-align: center; padding: 40px 0;">' +
                                            '<div style="font-size: 48px; margin-bottom: 16px;">👥</div>' +
                                            '<p style="color: #718096;">배정된 인원이 없습니다.</p>' +
                                            '</div>';
                                        return;
                                    }

                                    listContainer.innerHTML = workers.map(function (worker) {
                                        return '<div class="worker-item">' +
                                            '<div class="worker-info">' +
                                            '<div class="worker-avatar">' +
                                            worker.empName.charAt(0) +
                                            '</div>' +
                                            '<div>' +
                                            '<div class="worker-name">' +
                                            worker.empName +
                                            ' <span class="worker-id">(' + worker.empId + ')</span>' +
                                            '</div>' +
                                            '<div class="worker-meta">' +
                                            worker.deptName + ' • ' + worker.positionName +
                                            '</div>' +
                                            '</div>' +
                                            '</div>' +
                                            '<div class="worker-status" style="display: flex; align-items: center;">' +
                                            '<span class="status-badge">' +
                                            worker.status +
                                            '</span>' +
                                            '<button onclick="removeWorker(\'' + worker.empId + '\')" class="btn-remove" title="배정 해제">&times;</button>' +
                                            '</div>' +
                                            '</div>';
                                    }).join('');
                                }, function (err) {
                                    console.error('Error loading workers:', err);
                                    listContainer.innerHTML = '<div style="text-align: center; color: #e53e3e;">데이터를 불러오는데 실패했습니다.</div>';
                                });
                            }

                            function loadAvailableWorkers() {
                                const select = document.getElementById('workerSelect');
                                select.innerHTML = '<option value="">데이터를 불러오는 중...</option>';

                                Api.get('/factory/lines/available-workers', function (workers) {
                                    if (!workers || workers.length === 0) {
                                        select.innerHTML = '<option value="">배정 가능한 사원이 없습니다</option>';
                                        return;
                                    }

                                    let options = '<option value="">배정할 사원을 선택하세요</option>';
                                    options += workers.map(function (w) {
                                        return '<option value="' + w.empId + '">' + w.empName + ' (' + w.deptName + '/' + w.positionName + ')</option>';
                                    }).join('');
                                    select.innerHTML = options;
                                }, function (err) {
                                    console.error('Error loading available workers:', err);
                                    select.innerHTML = '<option value="">데이터 로드 실패</option>';
                                });
                            }

                            function assignWorker() {
                                const empId = document.getElementById('workerSelect').value;
                                if (!empId) {
                                    showToast('배정할 사원을 선택해주세요.', 'error');
                                    return;
                                }

                                Api.post('/factory/lines/' + currentLineId + '/workers', { empId: empId }, function (response) {
                                    showToast('사원이 배정되었습니다.', 'success');

                                    // Instant UI Update
                                    const worker = response.worker;
                                    const listContainer = document.getElementById('workersList');

                                    // Remove 'No workers' message if it exists
                                    if (listContainer.innerHTML.includes('배정된 인원이 없습니다')) {
                                        listContainer.innerHTML = '';
                                    }

                                    const workerHtml =
                                        '<div class="worker-item new-item">' +
                                        '<div class="worker-info">' +
                                        '<div class="worker-avatar">' +
                                        worker.empName.charAt(0) +
                                        '</div>' +
                                        '<div>' +
                                        '<div class="worker-name">' +
                                        worker.empName +
                                        ' <span class="worker-id">(' + worker.empId + ')</span>' +
                                        '</div>' +
                                        '<div class="worker-meta">' +
                                        worker.deptName + ' • ' + worker.positionName +
                                        '</div>' +
                                        '</div>' +
                                        '</div>' +
                                        '<div class="worker-status" style="display: flex; align-items: center;">' +
                                        '<span class="status-badge">' +
                                        worker.status +
                                        '</span>' +
                                        '<button onclick="removeWorker(\'' + worker.empId + '\')" class="btn-remove" title="배정 해제">&times;</button>' +
                                        '</div>' +
                                        '</div>';

                                    listContainer.insertAdjacentHTML('beforeend', workerHtml);

                                    // Remove from dropdown
                                    const option = document.querySelector('#workerSelect option[value="' + empId + '"]');
                                    if (option) option.remove();

                                    // Reset select
                                    document.getElementById('workerSelect').value = '';

                                    // Update main table count
                                    updateWorkerCount(currentLineId, 1);

                                    // loadAvailableWorkers(); // Optional: Refresh available list in background if needed
                                }, function (xhr, status, error) {
                                    console.error('Error assigning worker:', error);
                                    let msg = '사원 배정에 실패했습니다.';
                                    if (xhr.responseText) {
                                        msg += ' (' + xhr.responseText + ')';
                                    }
                                    showToast(msg, 'error');
                                });
                            }

                            function removeWorker(empId) {
                                if (!confirm('해당 사원을 라인에서 제외하시겠습니까?')) return;

                                $.ajax({
                                    url: '/factory/lines/' + currentLineId + '/workers/' + empId,
                                    type: 'DELETE',
                                    success: function (result) {
                                        showToast('사원 배정이 해제되었습니다.', 'success');

                                        // Update main table count
                                        updateWorkerCount(currentLineId, -1);

                                        loadWorkers(currentLineId);
                                        loadAvailableWorkers(); // Refresh available list
                                    },
                                    error: function (xhr, status, error) {
                                        console.error('Error removing worker:', error);
                                        showToast('배정 해제 실패: ' + (xhr.responseText || error), 'error');
                                    }
                                });
                            }

                            // Close modal when clicking outside
                            window.onclick = function (event) {
                                const modal = document.getElementById('workersModal');
                                if (event.target == modal) {
                                    closeModal();
                                }
                            }
                        </script>
            </body>

            </html>