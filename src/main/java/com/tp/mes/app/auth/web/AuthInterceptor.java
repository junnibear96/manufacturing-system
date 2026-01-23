package com.tp.mes.app.auth.web;

import com.tp.mes.app.auth.model.AuthUser;
import com.tp.mes.app.auth.service.AuthService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

public class AuthInterceptor implements HandlerInterceptor {

  @Override
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
      throws Exception {
    String path = request.getRequestURI();
    String ctx = request.getContextPath();
    if (ctx != null && !ctx.isEmpty() && path.startsWith(ctx)) {
      path = path.substring(ctx.length());
    }

    // Public paths
    if (path.equals("/")
        || path.startsWith("/assets/")
        || path.startsWith("/api/")
        || path.equals("/app/login")
        || path.equals("/index.jsp")
        || path.equals("/company.jsp")) {
      return true;
    }

    // Only protect /app and /admin
    if (!path.startsWith("/app/") && !path.startsWith("/admin/")) {
      return true;
    }

    HttpSession session = request.getSession(false);
    AuthUser user = session == null ? null : (AuthUser) session.getAttribute(AuthUser.SESSION_KEY);
    if (user == null) {
      response.sendRedirect(request.getContextPath() + "/app/login");
      return false;
    }

    if (path.startsWith("/admin/") && !user.hasRole(AuthService.ROLE_ADMIN)) {
      response.sendError(403);
      return false;
    }

    return true;
  }
}
