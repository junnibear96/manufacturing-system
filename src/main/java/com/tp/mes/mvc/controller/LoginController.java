package com.tp.mes.mvc.controller;

import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

import com.tp.mes.app.notice.service.NoticeService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Login Controller - Spring Security based
 */
@Controller
public class LoginController {

    private final NoticeService noticeService;
    private final com.tp.mes.app.prod.service.ProductionAnalysisService productionAnalysisService;
    private final com.tp.mes.app.inventory.service.InventoryService inventoryService;

    public LoginController(NoticeService noticeService,
            com.tp.mes.app.prod.service.ProductionAnalysisService productionAnalysisService,
            com.tp.mes.app.inventory.service.InventoryService inventoryService) {
        this.noticeService = noticeService;
        this.productionAnalysisService = productionAnalysisService;
        this.inventoryService = inventoryService;
    }

    /**
     * Login page
     */
    @GetMapping("/login")
    public String login(
            @RequestParam(value = "error", required = false) String error,
            @RequestParam(value = "logout", required = false) String logout,
            @RequestParam(value = "successUrl", required = false) String successUrl,
            Model model) {

        if (error != null) {
            model.addAttribute("errorMessage", "아이디 또는 비밀번호가 올바르지 않습니다.");
        }

        if (logout != null) {
            model.addAttribute("message", "로그아웃되었습니다.");
        }

        if (successUrl != null) {
            model.addAttribute("successUrl", successUrl);
        }

        return "login";
    }

    /**
     * Dashboard - main page after login
     */
    @GetMapping("/dashboard")
    public String dashboard(Authentication authentication, Model model) {
        if (authentication == null) {
            return "redirect:/login"; // Should be handled by Security Config, but safety check
        }

        String username = authentication.getName();
        String displayName = username; // Default fallback

        // Map username to display name (Temporary hardcoding until DB auth is full)
        if ("admin".equals(username))
            displayName = "관리자";
        else if ("prod001".equals(username))
            displayName = "생산관리자";
        else if ("worker001".equals(username))
            displayName = "작업자";

        // Get roles
        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        List<String> roles = authorities.stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.toList());

        model.addAttribute("userName", displayName);
        model.addAttribute("userRoles", roles);

        // Load recent notices for dashboard
        model.addAttribute("recentNotices", noticeService.listNotices());

        // --- MANUFACTURING DASHBOARD DATA ---
        // 1. Production KPI
        // Use try-catch to be safe if DB is not fully ready (though services usually
        // handle it)
        try {
            model.addAttribute("kpi", productionAnalysisService.getTodayKpiSummary());
        } catch (Exception e) {
            // Fallback or log? For now, let it be null (JSP handles empty/null somewhat)
            // or create dummy
        }

        // 2. Inventory Stats
        try {
            model.addAttribute("inventoryStats", inventoryService.getStats());
        } catch (Exception e) {
        }

        // 3. Delivery Stats (Mocked)
        // No service exists, so just passing values used in JSP?
        // Actually JSP has hardcoded values: "45", "128".
        // If we want to control them from controller:
        // model.addAttribute("deliveryStats", Map.of("delivering", 45, "completed",
        // 128));
        // But the user's JSP hardcoded them. So I don't need to do anything for
        // Delivery.

        return "dashboard";
    }

    /**
     * Reports page
     */
    @GetMapping("/reports")
    public String reports() {
        return "reports";
    }
}
