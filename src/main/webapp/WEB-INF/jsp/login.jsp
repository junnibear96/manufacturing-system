<%@ page pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <spring:message code="login.page.title" />
                </title>
                <style>
                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }

                    body {
                        font-family: 'Noto Sans KR', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        min-height: 100vh;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        padding: 20px;
                    }

                    .login-container {
                        background: white;
                        border-radius: 16px;
                        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                        width: 100%;
                        max-width: 420px;
                        padding: 48px 40px;
                    }

                    .logo {
                        text-align: center;
                        margin-bottom: 32px;
                    }

                    .logo h1 {
                        font-size: 32px;
                        font-weight: 700;
                        color: #667eea;
                        margin-bottom: 8px;
                    }

                    .logo p {
                        font-size: 14px;
                        color: #666;
                        font-weight: 400;
                    }

                    .form-group {
                        margin-bottom: 24px;
                    }

                    .form-group label {
                        display: block;
                        margin-bottom: 8px;
                        font-size: 14px;
                        font-weight: 500;
                        color: #333;
                    }

                    .form-group input {
                        width: 100%;
                        padding: 14px 16px;
                        border: 2px solid #e0e0e0;
                        border-radius: 8px;
                        font-size: 15px;
                        transition: all 0.3s;
                        font-family: inherit;
                    }

                    .form-group input:focus {
                        outline: none;
                        border-color: #667eea;
                        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                    }

                    .form-options {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 24px;
                        font-size: 14px;
                    }

                    .remember-me {
                        display: flex;
                        align-items: center;
                        gap: 6px;
                    }

                    .remember-me input[type="checkbox"] {
                        width: 18px;
                        height: 18px;
                        cursor: pointer;
                    }

                    .remember-me label {
                        color: #666;
                        cursor: pointer;
                        user-select: none;
                    }

                    .btn-login {
                        width: 100%;
                        padding: 16px;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        border: none;
                        border-radius: 8px;
                        font-size: 16px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: transform 0.2s, box-shadow 0.2s;
                        font-family: inherit;
                    }

                    .btn-login:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
                    }

                    .btn-login:active {
                        transform: translateY(0);
                    }

                    .alert {
                        padding: 12px 16px;
                        border-radius: 8px;
                        margin-bottom: 20px;
                        font-size: 14px;
                    }

                    .alert-error {
                        background: #fee;
                        border: 1px solid #fcc;
                        color: #c33;
                    }

                    .alert-success {
                        background: #efe;
                        border: 1px solid #cfc;
                        color: #3c3;
                    }

                    .back-link {
                        text-align: center;
                        margin-top: 24px;
                    }

                    .back-link a {
                        color: #667eea;
                        text-decoration: none;
                        font-size: 14px;
                        font-weight: 500;
                        transition: color 0.2s;
                    }

                    .back-link a:hover {
                        color: #764ba2;
                        text-decoration: underline;
                    }

                    .divider {
                        text-align: center;
                        margin: 24px 0;
                        position: relative;
                    }

                    .divider::before {
                        content: '';
                        position: absolute;
                        top: 50%;
                        left: 0;
                        right: 0;
                        height: 1px;
                        background: #e0e0e0;
                    }

                    .divider span {
                        position: relative;
                        background: white;
                        padding: 0 16px;
                        color: #999;
                        font-size: 13px;
                    }

                    @media (max-width: 480px) {
                        .login-container {
                            padding: 32px 24px;
                        }
                    }
                </style>
            </head>

            <body>
                <div class="login-container">
                    <div class="logo">
                        <h1>Portfolio</h1>
                        <p>Login to Dashboard</p>
                    </div>

                    <% String errorMessage=(String) request.getAttribute("errorMessage"); String message=(String)
                        request.getAttribute("message"); if (errorMessage !=null && !errorMessage.isEmpty()) { %>
                        <div class="alert alert-error">
                            <%= errorMessage %>
                        </div>
                        <% } if (message !=null && !message.isEmpty()) { %>
                            <div class="alert alert-success">
                                <%= message %>
                            </div>
                            <% } %>

                                <form action="/login" method="post">
                                    <div class="form-group">
                                        <label for="username">
                                            <spring:message code="login.label.username" />
                                        </label>
                                        <input type="text" id="username" name="username"
                                            placeholder="<spring:message code='login.placeholder.username'/>" required
                                            autofocus>
                                    </div>

                                    <div class="form-group">
                                        <label for="password">
                                            <spring:message code="login.label.password" />
                                        </label>
                                        <input type="password" id="password" name="password"
                                            placeholder="<spring:message code='login.placeholder.password'/>" required>
                                    </div>

                                    <div class="form-options">
                                        <div class="remember-me">
                                            <input type="checkbox" id="remember-me" name="remember-me">
                                            <label for="remember-me">
                                                <spring:message code="login.remember_me" />
                                            </label>
                                        </div>
                                    </div>

                                    <c:if test="${not empty successUrl}">
                                        <input type="hidden" name="successUrl" value="${successUrl}" />
                                    </c:if>

                                    <button type="submit" class="btn-login">
                                        <spring:message code="login.button" />
                                    </button>
                                </form>

                                <div class="divider">
                                    <span>
                                        <spring:message code="login.divider" />
                                    </span>
                                </div>

                                <div class="back-link">
                                    <a href="/">←
                                        <spring:message code="login.back_home" />
                                    </a>
                                </div>

                                <div
                                    style="margin-top: 30px; padding-top: 20px; border-top: 1px dashed #e0e0e0; font-size: 11px; color: #888;">
                                    <h4 style="margin-bottom: 8px; color: #667eea; font-weight: 600;">Test Accounts</h4>
                                    <table style="width: 100%; text-align: left; border-collapse: collapse;">
                                        <thead>
                                            <tr style="border-bottom: 1px solid #eee;">
                                                <th style="padding: 4px;">User</th>
                                                <th style="padding: 4px;">Pass</th>
                                                <th style="padding: 4px;">Role</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td style="padding: 2px 4px;">admin</td>
                                                <td style="padding: 2px 4px;">admin123</td>
                                                <td style="padding: 2px 4px;">ADMIN</td>
                                            </tr>
                                            <tr>
                                                <td style="padding: 2px 4px;">manager</td>
                                                <td style="padding: 2px 4px;">manager123</td>
                                                <td style="padding: 2px 4px;">MANAGER</td>
                                            </tr>
                                            <tr>
                                                <td style="padding: 2px 4px;">operator</td>
                                                <td style="padding: 2px 4px;">operator123</td>
                                                <td style="padding: 2px 4px;">OPERATOR</td>
                                            </tr>
                                            <tr>
                                                <td style="padding: 2px 4px;">viewer</td>
                                                <td style="padding: 2px 4px;">viewer123</td>
                                                <td style="padding: 2px 4px;">VIEWER</td>
                                            </tr>
                                            <tr>
                                                <td style="padding: 2px 4px; color: #999;">prod001</td>
                                                <td style="padding: 2px 4px; color: #999;">prod123</td>
                                                <td style="padding: 2px 4px; color: #999;">MANAGER</td>
                                            </tr>
                                            <tr>
                                                <td style="padding: 2px 4px; color: #999;">worker001</td>
                                                <td style="padding: 2px 4px; color: #999;">work123</td>
                                                <td style="padding: 2px 4px; color: #999;">OPERATOR</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                </div>
            </body>

            </html>
