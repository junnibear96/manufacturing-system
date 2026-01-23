package com.tp.mes.app.group.service;

import com.tp.mes.app.group.model.GroupCompany;
import java.util.List;
import java.util.Optional;

public interface GroupCompanyService {

  List<GroupCompany> listCompanies();

  Optional<GroupCompany> findCompany(long companyId);

  long createCompany(String companyCode, String companyName, String description, String activeYn);

  boolean updateCompany(long companyId, String companyCode, String companyName, String description, String activeYn);

  boolean deleteCompany(long companyId);
}
