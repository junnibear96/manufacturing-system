<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <spring:message code="factory.line.form.title" text="생산라인 등록 - TP MES" />
                </title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <link href="/assets/factory-modern.css" rel="stylesheet">
                <style>
                    .form-container {
                        max-width: 800px;
                        margin: 40px auto;
                        background: white;
                        border-radius: 16px;
                        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                        padding: 40px;
                    }

                    .form-header {
                        margin-bottom: 32px;
                    }

                    .form-header h1 {
                        font-size: 28px;
                        font-weight: 700;
                        color: #1a202c;
                        margin-bottom: 8px;
                    }

                    .form-header p {
                        color: #718096;
                        font-size: 14px;
                    }

                    .form-group {
                        margin-bottom: 24px;
                    }

                    .form-group label {
                        display: block;
                        margin-bottom: 8px;
                        font-weight: 600;
                        color: #2d3748;
                        font-size: 14px;
                    }

                    .form-group label .required {
                        color: #e53e3e;
                        margin-left: 4px;
                    }

                    .form-group input,
                    .form-group select {
                        width: 100%;
                        padding: 12px 16px;
                        border: 1px solid #e2e8f0;
                        border-radius: 8px;
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

                    .form-actions {
                        display: flex;
                        gap: 12px;
                        justify-content: flex-end;
                        margin-top: 32px;
                        padding-top: 24px;
                        border-top: 1px solid #e2e8f0;
                    }

                    .btn {
                        padding: 12px 24px;
                        border: none;
                        border-radius: 8px;
                        font-size: 14px;
                        font-weight: 600;
                        cursor: pointer;
                        text-decoration: none;
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

                    .help-text {
                        font-size: 12px;
                        color: #718096;
                        margin-top: 4px;
                    }
                </style>
            </head>

            <body>
                <%@ include file="../app/_appHeader.jspf" %>

                    <div class="container">
                        <div class="form-container">
                            <div class="form-header">
                                <h1>⚙️
                                    <spring:message code="factory.line.form.header" text="생산라인 등록" />
                                </h1>
                                <p>
                                    <spring:message code="factory.line.form.desc" text="새로운 생산라인을 등록합니다" />
                                </p>
                            </div>

                            <form method="post" action="/factory/lines">
                                <div class="form-group">
                                    <label>
                                        <spring:message code="factory.line.id" text="라인 ID" /> <span
                                            class="required">*</span>
                                    </label>
                                    <input type="text" name="lineId" required placeholder="예: LINE001">
                                    <div class="help-text">고유 라인 식별자를 입력하세요</div>
                                </div>

                                <div class="form-group">
                                    <label>
                                        <spring:message code="factory.plant" text="공장 선택" /> <span
                                            class="required">*</span>
                                    </label>
                                    <select name="factoryId" required>
                                        <option value="">공장을 선택하세요</option>
                                        <c:forEach items="${factories}" var="factory">
                                            <option value="${factory.factoryId}">${factory.factoryName}
                                                (${factory.factoryId})</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label>
                                            <spring:message code="factory.line.name" text="라인명" /> <span
                                                class="required">*</span>
                                        </label>
                                        <input type="text" name="lineName" required placeholder="예: 조립 라인 1">
                                    </div>

                                    <div class="form-group">
                                        <label>
                                            <spring:message code="factory.line.lineType" text="라인 유형" /> <span
                                                class="required">*</span>
                                        </label>
                                        <select name="lineType" required>
                                            <option value="">유형 선택</option>
                                            <option value="SEMI_AUTO">반자동</option>
                                            <option value="FULL_AUTO">완전자동</option>
                                            <option value="MANUAL">수동</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label>
                                            <spring:message code="factory.capacity" text="최대 생산능력 (개/일)" />
                                        </label>
                                        <input type="number" name="maxCapacity" value="0" min="0">
                                        <div class="help-text">일일 최대 생산 가능 수량</div>
                                    </div>

                                    <div class="form-group">
                                        <label>
                                            <spring:message code="factory.workers" text="표준 작업 인원" />
                                        </label>
                                        <input type="number" name="standardWorkers" value="0" min="0">
                                        <div class="help-text">정상 운영 시 필요 인원</div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label>
                                        <spring:message code="factory.status" text="초기 상태" />
                                    </label>
                                    <select name="status">
                                        <option value="STOPPED" selected>정지</option>
                                        <option value="IDLE">대기</option>
                                        <option value="RUNNING">가동</option>
                                    </select>
                                    <div class="help-text">라인의 초기 운영 상태를 선택하세요</div>
                                </div>

                                <div class="form-actions">
                                    <a href="/factory/lines" class="btn btn-secondary">
                                        <spring:message code="common.cancel" text="취소" />
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        <spring:message code="common.register" text="등록" />
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <%@ include file="../include/footer.jspf" %>
            </body>

            </html>
