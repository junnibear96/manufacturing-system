package com.tp.mes.app.auth.repository;

import com.tp.mes.app.auth.model.UserRecord;
import java.util.List;
import java.util.Optional;

public interface UserRepository {

  Optional<UserRecord> findByUsername(String username);

  List<String> findRoleCodesByUserId(long userId);

  void ensureRoleExists(String roleCode);

  boolean hasAnyUser();

  long insertUser(String username, String passwordHash, String displayName);

  void ensureUserRole(long userId, String roleCode);
}
