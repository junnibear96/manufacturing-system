package com.tp.mes.app.group.repository;

import com.tp.mes.app.group.model.GroupCompany;
import java.util.List;
import java.util.Optional;

public interface GroupCompanyRepository {

  List<GroupCompany> listCompanies();

  Optional<GroupCompany> findCompany(long companyId);

  long insertCompany(String companyCode, String companyName, String description, String activeYn);

  boolean updateCompany(long companyId, String companyCode, String companyName, String description, String activeYn);

  boolean deleteCompany(long companyId);
}
