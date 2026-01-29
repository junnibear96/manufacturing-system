<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
      <!doctype html>
      <html lang="ko">

      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>
          <spring:message code="admin.production.plan.form" text="생산 계획 등록" /> 
        </title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/styles.css" />
      </head>

      <body>
        <%@ include file="/WEB-INF/jsp/app/_appHeader.jspf" %>
          <main class="container" role="main">
            <section class="hero" aria-label="New Plan">
              <div class="hero-grid">
                <div class="card card-strong">
                  <div class="kicker"><span class="badge">Admin</span><span class="small">production_plan</span></div>
                  <h1>
                    <spring:message code="admin.production.plan.form" text="생산 계획 등록" />
                  </h1>

                  <form method="post" action="${pageContext.request.contextPath}/admin/production/plans/new">
                    <div style="display:grid; gap:10px;">
                      <label>
                        <div class="small">
                          <spring:message code="production.plans.date" text="Plan Date (YYYY-MM-DD)" />
                        </div>
                        <input name="planDate" value="<c:out value='${planDate}' />" style="width:100%; padding:10px;"
                          required />
                      </label>
                      <label>
                        <div class="small">
                          <spring:message code="production.plans.item" text="Item Code" />
                        </div>
                        <input name="itemCode" value="<c:out value='${itemCode}' />" style="width:100%; padding:10px;"
                          required />
                      </label>
                      <label>
                        <div class="small">
                          <spring:message code="production.plans.qty" text="Qty Plan" />
                        </div>
                        <input name="qtyPlan" value="<c:out value='${qtyPlan}' />" style="width:100%; padding:10px;"
                          required />
                      </label>
                    </div>

                    <div style="margin-top:16px; display:flex; gap:8px; align-items:center;">
                      <button class="btn" type="submit">
                        <spring:message code="common.save" text="Save" />
                      </button>
                      <a class="btn" href="${pageContext.request.contextPath}/app/production/plans"
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
                    <spring:message code="common.hint.date" text="날짜는 YYYY-MM-DD 형식으로 입력합니다." />
                  </p>
                </aside>
              </div>
            </section>
          </main>
      </body>

      </html>
