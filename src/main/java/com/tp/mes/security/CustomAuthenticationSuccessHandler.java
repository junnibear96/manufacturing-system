package com.tp.mes.security;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

/**
 * Custom Authentication Success Handler
 * Prioritizes 'successUrl' parameter, then falls back to saved request or
 * default URL.
 */
@Component
public class CustomAuthenticationSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {

    public CustomAuthenticationSuccessHandler() {
        setDefaultTargetUrl("/dashboard");
        setAlwaysUseDefaultTargetUrl(false); // Validates that we should use the saved request if available
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws ServletException, IOException {

        // 1. Check for explicit successUrl parameter
        String targetUrl = request.getParameter("successUrl");

        if (StringUtils.hasText(targetUrl)) {
            // Basic security check: ensure it's a relative URL to prevent Open Redirect
            // attacks
            if (targetUrl.startsWith("/") && !targetUrl.startsWith("//")) {
                getRedirectStrategy().sendRedirect(request, response, targetUrl);
                return;
            }
        }

        // 2. Fallback to standard behavior (Saved Request or Default URL)
        super.onAuthenticationSuccess(request, response, authentication);
    }
}
