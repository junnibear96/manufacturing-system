package com.tp.mes.app.prod.web;

import com.tp.mes.app.auth.model.AuthUser;
import com.tp.mes.app.prod.service.ProductionService;
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

  @GetMapping({ "/production/plans" })
  public String plans(Model model) {
    model.addAttribute("plans", service.listPlans());
    return "production/plans";
  }

  @GetMapping({ "/production/results" })
  public String results(Model model) {
    model.addAttribute("results", service.listResults());
    return "production/results";
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
}
