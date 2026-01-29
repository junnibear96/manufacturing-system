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
  private final com.tp.mes.app.prod.service.ProductionMonitorService monitorService;

  public ProductionController(ProductionService service,
      com.tp.mes.app.inventory.service.InventoryService inventoryService,
      com.tp.mes.app.prod.service.ProductionMonitorService monitorService) {
    this.service = service;
    this.inventoryService = inventoryService;
    this.monitorService = monitorService;
  }

  @GetMapping({ "/production/processes" })
  public String processes(Model model) {
    model.addAttribute("processes", service.listProcesses());
    return "production/processes";
  }

  @GetMapping("/production/manager-dashboard")
  public String managerDashboard(Model model) {
    // 1. Calculate KPI (Aggregate from all lines or raw plans)
    // For MVP, we aggregate from today's results directly via service or monitor
    List<com.tp.mes.app.prod.model.ProdResultItem> allResults = service.listResults();
    String today = java.time.LocalDate.now().toString();

    List<com.tp.mes.app.prod.model.ProdPlanItem> allPlans = service.listPlans();
    long todayPlansCount = allPlans.stream()
        .filter(p -> p.getPlanDate() != null && p.getPlanDate().startsWith(today))
        .count();

    // Sum targets from plans for today
    long totalTarget = allPlans.stream()
        .filter(p -> p.getPlanDate() != null && p.getPlanDate().startsWith(today))
        .mapToLong(p -> parseLongSafe(p.getQtyPlan()))
        .sum();

    long todayGood = 0;
    long todayNg = 0;
    for (com.tp.mes.app.prod.model.ProdResultItem item : allResults) {
      if (item.getWorkDate() != null && item.getWorkDate().startsWith(today)) {
        todayGood += parseLongSafe(item.getQtyGood());
        todayNg += parseLongSafe(item.getQtyNg());
      }
    }
    long totalProduced = todayGood + todayNg;
    double achievementRate = (totalTarget > 0) ? (double) todayGood / totalTarget * 100.0 : 0.0;
    double defectRate = (totalProduced > 0) ? (double) todayNg / totalProduced * 100.0 : 0.0;

    java.util.Map<String, Object> kpi = new java.util.HashMap<>();
    kpi.put("todayTargetQuantity", totalTarget);
    kpi.put("totalPlans", todayPlansCount);
    kpi.put("todayActualQuantity", todayGood);
    kpi.put("todayAchievementRate", achievementRate);
    kpi.put("todayDefectRate", defectRate);
    kpi.put("todayTotalDefect", todayNg);

    // Equipment Utilization (Mock logic: Active Equipment vs Total)
    List<com.tp.mes.app.prod.model.EquipmentItem> eqList = service.listEquipment();
    long totalEq = eqList.size();
    long runningEq = eqList.stream().filter(e -> "Y".equalsIgnoreCase(e.getActiveYn())).count();
    double utilRate = (totalEq > 0) ? (double) runningEq / totalEq * 100.0 : 0.0;

    kpi.put("equipmentUtilizationRate", utilRate);
    kpi.put("runningEquipment", runningEq);
    kpi.put("totalEquipment", totalEq);

    model.addAttribute("kpi", kpi);

    // 2. Equipment Status
    List<EquipmentStatusView> equipViews = eqList.stream().map(e -> {
      EquipmentStatus status = "Y".equalsIgnoreCase(e.getActiveYn()) ? EquipmentStatus.RUNNING
          : EquipmentStatus.STOPPED;
      // Simple random utilization for "Running" equipments for demo visualization
      Double rate = (status == EquipmentStatus.RUNNING) ? (Math.random() * 20 + 80) : 0.0;
      return new EquipmentStatusView(e.getEquipmentName(), e.getEquipmentCode(), status, rate);
    }).collect(Collectors.toList());
    model.addAttribute("equipment", equipViews);

    // 3. Daily Achievement (Last 7 days)
    List<com.tp.mes.app.prod.model.QtyStatRow> dailyStats = service.dailyStatsLast14Days();
    // Filter last 7 (Recent 7 days)
    List<DailyAchievementView> dailyViews = dailyStats.stream()
        .skip(Math.max(0, dailyStats.size() - 7))
        .map(s -> {
          long target = parseLongSafe(s.getQtyPlan());
          long actual = parseLongSafe(s.getQtyGood());
          double rate = (target > 0) ? (double) actual / target * 100.0 : 0.0;
          return new DailyAchievementView(s.getBucket(), "Total", target, actual, rate, 0, 0);
        })
        .collect(Collectors.toList());
    model.addAttribute("dailyAchievement", dailyViews);

    // Maintenance Due (Empty for now)
    model.addAttribute("maintenanceDue", java.util.Collections.emptyList());

    return "production/manager-dashboard";
  }

  // Helper DTOs for Dashboard
  public enum EquipmentStatus {
    RUNNING("가동중"), IDLE("대기"), STOPPED("정지"), MAINTENANCE("점검중"), ERROR("장애");

    private final String description;

    EquipmentStatus(String description) {
      this.description = description;
    }

    public String getDescription() {
      return description;
    }
  }

  public static class EquipmentStatusView {
    public String equipmentName;
    public String equipmentCode;
    public EquipmentStatus status;
    public Double utilizationRate;

    public EquipmentStatusView(String n, String c, EquipmentStatus s, Double u) {
      this.equipmentName = n;
      this.equipmentCode = c;
      this.status = s;
      this.utilizationRate = u;
    }

    public String getEquipmentName() {
      return equipmentName;
    }

    public String getEquipmentCode() {
      return equipmentCode;
    }

    public EquipmentStatus getStatus() {
      return status;
    }

    public Double getUtilizationRate() {
      return utilizationRate;
    }
  }

  public static class DailyAchievementView {
    public String workDate;
    public String lineName;
    public long totalTarget;
    public long totalActual;
    public double achievementRate;
    public int completedPlanCount;
    public int planCount;

    public DailyAchievementView(String d, String l, long t, long a, double r, int c, int p) {
      this.workDate = d;
      this.lineName = l;
      this.totalTarget = t;
      this.totalActual = a;
      this.achievementRate = r;
      this.completedPlanCount = c;
      this.planCount = p;
    }

    public String getWorkDate() {
      return workDate;
    }

    public String getLineName() {
      return lineName;
    }

    public long getTotalTarget() {
      return totalTarget;
    }

    public long getTotalActual() {
      return totalActual;
    }

    public double getAchievementRate() {
      return achievementRate;
    }

    public int getCompletedPlanCount() {
      return completedPlanCount;
    }

    public int getPlanCount() {
      return planCount;
    }
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
      @RequestParam(value = "equipmentId", required = false) String equipmentIdStr,
      org.springframework.security.core.Authentication authentication) {
    // AuthUser user = (AuthUser) session.getAttribute(AuthUser.SESSION_KEY);
    // Long createdBy = user == null ? null : user.getUserId();
    Long createdBy = 1L; // Fallback for in-memory users
    Long equipmentId = parseLongOrNull(equipmentIdStr);
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
      @RequestParam(value = "equipmentId", required = false) String equipmentIdStr,
      org.springframework.security.core.Authentication authentication) {
    Long updatedBy = 1L; // Fallback
    Long equipmentId = parseLongOrNull(equipmentIdStr);
    service.updateResult(resultId, workDate, itemCode, qtyGood, qtyNg, equipmentId, updatedBy);
    return "redirect:/production/results";
  }

  private Long parseLongOrNull(String value) {
    if (value == null || value.trim().isEmpty()) {
      return null;
    }
    try {
      return Long.parseLong(value);
    } catch (NumberFormatException e) {
      return null;
    }
  }
}
