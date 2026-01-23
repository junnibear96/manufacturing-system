package com.tp.mes.mvc.service;

import com.tp.mes.mvc.model.view.PortfolioPageData;
import com.tp.mes.mvc.repository.PortfolioRepository;
import java.time.Instant;
import org.springframework.stereotype.Service;

@Service
public class DefaultPortfolioPageService implements PortfolioPageService {

  private final PortfolioRepository portfolioRepository;

  public DefaultPortfolioPageService(PortfolioRepository portfolioRepository) {
    this.portfolioRepository = portfolioRepository;
  }

  @Override
  public PortfolioPageData getPageData() {
    return new PortfolioPageData(
        Instant.now(),
        portfolioRepository.getSkills(),
        portfolioRepository.getProjects()
    );
  }
}
