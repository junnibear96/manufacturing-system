<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <spring:message code="inventory.form.title" text="재고 등록 " />
                </title>
                <style>
                    body {
                        font-family: 'Noto Sans KR', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        margin: 0;
                        padding: 20px;
                        min-height: 100vh;
                    }

                    .container {
                        max-width: 800px;
                        margin: 0 auto;
                    }

                    .header {
                        background: white;
                        padding: 24px 32px;
                        border-radius: 16px;
                        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                        margin-bottom: 24px;
                    }

                    .header h1 {
                        margin: 0;
                        color: #2d3748;
                        font-size: 28px;
                        font-weight: 700;
                    }

                    .card {
                        background: white;
                        border-radius: 16px;
                        padding: 32px;
                        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                    }

                    .form-group {
                        margin-bottom: 24px;
                    }

                    .form-label {
                        display: block;
                        font-weight: 600;
                        color: #2d3748;
                        margin-bottom: 8px;
                        font-size: 14px;
                    }

                    .form-label .required {
                        color: #e53e3e;
                        margin-left: 4px;
                    }

                    .form-control {
                        width: 100%;
                        padding: 12px 16px;
                        border: 2px solid #e2e8f0;
                        border-radius: 8px;
                        font-size: 14px;
                        transition: border-color 0.2s;
                        box-sizing: border-box;
                    }

                    .form-control:focus {
                        outline: none;
                        border-color: #667eea;
                    }

                    select.form-control {
                        background: white;
                        cursor: pointer;
                    }

                    .form-row {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 16px;
                    }

                    .btn {
                        padding: 12px 24px;
                        border-radius: 8px;
                        text-decoration: none;
                        font-weight: 600;
                        transition: all 0.3s;
                        border: none;
                        cursor: pointer;
                        font-size: 14px;
                        display: inline-block;
                        text-align: center;
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
                        color: #2d3748;
                    }

                    .btn-secondary:hover {
                        background: #cbd5e0;
                    }

                    .button-group {
                        display: flex;
                        gap: 12px;
                        margin-top: 32px;
                    }

                    .help-text {
                        font-size: 13px;
                        color: #718096;
                        margin-top: 4px;
                    }

                    /* Responsive */
                    @media (max-width: 768px) {
                        body {
                            padding: 12px;
                        }

                        .header {
                            padding: 20px;
                        }

                        .header h1 {
                            font-size: 22px;
                        }

                        .card {
                            padding: 20px;
                        }

                        .form-row {
                            grid-template-columns: 1fr;
                        }

                        .button-group {
                            flex-direction: column;
                        }

                        .btn {
                            width: 100%;
                        }
                    }
                </style>
            </head>

            <body>
                <div class="container">
                    <div class="header">
                        <h1>📦 <c:choose>
                                <c:when test="${empty item.inventoryId}">
                                    <spring:message code="inventory.form.new" text="새 재고 등록" />
                                </c:when>
                                <c:otherwise>
                                    <spring:message code="inventory.form.edit" text="재고 수정" />
                                </c:otherwise>
                            </c:choose>
                        </h1>
                    </div>

                    <div class="card">
                        <form method="post"
                            action="<c:choose><c:when test='${empty item.inventoryId}'>/inventory</c:when><c:otherwise>/inventory/${item.inventoryId}</c:otherwise></c:choose>">

                            <div class="form-group">
                                <label class="form-label">
                                    <spring:message code="inventory.code" text="품목 코드" /><span
                                        class="required">*</span>
                                </label>
                                <input type="text" name="itemCode" class="form-control" value="${item.itemCode}"
                                    required placeholder="예: RM-001">
                                <div class="help-text">
                                    <spring:message code="inventory.code.help" text="고유한 품목 코드를 입력하세요." />
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    <spring:message code="inventory.name" text="품명" /><span class="required">*</span>
                                </label>
                                <input type="text" name="itemName" class="form-control" value="${item.itemName}"
                                    required placeholder="예: 플라스틱 원자재">
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">
                                        <spring:message code="inventory.type" text="품목 타입" /><span
                                            class="required">*</span>
                                    </label>
                                    <select name="itemType" class="form-control" required>
                                        <option value="">
                                            <spring:message code="common.select" text="선택하세요" />
                                        </option>
                                        <option value="RAW_MATERIAL" <c:if test="${item.itemType == 'RAW_MATERIAL'}">
                                            selected</c:if>>
                                            <spring:message code="inventory.type.raw" text="원자재" />
                                        </option>
                                        <option value="COMPONENT" <c:if test="${item.itemType == 'COMPONENT'}">selected
                                            </c:if>>
                                            <spring:message code="inventory.type.component" text="부품" />
                                        </option>
                                        <option value="FINISHED_PRODUCT" <c:if
                                            test="${item.itemType == 'FINISHED_PRODUCT'}">selected</c:if>>
                                            <spring:message code="inventory.type.finished" text="완제품" />
                                        </option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">
                                        <spring:message code="inventory.unit" text="단위" /><span
                                            class="required">*</span>
                                    </label>
                                    <input type="text" name="unit" class="form-control" value="${item.unit}" required
                                        placeholder="예: KG, EA, L">
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label">
                                        <spring:message code="inventory.currentQty" text="현재 재고" /><span
                                            class="required">*</span>
                                    </label>
                                    <input type="number" name="currentQuantity" class="form-control"
                                        value="<c:choose><c:when test='${item.currentQuantity != null}'>${item.currentQuantity}</c:when><c:otherwise>0</c:otherwise></c:choose>"
                                        step="0.01" min="0" required>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">
                                        <spring:message code="inventory.minQty" text="최소 재고" /><span
                                            class="required">*</span>
                                    </label>
                                    <input type="number" name="minQuantity" class="form-control"
                                        value="${item.minQuantity}" step="0.01" min="0" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    <spring:message code="inventory.price" text="단가" /><span
                                        class="required">*</span>
                                </label>
                                <input type="number" name="unitPrice" class="form-control" value="${item.unitPrice}"
                                    step="0.01" min="0" required placeholder="원 단위">
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    <spring:message code="inventory.location" text="창고 위치" />
                                </label>
                                <input type="text" name="warehouseLocation" class="form-control"
                                    value="${item.warehouseLocation}" placeholder="예: A동 2구역">
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    <spring:message code="common.notes" text="비고" />
                                </label>
                                <textarea name="specifications" class="form-control" rows="3"
                                    placeholder="추가 정보를 입력하세요">${item.specifications}</textarea>
                            </div>

                            <div class="button-group">
                                <button type="submit" class="btn btn-primary">
                                    <c:choose>
                                        <c:when test="${empty item.inventoryId}">
                                            <spring:message code="common.register" text="등록하기" />
                                        </c:when>
                                        <c:otherwise>
                                            <spring:message code="common.update" text="수정하기" />
                                        </c:otherwise>
                                    </c:choose>
                                </button>
                                <a href="/inventory/list" class="btn btn-secondary">
                                    <spring:message code="common.cancel" text="취소" />
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </body>

            </html>
