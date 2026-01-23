package com.tp.mes.app.auth.service;

import com.tp.mes.app.auth.model.AuthUser;
import java.util.Optional;

public interface AuthService {

  String ROLE_ADMIN = "ROLE_ADMIN";
  String ROLE_USER = "ROLE_USER";

  Optional<AuthUser> authenticate(String username, String password);
}
