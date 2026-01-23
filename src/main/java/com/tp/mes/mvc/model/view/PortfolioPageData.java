package com.tp.mes.mvc.model.view;

import com.tp.mes.mvc.model.ProjectItem;
import java.time.Instant;
import java.util.List;

public class PortfolioPageData {

  private final Instant now;
  private final List<String> skills;
  private final List<ProjectItem> projects;

  public PortfolioPageData(Instant now, List<String> skills, List<ProjectItem> projects) {
    this.now = now;
    this.skills = skills;
    this.projects = projects;
  }

  public Instant getNow() {
    return now;
  }

  public List<String> getSkills() {
    return skills;
  }

  public List<ProjectItem> getProjects() {
    return projects;
  }
}
