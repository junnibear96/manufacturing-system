<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
      <!doctype html>
      <html lang="ko">

      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>
          <spring:message code="admin.production.result.form" text="생산 실적 등록" />
        </title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles.css" />
      </head>

      <body>
        <%@ include file="/WEB-INF/jsp/app/_appHeader.jspf" %>
          <main class="container" role="main">
            <section class="hero" aria-label="New Result">
              <div class="hero-grid">
                <div class="card card-strong">
                  <div class="kicker"><span class="badge">Admin</span><span class="small">production_result</span></div>
                  <h1>
                    <c:choose>
                      <c:when test="${mode == 'edit'}">
                        <spring:message code="admin.production.result.edit" text="생산 실적 수정" />
                      </c:when>
                      <c:otherwise>
                        <spring:message code="admin.production.result.form" text="생산 실적 등록" />
                      </c:otherwise>
                    </c:choose>
                  </h1>

                  <c:set var="actionUrl" value="${pageContext.request.contextPath}/admin/production/results/new" />
                  <c:if test="${mode == 'edit'}">
                    <c:set var="actionUrl"
                      value="${pageContext.request.contextPath}/admin/production/results/${resultId}/edit" />
                  </c:if>

                  <form method="post" action="${actionUrl}">
                    <div style="display:grid; gap:10px;">
                      <label>
                        <div class="small">
                          <spring:message code="production.results.date" text="Work Date (YYYY-MM-DD)" />
                        </div>
                        <input type="date" name="workDate" value="<c:out value='${workDate}' />"
                          style="width:100%; padding:10px;" required />
                      </label>
                      <label>
                        <div class="small">
                          <spring:message code="production.results.item" text="Item Code" />
                        </div>
                        <input name="itemCode" value="<c:out value='${itemCode}' />" style="width:100%; padding:10px;"
                          required />
                      </label>
                      <label>
                        <div class="small">
                          <spring:message code="production.results.good" text="Qty Good" />
                        </div>
                        <input type="number" name="qtyGood" value="<c:out value='${qtyGood}' />"
                          style="width:100%; padding:10px;" required />
                      </label>
                      <label>
                        <div class="small">
                          <spring:message code="production.results.ng" text="Qty NG" />
                        </div>
                        <input type="number" name="qtyNg" value="<c:out value='${qtyNg}' />"
                          style="width:100%; padding:10px;" required />
                      </label>
                      <label>
                        <div class="small">
                          <spring:message code="production.results.equip" text="Equipment (optional)" />
                        </div>
                        <select name="equipmentId" style="width:100%; padding:10px;">
                          <option value="">
                            <spring:message code="common.none" text="(none)" />
                          </option>
                          <c:forEach items="${equipmentList}" var="e">
                            <option value="${e.equipmentId}" <c:if test="${e.equipmentId == equipmentId}">selected
                              </c:if>>
                              <c:out value="${e.equipmentCode}" /> ·
                              <c:out value="${e.equipmentName}" />
                            </option>
                          </c:forEach>
                        </select>
                      </label>
                    </div>

                    <div style="margin-top:16px; display:flex; gap:8px; align-items:center;">
                      <button class="btn" type="submit">
                        <spring:message code="common.save" text="Save" />
                      </button>
                      <a class="btn" href="${pageContext.request.contextPath}/production/results"
                        style="text-decoration:none;">
                        <spring:message code="common.cancel" text="Cancel" />
                      </a>
                    </div>
                  </form>
                </div>

                <aside class="card" aria-label="Hint">
                  <h2 style="margin-top:0;">
                    <spring:message code="common.hint" text="Hint" />
                  </h2>
                  <p class="small">
                    <spring:message code="production.results.hint" text="설비는 optional입니다." />
                  </p>
                </aside>
              </div>
            </section>
          </main>
      </body>

      </html>