package com.tp.mes.mvc.repository;

import com.tp.mes.mvc.model.ProjectItem;
import java.util.List;

public interface PortfolioRepository {

  List<String> getSkills();

  List<ProjectItem> getProjects();
}
