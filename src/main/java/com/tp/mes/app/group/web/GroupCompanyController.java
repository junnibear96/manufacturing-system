package com.tp.mes.app.group.web;

import com.tp.mes.app.group.model.GroupCompany;
import com.tp.mes.app.group.service.GroupCompanyService;
import java.util.Optional;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class GroupCompanyController {

  private final GroupCompanyService service;

  public GroupCompanyController(GroupCompanyService service) {
    this.service = service;
  }

  @GetMapping("/companies")
  public String list(Model model) {
    model.addAttribute("companies", service.listCompanies());
    return "app/companies";
  }

  @GetMapping("/admin/companies/new")
  public String newForm(Model model) {
    model.addAttribute("mode", "create");
    model.addAttribute("companyId", 0);
    model.addAttribute("companyCode", "");
    model.addAttribute("companyName", "");
    model.addAttribute("description", "");
    model.addAttribute("activeYn", "Y");
    return "admin/company-form";
  }

  @PostMapping("/admin/companies/new")
  public String create(
      @RequestParam("companyCode") String companyCode,
      @RequestParam("companyName") String companyName,
      @RequestParam(value = "description", required = false) String description,
      @RequestParam(value = "activeYn", required = false) String activeYn) {
    service.createCompany(companyCode, companyName, description, activeYn);
    return "redirect:/companies";
  }

  @GetMapping("/admin/companies/{companyId}/edit")
  public String editForm(@PathVariable("companyId") long companyId, Model model) {
    Optional<GroupCompany> found = service.findCompany(companyId);
    if (found.isEmpty()) {
      return "redirect:/companies";
    }
    GroupCompany c = found.get();
    model.addAttribute("mode", "edit");
    model.addAttribute("companyId", c.getCompanyId());
    model.addAttribute("companyCode", c.getCompanyCode());
    model.addAttribute("companyName", c.getCompanyName());
    model.addAttribute("description", c.getDescription());
    model.addAttribute("activeYn", c.getActiveYn());
    return "admin/company-form";
  }

  @PostMapping("/admin/companies/{companyId}/edit")
  public String update(
      @PathVariable("companyId") long companyId,
      @RequestParam("companyCode") String companyCode,
      @RequestParam("companyName") String companyName,
      @RequestParam(value = "description", required = false) String description,
      @RequestParam(value = "activeYn", required = false) String activeYn) {
    service.updateCompany(companyId, companyCode, companyName, description, activeYn);
    return "redirect:/companies";
  }

  @PostMapping("/admin/companies/{companyId}/delete")
  public String delete(@PathVariable("companyId") long companyId) {
    service.deleteCompany(companyId);
    return "redirect:/companies";
  }
}
