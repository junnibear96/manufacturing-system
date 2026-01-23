package com.tp.mes.app.group.service;

import com.tp.mes.app.group.model.GroupCompany;
import com.tp.mes.app.group.repository.GroupCompanyRepository;
import java.util.List;
import java.util.Optional;
import org.springframework.stereotype.Service;

@Service
public class DefaultGroupCompanyService implements GroupCompanyService {

  private final GroupCompanyRepository repository;

  public DefaultGroupCompanyService(GroupCompanyRepository repository) {
    this.repository = repository;
  }

  @Override
  public List<GroupCompany> listCompanies() {
    return repository.listCompanies();
  }

  @Override
  public Optional<GroupCompany> findCompany(long companyId) {
    return repository.findCompany(companyId);
  }

  @Override
  public long createCompany(String companyCode, String companyName, String description, String activeYn) {
    return repository.insertCompany(
        normalize(companyCode),
        normalize(companyName),
        normalizeNullable(description),
        normalizeActive(activeYn)
    );
  }

  @Override
  public boolean updateCompany(long companyId, String companyCode, String companyName, String description, String activeYn) {
    return repository.updateCompany(
        companyId,
        normalize(companyCode),
        normalize(companyName),
        normalizeNullable(description),
        normalizeActive(activeYn)
    );
  }

  @Override
  public boolean deleteCompany(long companyId) {
    return repository.deleteCompany(companyId);
  }

  private static String normalize(String value) {
    if (value == null) {
      return "";
    }
    return value.trim();
  }

  private static String normalizeNullable(String value) {
    if (value == null) {
      return null;
    }
    String trimmed = value.trim();
    return trimmed.isEmpty() ? null : trimmed;
  }

  private static String normalizeActive(String activeYn) {
    if (activeYn == null) {
      return "Y";
    }
    return "N".equalsIgnoreCase(activeYn.trim()) ? "N" : "Y";
  }
}
