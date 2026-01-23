package com.tp.mes.mvc.controller;

import com.tp.mes.mvc.model.view.PortfolioPageData;
import com.tp.mes.mvc.service.PortfolioPageService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/app")
public class PageController {

  private final PortfolioPageService portfolioPageService;

  public PageController(PortfolioPageService portfolioPageService) {
    this.portfolioPageService = portfolioPageService;
  }

  @GetMapping("/portfolio")
  public String portfolio(Model model) {
    PortfolioPageData data = portfolioPageService.getPageData();

    model.addAttribute("now", data.getNow().toString());
    model.addAttribute("skills", data.getSkills());
    model.addAttribute("projects", data.getProjects());
    return "app/portfolio";
  }
}
