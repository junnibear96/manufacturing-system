<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <c:if test="${mode == 'new'}">
                        <spring:message code="hr.employee.form.new" text="사원 등록" />
                    </c:if>
                    <c:if test="${mode == 'edit'}">
                        <spring:message code="hr.employee.form.edit" text="사원 정보 수정" />
                    </c:if>
                </title>
                <style>
                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }

                    body {
                        font-family: 'Noto Sans KR', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                        background: #f5f7fa;
                        color: #333;
                    }

                    .container {
                        max-width: 800px;
                        margin: 40px auto;
                        padding: 0 20px;
                    }

                    h1 {
                        font-size: 28px;
                        font-weight: 700;
                        margin-bottom: 10px;
                        color: #1a202c;
                    }

                    .subtitle {
                        color: #718096;
                        margin-bottom: 30px;
                    }

                    .form-card {
                        background: white;
                        border-radius: 8px;
                        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                        padding: 40px;
                    }

                    .form-section {
                        margin-bottom: 30px;
                    }

                    .form-section h2 {
                        font-size: 18px;
                        font-weight: 600;
                        color: #2d3748;
                        margin-bottom: 20px;
                        padding-bottom: 10px;
                        border-bottom: 2px solid #e2e8f0;
                    }

                    .form-group {
                        margin-bottom: 20px;
                    }

                    .form-group label {
                        display: block;
                        margin-bottom: 8px;
                        font-weight: 500;
                        color: #4a5568;
                        font-size: 14px;
                    }

                    .form-group label .required {
                        color: #e53e3e;
                        margin-left: 4px;
                    }

                    .form-group input,
                    .form-group select {
                        width: 100%;
                        padding: 10px 14px;
                        border: 1px solid #cbd5e0;
                        border-radius: 6px;
                        font-size: 14px;
                        font-family: inherit;
                        transition: all 0.2s;
                    }

                    .form-group input:focus,
                    .form-group select:focus {
                        outline: none;
                        border-color: #667eea;
                        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                    }

                    .form-row {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 20px;
                    }

                    .btn {
                        padding: 12px 24px;
                        border: none;
                        border-radius: 6px;
                        font-size: 14px;
                        font-weight: 600;
                        cursor: pointer;
                        text-decoration: none;
                        display: inline-block;
                        transition: all 0.2s;
                    }

                    .btn-primary {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                    }

                    .btn-primary:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
                    }

                    .btn-secondary {
                        background: #e2e8f0;
                        color: #4a5568;
                    }

                    .btn-secondary:hover {
                        background: #cbd5e0;
                    }

                    .btn-danger {
                        background: #dc3545;
                        color: white;
                        border: none;
                        padding: 10px 20px;
                        border-radius: 8px;
                        font-weight: 600;
                    }

                    .btn-danger:hover {
                        background: #c82333;
                        transform: translateY(-1px);
                    }

                    .form-actions {
                        display: flex;
                        gap: 12px;
                        justify-content: flex-end;
                        margin-top: 30px;
                        padding-top: 20px;
                        border-top: 1px solid #e2e8f0;
                    }

                    .info-box {
                        background: #ebf8ff;
                        border-left: 4px solid #4299e1;
                        padding: 12px 16px;
                        margin-bottom: 20px;
                        border-radius: 4px;
                    }

                    .info-box p {
                        margin: 0;
                        color: #2c5282;
                        font-size: 14px;
                    }

                    .role-list {
                        background: #f7fafc;
                        border: 1px solid #e2e8f0;
                        border-radius: 6px;
                        padding: 12px 16px;
                        margin-top: 20px;
                    }

                    .role-list h3 {
                        font-size: 14px;
                        font-weight: 600;
                        margin-bottom: 10px;
                        color: #2d3748;
                    }

                    .role-badge {
                        display: inline-block;
                        padding: 4px 12px;
                        background: #667eea;
                        color: white;
                        border-radius: 12px;
                        font-size: 12px;
                        font-weight: 600;
                        margin-right: 8px;
                        margin-bottom: 8px;
                    }

                    @media (max-width: 768px) {
                        .form-row {
                            grid-template-columns: 1fr;
                        }

                        .form-card {
                            padding: 24px;
                        }
                    }
                </style>
            </head>

            <body>
                <%@ include file="/WEB-INF/jsp/app/_appHeader.jspf" %>

                    <div class="container">
                        <h1>
                            <c:if test="${mode == 'new'}">📝
                                <spring:message code="hr.employee.new" text="신규 사원 등록" />
                            </c:if>
                            <c:if test="${mode == 'edit'}">✏️
                                <spring:message code="hr.employee.edit" text="사원 정보 수정" />
                            </c:if>
                        </h1>
                        <p class="subtitle">
                            <c:if test="${mode == 'new'}">새로운 사원 정보를 입력하세요. 부서와 직급에 따라 권한이 자동으로 부여됩니다.</c:if>
                            <c:if test="${mode == 'edit'}">사원 정보를 수정하세요. 부서/직급 변경 시 권한이 재계산됩니다.</c:if>
                        </p>

                        <div class="form-card">
                            <c:choose>
                                <c:when test="${mode eq 'edit'}">
                                    <c:set var="formAction" value="/hr/employees/${employee.empId}" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="formAction" value="/hr/employees" />
                                </c:otherwise>
                            </c:choose>
                            <form method="post" action="${formAction}">

                                <!-- 기본 정보 -->
                                <div class="form-section">
                                    <h2>기본 정보</h2>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label>
                                                <spring:message code="hr.empId" text="사번" /> <span
                                                    class="required">*</span>
                                            </label>
                                            <input type="text" name="empId"
                                                value="${mode == 'edit' ? employee.empId : ''}" <c:if
                                                test="${mode == 'edit'}">readonly</c:if>
                                            required
                                            placeholder="예: EMP001">
                                        </div>

                                        <div class="form-group">
                                            <label>
                                                <spring:message code="hr.empName" text="이름" /> <span
                                                    class="required">*</span>
                                            </label>
                                            <input type="text" name="empName"
                                                value="${mode == 'edit' ? employee.empName : ''}" required
                                                placeholder="홍길동">
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label>
                                                <spring:message code="hr.email" text="이메일" />
                                            </label>
                                            <input type="email" name="email"
                                                value="${mode == 'edit' ? employee.email : ''}"
                                                placeholder="hong@tp-inc.com">
                                        </div>

                                        <div class="form-group">
                                            <label>
                                                <spring:message code="hr.phone" text="전화번호" />
                                            </label>
                                            <input type="tel" name="phone"
                                                value="${mode == 'edit' ? employee.phone : ''}"
                                                placeholder="010-1234-5678">
                                        </div>
                                    </div>
                                </div>

                                <!-- 조직 정보 -->
                                <div class="form-section">
                                    <h2>조직 정보</h2>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label>
                                                <spring:message code="hr.department" text="부서" /> <span
                                                    class="required">*</span>
                                            </label>
                                            <select name="departmentId" required>
                                                <option value="">선택하세요</option>
                                                <c:forEach items="${departments}" var="dept">
                                                    <option value="${dept.departmentId}" <c:if
                                                        test="${mode == 'edit' && dept.departmentId == employee.departmentId}">
                                                        selected</c:if>>
                                                        ${dept.deptName} (${dept.division})
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="form-group">
                                            <label>
                                                <spring:message code="hr.position" text="직급" /> <span
                                                    class="required">*</span>
                                            </label>
                                            <select name="positionId" required>
                                                <option value="">선택하세요</option>
                                                <c:forEach items="${positions}" var="pos">
                                                    <option value="${pos.positionId}" <c:if
                                                        test="${mode == 'edit' && pos.positionId == employee.positionId}">
                                                        selected</c:if>>
                                                        ${pos.positionName} (Level ${pos.level})
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label>
                                                <spring:message code="hr.jobType" text="근무 유형" /> <span
                                                    class="required">*</span>
                                            </label>
                                            <select name="jobType" required>
                                                <option value="OFFICE" <c:if
                                                    test="${mode == 'edit' && employee.jobType == 'OFFICE'}">selected
                                                    </c:if>
                                                    >사무직</option>
                                                <option value="PRODUCTION" <c:if
                                                    test="${mode == 'edit' && employee.jobType == 'PRODUCTION'}">
                                                    selected
                                                    </c:if>>생산직</option>
                                                <option value="LOGISTICS" <c:if
                                                    test="${mode == 'edit' && employee.jobType == 'LOGISTICS'}">selected
                                                    </c:if>>물류직</option>
                                            </select>
                                        </div>

                                        <c:if test="${mode == 'edit'}">
                                            <div class="form-group">
                                                <label>재직 상태</label>
                                                <select name="status">
                                                    <option value="ACTIVE" <c:if test="${employee.status == 'ACTIVE'}">
                                                        selected
                                        </c:if>>재직</option>
                                        <option value="LEAVE" <c:if test="${employee.status == 'LEAVE'}">selected</c:if>
                                            >휴직
                                        </option>
                                        <option value="PROBATION" <c:if test="${employee.status == 'PROBATION'}">
                                            selected
                                            </c:if>>수습</option>
                                        <option value="RETIRED" <c:if test="${employee.status == 'RETIRED'}">selected
                                            </c:if>
                                            >퇴직</option>
                                        <option value="TERMINATED" <c:if test="${employee.status == 'TERMINATED'}">
                                            selected
                                            </c:if>>해고</option>
                                        </select>
                                    </div>
                                    </c:if>
                                </div>
                        </div>

                        <!-- 생산 관련 (생산직만) -->
                        <div class="form-section">
                            <h2>생산 관련 정보 (생산직만)</h2>

                            <div class="form-row">
                                <div class="form-group">
                                    <label>교대 근무 조</label>
                                    <select name="shiftType">
                                        <option value="">해당없음</option>
                                        <option value="DAY" <c:if
                                            test="${mode == 'edit' && employee.shiftType == 'DAY'}">
                                            selected</c:if>>주간조</option>
                                        <option value="SWING" <c:if
                                            test="${mode == 'edit' && employee.shiftType == 'SWING'}">selected</c:if>
                                            >중간조
                                        </option>
                                        <option value="NIGHT" <c:if
                                            test="${mode == 'edit' && employee.shiftType == 'NIGHT'}">selected</c:if>
                                            >야간조
                                        </option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label>숙련도</label>
                                    <select name="skillLevel">
                                        <option value="">해당없음</option>
                                        <option value="1" <c:if test="${mode == 'edit' && employee.skillLevel == 1}">
                                            selected</c:if>>1 (초급)</option>
                                        <option value="2" <c:if test="${mode == 'edit' && employee.skillLevel == 2}">
                                            selected</c:if>>2</option>
                                        <option value="3" <c:if test="${mode == 'edit' && employee.skillLevel == 3}">
                                            selected</c:if>>3 (중급)</option>
                                        <option value="4" <c:if test="${mode == 'edit' && employee.skillLevel == 4}">
                                            selected</c:if>>4</option>
                                        <option value="5" <c:if test="${mode == 'edit' && employee.skillLevel == 5}">
                                            selected</c:if>>5 (고급)</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- 권한 정보 (수정 모드일 때만 표시) -->
                        <c:if test="${mode == 'edit' && not empty roles}">
                            <div class="role-list">
                                <h3>🔐 현재 부여된 권한</h3>
                                <c:forEach items="${roles}" var="role">
                                    <span class="role-badge">${role}</span>
                                </c:forEach>
                                <p style="margin-top: 10px; font-size: 12px; color: #718096;">
                                    부서나 직급을 변경하면 권한이 자동으로 재계산됩니다.
                                </p>
                            </div>
                        </c:if>

                        <!-- 안내 메시지 -->
                        <c:if test="${mode == 'new'}">
                            <div class="info-box">
                                <p><strong>💡 자동 권한 부여:</strong> 부서와 직급에 따라 시스템 권한(Role)이 자동으로 부여됩니다. 예: IT팀 과장 이상 →
                                    ROLE_ADMIN</p>
                            </div>
                        </c:if>

                        <!-- 버튼 -->
                        <div class="form-actions">
                            <a href="/hr/employees" class="btn btn-secondary">
                                <spring:message code="common.cancel" text="취소" />
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <c:if test="${mode == 'new'}">
                                    <spring:message code="common.register" text="등록" />
                                </c:if>
                                <c:if test="${mode == 'edit'}">
                                    <spring:message code="common.edit" text="수정" />
                                </c:if>
                            </button>
                        </div>
                        <c:if test="${mode == 'new'}">
                            <p style="text-align: right; margin-top: 10px; font-size: 0.9em; color: #666;">
                                * 생성 시 기본 비밀번호는 <strong>test1234</strong> 입니다.
                            </p>
                        </c:if>
                        </form>

                        <!-- 재직 상태 변경 (수정 모드일 때만) -->
                        <c:if test="${mode == 'edit'}">
                            <div style="margin-top: 40px; padding-top: 40px; border-top: 2px solid #e2e8f0;">
                                <h2 style="font-size: 18px; margin-bottom: 16px; color: #2d3748;">재직 상태 영역</h2>
                                <form method="post" action="/hr/employees/${employee.empId}/status"
                                    onsubmit="return confirm('재직 상태를 변경하시겠습니까?');">
                                    <div class="form-row">
                                        <div class="form-group">
                                            <label>재직 상태 변경</label>
                                            <select name="status" required>
                                                <option value="ACTIVE">재직</option>
                                                <option value="LEAVE">휴직</option>
                                                <option value="RETIRED">정년퇴직</option>
                                                <option value="TERMINATED">해고/사직</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label>사유</label>
                                            <input type="text" name="reason" placeholder="변경 사유를 입력하세요">
                                        </div>
                                    </div>
                                    <button type="submit" class="btn-danger">상태 변경</button>
                                </form>
                            </div>
                        </c:if>
                    </div>
                    </div>

                    <%@ include file="../include/footer.jspf" %>
            </body>

            </html>