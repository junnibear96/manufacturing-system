<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
                <!DOCTYPE html>
                <html lang="ko">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>
                        <spring:message code="production.equipment.title" text="장비 관리 - TP MES" />
                    </title>
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                        rel="stylesheet">
                    <style>
                        * {
                            margin: 0;
                            padding: 0;
                            box-sizing: border-box;
                        }

                        body {
                            font-family: 'Inter', 'Noto Sans KR', sans-serif;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            min-height: 100vh;
                            padding: 20px;
                        }

                        .container {
                            max-width: 1200px;
                            margin: 0 auto;
                        }

                        .page-header {
                            background: white;
                            border-radius: 16px;
                            padding: 32px;
                            margin-bottom: 24px;
                            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                        }

                        .page-header h1 {
                            font-size: 28px;
                            font-weight: 700;
                            color: #1a202c;
                            margin-bottom: 8px;
                        }

                        .subtitle {
                            color: #718096;
                            font-size: 14px;
                        }

                        .section {
                            background: white;
                            border-radius: 16px;
                            padding: 24px;
                            margin-bottom: 24px;
                            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                        }

                        .filter-form {
                            display: flex;
                            gap: 16px;
                            align-items: center;
                        }

                        .form-control {
                            padding: 10px 12px;
                            border: 1px solid #e2e8f0;
                            border-radius: 8px;
                            font-size: 14px;
                        }

                        .btn {
                            padding: 10px 20px;
                            border: none;
                            border-radius: 8px;
                            font-weight: 600;
                            cursor: pointer;
                            transition: all 0.2s;
                            text-decoration: none;
                        }

                        .btn-primary {
                            background: #667eea;
                            color: white;
                        }

                        .btn-primary:hover {
                            background: #5a67d8;
                        }

                        .btn-search {
                            background: #4a5568;
                            color: white;
                        }

                        table {
                            width: 100%;
                            border-collapse: collapse;
                            margin-top: 16px;
                        }

                        th {
                            text-align: left;
                            padding: 12px;
                            border-bottom: 2px solid #e2e8f0;
                            color: #4a5568;
                            font-size: 13px;
                            font-weight: 600;
                            text-transform: uppercase;
                        }

                        td {
                            padding: 14px 12px;
                            border-bottom: 1px solid #f0f4f8;
                            font-size: 14px;
                            color: #2d3748;
                            vertical-align: middle;
                        }

                        .status-badge {
                            display: inline-block;
                            padding: 4px 10px;
                            border-radius: 20px;
                            font-size: 12px;
                            font-weight: 600;
                        }

                        .status-running {
                            background: #c6f6d5;
                            color: #22543d;
                        }

                        .status-idle {
                            background: #edf2f7;
                            color: #4a5568;
                        }

                        .status-maintenance {
                            background: #feebc8;
                            color: #744210;
                        }

                        .status-error {
                            background: #fed7d7;
                            color: #822727;
                        }

                        .status-stopped {
                            background: #e2e8f0;
                            color: #718096;
                        }

                        .action-links {
                            display: flex;
                            gap: 8px;
                        }

                        .btn-sm {
                            padding: 6px 12px;
                            font-size: 12px;
                            border-radius: 6px;
                        }

                        .btn-maintenance {
                            background: #edf2f7;
                            color: #4a5568;
                        }

                        .btn-maintenance:hover {
                            background: #e2e8f0;
                        }

                        .nav-links {
                            margin-bottom: 20px;
                        }

                        .nav-link-btn {
                            display: inline-block;
                            background: rgba(255, 255, 255, 0.2);
                            color: white;
                            padding: 10px 20px;
                            border-radius: 8px;
                            font-weight: 600;
                            text-decoration: none;
                            backdrop-filter: blur(4px);
                            transition: background 0.2s;
                        }

                        .nav-link-btn:hover {
                            background: rgba(255, 255, 255, 0.3);
                        }

                        /* Modal Styles */
                        .modal-overlay {
                            display: none;
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background: rgba(0, 0, 0, 0.5);
                            z-index: 1000;
                            justify-content: center;
                            align-items: center;
                        }

                        .modal-overlay.active {
                            display: flex;
                        }

                        .modal-container {
                            background: white;
                            border-radius: 16px;
                            width: 90%;
                            max-width: 800px;
                            max-height: 90vh;
                            overflow-y: auto;
                            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
                            display: flex;
                            flex-direction: column;
                        }

                        .modal-header {
                            padding: 24px;
                            border-bottom: 1px solid #e2e8f0;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            background: #f8fafc;
                            border-radius: 16px 16px 0 0;
                        }

                        .modal-title {
                            font-size: 20px;
                            font-weight: 700;
                            color: #2d3748;
                        }

                        .modal-close {
                            background: none;
                            border: none;
                            font-size: 24px;
                            cursor: pointer;
                            color: #a0aec0;
                        }

                        .modal-body {
                            padding: 24px;
                            flex: 1;
                            overflow-y: auto;
                        }

                        .modal-section {
                            margin-bottom: 24px;
                            background: #fff;
                            border: 1px solid #e2e8f0;
                            border-radius: 12px;
                            padding: 20px;
                        }

                        .modal-section-title {
                            font-size: 16px;
                            font-weight: 700;
                            color: #4a5568;
                            margin-bottom: 16px;
                            display: flex;
                            align-items: center;
                            gap: 8px;
                        }

                        .history-table {
                            width: 100%;
                            border-collapse: collapse;
                            font-size: 14px;
                        }

                        .history-table th {
                            background: #f7fafc;
                            padding: 10px;
                            text-align: left;
                            border-bottom: 2px solid #e2e8f0;
                        }

                        .history-table td {
                            padding: 10px;
                            border-bottom: 1px solid #edf2f7;
                        }

                        .status-control-group {
                            display: flex;
                            gap: 12px;
                            align-items: center;
                        }

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

                            .equipment-grid {
                                grid-template-columns: 1fr;
                            }

                            table {
                                font-size: 13px;
                                display: block;
                                overflow-x: auto;
                            }

                            .btn {
                                width: 100%;
                                margin-bottom: 8px;
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
                    </style>
                    <script>
                        function openHistoryModal(id, name, status, statusDesc) {
                            document.getElementById('modalEquipmentId').value = id;
                            document.getElementById('modalEquipmentName').textContent = name;
                            document.getElementById('currentStatusValue').value = status;

                            // Set current status badge
                            const badge = document.getElementById('modalStatusBadge');
                            badge.className = 'status-badge status-' + status.toLowerCase();
                            badge.textContent = statusDesc;

                            // Filter Status Options based on Transition Rules
                            const select = document.getElementById('modalStatusSelect');
                            select.innerHTML = ''; // Clear existing

                            // Rule: ERROR -> MAINTENANCE -> STOPPED (Completed)
                            const options = [];

                            if (status === 'ERROR') {
                                options.push({ val: 'MAINTENANCE', txt: '<spring:message code="production.equipment.status.maintenance" text="점검 시작 (MAINTENANCE)"/>' });
                            } else if (status === 'MAINTENANCE') {
                                options.push({ val: 'STOPPED', txt: '<spring:message code="production.equipment.status.stopped" text="점검 완료 (STOPPED)"/>' });
                            } else if (status === 'STOPPED' || status === 'IDLE') {
                                options.push({ val: 'MAINTENANCE', txt: '<spring:message code="production.equipment.status.maintenance" text="점검 시작 (MAINTENANCE)"/>' });
                                options.push({ val: 'ERROR', txt: '<spring:message code="production.equipment.status.error" text="고장 신고 (ERROR)"/>' });
                            } else if (status === 'RUNNING') {
                                options.push({ val: 'ERROR', txt: '<spring:message code="production.equipment.status.error" text="고장 신고 (ERROR)"/>' });
                            }

                            // Add options to select
                            options.forEach(opt => {
                                const el = document.createElement('option');
                                el.value = opt.val;
                                el.textContent = opt.txt;
                                select.appendChild(el);
                            });

                            // If no options (e.g. unknown state), add default or keep empty
                            if (options.length === 0) {
                                const el = document.createElement('option');
                                el.value = status;
                                el.textContent = '<spring:message code="production.equipment.status.unchangeable" text="변경 불가"/>';
                                select.appendChild(el);
                                select.disabled = true;
                            } else {
                                select.disabled = false;
                            }

                            loadHistory(id);
                            document.getElementById('historyModal').classList.add('active');
                        }

                        function closeHistoryModal() {
                            document.getElementById('historyModal').classList.remove('active');
                        }

                        function loadHistory(id) {
                            fetch('/production/equipment/' + id + '/history')
                                .then(res => res.json())
                                .then(data => {
                                    const tbody = document.getElementById('historyTableBody');
                                    tbody.innerHTML = '';
                                    if (!data || data.length === 0) {
                                        tbody.innerHTML = '<tr><td colspan="3" style="text-align:center; color:#a0aec0; padding:20px;"><spring:message code="common.noHistory" text="기록이 없습니다."/></td></tr>';
                                        return;
                                    }
                                    data.forEach(item => {
                                        const row = document.createElement('tr');
                                        const date = new Date(item.maintenanceDate).toLocaleString();
                                        row.innerHTML = `
                                        <td>${date}</td>
                                        <td>${item.worker || '-'}</td>
                                        <td>${item.description || '-'}</td>
                                    `;
                                        tbody.appendChild(row);
                                    });
                                })
                                .catch(err => console.error('Failed to load history', err));
                        }

                        function updateStatusInModal() {
                            const id = document.getElementById('modalEquipmentId').value;
                            const currentStatus = document.getElementById('currentStatusValue').value;
                            const newStatus = document.getElementById('modalStatusSelect').value;

                            // Constraint: If completing maintenance (MAINTENANCE -> STOPPED), require record
                            if (currentStatus === 'MAINTENANCE' && newStatus === 'STOPPED') {
                                const worker = document.getElementById('recordWorker').value;
                                const desc = document.getElementById('recordDescription').value;

                                if (!worker || !desc) {
                                    alert('<spring:message code="production.equipment.alert.needRecord" text="점검 완료를 위해서는 점검 기록(작업자/내용)을 먼저 작성해야 합니다."/>');
                                    document.getElementById('recordWorker').focus();
                                    return;
                                }

                                if (!confirm('<spring:message code="production.equipment.confirm.completeMaintenance" text="점검 기록을 저장하고 상태를 [점검 완료]로 변경하시겠습니까?"/>')) return;

                                // Save Record FIRST, then Update Status
                                saveMaintenanceRecord(true);
                                return;
                            }

                            if (!confirm('<spring:message code="production.equipment.confirm.changeStatus" text="상태를 변경하시겠습니까?"/>')) return;
                            performStatusUpdate(id, newStatus);
                        }

                        function performStatusUpdate(id, newStatus) {
                            fetch(`/production/equipment/` + id + `/status?status=` + newStatus, { method: 'POST' })
                                .then(res => res.text())
                                .then(data => {
                                    if (data === 'SUCCESS') {
                                        alert('<spring:message code="common.success.changed" text="상태가 변경되었습니다."/>');
                                        location.reload();
                                    } else {
                                        alert('<spring:message code="common.error" text="오류"/>: ' + data);
                                    }
                                });
                        }

                        function saveMaintenanceRecord(isChainedForCompletion) {
                            const id = document.getElementById('modalEquipmentId').value;
                            const worker = document.getElementById('recordWorker').value;
                            const desc = document.getElementById('recordDescription').value;

                            if (!worker || !desc) {
                                alert('<spring:message code="production.equipment.alert.inputWorker" text="작업자와 내용을 입력해주세요."/>');
                                return;
                            }

                            const formData = new URLSearchParams();
                            formData.append('worker', worker);
                            formData.append('description', desc);

                            fetch(`/production/equipment/` + id + `/maintenance`, {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: formData
                            })
                                .then(res => res.text())
                                .then(data => {
                                    if (data === 'SUCCESS') {
                                        if (isChainedForCompletion) {
                                            performStatusUpdate(id, 'STOPPED');
                                        } else {
                                            alert('<spring:message code="common.success.saved" text="기록이 저장되었습니다."/>');
                                            document.getElementById('recordDescription').value = '';
                                            loadHistory(id);
                                        }
                                    } else {
                                        alert('<spring:message code="common.error" text="오류"/>: ' + data);
                                    }
                                });
                        }

                        // For main table buttons
                        function updateStatus(id, status) {
                            if (!id) {
                                alert('<spring:message code="production.equipment.alert.missingId" text="Error: Equipment ID is missing."/>');
                                return;
                            }
                            if (!confirm('<spring:message code="production.equipment.confirm.changeStatus" text="장비 상태를 변경하시겠습니까?"/>')) return;

                            fetch(`/production/equipment/` + id + `/status?status=` + status, {
                                method: 'POST'
                            })
                                .then(res => res.text())
                                .then(data => {
                                    if (data === 'SUCCESS') location.reload();
                                    else alert('<spring:message code="common.error.occurred" text="오류가 발생했습니다"/>: ' + data);
                                });
                        }

                        // Target Rate Modal
                        function openTargetRateModal(id, name, currentRate) {
                            document.getElementById('targetRateEquipmentId').value = id;
                            document.getElementById('targetRateEquipmentName').textContent = name;
                            document.getElementById('targetRateInput').value = currentRate || 85.0;
                            document.getElementById('targetRateModal').classList.add('active');
                        }

                        function closeTargetRateModal() {
                            document.getElementById('targetRateModal').classList.remove('active');
                        }

                        function saveTargetRate() {
                            const id = document.getElementById('targetRateEquipmentId').value;
                            const rate = parseFloat(document.getElementById('targetRateInput').value);

                            if (isNaN(rate) || rate < 0 || rate > 100) {
                                alert('<spring:message code="production.equipment.alert.invalidRate" text="목표 가동률은 0~100 사이의 값이어야 합니다."/>');
                                return;
                            }

                            if (!confirm('<spring:message code="production.equipment.confirm.updateTargetRate" text="목표 가동률을 변경하시겠습니까?"/>' + ` (${rate}%)`)) return;

                            fetch(`/production/equipment/${id}/target-rate?targetRate=${rate}`, { method: 'POST' })
                                .then(res => res.text())
                                .then(data => {
                                    if (data === 'SUCCESS') {
                                        alert('<spring:message code="common.success.changed" text="변경되었습니다."/>');
                                        location.reload();
                                    } else {
                                        alert('<spring:message code="common.error" text="오류"/>: ' + data);
                                    }
                                });
                        }
                    </script>
                </head>

                <body>
                    <div class="container">

                        <div class="nav-links">
                            <a href="/production/dashboard" class="nav-link-btn">←
                                <spring:message code="production.common.backToDashboard" text="대시보드로 돌아가기" />
                            </a>
                        </div>

                        <div class="page-header">
                            <h1>🔧
                                <spring:message code="production.equipment.header" text="장비 관리" />
                            </h1>
                            <p class="subtitle">
                                <spring:message code="production.equipment.subtitle" text="공정 내 설비 상태 관리 및 점검 이력 기록" />
                            </p>
                        </div>

                        <div class="section">
                            <form action="/production/equipment" method="GET" class="filter-form">
                                <input type="text" name="keyword" class="form-control"
                                    placeholder="<spring:message code=" production.equipment.placeholder.search"
                                    text="장비명, 라인 ID 검색" />"
                                value="${keyword}">

                                <select name="status" class="form-control">
                                    <option value="">
                                        <spring:message code="production.equipment.status.all" text="전체 상태" />
                                    </option>
                                    <c:forEach items="${statusOptions}" var="opt">
                                        <option value="${opt}" ${selectedStatus==opt ? 'selected' : '' }>
                                            ${opt.description}
                                        </option>
                                    </c:forEach>
                                </select>

                                <button type="submit" class="btn btn-search">
                                    <spring:message code="common.search" text="검색" />
                                </button>
                                <a href="/production/equipment" class="btn btn-maintenance">
                                    <spring:message code="common.reset" text="초기화" />
                                </a>
                            </form>

                            <table>
                                <thead>
                                    <tr>
                                        <th>
                                            <spring:message code="production.equipment.table.code" text="코드" />
                                        </th>
                                        <th>
                                            <spring:message code="production.equipment.table.id" text="ID (Debug)" />
                                        </th>
                                        <th>
                                            <spring:message code="production.equipment.table.name" text="장비명" />
                                        </th>
                                        <th>
                                            <spring:message code="production.common.line" text="라인" />
                                        </th>
                                        <th>
                                            <spring:message code="common.status" text="현재 상태" />
                                        </th>
                                        <th>
                                            <spring:message code="production.equipment.table.rate" text="가동률" />
                                        </th>
                                        <th>
                                            <spring:message code="production.equipment.table.targetRate"
                                                text="목표 가동률" />
                                        </th>
                                        <th>
                                            <spring:message code="production.equipment.table.lastCheck" text="최근 점검" />
                                        </th>
                                        <th>
                                            <spring:message code="common.action" text="관리" />
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${equipment}" var="item">
                                        <tr>
                                            <td>
                                                <strong>${item.equipmentCode}</strong>
                                            </td>
                                            <td style="color: #cbd5e0; font-size: 12px;">${item.equipmentId}</td>
                                            <td>${item.equipmentName}</td>
                                            <td>${item.lineId}</td>
                                            <td>
                                                <c:if test="${item.status != null}">
                                                    <span
                                                        class="status-badge status-${item.status.name().toLowerCase()}">
                                                        ${item.status.description}
                                                    </span>
                                                </c:if>
                                                <c:if test="${item.status == null}">
                                                    <span class="status-badge status-stopped">
                                                        <spring:message code="common.unknown" text="알 수 없음" />
                                                    </span>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${item.utilizationRate != null}">
                                                    <fmt:formatNumber value="${item.utilizationRate}"
                                                        pattern="#,##0.0" />%
                                                </c:if>
                                                <c:if test="${item.utilizationRate == null}">-</c:if>
                                            </td>
                                            <td>
                                                <c:if test="${item.targetUtilizationRate != null}">
                                                    <fmt:formatNumber value="${item.targetUtilizationRate}"
                                                        pattern="#,##0.0" />%
                                                </c:if>
                                                <c:if test="${item.targetUtilizationRate == null}">85.0%</c:if>
                                            </td>
                                            <td>
                                                <c:if test="${item.lastMaintenanceAt != null}">
                                                    <fmt:parseDate value="${item.lastMaintenanceAt}"
                                                        pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm" />
                                                </c:if>
                                                <c:if test="${item.lastMaintenanceAt == null}">
                                                    <span style="color: #cbd5e0;">
                                                        <spring:message code="common.noHistory" text="기록 없음" />
                                                    </span>
                                                </c:if>
                                            </td>
                                            <td class="action-links">
                                                <c:if test="${item.status == 'STOPPED' || item.status == 'IDLE'}">
                                                    <button class="btn btn-primary btn-sm"
                                                        onclick="updateStatus('${item.equipmentId}', 'RUNNING')">
                                                        <spring:message code="production.action.run" text="가동" />
                                                    </button>
                                                </c:if>
                                                <c:if test="${item.status == 'ERROR' || item.status == 'MAINTENANCE'}">
                                                    <button class="btn btn-primary btn-sm"
                                                        style="background-color: #cbd5e0; cursor: not-allowed;" disabled
                                                        title="<spring:message code='production.equipment.tooltip.cantRun' text='점검 또는 수리 중에는 가동할 수 없습니다.'/>">
                                                        <spring:message code="production.action.run" text="가동" />
                                                    </button>
                                                </c:if>
                                                <c:if test="${item.status == 'RUNNING'}">
                                                    <button class="btn btn-primary btn-sm" style="background:#f56565;"
                                                        onclick="updateStatus('${item.equipmentId}', 'STOPPED')">
                                                        <spring:message code="production.action.stop" text="정지" />
                                                    </button>
                                                </c:if>

                                                <button class="btn btn-maintenance btn-sm"
                                                    onclick="openHistoryModal('${item.equipmentId}', '${item.equipmentName}', '${item.status != null ? item.status : "
                                                    STOPPED"}', '${item.status != null ? item.status.description : "알 수 없음"}'
                                                    )">
                                                    <spring:message code="production.action.history" text="점검 기록" />
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty equipment}">
                                        <tr>
                                            <td colspan="9" style="text-align: center; padding: 40px; color: #718096;">
                                                <spring:message code="common.noSearchResult" text="검색 결과가 없습니다." />
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Maintenance History Modal -->
                    <div id="historyModal" class="modal-overlay">
                        <div class="modal-container">
                            <div class="modal-header">
                                <div>
                                    <span class="modal-title" id="modalEquipmentName">장비명</span>
                                    <span id="modalStatusBadge" class="status-badge"
                                        style="margin-left: 10px;">Status</span>
                                </div>
                                <button class="modal-close" onclick="closeHistoryModal()">&times;</button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" id="modalEquipmentId">
                                <input type="hidden" id="currentStatusValue">

                                <!-- Status Update Section -->
                                <div class="modal-section">
                                    <div class="modal-section-title">📊
                                        <spring:message code="production.equipment.modal.changeStatus" text="상태 변경" />
                                    </div>
                                    <div class="status-control-group">
                                        <select id="modalStatusSelect" class="form-control" style="flex:1;">
                                            <!-- Dynamic Options -->
                                        </select>
                                        <button class="btn btn-primary" onclick="updateStatusInModal()">
                                            <spring:message code="common.saveChange" text="변경 저장" />
                                        </button>
                                    </div>
                                </div>

                                <!-- New Record Section -->
                                <div class="modal-section">
                                    <div class="modal-section-title">📝
                                        <spring:message code="production.equipment.modal.addRecord" text="점검 기록 추가" />
                                    </div>
                                    <div style="display: flex; gap: 10px; margin-bottom: 10px;">
                                        <input type="text" id="recordWorker" class="form-control"
                                            placeholder="<spring:message code='production.equipment.placeholder.worker' text='작업자'/>"
                                            style="width: 120px;">
                                        <input type="text" id="recordDescription" class="form-control"
                                            placeholder="<spring:message code='production.equipment.placeholder.description' text='점검 내용 / 특이사항'/>"
                                            style="flex: 1;">
                                    </div>
                                    <div style="text-align: right;">
                                        <button class="btn btn-maintenance" onclick="saveMaintenanceRecord()">
                                            <spring:message code="common.saveRecord" text="기록 저장" />
                                        </button>
                                    </div>
                                </div>

                                <!-- History Table -->
                                <div class="modal-section" style="border: none; padding: 0;">
                                    <div class="modal-section-title">📅
                                        <spring:message code="production.equipment.modal.history" text="이전 점검 이력" />
                                    </div>
                                    <table class="history-table">
                                        <thead>
                                            <tr>
                                                <th width="30%">
                                                    <spring:message code="common.date" text="일시" />
                                                </th>
                                                <th width="20%">
                                                    <spring:message code="common.worker" text="작업자" />
                                                </th>
                                                <th width="50%">
                                                    <spring:message code="common.content" text="내용" />
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody id="historyTableBody">
                                            <!-- Loaded via AJAX -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Target Rate Modal -->
                    <div id="targetRateModal" class="modal-overlay">
                        <div class="modal-container" style="max-width: 500px;">
                            <div class="modal-header">
                                <div>
                                    <span class="modal-title" id="targetRateEquipmentName">설비명</span>
                                </div>
                                <button class="modal-close" onclick="closeTargetRateModal()">&times;</button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" id="targetRateEquipmentId">

                                <div class="modal-section">
                                    <div class="modal-section-title">🎯
                                        <spring:message code="production.equipment.modal.targetRate" text="목표 가동률 수정" />
                                    </div>
                                    <div style="display: flex; gap: 10px; align-items: center;">
                                        <input type="number" id="targetRateInput" class="form-control" min="0" max="100"
                                            step="0.1" placeholder="85.0" style="flex: 1;">
                                        <span style="font-weight: 600;">%</span>
                                        <button class="btn btn-primary" onclick="saveTargetRate()">
                                            <spring:message code="common.save" text="저장" />
                                        </button>
                                    </div>
                                    <p style="margin-top: 12px; color: #718096; font-size: 13px;">
                                        <spring:message code="production.equipment.help.targetRate"
                                            text="0 ~ 100 사이의 값을 입력하세요." />
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%@ include file="../include/footer.jspf" %>
                </body>

                </html>