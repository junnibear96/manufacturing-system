package com.tp.mes.app.prod.web;

import com.tp.mes.app.auth.model.AuthUser;
import com.tp.mes.app.prod.service.ProductionService;
import java.util.List;
import java.util.stream.Collectors;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ProductionController {

  private final ProductionService service;
  private final com.tp.mes.app.inventory.service.InventoryService inventoryService;

  public ProductionController(ProductionService service,
      com.tp.mes.app.inventory.service.InventoryService inventoryService) {
    this.service = service;
    this.inventoryService = inventoryService;
  }

  @GetMapping({ "/production/processes" })
  public String processes(Model model) {
    model.addAttribute("processes", service.listProcesses());
    return "production/processes";
  }

  @GetMapping("/production/manager-dashboard")
  public String managerDashboard() {
    return "production/manager-dashboard";
  }

  @GetMapping({ "/production/plans" })
  public String plans(Model model) {
    model.addAttribute("plans", service.listPlans());
    return "production/plans";
  }

  @GetMapping({ "/production/results" })
  public String results(Model model) {
    List<com.tp.mes.app.prod.model.ProdResultItem> allResults = service.listResults();
    model.addAttribute("results", allResults);

    // Calculate Summary for Today
    String today = java.time.LocalDate.now().toString();
    long todayTotal = 0;
    long todayGood = 0;
    long todayNg = 0;

    for (com.tp.mes.app.prod.model.ProdResultItem item : allResults) {
      if (item.getWorkDate() != null && item.getWorkDate().startsWith(today)) {
        todayGood += parseLongSafe(item.getQtyGood());
        todayNg += parseLongSafe(item.getQtyNg());
      }
    }
    todayTotal = todayGood + todayNg;
    double defectRate = (todayTotal > 0) ? (double) todayNg / todayTotal * 100.0 : 0.0;

    model.addAttribute("summaryTotal", todayTotal);
    model.addAttribute("summaryGood", todayGood);
    model.addAttribute("summaryNg", todayNg);
    model.addAttribute("summaryDefectRate", defectRate);

    return "production/results";
  }

  private long parseLongSafe(String value) {
    if (value == null)
      return 0;
    try {
      return Long.parseLong(value);
    } catch (NumberFormatException e) {
      return 0;
    }
  }

  @GetMapping({ "/production/stats" })
  public String stats(Model model) {
    model.addAttribute("daily", service.dailyStatsLast14Days());
    model.addAttribute("monthly", service.monthlyStatsThisYear());
    return "production/stats";
  }

  @GetMapping("/production/plans/new")
  public String newPlanForm(Model model) {
    model.addAttribute("planDate", "");
    model.addAttribute("itemCode", "");
    model.addAttribute("qtyPlan", "0");
    model.addAttribute("items", inventoryService.getAllItems());
    return "production/production-plan-form";
  }

  @PreAuthorize("hasAnyRole('MANAGER', 'ADMIN')")
  @PostMapping("/production/plans/new")
  public String createPlan(
      @RequestParam("planDate") String planDate,
      @RequestParam("itemCode") String itemCode,
      @RequestParam("qtyPlan") String qtyPlan,
      org.springframework.security.core.Authentication authentication) {
    // AuthUser user = (AuthUser) session.getAttribute(AuthUser.SESSION_KEY);
    // Long createdBy = user == null ? null : user.getUserId();
    Long createdBy = 1L; // Fallback for in-memory users
    service.createPlan(planDate, itemCode, qtyPlan, createdBy);
    return "redirect:/production/plans";
  }

  @PreAuthorize("hasAnyRole('MANAGER', 'ADMIN')")
  @PostMapping("/production/plans/delete")
  public String deletePlan(@RequestParam("planId") long planId) {
    service.deletePlan(planId);
    return "redirect:/production/plans";
  }

  @GetMapping("/production/plans/{planId}/edit")
  public String editPlanForm(@org.springframework.web.bind.annotation.PathVariable("planId") long planId, Model model) {
    com.tp.mes.app.prod.model.ProdPlanItem plan = service.getPlan(planId);
    if (plan == null) {
      return "redirect:/production/plans?error=notfound";
    }
    model.addAttribute("plan", plan);
    model.addAttribute("items", inventoryService.getAllItems());
    return "production/production-plan-edit";
  }

  @PreAuthorize("hasAnyRole('MANAGER', 'ADMIN')")
  @PostMapping("/production/plans/{planId}/edit")
  public String updatePlan(
      @org.springframework.web.bind.annotation.PathVariable("planId") long planId,
      @RequestParam("planDate") String planDate,
      @RequestParam("itemCode") String itemCode,
      @RequestParam("qtyPlan") String qtyPlan,
      org.springframework.security.core.Authentication authentication) {
    Long updatedBy = 1L; // Fallback
    service.updatePlan(planId, planDate, itemCode, qtyPlan, updatedBy);
    return "redirect:/production/plans";
  }

  @GetMapping("/admin/production/results/new")
  public String newResultForm(Model model) {
    model.addAttribute("workDate", "");
    model.addAttribute("itemCode", "");
    model.addAttribute("qtyGood", "0");
    model.addAttribute("qtyNg", "0");
    model.addAttribute("equipmentList", service.listEquipment().stream()
        .filter(e -> "Y".equalsIgnoreCase(e.getActiveYn()))
        .collect(Collectors.toList()));
    model.addAttribute("items", inventoryService.getAllItems());
    return "admin/production-result-form";
  }

  @PostMapping("/admin/production/results/new")
  public String createResult(
      @RequestParam("workDate") String workDate,
      @RequestParam("itemCode") String itemCode,
      @RequestParam("qtyGood") String qtyGood,
      @RequestParam("qtyNg") String qtyNg,
      @RequestParam(value = "equipmentId", required = false) Long equipmentId,
      org.springframework.security.core.Authentication authentication) {
    // AuthUser user = (AuthUser) session.getAttribute(AuthUser.SESSION_KEY);
    // Long createdBy = user == null ? null : user.getUserId();
    Long createdBy = 1L; // Fallback for in-memory users
    service.createResult(workDate, itemCode, qtyGood, qtyNg, equipmentId, createdBy);
    return "redirect:/production/results";
  }

  @PostMapping("/admin/production/results/delete")
  public String deleteResult(@RequestParam("resultId") long resultId) {
    service.deleteResult(resultId);
    return "redirect:/production/results";
  }

  @GetMapping("/admin/production/results/{resultId}/edit")
  public String editResultForm(@org.springframework.web.bind.annotation.PathVariable("resultId") long resultId,
      Model model) {
    com.tp.mes.app.prod.model.ProdResultItem result = service.getResult(resultId);
    if (result == null) {
      return "redirect:/production/results?error=notfound";
    }
    model.addAttribute("mode", "edit");
    // Pre-populate form fields
    model.addAttribute("workDate", result.getWorkDate());
    model.addAttribute("itemCode", result.getItemCode());
    model.addAttribute("qtyGood", result.getQtyGood());
    model.addAttribute("qtyNg", result.getQtyNg());
    model.addAttribute("equipmentId", result.getEquipmentId());
    model.addAttribute("resultId", result.getResultId());

    model.addAttribute("equipmentList", service.listEquipment().stream()
        .filter(e -> "Y".equalsIgnoreCase(e.getActiveYn()))
        .collect(Collectors.toList()));
    model.addAttribute("items", inventoryService.getAllItems());

    return "admin/production-result-form";
  }

  @PostMapping("/admin/production/results/{resultId}/edit")
  public String updateResult(
      @org.springframework.web.bind.annotation.PathVariable("resultId") long resultId,
      @RequestParam("workDate") String workDate,
      @RequestParam("itemCode") String itemCode,
      @RequestParam("qtyGood") String qtyGood,
      @RequestParam("qtyNg") String qtyNg,
      @RequestParam(value = "equipmentId", required = false) Long equipmentId,
      org.springframework.security.core.Authentication authentication) {
    Long updatedBy = 1L; // Fallback
    service.updateResult(resultId, workDate, itemCode, qtyGood, qtyNg, equipmentId, updatedBy);
    return "redirect:/production/results";
  }
}
